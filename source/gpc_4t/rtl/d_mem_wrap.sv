//-----------------------------------------------------------------------------
// Title            : data memory wrap
// Project          : gpc_4t
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

`include "gpc_4t_defines.sv"
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
                 output  t_cr              cr,
                 output  t_drct_out        drct_out
                );

t_mmio mmio_mem;
t_mmio next_mmio_mem;
logic [31:0] offset_address;
logic [31:0] mmio_q;
logic [31:0] mmio_data_core;
logic [31:0] mmio_data_io; 
logic [31:0] data_q;
logic in_range_data, in_range_mmio_data;
logic sample_in_range_data, sample_in_range_mmio_data;

always_comb begin
    in_range_data      = (address<(MSB_DATA_MEM)&&address>(LSB_DATA_MEM-1));
    in_range_mmio_data = (address<(MSB_MMIO_MEM)&&address>(LSB_MMIO_MEM-1));
    offset_address     = address;
    if (in_range_data) offset_address[11]=1'b0;
end

`ifdef ALTERA
altera_sram_512x32_take3	altera_sram_512x32_data_mem (
	.clock    (clock),
	.address  (offset_address[10:2]),
	.byteena  (byteena),
	.data     (data),
	.rden     (rden && in_range_data),
	.wren     (wren && in_range_data),
	.q        (data_q),
	);
`else
d_mem d_mem (                                                             
    .clock    (clock),
    .address  (offset_address[31:0]),
    .byteena  (byteena),
    .data     (data),
    .rden     (rden&&in_range_data),
    .wren     (wren&&in_range_data),
    .q        (data_q)
    );
`endif

//=======================================================
//================MMIO memory write======================
//=======================================================
always_comb begin
    next_mmio_mem = mmio_mem; //defualt value
    if (rst) begin //rst value for CR
        next_mmio_mem.cr.en_pc  = '0;// en_pc
        next_mmio_mem.cr.rst_pc = '0;// rst+pc
        next_mmio_mem.cr.rd_ptr = '0;// rd_ptr
        next_mmio_mem.cr.start  = '0;// start -> after SOC sets this bit core should reset it.
        next_mmio_mem.cr.done   = '0;// done  -> After core sets this SOC should reset it.
    end
    if(wren) begin
        unique case (address[12:0])
            OFFSET_MMIO_CSR   + 'h0  : next_mmio_mem.cr.en_pc   = data[0]  ;
            OFFSET_MMIO_CSR   + 'h4  : next_mmio_mem.cr.rst_pc  = data[0]  ;
            OFFSET_MMIO_CSR   + 'h8  : next_mmio_mem.cr.rd_ptr  = data[4:0];
            OFFSET_MMIO_CSR   + 'h10 : next_mmio_mem.cr.start   = data[0]  ;
            OFFSET_MMIO_CSR   + 'h14 : next_mmio_mem.cr.done    = data[0]  ;
            OFFSET_MMIO_DRCT_OUT     : next_mmio_mem.drct_out.out= data    ;
            default                  : /*do nothing*/                        ;
        endcase
    end
end 

//=======================================================
//================MMIO memory flops======================
//=======================================================
`GPC_MSFF(mmio_mem, next_mmio_mem, clock) 

//=======================================================
//================MMIO memory read======================
//=======================================================
always_comb begin
    mmio_data_core =32'b0;
    if(rden) begin
        unique case (address[12:0])
            OFFSET_MMIO_CSR   + 'h0  : mmio_data_core  = {31'b0,mmio_mem.cr.en_pc} ;
            OFFSET_MMIO_CSR   + 'h4  : mmio_data_core  = {31'b0,mmio_mem.cr.rst_pc};
            OFFSET_MMIO_CSR   + 'h8  : mmio_data_core  = {27'b0,mmio_mem.cr.rd_ptr};
            OFFSET_MMIO_CSR   + 'h10 : mmio_data_core  = {31'b0,mmio_mem.cr.start} ;
            OFFSET_MMIO_CSR   + 'h14 : mmio_data_core  = {31'b0,mmio_mem.cr.done}  ;
            OFFSET_MMIO_DRCT_OUT     : mmio_data_core  =        mmio_mem.drct_out.out;
            default                  : mmio_data_core  = 32'b0                      ;
        endcase
    end
end
//sample the read (synchornic read)
`GPC_EN_MSFF(mmio_q, mmio_data_core, clock, in_range_mmio_data && rden)

`GPC_MSFF(sample_in_range_data      , in_range_data      && rden, clock)
`GPC_MSFF(sample_in_range_mmio_data , in_range_mmio_data && rden, clock)

//mux between the MMIO and the DATA
always_comb begin
    q      = sample_in_range_data      ? data_q:
             sample_in_range_mmio_data ? mmio_q:
                                         32'b0;
    cr       = mmio_mem.cr;
    drct_out = mmio_mem.drct_out.out;
end

endmodule
