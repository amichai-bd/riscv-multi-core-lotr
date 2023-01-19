/*
 User transfer handler FSM 
 Wishbone master unit to 
 handle user transfers 
 between uart host(PC) and device lotr
 */


`timescale 1ns/1ns

module transfer_handler_engine
  (
   input logic 	       clk,
   input logic 	       rstn,
   input logic 	       interrupt,		// no use in this module
   output logic        invalid_comm,
   output logic [31:0] address,
   output logic [31:0] data_out,
   input logic [31:0]  data_in,
   output logic        write_transfer_valid,	// once address and data are ready, pulse for one cycle.
   input logic 	       write_resp_valid,	// is ppulsed to indicate write_data is valid from RC.
   output logic        read_transfer_valid,	// once address and data are ready, pulse for one cycle.
   input logic 	       read_resp_valid,		// is ppulsed to indicate read_data is valid from RC.
   wishbone.master wb_master    		// no use in this module forwarded to wishbone fsm.
   );

   parameter [7:0] TRANSFER_ACK_OPCODE  = 8'd55;
   parameter [7:0] TRANSFER_NACK_OPCODE = 8'd66;
   parameter [7:0] TRANSFER_R_OPCODE    = 8'd82;
   parameter [7:0] TRANSFER_W_OPCODE    = 8'd87;
   parameter [7:0] TRANSFER_WB_OPCODE   = 8'd74;
   parameter [7:0] TRANSFER_RB_OPCODE   = 8'd77;

   parameter integer   N_TRANSFER_STATES=5;
   parameter integer   W_TRANSFER_STATES=$clog2(N_TRANSFER_STATES);
   typedef enum        logic [W_TRANSFER_STATES-1:0]
    {
     INVALID,
     WRITE_TRANS,
     READ_TRANS,
     WRITE_BURST_TRANS,
     READ_BURST_TRANS
     } trans_state;
   trans_state transfer_state, next_transfer_state;

   parameter integer   N_FSM_STATES=10;
   parameter integer   W_FSM_STATES=$clog2(N_FSM_STATES);
   typedef enum        logic [W_FSM_STATES-1:0]
    {
     IDLE,
     DECODING_PHASE,
     ADDRESS_PHASE,
     DATA_PHASE,
     SIZE_PHASE,
     ACK_RESP,
     NACK_RESP,
     READ_FROM_RC,
     WRITE_TO_RC,
     WRITE_TO_UART
     } fsm_state;
   fsm_state curr_state, next_state;

   logic 	       write_resp_rc_timeout;   // write timeout
   logic 	       read_resp_rc_timeout;    // read timeout.
   
   // UART FSM SIGNALS.
   logic 	       read_valid_from_uart;
   logic 	       write_busy_from_uart;
   logic 	       write_ack_from_uart;
   logic 	       write_ack_timeout_from_uart;
   logic 	       write_enable_to_uart;
   logic [7:0] 	       read_data_from_uart;
   logic [7:0] 	       write_data_to_uart;
   
   // TRANSFER STATES SIGNALS
   logic 	       update_transfer_state;

   // ADDRESS SIGNALS
   logic 	       address_counter_enable;
   logic 	       address_counter_set_zero;
   logic 	       address_counter_last;
   logic [31:0]        address_counter_max_value;
   logic [31:0]        address_counter_value;

   // BYTE INDEX COUNTER SIGNALS
   logic 	       byte_index_counter_enable;
   logic 	       byte_index_counter_load;
   logic 	       byte_index_counter_last;
   logic [1:0] 	       byte_index_counter_value;

   // RC TIMEOUT COUNTER SIGNALS
   logic 	       rc_read_timeout_counter_enable;
   logic 	       rc_read_timeout_counter_set_zero;
   logic 	       rc_read_timeout_counter_last;
   logic 	       active_read_from_rc;
   
   // DATA, ADDRESS, AND SIZE BUFFERS
   logic 	       update_transfer_address;
   logic [3:0][7:0]    transfer_address;
   logic 	       update_transfer_size;
   logic [3:0][7:0]    transfer_size;
   logic 	       update_transfer_read_data;
   logic [3:0][7:0]    transfer_read_data;
   logic 	       update_transfer_write_data;
   logic [3:0][7:0]    transfer_write_data;
   
   assign address = transfer_address + address_counter_value;
   assign data_out = transfer_write_data; 
   assign address_counter_max_value = (transfer_size-32'd4);

   always_comb begin
      next_state 			= curr_state;

      // TRANSFER STATE SIGNALS
      next_transfer_state 		= transfer_state;
      update_transfer_state 		= 1'b0;
      
      // BYTE INDEX SIGNALS
      byte_index_counter_enable 	= 1'b0;
      byte_index_counter_load		= 1'b0;

      // TRANSFER DATA, AIZE, and ADDRESS
      update_transfer_size 		= 1'b0;
      update_transfer_address		= 1'b0;
      update_transfer_write_data	= 1'b0;

      // ADDRESS COUNTER SIGNALS
      address_counter_enable		= 1'b0;
      address_counter_set_zero		= 1'b0;

      // UART HANDLER SIGNALS
      write_enable_to_uart		= 1'b0;
      write_data_to_uart		= '0;   

      // OUTPUT SIGNALS
      invalid_comm			= 1'b0;
      write_transfer_valid		= 1'b0;
      read_transfer_valid		= 1'b0;

      case(curr_state)
	// multi cycle state
	IDLE: begin
	   if(read_valid_from_uart)
	     next_state = DECODING_PHASE;
	   /*else if(read_valid_from_rc)*/
	end

	// single cycle state
	DECODING_PHASE: begin
	   next_state            	= ADDRESS_PHASE;
	   update_transfer_state 	= 1'b1;
	   byte_index_counter_load = 1'b1;
	   case(read_data_from_uart)
	     TRANSFER_W_OPCODE  : next_transfer_state = WRITE_TRANS;
	     TRANSFER_R_OPCODE  : next_transfer_state = READ_TRANS;
	     TRANSFER_WB_OPCODE : next_transfer_state = WRITE_BURST_TRANS;
	     TRANSFER_RB_OPCODE : next_transfer_state = READ_BURST_TRANS;
	     default	: begin
		next_transfer_state = INVALID;
		next_state          = IDLE;
		invalid_comm        = 1'b1;
	     end
	   endcase
	end

	// multi cycle state
        ADDRESS_PHASE: begin
	   byte_index_counter_enable = read_valid_from_uart;
	   update_transfer_address   = read_valid_from_uart;
	   if(byte_index_counter_last & read_valid_from_uart) begin
	      case(transfer_state)
		WRITE_TRANS		: next_state = DATA_PHASE; 
		READ_TRANS		: next_state = ACK_RESP;
		WRITE_BURST_TRANS	: next_state = SIZE_PHASE;
		READ_BURST_TRANS	: next_state = SIZE_PHASE;
		default			: next_state = IDLE;
	      endcase
	   end
	end	

        // multi cycle state
        SIZE_PHASE: begin
	   byte_index_counter_enable = read_valid_from_uart;
	   update_transfer_size      = read_valid_from_uart;
	   if(byte_index_counter_last & read_valid_from_uart) begin
	      case(transfer_state)
		WRITE_BURST_TRANS : next_state = DATA_PHASE;
		READ_BURST_TRANS  : next_state = ACK_RESP;
		default           : next_state = IDLE;
	      endcase
	   end
	end

        // multi cycle state
        DATA_PHASE: begin
	   byte_index_counter_enable  = read_valid_from_uart;
	   update_transfer_write_data = read_valid_from_uart;
	   if(byte_index_counter_last & read_valid_from_uart)
	     next_state = WRITE_TO_RC;
	end

	// multi cycle state
        ACK_RESP: begin
	   write_enable_to_uart = ~write_busy_from_uart;
	   write_data_to_uart   = TRANSFER_ACK_OPCODE; 
	   if(write_ack_from_uart) begin
	      case(transfer_state)
		WRITE_TRANS		: next_state = IDLE;
		READ_TRANS		: next_state = READ_FROM_RC;
		WRITE_BURST_TRANS	: next_state = IDLE;
		READ_BURST_TRANS	: next_state = READ_FROM_RC;
		default			: next_state = IDLE;
	      endcase
	   end
	   else if(write_ack_timeout_from_uart) begin
	      next_state = IDLE;
	      invalid_comm = 1'b1;
	   end
	end

	NACK_RESP: begin
	   invalid_comm = 1'b1;
	   write_enable_to_uart = ~write_busy_from_uart;
	   write_data_to_uart   = TRANSFER_ACK_OPCODE; 
	   next_state = IDLE;
	end

	// multi cycle state
	READ_FROM_RC: begin
	   if(~active_read_from_rc)
	     read_transfer_valid = 1'b1;
	   if(read_resp_valid)
	     next_state = WRITE_TO_UART;
	   else if(read_resp_rc_timeout)
	     next_state = WRITE_TO_UART; // DUMMY WRITE
	end

	// single cycle state
        WRITE_TO_RC: begin
	   next_state = DATA_PHASE;
	   write_transfer_valid    = 1'b1;
	   address_counter_enable  = 1'b1;
	   if(transfer_state == WRITE_TRANS) begin
	      next_state = ACK_RESP;
	      address_counter_enable  = 1'b0;
	   end
	   else if((transfer_state == WRITE_BURST_TRANS) && address_counter_last) begin 
	      next_state = ACK_RESP;
	      address_counter_set_zero = 1'b1;
	   end
	end

	// multi cycle state
	WRITE_TO_UART: begin
	   write_enable_to_uart 	= ~write_busy_from_uart;
	   write_data_to_uart   	= transfer_read_data[byte_index_counter_value];
	   byte_index_counter_enable 	= write_ack_from_uart;
	   if(write_ack_from_uart & byte_index_counter_last) begin
	      next_state = READ_FROM_RC;
	      if(transfer_state == READ_TRANS)
		next_state = IDLE;
	      else if(transfer_state == READ_BURST_TRANS) begin
		 address_counter_enable = 1'b1;
		 if(address_counter_last) begin
		    address_counter_set_zero = 1'b1;
		    next_state = IDLE;
		 end
	      end
	   end
	   else if(write_ack_timeout_from_uart) begin
	      next_state = IDLE;
	      invalid_comm = 1'b1;
	   end
	end

	default: next_state = IDLE;
      endcase
   end

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn)                      transfer_state <= INVALID;
      else if(update_transfer_state) transfer_state <= next_transfer_state;
   end

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) curr_state <= IDLE;
      else      curr_state <= next_state;
   end

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) transfer_address <= '0;
      else if(update_transfer_address)
	transfer_address[byte_index_counter_value] <= read_data_from_uart;
   end

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) transfer_size <= '0;
      else if(update_transfer_size)
	transfer_size[byte_index_counter_value] <= read_data_from_uart;
   end

   // write from uart to RC
   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) transfer_write_data <= '0;
      else if(update_transfer_write_data)
	transfer_write_data[byte_index_counter_value] <= read_data_from_uart;
   end
   
   // read from rc to uart
   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) transfer_read_data <= '0;
      else if(update_transfer_read_data)
	transfer_read_data <= data_in;
   end

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn)                	                	active_read_from_rc <= 1'b0;
      else if(read_resp_valid | read_resp_rc_timeout)	active_read_from_rc <= 1'b0;
      else if(read_transfer_valid)      		active_read_from_rc <= 1'b1;
   end

   assign rc_read_timeout_counter_enable	= active_read_from_rc;
   assign rc_read_timeout_counter_set_zero	= read_transfer_valid;
   assign update_transfer_read_data		= read_resp_valid;
   assign read_resp_rc_timeout 			= rc_read_timeout_counter_last;

   // RC READ TIMEOUT COUNTER
   Counter #(5)
   rc_read_timeout_counter_inst
     (
      .clk            (clk),
      .rstn           (rstn),
      .enable         (rc_read_timeout_counter_enable),
      .inc_dec        (1'b1),
      .scale          (5'd1),
      .min_value      ('0),
      .max_value      ('1),
      .load           (rc_read_timeout_counter_set_zero),
      .load_value     ('0),
      .first          (), // floating
      .last           (rc_read_timeout_counter_last),
      .counter_value  () // floating
      );


   // GENERAL PURPOSE COUNTER
   Counter #(2)
   byte_index_counter_inst
     (
      .clk            (clk),
      .rstn           (rstn),
      .enable         (byte_index_counter_enable),
      .inc_dec        (1'b0),
      .scale          (2'd1),
      .min_value      ('0),
      .max_value      ('1),
      .load           (byte_index_counter_load),
      .load_value     ('1),
      .first          (byte_index_counter_last),
      .last           (), // floating
      .counter_value  (byte_index_counter_value)
      );

   // ADDRESS INCREASE COUNTER
   Counter #(32) 
   address_generation_counter_inst
     (
      .clk            (clk),
      .rstn           (rstn),
      .enable         (address_counter_enable),
      .inc_dec        (1'b1),
      .scale          (32'd4),
      .min_value      ('0),
      .max_value      (address_counter_max_value),
      .load           (address_counter_set_zero),
      .load_value     ('0),
      .first          (), // floating
      .last           (address_counter_last),
      .counter_value  (address_counter_value)
      );

   // WISHBONE TRANSFER HANDLER
   wishbone_transfer_fsm
     wishbone_transfer_fsm_inst
       (
	.clk			(clk),
	.rstn			(rstn),
	.interrupt		(interrupt),
	.read_data  		(read_data_from_uart),
	.read_valid 		(read_valid_from_uart), //level_based
	.read_ack   		(read_valid_from_uart), //pulse based
	.write_enable 		(write_enable_to_uart), //pulse based
	.write_ack		(write_ack_from_uart),  //pulse based
	.write_busy		(write_busy_from_uart),
	.write_ack_timeout 	(write_ack_timeout_from_uart),
	.write_data		(write_data_to_uart),
	.wb_master		(wb_master)
	);

endmodule
