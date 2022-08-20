/*
 RC to wishbone gateway controller
 this module controlls the uart ip 
 via wishbone transactions and the 
 lotr project via the RC controller
 */

`timescale 1ns/1ns
`include "../uart/uart_defines.v"

module gateway
  (
   input logic clk,
   input logic rstn,
   // wishbone master interface
   wishbone.master wb_master,
   input logic interrupt
   // RC Interface
   // TBD...  
   );

   // wishbone interface
   wishbone 
     #(
       .ADDR_W   (`UART_ADDR_WIDTH),
       .DATA_W   (`UART_DATA_WIDTH),
       .SELECT_W (4)
       ) wb_if[3]();
   
   wishbone_mux3to1
     #()
   wishbone_mux3to1
     (
      .clk          (clk),
      .rstn         (rstn),
      .slave_select ('0),
      .wb_slave_0   (wb_if[0]),
      .wb_slave_1   (wb_if[1]),
      .wb_slave_2   (wb_if[2]),
      .wb_master    (wb_master)
      );
   
   uart_config
     #()
   uart_config_inst
     (
      .clk       (clk),
      .rstn      (rstn),
      .wb_master (wb_if[0])
      );
   
   handshake
     #()
   handshake_inst
     (
      .clk       (clk),
      .rstn      (rstn),
      .wb_master (wb_if[1])
      );

   xmodem
     #()
   xmodem_inst
     (
      .clk(clk),
      .rstn(rstn),
      .wb_master(wb_if[2])
      );
  
endmodule // gateway
