/*
 Xmodem File transfer protocol
 handler, packet proccessing,
 and decoding unit as a wishbone
 master on uart slave module
 */

`timescale 1ns/1ns

module xmodem
  #()
   (
    input logic clk,
    input logic rstn,
    wishbone.master wb_master
    );

endmodule // xmodem

