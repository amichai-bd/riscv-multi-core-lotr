/*
 UART config routine FSM 
 Wishbone master unit to 
 read/write from UART
 */

`timescale 1ns/1ns

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
    wishbone.master wb_master
    );
   
endmodule // uart_config

