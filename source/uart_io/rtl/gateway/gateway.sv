/*
 RC to wishbone gateway controller
 this module controlls the uart ip 
 via wishbone transactions and the 
 lotr project via the RC controller
 */

`timescale 1ns/1ns

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

   assign wb_master.clk = clk;
   assign wb_master.rstn = rstn;
   assign wb_master.address = '0;
   assign wb_master.data_out = '0;
   assign wb_master.we = '0;
   assign wb_master.stb = '0;
   assign wb_master.cyc = '0;
   assign wb_master.sel = '0;

endmodule // gateway
