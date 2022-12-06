/*
 
 

 */
`timescale 1ns/1ns

`include "./uart/uart_defines.v"
`include "../../common/lotr_defines.sv"

module uart_io
  import lotr_pkg::*;
  (
   input  logic 	      clk,
   input  logic 	      rstn,
   input  logic [7:0]   core_id,
   //RC <---> Core C2F
   // Request
   output logic         C2F_ReqValidQ500H      ,
   output t_opcode      C2F_ReqOpcodeQ500H     ,
   output logic  [31:0] C2F_ReqAddressQ500H    ,
   output logic  [31:0] C2F_ReqDataQ500H       ,
   output logic  [1:0]  C2F_ReqThreadIDQ500H   ,
   // Response
   input  logic         C2F_RspValidQ502H      ,
   input  t_opcode      C2F_RspOpcodeQ502H     ,
   input  logic  [31:0] C2F_RspDataQ502H       ,
   input  logic         C2F_RspStall           ,
   input  logic  [1:0]  C2F_RspThreadIDQ502H   ,     
   // uart RX/TX signals
   input   logic 	      uart_master_tx, 
   output  logic        uart_master_rx,
   output  logic        interrupt
   );
   
   logic 	uart_interrupt;
  assign interrupt = uart_interrupt;

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
        .interrupt      (uart_interrupt)
        );
   
   // Gateway
   gateway
     gateway_inst
       (
        .wb_master (wb_if),
        .clk       (clk),
        .rstn      (rstn),
        .interrupt (uart_interrupt)
        );

/*
Reg-to-RC and RC-to-Reg
to add module design...
*/

endmodule // uart_io