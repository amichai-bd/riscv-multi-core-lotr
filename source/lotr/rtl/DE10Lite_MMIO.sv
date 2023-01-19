//-----------------------------------------------------------------------------
// Title            : 
// Project          : 
//-----------------------------------------------------------------------------
// File             : 
// Original Author  : 
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 06/2022
//-----------------------------------------------------------------------------
// Description :
//
`include "lotr_defines.sv"


module DE10Lite_MMIO 
import lotr_pkg::*;
(
    input  logic       CLK_50,
    input  logic       QClk,
    input  logic       RstQnnnH,
    input  logic [7:0]    CoreID              ,

    input logic        F2C_ReqValidQ502H      ,//input
    input t_opcode     F2C_ReqOpcodeQ502H     ,//input
    input logic [31:0] F2C_ReqAddressQ502H    ,//input
    input logic [31:0] F2C_ReqDataQ502H       ,//input

    output logic        F2C_RspValidQ500H      ,//output
    output t_opcode     F2C_RspOpcodeQ500H     ,//output
    output logic [31:0] F2C_RspAddressQ500H    ,//output
    output logic [31:0] F2C_RspDataQ500H       ,//output

    // FPGA interface inputs
    input  logic        Button_0,
    input  logic        Button_1,
    input  logic [9:0]  Switch,
    input  logic [15:0] Arduino_dg_io,

    // FPGA interface outputs
    output logic [7:0] SEG7_0,
    output logic [7:0] SEG7_1,
    output logic [7:0] SEG7_2,
    output logic [7:0] SEG7_3,
    output logic [7:0] SEG7_4,
    output logic [7:0] SEG7_5,
    output logic [3:0] RED,
    output logic [3:0] GREEN,
    output logic [3:0] BLUE,
    output logic       v_sync,
    output logic       h_sync,
    output logic [9:0] LED,
	 output logic       ALL_PC_RESET
);

// Memory CR objects (behavrial - not for FPGA/ASIC)
t_cr_ro_fpga cr_ro;
t_cr_rw_fpga cr_rw;
t_cr_ro_fpga cr_ro_next;
t_cr_rw_fpga cr_rw_next;
logic CtrlCRMemWrEn;
// Data-Path signals
logic  F2C_ReqValidQ503H;
t_opcode F2C_ReqOpcodeQ503H;
logic [31:0] F2C_ReqAddressQ503H;
logic [31:0] F2C_RspAddressQ504H;
logic        F2C_RspValidQ504H;
logic [31:0] F2C_ReqDataQ503H;
logic [31:0] F2C_RspDataQ503H;
logic [31:0] F2C_RspDataQ504H;
logic [31:0] CrRspDataQ504H;
logic [31:0] VgaRspDataQ504H;
t_opcode F2C_RspOpcodeQ504H;
logic CtrlCRMemRdEnQ503; 
logic CtrlCRMemWrEnQ503;
logic CtrlCRMemRdEnQ504; 
logic CtrlCRMemWrEnQ504;
logic CtrlVgaMemRdEnQ503; 
logic CtrlVgaMemWrEnQ503;
logic CtrlVgaMemRdEnQ504; 
logic CtrlVgaMemWrEnQ504;
//Sample input 502 -> 503
`LOTR_MSFF(F2C_ReqValidQ503H   , F2C_ReqValidQ502H   , QClk)
`LOTR_MSFF(F2C_ReqOpcodeQ503H  , F2C_ReqOpcodeQ502H  , QClk)
`LOTR_MSFF(F2C_ReqAddressQ503H , F2C_ReqAddressQ502H , QClk)
`LOTR_MSFF(F2C_ReqDataQ503H    , F2C_ReqDataQ502H    , QClk)

assign CtrlCRMemRdEnQ503 = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == RD) && (F2C_ReqAddressQ503H[MSB_REGION:LSB_REGION] == CR_REGION);
assign CtrlCRMemWrEnQ503 = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == WR) && (F2C_ReqAddressQ503H[MSB_REGION:LSB_REGION] == CR_REGION);

assign CtrlVgaMemRdEnQ503 = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == RD) && (F2C_ReqAddressQ503H[MSB_REGION:LSB_REGION] == D_MEM_REGION);
assign CtrlVgaMemWrEnQ503 = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == WR) && (F2C_ReqAddressQ503H[MSB_REGION:LSB_REGION] == D_MEM_REGION);


//[31:24] TILEID
//[23:22] region
//[16:0]  offset
//
//            D_MEM
//32'b00000011_01_0000<offset> //offset is 0->38400 (This is in Byte)
//                             //offset is 0->9600 (This is in 32 bit words)
//                             //offset is 2D VGA[80][120]
//            CR_MEM                             
//32'b00000011_10_0000<offset>
//

`LOTR_MSFF(CtrlVgaMemRdEnQ504    , CtrlVgaMemRdEnQ503    , QClk)
`LOTR_MSFF(CtrlVgaMemWrEnQ504    , CtrlVgaMemWrEnQ503    , QClk)
vga_ctrl vga_ctrl (
    .CLK_50             (CLK_50           ),  //input  logic        
    .QClk               (QClk             ),  //input  logic        
    .Reset              (RstQnnnH         ),  //input  logic        
    //// VGA memory 
    .F2C_ReqDataQ503H   (F2C_ReqDataQ503H   ),//input  logic [31:0] 
    .F2C_ReqAddressQ503H(F2C_ReqAddressQ503H),//input  logic [31:0] 
    .CtrlVGAMemByteEn   (4'b1111 ),           //input  logic [3:0]  
    .CtrlVgaMemWrEnQ503 (CtrlVgaMemWrEnQ503),  //input  logic        
    //// Read core  
    .CtrlVgaMemRdEnQ503 (CtrlVgaMemRdEnQ503),  //input  logic        
    .VgaRspDataQ504H    (VgaRspDataQ504H),    //output logic [31:0] 
    //// VGA output  
    .RED                (RED              ),  //output logic [3:0]  
    .GREEN              (GREEN            ),  //output logic [3:0]  
    .BLUE               (BLUE             ),  //output logic [3:0]  
    .h_sync             (h_sync           ),  //output logic        
    .v_sync             (v_sync           )   //output logic        
);


//==============================
// Memory Access
//------------------------------
// 1. Access CR_MEM for Write (STORE) and Reads (LOAD)
//==============================
always_comb begin
    cr_ro_next = cr_ro;
    cr_rw_next = cr_rw; 
    if(CtrlCRMemWrEnQ503) begin
        unique casez (F2C_ReqAddressQ503H[19:0]) // AluOut holds the offset
            // ---- RW memory ----
            CR_SEG7_0 : cr_rw_next.SEG7_0 = F2C_ReqDataQ503H[7:0];
            CR_SEG7_1 : cr_rw_next.SEG7_1 = F2C_ReqDataQ503H[7:0];
            CR_SEG7_2 : cr_rw_next.SEG7_2 = F2C_ReqDataQ503H[7:0];
            CR_SEG7_3 : cr_rw_next.SEG7_3 = F2C_ReqDataQ503H[7:0];
            CR_SEG7_4 : cr_rw_next.SEG7_4 = F2C_ReqDataQ503H[7:0];
            CR_SEG7_5 : cr_rw_next.SEG7_5 = F2C_ReqDataQ503H[7:0];
            CR_LED    : cr_rw_next.LED    = F2C_ReqDataQ503H[9:0];
			CR_ALL_PC_RESET: cr_rw_next.ALL_PC_RESET = F2C_ReqDataQ503H[0];
            // ---- Other ----
            default   : /* Do nothing */;
        endcase
    end
    // ---- RO memory - writes from FPGA ----
    cr_ro_next.Button_0 = Button_0;
    cr_ro_next.Button_1 = Button_1;
    cr_ro_next.Switch   = Switch;
    cr_ro_next.Arduino_dg_io = Arduino_dg_io;
    // update only when a valid read from Arduino_dg_io
    if(|cr_ro.Arduino_dg_io) cr_ro_next.Sticky_Arduino_dg_io = cr_ro.Arduino_dg_io; 
end



// This is the load
always_comb begin
		F2C_RspDataQ503H = '0;
    if(CtrlCRMemRdEnQ503) begin
        unique casez (F2C_ReqAddressQ503H[19:0]) // AluOut holds the offset
            // ---- RW memory ----
            CR_SEG7_0   : F2C_RspDataQ503H = {24'b0 , cr_rw.SEG7_0}   ; 
            CR_SEG7_1   : F2C_RspDataQ503H = {24'b0 , cr_rw.SEG7_1}   ;
            CR_SEG7_2   : F2C_RspDataQ503H = {24'b0 , cr_rw.SEG7_2}   ;
            CR_SEG7_3   : F2C_RspDataQ503H = {24'b0 , cr_rw.SEG7_3}   ;
            CR_SEG7_4   : F2C_RspDataQ503H = {24'b0 , cr_rw.SEG7_4}   ;
            CR_SEG7_5   : F2C_RspDataQ503H = {24'b0 , cr_rw.SEG7_5}   ;
            CR_LED      : F2C_RspDataQ503H = {22'b0 , cr_rw.LED}      ;
            CR_ALL_PC_RESET:F2C_RspDataQ503H = {31'b0 , cr_rw.ALL_PC_RESET};

            // ---- RO memory ----
            CR_Button_0 : F2C_RspDataQ503H = {31'b0 , cr_ro.Button_0} ;
            CR_Button_1 : F2C_RspDataQ503H = {31'b0 , cr_ro.Button_1} ;
            CR_Switch   : F2C_RspDataQ503H = {22'b0 , cr_ro.Switch}   ;
            CR_Arduino_dg_io : F2C_RspDataQ503H = {16'b0 , cr_ro.Arduino_dg_io[15:0]}   ;
            CR_Sticky_Arduino_dg_io : F2C_RspDataQ503H = {16'b0 , cr_ro.Sticky_Arduino_dg_io[15:0]}   ;
            // ---- Other ----
            default     : F2C_RspDataQ503H = 32'b0                         ;
        endcase
    end
end
//============================================
//    set F2C Respose 504 ( D_MEM | I_MEM )
//============================================

// align Read ALtency 503 -> 504
assign      F2C_RspOpcodeQ504H  = RD_RSP;


// Sample the data load - synchorus load
`LOTR_MSFF(F2C_RspAddressQ504H,  F2C_ReqAddressQ503H, QClk)
`LOTR_MSFF(CrRspDataQ504H,       F2C_RspDataQ503H, QClk)
`LOTR_MSFF(CtrlCRMemRdEnQ504,    CtrlCRMemRdEnQ503, QClk)
`LOTR_MSFF(CtrlCRMemWrEnQ504,    CtrlCRMemWrEnQ503, QClk)

assign F2C_RspValidQ504H = CtrlCRMemRdEnQ504 || CtrlCRMemWrEnQ504 || CtrlVgaMemRdEnQ504 || CtrlVgaMemWrEnQ504;
assign F2C_RspDataQ504H  = CtrlCRMemRdEnQ504  ? CrRspDataQ504H  : 
                           CtrlVgaMemRdEnQ504 ? VgaRspDataQ504H :
                                                '0              ;
`LOTR_MSFF(F2C_RspValidQ500H   , F2C_RspValidQ504H   , QClk)
`LOTR_MSFF(F2C_RspOpcodeQ500H  , F2C_RspOpcodeQ504H  , QClk)
`LOTR_MSFF(F2C_RspAddressQ500H , F2C_RspAddressQ504H , QClk)
`LOTR_MSFF(F2C_RspDataQ500H    , F2C_RspDataQ504H    , QClk)



`LOTR_RST_MSFF(cr_rw, cr_rw_next, QClk, RstQnnnH)
`LOTR_RST_MSFF(cr_ro, cr_ro_next, QClk, RstQnnnH)

// Reflects outputs to the FPGA - synchorus reflects
`LOTR_RST_MSFF(SEG7_0      , cr_rw.SEG7_0      , QClk, RstQnnnH)
`LOTR_RST_MSFF(SEG7_1      , cr_rw.SEG7_1      , QClk, RstQnnnH)
`LOTR_RST_MSFF(SEG7_2      , cr_rw.SEG7_2      , QClk, RstQnnnH)
`LOTR_RST_MSFF(SEG7_3      , cr_rw.SEG7_3      , QClk, RstQnnnH)
`LOTR_RST_MSFF(SEG7_4      , cr_rw.SEG7_4      , QClk, RstQnnnH)
`LOTR_RST_MSFF(SEG7_5      , cr_rw.SEG7_5      , QClk, RstQnnnH)
`LOTR_RST_MSFF(LED         , cr_rw.LED         , QClk, RstQnnnH)
`LOTR_RST_MSFF(ALL_PC_RESET, cr_rw.ALL_PC_RESET, QClk, RstQnnnH)


// This logic is to get data from the DE10lite Analog pins
// currently "Can’t route signal" when using both ADC & othe DE10 lite IP such as VGA, 7SEG
/*
logic [11:0] adc_digital_output;
`LOTR_RST_MSFF(LED    , adc_digital_output[11:2], QClk, RstQnnnH)
	 adc_qsys adc_qsys (
		.CLOCK(CLK_50),//input  wire        CLOCK, //      clk.clk
		.CH0(),  //output wire [11:0] CH0,   // readings.CH0
		.CH1(),  //output wire [11:0] CH1,   //         .CH1
		.CH2(),  //output wire [11:0] CH2,   //         .CH2
		.CH3(),  //output wire [11:0] CH3,   //         .CH3
		.CH4(),  //output wire [11:0] CH4,   //         .CH4
		.CH5(),  //output wire [11:0] CH5,   //         .CH5
		.CH6(),  //output wire [11:0] CH6,   //         .CH6
		.CH7(),  //output wire [11:0] CH7,   //         .CH7
		.RESET(RstQnnnH) //input  wire        RESET  //    reset.reset
	);
*/
endmodule // Module rvc_asap_5pl_cr_mem