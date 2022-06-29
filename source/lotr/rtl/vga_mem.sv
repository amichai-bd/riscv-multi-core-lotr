//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_5pl_vga_mem
// Original Author  : Matan Eshel & Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 06/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the vga memory of the core.
// VGA_MEM will support sync memory read.
`include "lotr_defines.sv"

module vga_mem (
    input  logic        Clock,
    input  logic        CLK_25,
    // Write core
    input  logic [31:0] RegRdData2,
    input  logic [31:0] AluOut,
    input  logic [3:0]  CtrlVGAMemByteEn,
    input  logic        CtrlVGAMemWrEn,
    // Read core
    input  logic        SelVGAMemWb,
    output logic [31:0] VGAMemRdDataQ104H,
    // Read vga controller
    input  logic [12:0] rdaddress,
    output logic [31:0] q
);
import lotr_pkg::*;
// Memory array (behavrial - not for FPGA/ASIC)
logic [7:0]         VGAMem    [38399:0]; //80 x 480
logic [7:0]         NextVGAMem[38399:0]; 

// Data-Path signals core
logic [31:0]        PreVGAMemRdData;
logic [31:0]        VGAMemRdDataQ103H;

// Data-Path signals vga ctrl
logic [7:0] RdByte0;
logic [7:0] RdByte1;
logic [7:0] RdByte2;
logic [7:0] RdByte3;
logic [31:0] pre_q;
logic [15:0] RdAddressByteAl;
assign  RdAddressByteAl = {rdaddress,2'b00}; // The memory is "32bit aligned" but we save and measure the memory in Bytes.
                                             // This is to make this model behave as the FPGA Memory we use.

//==============================
// Memory Access
//------------------------------
// 1. Access VGA_MEM for Wrote (STORE) and Reads (LOAD)
//==============================
always_comb begin
    NextVGAMem = VGAMem;
    if(CtrlVGAMemWrEn) begin
        if(CtrlVGAMemByteEn[0]) NextVGAMem[AluOut[15:0]+0] = RegRdData2[7:0];
        if(CtrlVGAMemByteEn[1]) NextVGAMem[AluOut[15:0]+1] = RegRdData2[15:8];
        if(CtrlVGAMemByteEn[2]) NextVGAMem[AluOut[15:0]+2] = RegRdData2[23:16];
        if(CtrlVGAMemByteEn[3]) NextVGAMem[AluOut[15:0]+3] = RegRdData2[31:24];
    end
end

`LOTR_MSFF(VGAMem , NextVGAMem , Clock)

// This is the read from the core
assign PreVGAMemRdData[7:0]     =  SelVGAMemWb ? VGAMem[AluOut[15:0]+0] : 8'b0; 
assign PreVGAMemRdData[15:8]    =  SelVGAMemWb ? VGAMem[AluOut[15:0]+1] : 8'b0;
assign PreVGAMemRdData[23:16]   =  SelVGAMemWb ? VGAMem[AluOut[15:0]+2] : 8'b0;
assign PreVGAMemRdData[31:24]   =  SelVGAMemWb ? VGAMem[AluOut[15:0]+3] : 8'b0;

assign VGAMemRdDataQ103H[7:0]   =  CtrlVGAMemByteEn[0] ? PreVGAMemRdData[7:0]   : 8'b0;
assign VGAMemRdDataQ103H[15:8]  =  CtrlVGAMemByteEn[1] ? PreVGAMemRdData[15:8]  : 8'b0;
assign VGAMemRdDataQ103H[23:16] =  CtrlVGAMemByteEn[2] ? PreVGAMemRdData[23:16] : 8'b0;
assign VGAMemRdDataQ103H[31:24] =  CtrlVGAMemByteEn[3] ? PreVGAMemRdData[31:24] : 8'b0;

// Sample the data load - synchorus load
`LOTR_MSFF(VGAMemRdDataQ104H, VGAMemRdDataQ103H, Clock)

// This is the read from the vga controller
assign RdByte0 = VGAMem[RdAddressByteAl+0];
assign RdByte1 = VGAMem[RdAddressByteAl+1];
assign RdByte2 = VGAMem[RdAddressByteAl+2];
assign RdByte3 = VGAMem[RdAddressByteAl+3];
assign pre_q   = {RdByte3, RdByte2, RdByte1, RdByte0};

// sample the read - synchorus read
`LOTR_MSFF(q, pre_q, CLK_25)

endmodule // Module rvc_asap_5pl_vga_mem