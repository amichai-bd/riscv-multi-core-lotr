//-----------------------------------------------------------------------------
// Title            : data memory wrap
// Project          : LOTR
//-----------------------------------------------------------------------------
// File             : d_mem_wrap.sv
// Original Author  : Amichai Ben-David
// Created          : 1/2020
//-----------------------------------------------------------------------------
// Description      :
// will `ifdef the SRAM memory vs behavrial memory

//------------------------------------------------------------------------------
// Modification history :
//------------------------------------------------------------------------------

`include "lotr_defines.sv"
module d_mem_wrap import gpc_4t_pkg::*;  
                (input   logic             clock,          
                 input   logic             rst,          
                 //core
                 input   logic [31:0]      address,
                 input   logic [3:0]       byteena,
                 input   logic [31:0]      data,
                 input   logic             rden,  
                 input   logic             wren,  
                 output  logic [31:0]      q,     
                 //CR memory regions
                 output  t_cr              cr
                );

t_mmio mmio_mem;
t_mmio next_mmio_mem;
logic [31:0] mmio_q;
logic [31:0] mmio_data_core;
logic [31:0] data_q;

logic [7:0] core_id_strap     ;
logic       match_local_core  ;
logic       match_d_mem_region;
logic       match_cr_region   ;

assign core_id_strap = 8'b01; //FIXME - strap from outside

always_comb begin
    match_local_core  = (address[MSB_CORE_ID:LSB_CORE_ID] == 8'b0 || address[MSB_CORE_ID:LSB_CORE_ID] == core_id_strap);
    match_d_mem_region = (address[MSB_REGION:LSB_REGION] == D_MEM_REGION);
    match_cr_region    = (address[MSB_REGION:LSB_REGION] == CR_REGION);
end

`ifdef FPGA
mem_32_12_234_234 d_mem (                                                             
`else
d_mem d_mem (                                                             
`endif
    .clock    (clock),
    .address  (address[MSB_D_MEM:0]),
    .byteena  (byteena),
    .data     (data),
    .rden     (rden && match_d_mem_region && match_local_core),
    .wren     (wren && match_d_mem_region && match_local_core),
    .q        (data_q)
    );

//=======================================================
//================CR memory write======================
//=======================================================
always_comb begin
    next_mmio_mem = mmio_mem; //defualt value
    if (rst) begin //rst value for CR
        next_mmio_mem.cr.en_pc  = '0;// en_pc
        next_mmio_mem.cr.rst_pc = '0;// rst_pc
    end


    if(wren && match_cr_region) begin
        unique case (address[MSB_CR:0])
           CR_EN_PC     : next_mmio_mem.cr.en_pc   = data[0] ;
           CR_RST_PC    : next_mmio_mem.cr.rst_pc  = data[0] ;
           default      : /*do nothing*/                     ;
        endcase
    end
end 

//=======================================================
//================CR memory flops======================
//=======================================================
`LOTR_MSFF(mmio_mem, next_mmio_mem, clock) 

//=======================================================
//================CR memory read======================
//=======================================================
always_comb begin
    mmio_data_core =32'b0;
    if(rden && match_cr_region) begin
        unique case (address[MSB_CR:0])
             CR_EN_PC     : mmio_data_core  = {31'b0,mmio_mem.cr.en_pc} ;
             CR_RST_PC    : mmio_data_core  = {31'b0,mmio_mem.cr.rst_pc};
             CR_CORE_ID   : mmio_data_core  = {23'b0,core_id_strap}; //FIXME - add strap CORE_ID from top level
             CR_THREAD_ID : mmio_data_core  = 31'b0; //FIXME - return the Thread_ID acording to the requests THREAD.
            default       : mmio_data_core  = 32'b0                      ;
        endcase
    end
end

//sample the read (synchornic read)
`LOTR_EN_MSFF(mmio_q, mmio_data_core, clock, match_cr_region)

//mux between the CR and the DATA
always_comb begin
    q        = match_cr_region      ? mmio_q :
               match_d_mem_region   ? data_q :
                                      32'b0  ;
    cr       = mmio_mem.cr;
end

endmodule
