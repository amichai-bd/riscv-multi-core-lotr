`timescale 1ps/1ps

`include "lotr_defines.sv"

module gpc_4t_tile_tb;
import lotr_pkg::*;
	logic         QClk                     ;
	logic         RstQnnnH                 ;
	logic  [7:0]  CoreID_tb  		       ; 
	logic         RingInputValidQ500H_tb   ; 
	t_opcode      RingInputOpcodeQ500H_tb  ; 
	logic  [31:0] RingInputAddressQ500H_tb ; 
	logic  [31:0] RingInputDataQ500H_tb    ; 
	logic         RingOutputValidQ502H_tb  ; 
	t_opcode      RingOutputOpcodeQ502H_tb ; 
	logic  [31:0] RingOutputAddressQ502H_tb; 
	logic  [31:0] RingOutputDataQ502H_tb   ; 
	
	// clock generation
	initial begin: clock_gen
		forever begin
            #5 
            QClk = 1'b0;
            #5 
            QClk = 1'b1;
		end
	end: clock_gen

	// reset generation
	initial begin: reset_gen
		RstQnnnH = 1'b1;
		#40 
        RstQnnnH = 1'b0;
	end: reset_gen
	
	initial begin: wr_req_in_ring_input
        CoreID_tb                  = 8'b01;
	    RingInputValidQ500H_tb     = '0 ; 
		RingInputOpcodeQ500H_tb    = RD ; // 2'b00
		RingInputAddressQ500H_tb   = '0 ; 
		RingInputDataQ500H_tb      = '0 ; 
		#95
		RingInputValidQ500H_tb     = 1'b1 ; 
		RingInputOpcodeQ500H_tb    = WR ; //write
		RingInputAddressQ500H_tb   = 32'h0200_0001 ; 
		RingInputDataQ500H_tb      = 32'h0200_0001 ; 
		#10
		RingInputValidQ500H_tb     = 1'b0 ; 
		RingInputOpcodeQ500H_tb    = RD ; // 2'b00
		RingInputAddressQ500H_tb   = 32'h0000_0000 ; 
		RingInputDataQ500H_tb      = 32'h0000_0000 ; 
        #1000 
        $finish;
	end: wr_req_in_ring_input

gpc_4t_tile gpc_4t_tile(	  
              //general signals input
			  .QClk  		          (QClk),                       //input
			  .RstQnnnH  	          (RstQnnnH),                   //input
			  .CoreID       		  (CoreID_tb),                  //input
              //tile input
			  .RingInputValidQ500H    (RingInputValidQ500H_tb),     //input
			  .RingInputOpcodeQ500H   (RingInputOpcodeQ500H_tb),    //input
			  .RingInputAddressQ500H  (RingInputAddressQ500H_tb),   //input
			  .RingInputDataQ500H     (RingInputDataQ500H_tb),      //input
              //tile output
			  .RingOutputValidQ502H   (),                           // outout
			  .RingOutputOpcodeQ502H  (),                           // outout
			  .RingOutputAddressQ502H (),                           // outout
			  .RingOutputDataQ502H    ()                            // outout
			 );


endmodule // tb_top

