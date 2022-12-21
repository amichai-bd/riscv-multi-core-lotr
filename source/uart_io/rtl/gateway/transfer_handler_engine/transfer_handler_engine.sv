/*
 User transfer handler FSM 
 Wishbone master unit to 
 handle user transfers 
 between uart host(PC) and device lotr
 */


`timescale 1ns/1ns

module transfer_handler_engine
   (
    input logic clk,
    input logic rstn,
    input logic interrupt,       // no use in this module
    output logic invalid_comm,
	output [31:0] address,
	output [31:0] data_out,
	input [31:0] data_in,
	output write_transfer_valid, // once address and data are ready, pulse for one cycle.
	input  write_resp_valid,     // is ppulsed to indicate write_data is valid from RC.
	input  write_resp_timeout,   // read timeout
	output read_transfer_valid,  // once address and data are ready, pulse for one cycle.
	input  read_resp_valid,      // is ppulsed to indicate read_data is valid from RC.
	input  read_resp_timeout,    // read timeout.
    wishbone.master wb_master    // no use in this module.
    );

parameter integer STATE_BITS_2 = 5;
typedef enum logic  [STATE_BITS_2-1:0]
   {
	IDLE_2,
	READ_COMM,
	WAIT_FOR_COMM,
	WAIT_INTERRUPT,
	WAIT_FOR_READ,
	SEND_TO_LOTR,
	INVALID_COMM
	} e_WB_fsm_state;


logic temp_read_ack;
logic read_valid;
logic [7:0] write_data;


logic [7:0] data_i;
logic ack_i;
logic ack_sampled;
logic  we_o;
logic  [7:0] data_o;
logic  [2:0] addr_o;
logic  cyc_o;
logic  stb_o;       

logic data_update;
logic receive_interrupt;
logic interrupt_s1;
logic data_cap_en;
logic [7:0] data;
logic start_read;
logic data_valid;
logic [2:0] read_conter;
logic [2:0] read_conter_nxt;
assign receive_interrupt = interrupt & !interrupt_s1;

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
	read_conter_nxt = read_conter;
	uart_data_buffer_nxt = uart_data_buffer;
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

wishbone_transfer_fsm
	wishbone_transfer_fsm_inst
	(
		.clk			(clk),
        .rstn			(rstn),
        .interrupt		(interrupt),
        .read_data  	(write_data),
        .read_valid 	(read_valid),  		//level_based
        .read_ack   	(read_valid),       //pulse based
        .write_enable 	(read_valid), 		//pulse based
        .write_ack		(),    				//pulse based
        .write_busy		(),
        .write_data		(write_data),
        .wb_master		(wb_master)
	);

always_ff@(posedge clk or negedge rstn) begin
	if(!rstn) begin
		uart_data_buffer <= '0;
		WB_man_state <= IDLE_2;		
		ack_sampled <= 1'b0;	       	
		interrupt_s1 <= 1'b0;
		read_conter <= '0;
	end 
	else begin
		uart_data_buffer <= uart_data_buffer_nxt;
		interrupt_s1 <= interrupt;
		WB_man_state <= WB_man_state_nxt;				
		ack_sampled <= ack_i;
		read_conter <= read_conter_nxt;		
	end
end

always_ff@(posedge clk or negedge rstn) begin
	if(!rstn)                    read_num <= '0;		
	else if (read_num_update_en) read_num <= read_num_nxt;
end


always_ff@(posedge clk or negedge rstn) begin
	if(!rstn) 			  data <= '0;
	else if (data_cap_en) data <= data_i;
end

endmodule