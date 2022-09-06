/*
 Xmodem File transfer protocol
 handler, packet proccessing,
 and decoding unit as a wishbone
 master on uart slave module
 */

`timescale 1ns/1ns

module xmodem
  import xmodem_pkg::*;
   #()
   (
    input logic clk,
    input logic rstn,
    wishbone.master wb_master
    );
   
   t_xmodem_fsm current_state, next_state;

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) current_state <= IDLE; //'0
      else      current_state <= next_state;
   end
   
   always_comb begin
      next_state = IDLE;      
      case(current_state) 
	IDLE: begin
	end	
	WAITE_FOR_SYMBOL: begin
	end	
	PROCCESS_PACKET_NUMBER: begin
	end	
	PROCCESS_PACKET_NUMBER_1s: begin
	end	
	PROCCESS_DATA: begin
	end	
	VALIDATE_CHECKSUM: begin
	end
	default: next_state = IDLE;
      endcase
   end
   
endmodule // xmodem

