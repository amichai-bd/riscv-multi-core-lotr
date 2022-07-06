//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_5pl_sync_gen 
// Original Author  : Amichai Ben-David
// Code Owner       : Matan Eshel & Gil Ya'akov
// Adviser          : Amichai Ben-David
// Created          : 03/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the sync generator of the vga controller.

`include "lotr_defines.sv"

module vga_sync_gen (
        input  logic        CLK_25,
        input  logic        Reset,
        output logic        vga_h_sync,
        output logic        vga_v_sync,
        output logic        inDisplayArea,
        output logic  [9:0] CounterX,
        output logic  [9:0] CounterY
);
    
logic h_sync, v_sync;
logic next_h_sync, next_v_sync;
logic CounterXmaxed, CounterYmaxed;
logic NextinDisplayArea;

// VGA @ 640x480 resolution @ 60Hz requires a pixel clock of 25.175Mhz.
// Maxed x = 800 , y = 525
assign CounterXmaxed = (CounterX == 800) || Reset; // 16 + 48 + 96 + 640
assign CounterYmaxed = (CounterY == 525) || Reset; // 10 + 2 + 33 + 480

// x and y counters
`LOTR_RST_MSFF   (CounterX, (CounterX+1'b1), CLK_25, CounterXmaxed)
`LOTR_EN_RST_MSFF(CounterY, (CounterY+1'b1), CLK_25, CounterXmaxed, (CounterXmaxed && CounterYmaxed) )

assign next_h_sync = (CounterX >= (640 + 16) && (CounterX < (640 + 16 + 96)));  // active for 96 clocks
assign next_v_sync = (CounterY >= (480 + 10) && (CounterY < (480 + 10 + 2)));   // active for 2 clocks

`LOTR_MSFF(h_sync, next_h_sync, CLK_25)
`LOTR_MSFF(v_sync, next_v_sync, CLK_25)

// Indication that we must not send Data in VGA RGB
assign NextinDisplayArea = ((CounterX < 640) && (CounterY < 480));
`LOTR_MSFF(inDisplayArea, NextinDisplayArea, CLK_25)

assign vga_h_sync = ~h_sync;
assign vga_v_sync = ~v_sync;

endmodule // Module rvc_asap_5pl_sync_gen