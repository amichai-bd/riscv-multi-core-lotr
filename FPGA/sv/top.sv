`include "lotr_defines.sv"
module top(
        input  logic        CLK_50,
        input  logic [9:0]  SW,
        input  logic [1:0]  BUTTON,
        input  logic [15:0] Arduino_IO,

        input logic         UART_TXD,
        output logic        UART_RXD,
        output logic        INTERRUPT,

        output logic [7:0]  HEX0,
        output logic [7:0]  HEX1,
        output logic [7:0]  HEX2,
        output logic [7:0]  HEX3,
        output logic [7:0]  HEX4,
        output logic [7:0]  HEX5,
        output logic [9:0]  LED,

        output logic [3:0]  RED,
        output logic [3:0]  GREEN,
        output logic [3:0]  BLUE,
        output logic        h_sync,
        output logic        v_sync
    );
	 
/*
logic CLK_5;
	pll_5Mhz pll_5Mhz (
	.inclk0 ( CLK_50),
	.c0		(CLK_5));
*/

/*
logic CLK_50Khz;
	pll_50Khz pll_5Khz (
	.inclk0 ( CLK_50),
	.c0		(CLK_50Khz));
*/

lotr lotr(
    //general signals input
	 //TO ease the compilation time we are using a slow clock. it works also with the 50MHz
    //.QClk  	(CLK_50Khz),   //input
	//.QClk  	(CLK_5),   //input ->5MHz
	.QClk  	(CLK_50),   //input ->50MHz
    .CLK_50 (CLK_50),   //input
    //.RstQnnnH  	(BUTTON[0])
    .Button_0    (BUTTON[0]),
    .Button_1    (BUTTON[1]),
    .Switch      (SW),//,(SW),
	.Arduino_dg_io (Arduino_IO),
    // UART IO
    .uart_master_tx  (UART_TXD),
    .uart_master_rx  (UART_RXD),
    .interrupt       (INTERRUPT),
    //outputs
    .SEG7_0  (HEX0),  //(HEX0),
    .SEG7_1  (HEX1),  //(HEX1),
    .SEG7_2  (HEX2),  //(HEX2),
    .SEG7_3  (HEX3),  //(HEX3),
    .SEG7_4  (HEX4),  //(HEX4),
    .SEG7_5  (HEX5),  //(HEX5),
    .RED     (RED),   //(RED   ),//output logic [3:0] 
    .GREEN   (GREEN), //(GREEN ),//output logic [3:0] 
    .BLUE    (BLUE),  //(BLUE  ),//output logic [3:0] 
    .v_sync  (v_sync),//(v_sync),//output logic       
    .h_sync  (h_sync),//(h_sync),//output logic      
    .LED     (LED)
    );
	 

// This logic is to get data from the Analog pin in the DE10lite 
// currently "Can’t route signal" when using both ADC & othe DE10 lite IP such as VGA, 7SEG
/*
	 logic [10:0] rm1; 
 	 logic [7:0] rm2;
assign LED[8:0] ='0;

	 adc_qsys adc_qsys (
		.CLOCK(CLK_50),//input  wire        CLOCK, //      clk.clk
		.CH0({LED[9],rm1}),  //output wire [11:0] CH0,   // readings.CH0
		.CH1(),  //output wire [11:0] CH1,   //         .CH1
		.CH2(),  //output wire [11:0] CH2,   //         .CH2
		.CH3(),  //output wire [11:0] CH3,   //         .CH3
		.CH4(),  //output wire [11:0] CH4,   //         .CH4
		.CH5(),  //output wire [11:0] CH5,   //         .CH5
		.CH6(),  //output wire [11:0] CH6,   //         .CH6
		.CH7(),  //output wire [11:0] CH7,   //         .CH7
		.RESET(~BUTTON[0]) //input  wire        RESET  //    reset.reset
	);
*/

endmodule
