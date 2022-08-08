/*
 
 

 */
`timescale 1ns/1ns

`include "./uart/uart_defines.v"

module uart_io
  (
   input logic 	clk,
   input logic 	rstn,
   // RC interface
   // uart RX/TX signals
   input logic 	uart_master_tx, 
   output logic uart_master_rx
   );
   
   logic 	interrupt;

   // wishbone interface
   wishbone 
     #(
       .ADDR_W   (`UART_ADDR_WIDTH),
       .DATA_W   (`UART_DATA_WIDTH),
       .SELECT_W (4)
       ) wb_if();
   
   // UART wrapper inst
   uart_wrapper
     uart_wrapper_inst
       (
	.wb_slave       (wb_if),
	.uart_master_tx (uart_master_tx),
	.uart_master_rx (uart_master_rx),
	.interrupt      (interrupt)
	);
   
   // Gateway
   gateway
     gateway_inst
       (
	.wb_master (wb_if),
	.clk       (clk),
	.rstn      (rstn),
	.interrupt (interrupt)
	);

endmodule // uart_io
