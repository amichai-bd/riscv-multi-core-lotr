/*
 User transfer handler FSM 
 Wishbone master unit to 
 handle user transfers 
 between uart host(PC) and device lotr
 */

parameter STATE_BITS = 3;
typedef enum logic [STATE_BITS-1:0]
   {
		IDLE,
		FIRST_READ,
		WAIT_ACK_1,
		DATA_UPDATE,
		WRITE_1   } e_fsm_state;
parameter STATE_BITS_2 = 5;

typedef enum logic  [STATE_BITS_2-1:0]
   {
		IDLE_2,
		READ_COMM,
		WAIT_FOR_COMM,
		WAIT_INTERRUPT,
		WAIT_FOR_READ,
		SEND_TO_LOTR,
       		INVALID_COMM	} e_WB_fsm_state;



`timescale 1ns/1ns

module transfer_handler_engine
  #()
   (
    input logic clk,
    input logic rstn,
    input logic interrupt,
    output logic invalid_comm,
    wishbone.master wb_master
    );

logic [7:0] data_i;
logic ack_i;
logic ack_sampled;
logic  we_o;
logic  [7:0] data_o;
logic  [2:0] addr_o;
logic  cyc_o;
logic  stb_o;       

assign ack_i  = wb_master.ack;
assign data_i = wb_master.data_in;
assign wb_master.address = addr_o;
assign wb_master.data_out = data_o;
assign wb_master.we = we_o;
assign wb_master.stb = stb_o;
assign wb_master.cyc = cyc_o;

logic data_update;
logic receive_interrupt;
logic interrupt_s1;
logic data_cap_en;
logic [STATE_BITS-1:0] FSM_state;
logic [STATE_BITS-1:0] FSM_state_nxt;
logic [7:0] data;
logic start_read;
logic data_valid;
logic [2:0] read_conter;
logic [2:0] read_conter_nxt;
assign receive_interrupt = interrupt & !interrupt_s1;
//assign start_read = receive_interrupt;

logic [63:0] uart_data_buffer_nxt;
logic [63:0] uart_data_buffer;
logic [31:0] addr_from_uart;
logic [31:0] data_from_uart;
assign addr_from_uart = {uart_data_buffer[7:0],uart_data_buffer[15:8],uart_data_buffer[23:16],uart_data_buffer[31:24]};
assign data_from_uart = {uart_data_buffer[39:32],uart_data_buffer[47:40],uart_data_buffer[55:48],uart_data_buffer[63:56]};
logic [STATE_BITS_2-1:0] WB_man_state;
logic [STATE_BITS_2-1:0] WB_man_state_nxt;
logic [2:0] read_num;
logic [2:0] read_num_nxt;
logic read_num_update_en;

//#### 
always_comb
begin	
	invalid_comm = 0;
	read_num_nxt = 3'd0;	
	read_num_update_en = 0;	
	WB_man_state_nxt=IDLE_2;
	start_read = 0;
	case(WB_man_state)
			IDLE_2:begin
				invalid_comm = 0;				
				if (receive_interrupt)
				begin
					WB_man_state_nxt=READ_COMM;
				end
			end
			
			READ_COMM:begin
				start_read = 1'b1;
				WB_man_state_nxt = WAIT_FOR_COMM;
			end
			WAIT_FOR_COMM:begin
				WB_man_state_nxt = WAIT_FOR_COMM;				
				start_read = 1'b0;
				if (data_update) begin
					case(data)
						8'hea: begin
						//8'd87:begi
							read_num_update_en = 1;
							read_num_nxt = 3'd7; // total 8
						       	read_conter_nxt = 3'd0;
							WB_man_state_nxt = WAIT_INTERRUPT;
						end
						8'd34:begin
							read_num_update_en = 1;				
							read_num_nxt = 3'h3; // total 4
					       		read_conter_nxt = 3'd0;
							WB_man_state_nxt = WAIT_INTERRUPT;
						end							
						default:begin
							WB_man_state_nxt = INVALID_COMM;
						end							
					endcase
				end
			end
			WAIT_INTERRUPT:begin
				start_read = 0;
				WB_man_state_nxt = WAIT_INTERRUPT; 				
				if (receive_interrupt) begin
					start_read = 1;
					WB_man_state_nxt = WAIT_FOR_READ; 
				end
			end
			WAIT_FOR_READ:begin
				WB_man_state_nxt = WAIT_FOR_READ; 				
				start_read = 0;				
				if (data_update) begin
					read_conter_nxt = read_conter + 3'b001;
					uart_data_buffer_nxt[read_conter*8 +: 8] = data; //TODO check if it works well on FPGA
					if(read_conter == read_num) begin
						WB_man_state_nxt = SEND_TO_LOTR;
					end else begin
						WB_man_state_nxt = WAIT_INTERRUPT;
					end
				end
			end
			SEND_TO_LOTR:begin
					WB_man_state_nxt = SEND_TO_LOTR;
					/* TODO add lotr signals here
					* add exstra states for LOTR trans */
			
			end
			INVALID_COMM: begin
					invalid_comm = 1;					
					WB_man_state_nxt = INVALID_COMM;
			end
	endcase		

end


//#### READ 1 WORD
always_comb
begin
	FSM_state_nxt = IDLE; 
	data_o = '0;
	addr_o = '0;
	cyc_o  = '0;
	stb_o  = '0;
	we_o = '0;
	data_cap_en ='0;
	data_update = '0;	

	case(FSM_state)
		IDLE: begin
			data_cap_en = 1'b0;
			data_update = 1'b0;			
			if (start_read) begin
				FSM_state_nxt = FIRST_READ;
			end							
		end
		FIRST_READ: begin
			FSM_state_nxt = WAIT_ACK_1;
			addr_o = 3'b000;
			we_o = 1'b0;
			cyc_o = 1'b1;
			stb_o = 1'b1;
		end
		WAIT_ACK_1: begin
			FSM_state_nxt = WAIT_ACK_1;			
			if(ack_i) begin
				data_cap_en = 1'b1;
			end				
			if (ack_sampled) begin
				FSM_state_nxt = DATA_UPDATE;
			end
		end
		DATA_UPDATE: begin			
			data_update = 1'b1;
			FSM_state_nxt = IDLE;
		end
	endcase	
end


always_ff@(posedge clk or negedge rstn)
begin
	if(!rstn) begin
		uart_data_buffer <= '0;
		FSM_state <= IDLE;
		WB_man_state <= IDLE_2;		
		ack_sampled <= 1'b0;	       	
		interrupt_s1 <= 1'b0;
		read_conter <= '0;
	end else begin
		uart_data_buffer <= uart_data_buffer_nxt;
		interrupt_s1 <= interrupt;
		WB_man_state <= WB_man_state_nxt;				
		FSM_state <= FSM_state_nxt;
		ack_sampled <= ack_i;
		read_conter <= read_conter_nxt;		
	end
end

always_ff@(posedge clk or negedge rstn)
begin
	if(!rstn) 
		read_num <= '0;		
	else if (read_num_update_en)
		read_num <= read_num_nxt;
end


always_ff@(posedge clk or negedge rstn)
begin
	if(!rstn) 
		data <= '0;
	else if (data_cap_en)
		data <= data_i;
end


endmodule // handshake

   

