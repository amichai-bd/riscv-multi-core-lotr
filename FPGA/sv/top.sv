module top(
        input  logic        CLK_50,
        input  logic [3:0]  SW,
        input  logic [1:0]  BUTTON,

        output logic [6:0]  HEX0,
        output logic [6:0]  HEX1,
        output logic [6:0]  HEX2,
        output logic [6:0]  HEX3,
        output logic [6:0]  HEX4,
        output logic [6:0]  HEX5,
        output logic [9:0]  LED,

        output logic [3:0]  RED,
        output logic [3:0]  GREEN,
        output logic [3:0]  BLUE,
        output logic        h_sync,
        output logic        v_sync
    );
	 

lotr lotr(
    //general signals input
    .QClk  	(CLK_50),   //input
    .RstQnnnH  	(BUTTON[0])
    );
	 
	  
	assign HEX0 = '0;
        assign HEX1 = '0;
        assign HEX2 = '0;
        assign HEX3 = '0;
        assign HEX4 = '0;
        assign HEX5 = '0;
        assign LED  = '0;

        assign RED      = '0;
        assign GREEN    = '0;
        assign BLUE     = '0;
        assign h_sync   = '0;
        assign v_sync   = '0;
endmodule
