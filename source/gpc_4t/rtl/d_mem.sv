//-----------------------------------------------------------------------------
// Title            : data memory - Behavioral
// Project          : gpc_4t
//-----------------------------------------------------------------------------
// File             : d_mem.sv
// Original Author  : Amichai Ben-David
// Created          : 1/2020
//-----------------------------------------------------------------------------
// Description :
// Behavioral duel read dueal write memory
//------------------------------------------------------------------------------
// Modification history :
//------------------------------------------------------------------------------

`include "lotr_defines.sv"

//---------------------------------------------------
module d_mem import gpc_4t_pkg::*; 
               (input  logic        clock    ,
                //core access
                input  logic [31:0] address  ,
                input  logic [3:0]  byteena  ,
                input  logic [31:0] data     ,
                input  logic        rden     ,
                input  logic        wren     ,
                output logic [31:0] q        
               );
localparam LOCAL_MEM_SIZE             = SIZE_DATA+SIZE_STACK+SIZE_MMIO_GENERAL;
localparam LOCAL_OFFSET_MMIO_GENERAL  = SIZE_DATA+SIZE_STACK;
localparam LOCAL_OFFSET_STACK_POINTER = SIZE_DATA;
localparam SP_SIZE = 512; //FIXME
logic [7:0] mem     [LOCAL_MEM_SIZE-1:0];
logic [7:0] next_mem[LOCAL_MEM_SIZE-1:0];
logic [31:0] pre_q;  

always_comb begin
    next_mem = mem;
    if(wren) begin
        if(byteena[0]) next_mem[SP_SIZE+address+0]= data[7:0];
        if(byteena[1]) next_mem[SP_SIZE+address+1]= data[15:8];
        if(byteena[2]) next_mem[SP_SIZE+address+2]= data[23:16];
        if(byteena[3]) next_mem[SP_SIZE+address+3]= data[31:24]; 
    end
end 
genvar i;
generate // the memory flipflops
    for (i = 0; i<LOCAL_MEM_SIZE; i++) begin : data_mem_gen
        `LOTR_MSFF(mem[i], next_mem[i], clock)
    end
endgenerate
assign pre_q = {mem[SP_SIZE+address+3],
                mem[SP_SIZE+address+2],
                mem[SP_SIZE+address+1],
                mem[SP_SIZE+address+0]};
//`LOTR_EN_MSFF(q, pre_q, clock, rden) ??
`LOTR_MSFF(q, pre_q, clock) //FIXME
// =========================================================================
//  MMIO_GENERAL      0xF00  0xA0   0xF9F    8  
//  This is just for simulation signals. (wont effect logic or syntethis)
// =========================================================================
logic [7:0] mmio_general [LOCAL_MEM_SIZE-1:LOCAL_OFFSET_MMIO_GENERAL];
assign mmio_general = mem[LOCAL_MEM_SIZE-1:LOCAL_OFFSET_MMIO_GENERAL];

logic [7:0] stack_pointer [LOCAL_OFFSET_MMIO_GENERAL-1:LOCAL_OFFSET_STACK_POINTER];
assign stack_pointer = mem[LOCAL_OFFSET_MMIO_GENERAL-1:LOCAL_OFFSET_STACK_POINTER];



endmodule
