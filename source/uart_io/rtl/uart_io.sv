/*
 
 
 */

`timescale 1ns/1ns

module uart_io
  #()
   (
    // RC interface
    // uart serial RX/TX
    );

   /*
   wishbone #(.ADDR_W   (ADDR_W),
	      .DATA_W   (DATA_W),
	      .SELECT_W (SELECT_W)
	      ) wb();
    */
   
   // UART wrapper inst
   uart_wrapper
     #()
   uart_wrapper_inst
     ();
   
   // Gateway
   gateway
     #()
   gateway_inst
     ();

endmodule // uart_io
