`timescale 1ns/1ps

`include "lotr_defines.sv"
module lotr_tb ();
import lotr_pkg::*;
	logic         QClk      ;
	logic         RstQnnnH  ;
	// clock generation
	initial begin: clock_gen
		forever begin
            #5 
            QClk = 1'b0;
            #5 
            QClk = 1'b1;
		end
	end// clock_gen

	// reset generation
	initial begin: reset_gen
		RstQnnnH = 1'b1;
		#80 
        RstQnnnH = 1'b0;
        #1000
        $finish;
	end// reset_gen

lotr lotr(
    //general signals input
    .QClk  		(QClk),   //input
    .RstQnnnH  	(RstQnnnH)
    );


endmodule // tb_top

