
interface wishbone
  #(parameter integer ADDR_W=3,
    parameter integer DATA_W=8,
    parameter integer SELECT_W=4);   
   logic [ADDR_W-1:0] address;
   logic [DATA_W-1:0] data_in;
   logic [DATA_W-1:0] data_out;
   logic 	      we;
   logic 	      stb;
   logic 	      cyc;
   logic 	      ack;
   logic [SELECT_W-1:0] sel;
   
   // master side
   modport master
     (
      input  ack, data_in,
      output address, data_out, we, stb, cyc, sel
      );

   // slave side
   modport slave
     (
      output ack, data_in,
      input  address, data_out, we, stb, cyc, sel
      );
   
endinterface // wishbone
