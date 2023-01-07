/*
 UART config routine FSM 
 Wishbone master unit to 
 read/write from UART
 */

`include "../../source/uart_io/rtl/uart/uart_defines.v"

`timescale 1ns/1ns

parameter STATE_BITS = 5;
typedef enum logic [STATE_BITS-1:0]
   {
		IDLE,
		FIRST_READ,
		WAIT_ACK_1,
		WRITE_1,
		WAIT_ACK_2,
		WAIT_STATE_1,
		WRITE_2,
		WAIT_ACK_3,
		WAIT_STATE_2,
		WRITE_3,
		WAIT_ACK_4,  //10
		WAIT_PRE_READ,
		READ_2,
		WAIT_ACK_5,
		WRITE_4,
		WAIT_ACK_6,
		WAIT_STATE_3,
		WRITE_5,
		WAIT_ACK_7,
		WAIT_PRE_READ_2,
		READ_3, //20
		WAIT_ACK_8,
		WRITE_6,
		WAIT_ACK_9,
		CONF_DONE

   } e_fsm_state;

module uart_config
   #(
     // UART PROTOCOL PARAMS
     parameter bit     LSB_FIRST=0,       //[0/1] 0: MSB first,   1: LSB first
     parameter bit     PARITY_EN=0,       //[0/1] 0: disable,     1: enable
     parameter bit     SINGLE_STOP_BIT=1, //[0/1] 0: 2 stop bits, 1: single
     parameter integer N_DATA_BITS=8,     //[5:8] any number between 5 and 8
     parameter integer BUADRATE=9600      //[] bits per sec
     )
   (
    input logic clk,
    input logic rstn,
	input logic interrupt,		
    input  logic start_config,	   
    output logic config_done,     
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
assign wb_master.sel = '1;

logic [STATE_BITS-1:0] FSM_state;
logic [STATE_BITS-1:0] FSM_state_nxt;
logic [7:0] data;

always_comb
begin
	FSM_state_nxt = IDLE; 
	data_o = '0;
	addr_o = '0;
	cyc_o  = '0;
	stb_o  = '0;
	we_o   = '0;
	config_done = '0;

	case(FSM_state)
		IDLE: begin
			config_done = 1'b0;
			if (start_config) begin
				FSM_state_nxt = FIRST_READ;
			end							
		end
		FIRST_READ: begin
			FSM_state_nxt = WAIT_ACK_1;
			addr_o = `UART_REG_LC;
			we_o = 1'b0;
			cyc_o = 1'b1;
			stb_o = 1'b1;
		end
		WAIT_ACK_1: begin
			if (ack_sampled) begin
				FSM_state_nxt = WRITE_1;
			end else begin
				FSM_state_nxt = WAIT_ACK_1;
			end
		end
		WRITE_1: begin
			FSM_state_nxt = WAIT_ACK_2;
			data_o = data | 8'b10000000;
			addr_o = `UART_REG_LC;			
			we_o = 1'b1;
			cyc_o = 1'b1;
			stb_o = 1'b1;
		end
		WAIT_ACK_2: begin
			if (ack_sampled) begin
				FSM_state_nxt = WAIT_STATE_1;
			end else begin
				FSM_state_nxt = WAIT_ACK_2;
			end			
		end
		WAIT_STATE_1: begin
			FSM_state_nxt = WRITE_2;			
			stb_o = 1'b0;
			end	

		WRITE_2: begin
			FSM_state_nxt = WAIT_ACK_3;
			data_o =  '0;
			addr_o = `UART_REG_DL2;	
			we_o = 1'b1;
			cyc_o = 1'b1;
			stb_o = 1'b1;
		end
		WAIT_ACK_3: begin
			if (ack_sampled) begin
				FSM_state_nxt = WAIT_STATE_2;
			end else begin
				FSM_state_nxt = WAIT_ACK_3;
			end			
		end
		WAIT_STATE_2: begin
			FSM_state_nxt = WRITE_3;			
			stb_o = 1'b0;
			end

		WRITE_3: begin
			FSM_state_nxt = WAIT_ACK_4;
			data_o =  8'h1b; // 50Mhz - 115200BR
			//data_o =  8'h03; // 5MHz - 115200BR
			//data_o =  8'h21; // 5MHz - 9600BR
			addr_o = `UART_REG_DL1;			
			we_o = 1'b1;
			cyc_o = 1'b1;
			stb_o = 1'b1;
		end
		WAIT_ACK_4: begin
			if (ack_sampled) begin
				FSM_state_nxt = WAIT_PRE_READ;
			end else begin
				FSM_state_nxt = WAIT_ACK_4;
			end			
		end
		WAIT_PRE_READ: begin
			FSM_state_nxt = READ_2;			
			stb_o = 1'b0;
			we_o = 1'b0;
			cyc_o = 1'b0;
			end	

	
		READ_2: begin
			FSM_state_nxt = WAIT_ACK_5;
			addr_o = `UART_REG_LC;
			we_o = 1'b0;
			cyc_o = 1'b1;
			stb_o = 1'b1;
		end
		WAIT_ACK_5: begin
			if (ack_sampled) begin
				FSM_state_nxt = WRITE_4;
			end else begin
				FSM_state_nxt = WAIT_ACK_5;
			end
		end
		WRITE_4: begin
			FSM_state_nxt = WAIT_ACK_6;
			data_o = data & 8'b01111111;
			addr_o = `UART_REG_LC;			
			we_o = 1'b1;
			cyc_o = 1'b1;
			stb_o = 1'b1;
		end
		WAIT_ACK_6: begin
			if (ack_sampled) begin
				FSM_state_nxt = WAIT_STATE_3;
			end else begin
				FSM_state_nxt = WAIT_ACK_6;
			end			
		end
		WAIT_STATE_3: begin
			FSM_state_nxt = WRITE_5;			
			stb_o = 1'b0;
			end	

		WRITE_5: begin
			FSM_state_nxt = WAIT_ACK_7;
			data_o =  8'b0;
			addr_o =  `UART_REG_FC;			
			we_o = 1'b1;
			cyc_o = 1'b1;
			stb_o = 1'b1;
		end
		WAIT_ACK_7: begin
			if (ack_sampled) begin
				FSM_state_nxt = WAIT_PRE_READ_2;
			end else begin
				FSM_state_nxt = WAIT_ACK_7;
			end			
		end
		WAIT_PRE_READ_2: begin
			FSM_state_nxt = READ_3;			
			stb_o = 1'b0;
			we_o = 1'b0;
			cyc_o = 1'b0;
			end	

	
		READ_3: begin
			FSM_state_nxt = WAIT_ACK_8;
			addr_o = `UART_REG_IE;
			we_o = 1'b0;
			cyc_o = 1'b1;
			stb_o = 1'b1;
		end
		WAIT_ACK_8: begin
			if (ack_sampled) begin
				FSM_state_nxt = WRITE_6;
			end else begin
				FSM_state_nxt = WAIT_ACK_8;
			end
		end
		WRITE_6: begin
			FSM_state_nxt = WAIT_ACK_9;
			data_o = data | 8'b00000001;
			addr_o = `UART_REG_IE;	
			we_o = 1'b1;
			cyc_o = 1'b1;
			stb_o = 1'b1;
		end
		WAIT_ACK_9: begin
			if (ack_sampled) begin
				FSM_state_nxt = CONF_DONE;
			end else begin
				FSM_state_nxt = WAIT_ACK_9;
			end			
		end
		CONF_DONE: begin
			FSM_state_nxt = CONF_DONE;			
			data_o ='0;
			addr_o = '0; 		
			we_o = 1'b0;
			cyc_o = 1'b0;
			stb_o = 1'b0;
			config_done = 1'b1;
		end			
	endcase
end

always_ff@(posedge clk or negedge rstn)
begin
	if(!rstn) begin 
		FSM_state <= IDLE;
		ack_sampled <= 1'b0;
	end else begin
		FSM_state <= FSM_state_nxt;
		ack_sampled <= ack_i;
	end
end

always_ff@(posedge clk or negedge rstn)
begin
	if(!rstn) 
		data <= '0;
	else if (ack_i)
		data <= data_i;
end


endmodule // uart_config

