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

  logic config_done;
  logic [1:0] wishbone_select;

  assign wishbone_select = {1'b0,config_done};

   // wishbone interface
   wishbone 
     #(
       .ADDR_W   (`UART_ADDR_WIDTH),
       .DATA_W   (`UART_DATA_WIDTH),
       .SELECT_W (4)
       ) wb_if[3]();
   
   wishbone_mux3to1
   wishbone_mux3to1
     (
      .clk          (clk),
      .rstn         (rstn),
      .slave_select (wishbone_select),
      .wb_slave_0   (wb_if[0]),
      .wb_slave_1   (wb_if[1]),
      .wb_slave_2   (wb_if[2]),
      .wb_master    (wb_master)
      );
   
   uart_config
   uart_config_inst
     (
      .clk          (clk),
      .rstn         (rstn),
      .interrupt    (interrupt),
      .start_config (1'b1),
      .config_done  (config_done),
      .wb_master    (wb_if[0])
      );
   
   transfer_handler_engine
   transfer_handler_engine_inst
     (
      .clk       (clk),
      .rstn      (rstn),
      .interrupt (interrupt),
      .wb_master (wb_if[1])
      );
  
endmodule // gateway
