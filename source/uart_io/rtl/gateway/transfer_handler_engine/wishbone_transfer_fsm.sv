/*
 */

`timescale 1ns/1ns

module wishbone_transfer_fsm
  #(
    parameter bit     FLIP_BIT_ORDER=0,
    parameter integer N_ACK_TIMEOUT_CYCLES = 5,
    parameter integer N_WRITE_BUSY_CYCLES = 4500
    )
   (
    input logic        clk,
    input logic        rstn,
    input logic        interrupt,
    output logic [7:0] read_data,
    output logic       read_valid, //level_based
    input logic        read_ack, //pulse based
    input logic        write_enable, //pulse based
    output logic       write_ack, //pulse based
    output logic       write_busy,
    output logic       write_ack_timeout,
    input logic [7:0]  write_data,
    wishbone.master wb_master
    );

   genvar 	       i;
   localparam integer  W_ACK_TIMEOUT_CYCLES = $clog2(N_ACK_TIMEOUT_CYCLES);
   localparam integer  W_WRITE_BUSY_CYCLES = $clog2(N_WRITE_BUSY_CYCLES);

   localparam integer  N_FSM_STATES=5;
   localparam integer  W_FSM_STATES=$clog2(N_FSM_STATES);
   typedef enum        logic [W_FSM_STATES-1:0]
    {
        IDLE = '0,
        READ_REQ,
        PENDING_READ_ACK,
        WRITE_REQ,
        PENDING_WRITE_ACK
    }   fsm_state;

   fsm_state curr_state, next_state;

   // wishbone interface
   logic 	       cyc_o;
   logic 	       stb_o;       
   logic 	       we_o;
   logic [3:0] 	       sel_o;
   logic [7:0] 	       data_o;
   logic [2:0] 	       addr_o;
   logic [7:0] 	       data_i;
   logic 	       ack_i;

   // internal signals
   logic 	       write_req;
   logic 	       update_read_data;
   logic 	       clear_write_req;
   logic 	       ack_sampled;
   logic [7:0] 	       write_data_sampled;
   logic 	       clear_pending_write_req;

   // acknowledge safety signals
   logic 	       ack_counter_set_zero;
   logic 	       ack_counter_enable;
   logic 	       ack_counter_timeout;

   // backpressure counter signals
   logic 	       write_busy_counter_set_zero;
   logic 	       write_busy_counter_enable;
   logic 	       write_busy_counter_timeout;

   // wishbone interface unpacking
   assign wb_master.cyc      = cyc_o;
   assign wb_master.stb      = stb_o;
   assign wb_master.we       = we_o;
   assign wb_master.sel      = sel_o;
   assign wb_master.address  = addr_o;
   assign ack_i              = wb_master.ack;

   generate
      if(FLIP_BIT_ORDER) begin: bit_order_flip_logic
         for(i=0; i<8; i++) begin: bit_flip
            assign data_i[i]             = wb_master.data_in[7-i];
            assign wb_master.data_out[i] = data_o[7-i];
         end
      end
      else begin: bit_order_noflip_logic
         assign data_i             = wb_master.data_in;
         assign wb_master.data_out = data_o;
      end 
   endgenerate

   // const assignments
   assign sel_o			= '1;
   assign data_o		= write_data_sampled;
   assign write_ack_timeout	= ack_counter_timeout;

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) curr_state <= IDLE;
      else      curr_state <= next_state;
   end

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn)                            write_busy <= 1'b0;
      else if(write_busy_counter_timeout)  write_busy <= 1'b0;
      else if(write_enable)                write_busy <= 1'b1;
   end

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn)                           write_data_sampled <= 1'b0;
      else if(write_enable & ~write_busy) write_data_sampled <= write_data;
   end

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn)                 read_data <= '0;
      else if(update_read_data) read_data <= data_i;
   end

   always_ff @(posedge clk or negedge rstn) begin
      if (~rstn)                read_valid <= 1'b0;
      else if(update_read_data) read_valid <= 1'b1;
      else if(read_ack)         read_valid <= 1'b0;
   end 

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn)                           write_req <= 1'b0;
      else if(clear_pending_write_req)    write_req <= 1'b0;
      else if(write_enable & ~write_busy) write_req <= 1'b1;
   end 

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) ack_sampled <= 1'b0;
      else      ack_sampled <= ack_i;
   end

   always_comb begin
      next_state              = curr_state;
      addr_o                  = '0;
      cyc_o                   = '0;
      stb_o                   = '0;
      we_o                    = '0;
      clear_pending_write_req = 1'b0;
      update_read_data        = 1'b0;
      write_ack               = 1'b0;
      ack_counter_enable      = 1'b0;
      ack_counter_set_zero    = 1'b0;
      
      case(curr_state)
	IDLE: begin
           if(write_req)      next_state = WRITE_REQ;
           else if(interrupt) next_state = READ_REQ;
	end

	READ_REQ: begin
           next_state = PENDING_READ_ACK;
           cyc_o                = 1'b1;
           stb_o                = 1'b1;
           we_o                 = 1'b0;
           ack_counter_set_zero = 1'b1;
	end

	PENDING_READ_ACK: begin
           ack_counter_enable = 1'b1;
           if(ack_sampled)              next_state       = IDLE;
           else if(ack_i)               update_read_data = 1'b1;
           else if(ack_counter_timeout) next_state = IDLE;
	end

	WRITE_REQ: begin
           next_state              = PENDING_WRITE_ACK;
           cyc_o                   = 1'b1;
           stb_o                   = 1'b1;
           we_o                    = 1'b1;
           clear_pending_write_req = 1'b1;
           ack_counter_set_zero    = 1'b1;
	end

	PENDING_WRITE_ACK: begin
           ack_counter_enable = 1'b1;
           if(ack_sampled)              next_state = IDLE;
           else if(ack_i)               write_ack  = 1'b1;
           else if(ack_counter_timeout) next_state = IDLE;
	end
      endcase
   end

   assign write_busy_counter_set_zero = write_enable;
   assign write_busy_counter_enable   = write_busy;

   // BACK-PRESSURE TIMER
   Counter #(W_WRITE_BUSY_CYCLES) 
   write_timeout_timer_inst
     (
      .clk            (clk),
      .rstn           (rstn),
      .enable         (write_busy_counter_enable),
      .inc_dec        (1'b1),
      .scale          (1),
      .min_value      ('0),
      .max_value      (N_WRITE_BUSY_CYCLES),
      .load           (write_busy_counter_set_zero),
      .load_value     ('0),
      .first          (), // floating
      .last           (write_busy_counter_timeout),
      .counter_value  ()  // floating
      );

   // SAFETY TIMER FOR ACK RESP
   Counter #(W_ACK_TIMEOUT_CYCLES)
   acknowledge_timeout_timer_inst
     (
      .clk            (clk),
      .rstn           (rstn),
      .enable         (ack_counter_enable),
      .inc_dec        (1'b1),
      .scale          (1),
      .min_value      ('0),
      .max_value      (N_ACK_TIMEOUT_CYCLES),
      .load           (ack_counter_set_zero),
      .load_value     ('0),
      .first          (), // floating
      .last           (ack_counter_timeout),
      .counter_value  ()  // floating
      );

endmodule
