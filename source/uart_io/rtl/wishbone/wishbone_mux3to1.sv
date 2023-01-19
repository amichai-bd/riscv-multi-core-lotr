/*
 wishbone mux selects
 between multiple masters
 */

`timescale 1ns/1ns

module wishbone_mux3to1
  (
   input logic slave_select,
   wishbone.slave wb_slave_0,
   wishbone.slave wb_slave_1,
   wishbone.master wb_master
   );
   
   always_comb begin
      wb_slave_0.ack		= 1'b0;
      wb_slave_0.data_in	= '0; 
      wb_slave_1.ack		= 1'b0;
      wb_slave_1.data_in	= '0; 
      if(slave_select==1'b0) begin
	 wb_master.address	= wb_slave_0.address;
	 wb_master.data_out	= wb_slave_0.data_out;
	 wb_master.we		= wb_slave_0.we;
	 wb_master.stb		= wb_slave_0.stb;
	 wb_master.cyc		= wb_slave_0.cyc;
	 wb_master.sel		= wb_slave_0.sel;   
	 wb_slave_0.ack		= wb_master.ack;
	 wb_slave_0.data_in	= wb_master.data_in; 
      end
      else begin
	 wb_master.address	= wb_slave_1.address;
	 wb_master.data_out	= wb_slave_1.data_out;
	 wb_master.we		= wb_slave_1.we;
	 wb_master.stb		= wb_slave_1.stb;
	 wb_master.cyc		= wb_slave_1.cyc;
	 wb_master.sel		= wb_slave_1.sel;   
	 wb_slave_1.ack		= wb_master.ack;
	 wb_slave_1.data_in	= wb_master.data_in; 
      end
   end     
endmodule // wishbone_mux3to1

