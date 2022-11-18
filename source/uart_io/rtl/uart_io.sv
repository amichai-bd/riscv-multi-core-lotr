/*
 
 

 */
`timescale 1ns/1ns

`include "./uart/uart_defines.v"
`include "./common/lotr_defines.sv"

module uart_io
  import lotr_pkg::*;
  (
   input logic 	       clk,
   input logic 	       rstn,
   // RC interface
   // Core To Fabric(C2F)
   // ----input----
   input logic 	       C2F_RspValidQ502H, 
   input 	       t_opcode C2F_RspOpcodeQ502H, 
   input logic [1:0]   C2F_RspThreadIDQ502H, 
   input logic [31:0]  C2F_RspDataQ502H,
   input logic 	       C2F_RspStall,
   // ----output----
   output logic        C2F_ReqValidQ500H,
   output 	       t_opcode C2F_ReqOpcodeQ500H,
   output logic [1:0]  C2F_ReqThreadIDQ500H,
   output logic [31:0] C2F_ReqAddressQ500H,
   output logic [31:0] C2F_ReqDataQ500H,
   // Fabric To Core(F2C)
   //----input----
   input logic 	       F2C_ReqValidQ502H,
   input 	       t_opcode F2C_ReqOpcodeQ502H,
   input logic [31:0]  F2C_ReqAddressQ502H,
   input logic [31:0]  F2C_ReqDataQ502H,
   //----output----
   output logic        F2C_RspValidQ500H,
   output 	       t_opcode F2C_RspOpcodeQ500H,
   output logic [31:0] F2C_RspAddressQ500H,
   output logic [31:0] F2C_RspDataQ500H, 
   // uart RX/TX signals
   input logic 	       uart_master_tx, 
   output logic        uart_master_rx
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
