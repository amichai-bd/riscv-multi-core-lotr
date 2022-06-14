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
    input  logic       RstQnnnH,
    input  logic [7:0]    CoreID              ,

    // input logic C2F_RspValidQ502H      ,//input
    // input t_opcode C2F_RspOpcodeQ502H     ,//input
    // input logic [1:0] C2F_RspThreadIDQ502H  ,//input
    // input logic [31:0] C2F_RspDataQ502H      ,//input
    // input logic        C2F_RspStall           ,//input
    
    // output logic C2F_ReqValidQ500H      ,//output
    // output t_opcode C2F_ReqOpcodeQ500H     ,//output
    // output logic [1:0]   C2F_ReqThreadIDQ500H   ,//output
    // output logic [31:0]  C2F_ReqAddressQ500H    ,//output
    // output logic [31:0]  C2F_ReqDataQ500H       ,//output

    input logic        F2C_ReqValidQ502H      ,//input
    input t_opcode     F2C_ReqOpcodeQ502H     ,//input
    input logic [31:0] F2C_ReqAddressQ502H    ,//input
    input logic [31:0] F2C_ReqDataQ502H       ,//input

    output logic        F2C_RspValidQ500H      ,//output
    output t_opcode     F2C_RspOpcodeQ500H     ,//output
    output logic [31:0] F2C_RspAddressQ500H    ,//output
    output logic [31:0] F2C_RspDataQ500H       ,//output

    // FPGA interface inputs
    input  logic       Button_0,
    input  logic       Button_1,
    input  logic [9:0] Switch,

    // FPGA interface outputs
    output logic [6:0] SEG7_0,
    output logic [6:0] SEG7_1,
    output logic [6:0] SEG7_2,
    output logic [6:0] SEG7_3,
    output logic [6:0] SEG7_4,
    output logic [6:0] SEG7_5,
    output logic [9:0] LED
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
logic [31:0] F2C_ReqDataQ503H;
logic [31:0] F2C_RspDataQ503H;
logic [31:0] F2C_RspDataQ504H;
t_opcode F2C_RspOpcodeQ504H;
logic CtrlCRMemRdEnQ503; 
logic CtrlCRMemWrEnQ503;
logic CtrlCRMemRdEnQ504; 
logic CtrlCRMemWrEnQ504;

//Sample input 502 -> 503
`LOTR_MSFF(F2C_ReqValidQ503H   , F2C_ReqValidQ502H   , CLK_50)
`LOTR_MSFF(F2C_ReqOpcodeQ503H  , F2C_ReqOpcodeQ502H  , CLK_50)
`LOTR_MSFF(F2C_ReqAddressQ503H , F2C_ReqAddressQ502H , CLK_50)
`LOTR_MSFF(F2C_ReqDataQ503H    , F2C_ReqDataQ502H    , CLK_50)

assign CtrlCRMemRdEnQ503 = F2C_ReqValidQ503H && F2C_ReqOpcodeQ503H == RD;
assign CtrlCRMemWrEnQ503 = F2C_ReqValidQ503H && F2C_ReqOpcodeQ503H == WR;
//==============================
// Memory Access
//------------------------------
// 1. Access CR_MEM for Wrote (STORE) and Reads (LOAD)
//==============================
always_comb begin
    cr_ro_next = cr_ro;
    cr_rw_next = cr_rw; 
    if(CtrlCRMemWrEnQ503) begin
        unique casez (F2C_ReqAddressQ503H[19:0]) // AluOut holds the offset
            // ---- RW memory ----
            CR_SEG7_0 : cr_rw_next.SEG7_0 = F2C_ReqDataQ503H[6:0];
            CR_SEG7_1 : cr_rw_next.SEG7_1 = F2C_ReqDataQ503H[6:0];
            CR_SEG7_2 : cr_rw_next.SEG7_2 = F2C_ReqDataQ503H[6:0];
            CR_SEG7_3 : cr_rw_next.SEG7_3 = F2C_ReqDataQ503H[6:0];
            CR_SEG7_4 : cr_rw_next.SEG7_4 = F2C_ReqDataQ503H[6:0];
            CR_SEG7_5 : cr_rw_next.SEG7_5 = F2C_ReqDataQ503H[6:0];
            CR_LED    : cr_rw_next.LED    = F2C_ReqDataQ503H[9:0];
            // ---- Other ----
            default   : /* Do nothing */;
        endcase
    end
    // ---- RO memory - writes from FPGA ----
    cr_ro_next.Button_0 = Button_0;
    cr_ro_next.Button_1 = Button_1;
    cr_ro_next.Switch   = Switch;
