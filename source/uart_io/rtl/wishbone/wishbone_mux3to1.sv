/*
 wishbone mux selects
 between multiple masters
 */

`timescale 1ns/1ns

module wishbone_mux3to1
  #(
	 parameter integer N_SLAVES=3,
    parameter integer W_SLAVES=$clog2(N_SLAVES)
    )
   (
    input logic 	       clk,
    input logic 	       rstn,
    input logic [W_SLAVES-1:0] slave_select,
    wishbone.slave wb_slave_0,
    wishbone.slave wb_slave_1,
    wishbone.slave wb_slave_2,
    wishbone.master wb_master
    );
   
   assign wb_master.clk = clk;
   assign wb_master.rstn = rstn;
   
   always_comb begin
	
	wb_slave_0.ack     = 1'b0;
	wb_slave_0.data_in = '0;
	
	wb_slave_1.ack     = 1'b0;
	wb_slave_1.data_in = '0;
	
	wb_slave_2.ack     = 1'b0;
	wb_slave_2.data_in = '0;
	
	wb_master.address	 = '0;
	wb_master.data_out = '0;
	wb_master.we		 = 1'b0;
	wb_master.stb	    = 1'b0;
	wb_master.cyc	    = 1'b0;
	wb_master.sel	    = 1'b0;   
	
	
      case(slave_select)
	
	2'd0: begin
	   // request
	   wb_master.address	= wb_slave_0.address;
	   wb_master.data_out	= wb_slave_0.data_out;
	   wb_master.we		= wb_slave_0.we;
	   wb_master.stb	= wb_slave_0.stb;
	   wb_master.cyc	= wb_slave_0.cyc;
	   wb_master.sel	= wb_slave_0.sel;   
	   // responce
	   wb_slave_0.ack	= wb_master.ack;
	   wb_slave_0.data_in	= wb_master.data_in; 
	end
	
	2'd1: begin
	   // request
	   wb_master.address	= wb_slave_1.address;
	   wb_master.data_out	= wb_slave_1.data_out;
	   wb_master.we		= wb_slave_1.we;
	   wb_master.stb	= wb_slave_1.stb;
	   wb_master.cyc	= wb_slave_1.cyc;
	   wb_master.sel	= wb_slave_1.sel;   
	   // responce
	   wb_slave_1.ack	= wb_master.ack;
	   wb_slave_1.data_in	= wb_master.data_in; 
	end

	2'd2: begin
	   // request
	   wb_master.address	= wb_slave_2.address;
	   wb_master.data_out	= wb_slave_2.data_out;
	   wb_master.we		= wb_slave_2.we;
	   wb_master.stb	= wb_slave_2.stb;
	   wb_master.cyc	= wb_slave_2.cyc;
	   wb_master.sel	= wb_slave_2.sel;   
	   // responce
	   wb_slave_2.ack	= wb_master.ack;
	   wb_slave_2.data_in	= wb_master.data_in; 
	end

	default: begin
	   // request
	   wb_master.address	= wb_slave_0.address;
	   wb_master.data_out	= wb_slave_0.data_out;
	   wb_master.we		= wb_slave_0.we;
	   wb_master.stb	= wb_slave_0.stb;
	   wb_master.cyc	= wb_slave_0.cyc;
	   wb_master.sel	= wb_slave_0.sel;   
	   // responce
	   wb_slave_0.ack	= wb_master.ack;
	   wb_slave_0.data_in	= wb_master.data_in; 	   
	end
      endcase // case (slave_select)
   end     
endmodule // wishbone_mux3to1

