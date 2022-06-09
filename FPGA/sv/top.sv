module top(
        input  logic        CLK_50,
        input  logic [9:0]  SW,
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
	 
logic CLK_5;
	pll_5Mhz pll_5Mhz (
	.inclk0 ( CLK_50),
	.c0		(CLK_5));
	 
lotr lotr(
    //general signals input
    .QClk  	(CLK_5),   //input
    //.RstQnnnH  	(BUTTON[0])
    .Button_0    (BUTTON[0]),
    .Button_1    (BUTTON[1]),
    .Switch      (SW),

    //utputs
    .SEG7_0  (HEX0),
    .SEG7_1  (HEX1),
    .SEG7_2  (HEX2),
    .SEG7_3  (HEX3),
    .SEG7_4  (HEX4),
    .SEG7_5  (HEX5),
    .LED     (LED)
    
    );
	 
	  

        assign RED      = '0;
        assign GREEN    = '0;
        assign BLUE     = '0;
        assign h_sync   = '0;
        assign v_sync   = '0;
endmodule
