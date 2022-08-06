//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_5pl_vga_ctrl
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 06/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the vga controller of the architecture.
// This module include the vga memory and the logic necessary for its management.

`include "lotr_defines.sv"

module vga_ctrl (
    input  logic        CLK_50,
    input  logic        QClk,
    input  logic        Reset,
    // VGA memory Access
    input  logic [31:0] F2C_ReqDataQ503H,
    input  logic [31:0] F2C_ReqAddressQ503H,
    input  logic [3:0]  CtrlVGAMemByteEn,
    input  logic        CtrlVgaMemWrEnQ503,
    // Read core
    input  logic        CtrlVgaMemRdEnQ503,
    output logic [31:0] VgaRspDataQ504H,
    // VGA output
    output logic [3:0]  RED,
    output logic [3:0]  GREEN,
    output logic [3:0]  BLUE,
    output logic        h_sync,
    output logic        v_sync
);

// Only One or the other (FPGA_ON vs SIMULATION_ON )
`ifndef SIMULATION_ON
    `define FPGA_ON    
`endif

logic [9:0]  pixel_y;
logic        CLK_25;
logic        inDisplayArea;
logic        next_h_sync;
logic        next_v_sync;
logic [3:0]  NextRED;
logic [3:0]  NextGREEN;
logic [3:0]  NextBLUE;
logic        CurentPixelQ2;
logic [8:0]  LineQ0, LineQ1;
logic [31:0] RdDataQ2;
logic [4:0]  SampleReset;
logic [6:0]  HEX; 
logic [13:0] WordOffsetQ1;
logic [2:0]  CountBitOffsetQ1, CountBitOffsetQ2 ;
logic [1:0]  CountByteOffsetQ1, CountByteOffsetQ2;
logic [7:0]  CountWordOffsetQ1;
logic        EnCountBitOffset,  EnCountByteOffset,  EnCountWordOffset ;
logic        RstCountBitOffset, RstCountByteOffset, RstCountWordOffset;

//=========================
//Reset For Clk Simulation 
//=========================
assign SampleReset[0] = Reset;
`LOTR_MSFF(SampleReset[4:1], SampleReset[3:0], QClk)

//=========================
//gen Clock 25Mhz
//=========================
`ifdef SIMULATION_ON
    `LOTR_RST_MSFF(CLK_25, !CLK_25, CLK_50, Reset)
`elsif FPGA_ON
// The VGA works without the PLL - SImulation clock devider version works just fine.
//pll_25 pll_25 (
//    .inclk0 (CLK_50),    // input
//    .c0     (CLK_25)     // output
//); 
    `LOTR_RST_MSFF(CLK_25, !CLK_25, CLK_50, Reset)
`endif // FPGA_ON

//=========================
// VGA sync Machine
//=========================
vga_sync_gen vga_sync_inst (
    .CLK_25         (CLK_25),          // input
    .Reset          (SampleReset[4]),  // input
    .vga_h_sync     (next_h_sync),     // output
    .vga_v_sync     (next_v_sync),     // output
    .CounterX       (),                // output
    .CounterY       (pixel_y),         // output
    .inDisplayArea  (inDisplayArea)    // output
);

//=========================
// VGA Display Line #
//=========================
assign LineQ0   = pixel_y[8:0];
`LOTR_MSFF(LineQ1 , LineQ0 , CLK_25)

//=========================
// Read CurrentPixelQ2 using VGA Virtual Address -> Physical Address in RAM
//=========================
assign EnCountByteOffset  = ((CountWordOffsetQ1 == 79) && EnCountWordOffset);
assign EnCountWordOffset  = (CountBitOffsetQ1 == 3'b111);
assign RstCountBitOffset  = SampleReset[4] || (!inDisplayArea);
assign RstCountByteOffset = SampleReset[4];
assign RstCountWordOffset = SampleReset[4] || ((CountWordOffsetQ1 == 8'd79) && EnCountWordOffset);
`LOTR_RST_MSFF   (CountBitOffsetQ1 , (CountBitOffsetQ1 +3'b01), CLK_25, RstCountBitOffset )
`LOTR_EN_RST_MSFF(CountByteOffsetQ1, (CountByteOffsetQ1+2'b01), CLK_25, EnCountByteOffset, RstCountByteOffset)
`LOTR_EN_RST_MSFF(CountWordOffsetQ1, (CountWordOffsetQ1+8'b01), CLK_25, EnCountWordOffset, RstCountWordOffset)

assign WordOffsetQ1 = ((LineQ1[8:2])*8'd80 + CountWordOffsetQ1);

// Align latency
`LOTR_MSFF(CountBitOffsetQ2  , CountBitOffsetQ1  , CLK_25)
`LOTR_MSFF(CountByteOffsetQ2 , CountByteOffsetQ1 , CLK_25)

assign CurentPixelQ2 = RdDataQ2[{CountByteOffsetQ2,CountBitOffsetQ2}];

//=========================
// VGA memory
//=========================
`ifdef SIMULATION_ON
vga_mem vga_mem (
    .clock_a        (QClk),
    .clock_b        (CLK_25),
    // Write
    .data_a         (F2C_ReqDataQ503H),
    .address_a      (F2C_ReqAddressQ503H[31:2]),
    .byteena_a      (CtrlVGAMemByteEn),
    .wren_a         (CtrlVgaMemWrEnQ503),
    // Read from core
    .rden_a         (CtrlVgaMemRdEnQ503),
    .q_a            (VgaRspDataQ504H),
    // Read from vga controller
    .address_b      (WordOffsetQ1), // Word offset (not Byte)
    .q_b            (RdDataQ2)
);
`else
vga_mem_fpga vga_mem(
	//CORE interface
    .clock_a        (QClk),
    .wren_a         (CtrlVgaMemWrEnQ503),
    .byteena_a      (CtrlVGAMemByteEn),
    .address_a      (F2C_ReqAddressQ503H[31:2]),
    .data_a         (F2C_ReqDataQ503H),
    .rden_a         (CtrlVgaMemRdEnQ503),	
    .q_a            (VgaRspDataQ504H),
    //VGA interface
    .clock_b        (CLK_25),
    .wren_b         (1'b0),
    .address_b      (WordOffsetQ1),
    .data_b         ('0),
    .rden_b         (1'b1),
    .q_b            (RdDataQ2)
    );
`endif

//assign NextRED   = (inDisplayArea) ? 4'b1111 : '0;//{4{CurentPixelQ2}} : '0;
//assign NextGREEN = (inDisplayArea) ? 4'b1111 : '0;//{4{CurentPixelQ2}} : '0;
//assign NextBLUE  = (inDisplayArea) ? 4'b1111 : '0;//{4{CurentPixelQ2}} : '0;
assign NextRED   = (inDisplayArea) ? {4{CurentPixelQ2}} : '0;
assign NextGREEN = (inDisplayArea) ? {4{CurentPixelQ2}} : '0;
assign NextBLUE  = (inDisplayArea) ? {4{CurentPixelQ2}} : '0;
`LOTR_MSFF(RED    , NextRED     , CLK_25)
`LOTR_MSFF(GREEN  , NextGREEN   , CLK_25)
`LOTR_MSFF(BLUE   , NextBLUE    , CLK_25)
`LOTR_MSFF(h_sync , next_h_sync , CLK_25)
`LOTR_MSFF(v_sync , next_v_sync , CLK_25)

endmodule // Module rvc_asap_5pl_vga_ctrl
