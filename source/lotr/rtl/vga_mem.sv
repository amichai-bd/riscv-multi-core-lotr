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
// This module serves as the vga memory of the core.
// VGA_MEM will support sync memory read.
`include "lotr_defines.sv"

module vga_mem (
    input  logic        clock_a,
    input  logic        clock_b,
    // Write core
    input  logic [31:0] data_a,
    input  logic [29:0] address_a,
    input  logic [3:0]  byteena_a,
    input  logic        wren_a,
    // Read core
    input  logic        rden_a,
    output logic [31:0] q_a,
    // Read vga controller
    input  logic [13:0] address_b,
    output logic [31:0] q_b
);
import lotr_pkg::*;
// Memory array (behavrial - not for FPGA/ASIC)
logic [7:0]  VGAMem    [38399:0]; //80 x 480
logic [7:0]  NextVGAMem[38399:0]; 

// Data-Path signals core
logic [31:0] pre_q_a;

// Data-Path signals vga ctrl
logic [31:0] pre_q_b;
logic [15:0] address_a_byte;
logic [15:0] address_b_byte;
assign  address_a_byte = {address_a,2'b00};
assign  address_b_byte = {address_b,2'b00}; // The memory is "32bit aligned" but we save and measure the memory in Bytes.
                                             // This is to make this model behave as the FPGA Memory we use.
//==============================
// Memory Access
//------------------------------
// 1. Access VGA_MEM for Wrote (STORE) and Reads (LOAD)
//==============================
always_comb begin
    NextVGAMem = VGAMem;
    if(wren_a) begin
        if(byteena_a[0]) NextVGAMem[address_a_byte[15:0]+0] = data_a[7:0];
        if(byteena_a[1]) NextVGAMem[address_a_byte[15:0]+1] = data_a[15:8];
        if(byteena_a[2]) NextVGAMem[address_a_byte[15:0]+2] = data_a[23:16];
        if(byteena_a[3]) NextVGAMem[address_a_byte[15:0]+3] = data_a[31:24];
    end
end
// ================
// The Memory:
// ================
`LOTR_MSFF(VGAMem , NextVGAMem , clock_a)
// ================

// This is the read from the core
assign pre_q_a   =  rden_a  ? {VGAMem[address_a_byte+3], VGAMem[address_a_byte+2], VGAMem[address_a_byte+1], VGAMem[address_a_byte+0]} : '0;
`LOTR_MSFF(q_a, pre_q_a, clock_a)// Sample the data load - synchorus load

// This is the read from the vga controller
assign pre_q_b   = {VGAMem[address_b_byte+3], VGAMem[address_b_byte+2], VGAMem[address_b_byte+1], VGAMem[address_b_byte+0]};
`LOTR_MSFF(q_b, pre_q_b, clock_b)// sample the read - synchorus read

endmodule // Module rvc_asap_5pl_vga_mem