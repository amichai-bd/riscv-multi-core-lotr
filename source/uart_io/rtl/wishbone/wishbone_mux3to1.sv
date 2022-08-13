/*
 wishbone mux selects
 between multiple masters
 */

`timescale 1ns/1ns

module wishbone_mux3to1
  #(
    parameter integer N_SLAVES=3
    )
   (
    input logic       clk,
    input logic       rstn,
    input logic [1:0] slave_select,
    wishbone.slave    wb_slave_0,
    wishbone.slave    wb_slave_1,
    wishbone.slave    wb_slave_2,
    wishbone.master   wb_master
    );

endmodule // wishbone_mux3to1

