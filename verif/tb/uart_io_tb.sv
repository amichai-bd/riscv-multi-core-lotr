`timescale 1ns/1ns

`include "lotr_defines.sv"
module uart_io_tb ();
   import lotr_pkg::*;

   // CLK PARAMETERS 20MHz CLK
   localparam integer HALF_CLK=25; 
   localparam integer CLK_PERIOD=2*HALF_CLK;

   // UART PROTOCOL PARAMS
   localparam bit     LSB_FIRST=1;        //[0/1] 0: MSB first,   1: LSB first
   localparam bit     PARITY_EN=0;        //[0/1] 0: disable,     1: enable
   localparam bit     SINGLE_STOP_BIT=1;  //[0/1] 0: 2 stop bits, 1: single
   localparam integer N_DATA_BITS=8;      //[5:8] can be any number between 5 and 8
   localparam integer BUADRATE=9600;      //[] bits per sec
   localparam integer NANOSECOND=1e+9;
   localparam         UART_BIT_PERIOD=(NANOSECOND/BUADRATE);

   logic 	      clk;
   logic 	      rstn;
   logic 	      clk_en;
   logic 	      uart_master_tx; //pc side to uart
   logic 	      uart_master_rx; //pc side to uart
   
   always #HALF_CLK
     clk = (clk_en) ? ~clk : 0;


   uart_io
     #()
   uart_io_DUT
     (
      // clk, rst
      
      // RC interface

      // UART RX/TX signals 
      );
   
   task print(string str);
      $display("-I- time=%0t[ns]: %s",
               $time, str);   
   endtask // print

   task uart_bit_wait(int bits);
      #(bits*UART_BIT_PERIOD);
   endtask // uart_bit_wait
      
   task delay(int cycles);
      #(cycles*CLK_PERIOD);
   endtask // delay
   
   task reset();
      print("Asserting reset");
      rstn=1'b0;
      delay(100);
      rstn=1'b1;
   endtask // reset

   task enable_clk();
      clk_en=1'b1;
   endtask // enable_clk

   //uart host to device transmit
   task UART_H2D_transmit;
      input logic [N_DATA_BITS-1:0] data;      
      print($sformatf("UART transmiting Host to Device, %b", data));
      // start bit
      uart_master_tx=1'b0;
      uart_bit_wait(1);       
      // data bits
      for(int i=0; i<N_DATA_BITS; i++) begin
	 uart_master_tx = data[i]; 
	 uart_bit_wait(1);
      end		     
      // parity
      if(PARITY_EN) begin 
	 uart_master_tx = ^data;
	 uart_bit_wait(1);
      end
      // end bits
      uart_master_tx = 1'b1;
      uart_bit_wait((SINGLE_STOP_BIT) ? 1 : 2);
   endtask // UART_H2D_transmit

   
   initial begin
      $display("UART playground testbench");      
      delay(10); init();
      delay(10); reset();
      delay(10); enable_clk();
      
      $finish();
   end
   
endmodule