end



// This is the load
always_comb begin
		F2C_RspDataQ503H = '0;
    if(CtrlCRMemRdEnQ503) begin
        unique casez (F2C_ReqAddressQ503H[19:0]) // AluOut holds the offset
            // ---- RW memory ----
            CR_SEG7_0   : F2C_RspDataQ503H = {25'b0 , cr_rw_next.SEG7_0}   ; 
            CR_SEG7_1   : F2C_RspDataQ503H = {25'b0 , cr_rw_next.SEG7_1}   ;
            CR_SEG7_2   : F2C_RspDataQ503H = {25'b0 , cr_rw_next.SEG7_2}   ;
            CR_SEG7_3   : F2C_RspDataQ503H = {25'b0 , cr_rw_next.SEG7_3}   ;
            CR_SEG7_4   : F2C_RspDataQ503H = {25'b0 , cr_rw_next.SEG7_4}   ;
            CR_SEG7_5   : F2C_RspDataQ503H = {25'b0 , cr_rw_next.SEG7_5}   ;
            CR_LED      : F2C_RspDataQ503H = {22'b0 , cr_rw_next.LED}      ;
            // ---- RO memory ----
            CR_Button_0 : F2C_RspDataQ503H = {31'b0 , cr_ro_next.Button_0} ;
            CR_Button_1 : F2C_RspDataQ503H = {31'b0 , cr_ro_next.Button_1} ;
            CR_Switch   : F2C_RspDataQ503H = {22'b0 , cr_ro_next.Switch}   ;
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
`LOTR_MSFF( F2C_RspAddressQ504H,  F2C_ReqAddressQ503H, CLK_50)
`LOTR_MSFF(F2C_RspDataQ504H, F2C_RspDataQ503H, CLK_50)
`LOTR_MSFF(CtrlCRMemRdEnQ504, CtrlCRMemRdEnQ503, CLK_50)
`LOTR_MSFF(CtrlCRMemWrEnQ504, CtrlCRMemWrEnQ503, CLK_50)

assign F2C_RspValidQ504H = CtrlCRMemRdEnQ504 || CtrlCRMemWrEnQ504;

`LOTR_MSFF(F2C_RspValidQ500H   , F2C_RspValidQ504H   , CLK_50)
`LOTR_MSFF(F2C_RspOpcodeQ500H  , F2C_RspOpcodeQ504H  , CLK_50)
`LOTR_MSFF(F2C_RspAddressQ500H , F2C_RspAddressQ504H , CLK_50)
`LOTR_MSFF(F2C_RspDataQ500H, F2C_RspDataQ504H, CLK_50)



`LOTR_MSFF(cr_rw, cr_rw_next, CLK_50)
`LOTR_MSFF(cr_ro, cr_ro_next, CLK_50)

// Reflects outputs to the FPGA - synchorus reflects
`LOTR_MSFF(SEG7_0 , cr_rw_next.SEG7_0 , CLK_50)
`LOTR_MSFF(SEG7_1 , cr_rw_next.SEG7_1 , CLK_50)
`LOTR_MSFF(SEG7_2 , cr_rw_next.SEG7_2 , CLK_50)
`LOTR_MSFF(SEG7_3 , cr_rw_next.SEG7_3 , CLK_50)
`LOTR_MSFF(SEG7_4 , cr_rw_next.SEG7_4 , CLK_50)
`LOTR_MSFF(SEG7_5 , cr_rw_next.SEG7_5 , CLK_50)
`LOTR_MSFF(LED    , cr_rw_next.LED    , CLK_50)

endmodule // Module rvc_asap_5pl_cr_mem