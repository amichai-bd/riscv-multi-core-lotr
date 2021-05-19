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
                 //MMIO memory regions
                 output  t_cr              cr
                );

t_mmio mmio_mem;
t_mmio next_mmio_mem;
logic [31:0] mmio_q;
logic [31:0] mmio_data_core;
logic [31:0] mmio_data_io; 
logic [31:0] data_q;
logic in_range_data, in_range_cr;
logic sample_in_range_data, sample_in_range_mmio_data;

always_comb begin
    in_range_data    = (address[MSB_CORE_ID:LSB_CORE_ID] == D_MEM_REGION);
    in_range_cr      = (address[MSB_CORE_ID:LSB_CORE_ID] == CR_REGION);
end

d_mem d_mem (                                                             
    .clock    (clock),
    .address  (address[MSB_D_MEM:0]),
    .byteena  (byteena),
    .data     (data),
    .rden     (rden),
    .wren     (wren),
    .q        (data_q)
    );

//=======================================================
//================MMIO memory write======================
//=======================================================
always_comb begin
    next_mmio_mem = mmio_mem; //defualt value
    if (rst) begin //rst value for CR
        next_mmio_mem.cr.en_pc  = '0;// en_pc
        next_mmio_mem.cr.rst_pc = '0;// rst_pc
    end
    if(wren && in_range_cr) begin
        unique case (address[MSB_CR:0])
           CR_EN_PC     : next_mmio_mem.cr.en_pc   = data[0] ;
           CR_RST_PC    : next_mmio_mem.cr.rst_pc  = data[0] ;
           //CR_CORE_ID   : next_mmio_mem.cr.core_id = data  ;
           //CR_THREAD_ID : next_mmio_mem                    ;
           default      : /*do nothing*/                     ;
        endcase
    end
end 

//=======================================================
//================MMIO memory flops======================
//=======================================================
`LOTR_MSFF(mmio_mem, next_mmio_mem, clock) 

//=======================================================
//================MMIO memory read======================
//=======================================================
always_comb begin
    mmio_data_core =32'b0;
    if(rden && in_range_cr) begin
        unique case (address[MSB_CR:0])
             CR_EN_PC     :mmio_data_core  = {31'b0,mmio_mem.cr.en_pc} ;
             CR_RST_PC    :mmio_data_core  = {31'b0,mmio_mem.cr.rst_pc};
             CR_CORE_ID   :mmio_data_core  = 31'b01; //FIXME - add strap CORE_ID from top level
             CR_THREAD_ID :mmio_data_core  = 31'b01; //FIXME - return the Thread_ID acording to the requests THREAD.
            default       :mmio_data_core  = 32'b0                      ;
        endcase
    end
end

//sample the read (synchornic read)
`LOTR_EN_MSFF(mmio_q, mmio_data_core, clock, in_range_cr && rden)

//mux between the MMIO and the DATA
always_comb begin
    q        =  data_q;
    cr       = mmio_mem.cr;
end

endmodule
