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
                 input   logic [3:0]       ThreadQ103H,
                 input   logic [31:0]      PcQ103H,
                 input   logic [31:0]      data,
                 input   logic             rden,  
                 input   logic             wren,  
                 output  logic [31:0]      q,     
                 //CR memory regions
                 output  t_core_cr          core_cr
                );

t_cr_ro cr_ro;
t_cr_en cr_en;
t_cr_ofst cr_ofst;

logic [31:0] cr_q;
logic [31:0] cr_data_core;
logic [31:0] data_q;
logic [1:0] ThreadIDQ103H;
logic [31:0] StkOffsetQ103H;
logic [31:0] TlsOffsetQ103H;
logic [4:0] DfdThreadQ103H;
logic [7:0] core_id_strap     ;
logic       MatchLocalCoreQ103H  ;
logic       MatchLocalCoreQ104H  ;
logic       MatchD_MemRegionQ103H;
logic       MatchD_MemRegionQ104H;
logic       match_cr_region   ;
logic       match_cr_regionQ104H   ;
logic [31:0] scratch_pad_0;
logic [31:0] scratch_pad_1;
logic [31:0] scratch_pad_2;
logic [31:0] scratch_pad_3;
assign core_id_strap = 8'b01; //FIXME - strap from outside

always_comb begin
    MatchLocalCoreQ103H  = (address[MSB_CORE_ID:LSB_CORE_ID] == 8'b0 || address[MSB_CORE_ID:LSB_CORE_ID] == core_id_strap);
    MatchD_MemRegionQ103H = (address[MSB_REGION:LSB_REGION] == D_MEM_REGION);
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
    .rden     (rden && MatchD_MemRegionQ103H && MatchLocalCoreQ103H),
    .wren     (wren && MatchD_MemRegionQ103H && MatchLocalCoreQ103H),
    .q        (data_q)
    );

//=======================================================
//================CR memory write======================
//=======================================================
always_comb begin
  
    cr_en = '0;
    if(wren && match_cr_region && MatchLocalCoreQ103H) begin
        unique case (address[MSB_CR:0])
           //CR_EN_PC          : next_cr_mem.cr.en_pc   = data[0] ;
           //CR_RST_PC         : next_cr_mem.cr.rst_pc  = data[0] ;
           CR_THREAD0_PC_RST                : cr_en.rst_pc_0   = 1'b1 ;
           CR_THREAD1_PC_RST                : cr_en.rst_pc_1   = 1'b1 ;
           CR_THREAD2_PC_RST                : cr_en.rst_pc_2   = 1'b1 ;
           CR_THREAD3_PC_RST                : cr_en.rst_pc_3   = 1'b1 ;
           CR_THREAD0_PC_EN                 : cr_en.en_pc_0    = 1'b1 ;
           CR_THREAD1_PC_EN                 : cr_en.en_pc_1    = 1'b1 ;
           CR_THREAD2_PC_EN                 : cr_en.en_pc_2    = 1'b1 ;
           CR_THREAD3_PC_EN                 : cr_en.en_pc_3    = 1'b1 ;
           CR_THREAD0_DFD_REG_ID            : cr_en.dfd_id_0   = 1'b1 ;
           CR_THREAD1_DFD_REG_ID            : cr_en.dfd_id_1   = 1'b1 ;
           CR_THREAD2_DFD_REG_ID            : cr_en.dfd_id_2   = 1'b1 ;
           CR_THREAD3_DFD_REG_ID            : cr_en.dfd_id_3   = 1'b1 ;
           CR_THREAD0_STACK_BASE_OFFSET     : cr_en.stk_ofst_0 = 1'b1 ;
           CR_THREAD1_STACK_BASE_OFFSET     : cr_en.stk_ofst_1 = 1'b1 ;
           CR_THREAD2_STACK_BASE_OFFSET     : cr_en.stk_ofst_2 = 1'b1 ;
           CR_THREAD3_STACK_BASE_OFFSET     : cr_en.stk_ofst_3 = 1'b1 ;
           CR_THREAD0_TLS_BASE_OFFSET       : cr_en.tls_ofst_0 = 1'b1 ;
           CR_THREAD1_TLS_BASE_OFFSET       : cr_en.tls_ofst_1 = 1'b1 ;
           CR_THREAD2_TLS_BASE_OFFSET       : cr_en.tls_ofst_2 = 1'b1 ;
           CR_THREAD3_TLS_BASE_OFFSET       : cr_en.tls_ofst_3 = 1'b1 ;   
           CR_THREAD0_TLS_BASE_OFFSET       : cr_en.scratch_pad_0 = 1'b1 ;
           CR_THREAD1_TLS_BASE_OFFSET       : cr_en.scratch_pad_1 = 1'b1 ;
           CR_THREAD2_TLS_BASE_OFFSET       : cr_en.scratch_pad_2 = 1'b1 ;
           CR_THREAD3_TLS_BASE_OFFSET       : cr_en.scratch_pad_3 = 1'b1 ;   
           default      : /*do nothing*/                     ;
        endcase
    end //if (wren)

    cr_en.pc         = 1'b1;
    cr_en.thread     = 1'b1;
    cr_en.core       = 1'b1;
    cr_en.stk_ofst   = 1'b1;
    cr_en.tls_ofst   = 1'b1;
    cr_en.shrd_ofst  = 1'b1;
    cr_en.i_mem_msb  = 1'b1;
    cr_en.d_mem_msb  = 1'b1;
    cr_en.sts_0      = 1'b1;
    cr_en.sts_1      = 1'b1;
    cr_en.sts_2      = 1'b1;
    cr_en.sts_3      = 1'b1;
    cr_en.expt_0     = 1'b1 ;
    cr_en.expt_1     = 1'b1 ;
    cr_en.expt_2     = 1'b1 ;
    cr_en.expt_3     = 1'b1 ;
    cr_en.pc_0       = (ThreadIDQ103H == 2'b00);
    cr_en.pc_1       = (ThreadIDQ103H == 2'b01);
    cr_en.pc_2       = (ThreadIDQ103H == 2'b10);
    cr_en.pc_3       = (ThreadIDQ103H == 2'b11);
    cr_en.dfd_data_0 = 1'b1;
    cr_en.dfd_data_1 = 1'b1;
    cr_en.dfd_data_2 = 1'b1;
    cr_en.dfd_data_3 = 1'b1;
    
    
    
    
    
    
end 

//=======================================================
//================CR memory flops======================
//=======================================================
//`LOTR_MSFF(cr_mem, next_cr_mem, clock) 
`LOTR_EN_RST_VAL_MSFF   (core_cr.rst_pc_0  , data[0] ,  clock  ,  cr_en.rst_pc_0     , rst  ,  1'b1)
`LOTR_EN_RST_VAL_MSFF   (core_cr.rst_pc_1  , data[0] ,  clock  ,  cr_en.rst_pc_1     , rst  ,  1'b1)
`LOTR_EN_RST_VAL_MSFF   (core_cr.rst_pc_2  , data[0] ,  clock  ,  cr_en.rst_pc_2     , rst  ,  1'b1)
`LOTR_EN_RST_VAL_MSFF   (core_cr.rst_pc_3  , data[0] ,  clock  ,  cr_en.rst_pc_3     , rst  ,  1'b1)
`LOTR_EN_RST_VAL_MSFF   (core_cr.en_pc_0   , data[0] ,  clock  ,  cr_en.en_pc_0      , rst  ,  1'b1)
`LOTR_EN_RST_VAL_MSFF   (core_cr.en_pc_1   , data[0] ,  clock  ,  cr_en.en_pc_1      , rst  ,  1'b1)
`LOTR_EN_RST_VAL_MSFF   (core_cr.en_pc_2   , data[0] ,  clock  ,  cr_en.en_pc_2      , rst  ,  1'b1)
`LOTR_EN_RST_VAL_MSFF   (core_cr.en_pc_3   , data[0] ,  clock  ,  cr_en.en_pc_3      , rst  ,  1'b1)
`LOTR_EN_RST_VAL_MSFF   (core_cr.dfd_id_0  , data[4:0] ,  clock  ,  cr_en.dfd_id_0     , rst  ,  5'b0)
`LOTR_EN_RST_VAL_MSFF   (core_cr.dfd_id_1  , data[4:0] ,  clock  ,  cr_en.dfd_id_1     , rst  ,  5'b0)
`LOTR_EN_RST_VAL_MSFF   (core_cr.dfd_id_2  , data[4:0] ,  clock  ,  cr_en.dfd_id_2     , rst  ,  5'b0)
`LOTR_EN_RST_VAL_MSFF   (core_cr.dfd_id_3  , data[4:0] ,  clock  ,  cr_en.dfd_id_3     , rst  ,  5'b0)

`LOTR_EN_RST_VAL_MSFF   (cr_ofst.stk_ofst_0, data[31:0] ,  clock  ,  cr_en.stk_ofst_0   , rst  ,  32'h400200)
`LOTR_EN_RST_VAL_MSFF   (cr_ofst.stk_ofst_1, data[31:0] ,  clock  ,  cr_en.stk_ofst_1   , rst  ,  32'h400400)
`LOTR_EN_RST_VAL_MSFF   (cr_ofst.stk_ofst_2, data[31:0] ,  clock  ,  cr_en.stk_ofst_2   , rst  ,  32'h400600)
`LOTR_EN_RST_VAL_MSFF   (cr_ofst.stk_ofst_3, data[31:0] ,  clock  ,  cr_en.stk_ofst_3   , rst  ,  32'h400800)
`LOTR_EN_RST_VAL_MSFF   (cr_ofst.tls_ofst_0, data[31:0] ,  clock  ,  cr_en.tls_ofst_0   , rst  ,  32'h400200)
`LOTR_EN_RST_VAL_MSFF   (cr_ofst.tls_ofst_1, data[31:0] ,  clock  ,  cr_en.tls_ofst_1   , rst  ,  32'h400400)
`LOTR_EN_RST_VAL_MSFF   (cr_ofst.tls_ofst_2, data[31:0] ,  clock  ,  cr_en.tls_ofst_2   , rst  ,  32'h400600)
`LOTR_EN_RST_VAL_MSFF   (cr_ofst.tls_ofst_3, data[31:0] ,  clock  ,  cr_en.tls_ofst_3   , rst  ,  32'h400800)

`LOTR_EN_RST_MSFF   (scratch_pad_0, data[31:0] ,  clock  ,  cr_en.scratch_pad_0   , rst )
`LOTR_EN_RST_MSFF   (scratch_pad_1, data[31:0] ,  clock  ,  cr_en.scratch_pad_1   , rst )
`LOTR_EN_RST_MSFF   (scratch_pad_2, data[31:0] ,  clock  ,  cr_en.scratch_pad_2   , rst )
`LOTR_EN_RST_MSFF   (scratch_pad_3, data[31:0] ,  clock  ,  cr_en.scratch_pad_3   , rst )

`LOTR_EN_RST_MSFF       (cr_ro.pc           , PcQ103H ,         clock  ,  cr_en.pc         , rst )
`LOTR_EN_RST_MSFF       (cr_ro.thread       , ThreadIDQ103H ,   clock  ,  cr_en.thread     , rst )
`LOTR_EN_RST_MSFF       (cr_ro.core         , 32'b0 ,           clock  ,  cr_en.core       , rst )
`LOTR_EN_RST_MSFF       (cr_ro.stk_ofst     , StkOffsetQ103H ,  clock  ,  cr_en.stk_ofst   , rst )
`LOTR_EN_RST_MSFF       (cr_ro.tls_ofst     , TlsOffsetQ103H ,  clock  ,  cr_en.tls_ofst   , rst )
`LOTR_EN_RST_MSFF       (cr_ro.shrd_ofst    , 32'h400f00 ,      clock  ,  cr_en.shrd_ofst  , rst )
`LOTR_EN_RST_MSFF       (cr_ro.i_mem_msb    , MSB_I_MEM ,       clock  ,  cr_en.i_mem_msb  , rst )
`LOTR_EN_RST_MSFF       (cr_ro.d_mem_msb    , MSB_D_MEM ,       clock  ,  cr_en.d_mem_msb  , rst )
`LOTR_EN_RST_MSFF       (cr_ro.sts_0        , 32'b0 ,           clock  ,  cr_en.sts_0      , rst )
`LOTR_EN_RST_MSFF       (cr_ro.sts_1        , 32'b0 ,           clock  ,  cr_en.sts_1      , rst )
`LOTR_EN_RST_MSFF       (cr_ro.sts_2        , 32'b0 ,           clock  ,  cr_en.sts_2      , rst )
`LOTR_EN_RST_MSFF       (cr_ro.sts_3        , 32'b0 ,           clock  ,  cr_en.sts_3      , rst )
`LOTR_EN_RST_MSFF       (cr_ro.expt_0       , 32'b0 ,           clock  ,  cr_en.expt_0     , rst )
`LOTR_EN_RST_MSFF       (cr_ro.expt_1       , 32'b0 ,           clock  ,  cr_en.expt_1     , rst )
`LOTR_EN_RST_MSFF       (cr_ro.expt_2       , 32'b0 ,           clock  ,  cr_en.expt_2     , rst )
`LOTR_EN_RST_MSFF       (cr_ro.expt_3       , 32'b0 ,           clock  ,  cr_en.expt_3     , rst )
`LOTR_EN_RST_MSFF       (cr_ro.pc_0         , PcQ103H ,         clock  ,  cr_en.pc_0       , rst )
`LOTR_EN_RST_MSFF       (cr_ro.pc_1         , PcQ103H ,         clock  ,  cr_en.pc_1       , rst )
`LOTR_EN_RST_MSFF       (cr_ro.pc_2         , PcQ103H ,         clock  ,  cr_en.pc_2       , rst )
`LOTR_EN_RST_MSFF       (cr_ro.pc_3         , PcQ103H ,         clock  ,  cr_en.pc_3       , rst )
`LOTR_EN_RST_MSFF       (cr_ro.dfd_data_0   , DfdThreadQ103H ,  clock  ,  cr_en.dfd_data_0 , rst )
`LOTR_EN_RST_MSFF       (cr_ro.dfd_data_1   , DfdThreadQ103H ,  clock  ,  cr_en.dfd_data_1 , rst )
`LOTR_EN_RST_MSFF       (cr_ro.dfd_data_2   , DfdThreadQ103H ,  clock  ,  cr_en.dfd_data_2 , rst )
`LOTR_EN_RST_MSFF       (cr_ro.dfd_data_3   , DfdThreadQ103H ,  clock  ,  cr_en.dfd_data_3 , rst )





//assign cr       = cr_mem;
//=======================================================
//================CR memory read======================
//=======================================================
assign ThreadIDQ103H =  (ThreadQ103H == 4'b0001) ? 2'b00 :
                        (ThreadQ103H == 4'b0010) ? 2'b01 :
                        (ThreadQ103H == 4'b0100) ? 2'b10 :
                                                   2'b11 ;
                                                   
assign StkOffsetQ103H = (ThreadQ103H == 4'b0001) ? cr_ofst.stk_ofst_0 :
                        (ThreadQ103H == 4'b0010) ? cr_ofst.stk_ofst_1 :
                        (ThreadQ103H == 4'b0100) ? cr_ofst.stk_ofst_2 :
                                                   cr_ofst.stk_ofst_3 ;    
                                                   
assign TlsOffsetQ103H = (ThreadQ103H == 4'b0001) ? cr_ofst.tls_ofst_0 :
                        (ThreadQ103H == 4'b0010) ? cr_ofst.tls_ofst_1 :                           
                        (ThreadQ103H == 4'b0100) ? cr_ofst.tls_ofst_2 :
                                                   cr_ofst.tls_ofst_3 ;    
                                                   
assign DfdThreadQ103H = (ThreadQ103H == 4'b0001) ? core_cr.dfd_id_0 :
                        (ThreadQ103H == 4'b0010) ? core_cr.dfd_id_1 :                           
                        (ThreadQ103H == 4'b0100) ? core_cr.dfd_id_2 :
                                                   core_cr.dfd_id_3 ;                                                    

always_comb begin
    cr_data_core =32'b0;
    if(rden && match_cr_region && MatchLocalCoreQ103H) begin
        unique case (address[MSB_CR:0])
             //CR_EN_PC     : cr_data_core  = {31'b0,cr_mem.cr.en_pc} ;
             //CR_RST_PC    : cr_data_core  = {31'b0,cr_mem.cr.rst_pc};
             CR_THREAD_ID_Q103H           : cr_data_core  = ThreadIDQ103H; 
             CR_CORE_ID                 : cr_data_core  = {23'b0,core_id_strap}; //FIXME - add strap CORE_ID from top level
             CR_STACK_BASE_OFFSET       : cr_data_core  = StkOffsetQ103H ;
             CR_TLS_BASE_OFFSET         : cr_data_core  = cr_ro.tls_ofst ;
             CR_SHARED_BASE_OFFSET      : cr_data_core  = cr_ro.shrd_ofst;
             CR_I_MEM_MSB               : cr_data_core  = cr_ro.i_mem_msb;
             CR_D_MEM_MSB               : cr_data_core  = cr_ro.d_mem_msb;
             CR_THREAD0_STATUS          : cr_data_core  = cr_ro.sts_0;
             CR_THREAD1_STATUS          : cr_data_core  = cr_ro.sts_1;
             CR_THREAD2_STATUS          : cr_data_core  = cr_ro.sts_2;
             CR_THREAD3_STATUS          : cr_data_core  = cr_ro.sts_3;
             CR_THREAD0_EXCEPTION_CODE  : cr_data_core  = cr_ro.expt_0;
             CR_THREAD1_EXCEPTION_CODE  : cr_data_core  = cr_ro.expt_1;
             CR_THREAD2_EXCEPTION_CODE  : cr_data_core  = cr_ro.expt_2;
             CR_THREAD3_EXCEPTION_CODE  : cr_data_core  = cr_ro.expt_3;
             CR_THREAD0_PC              : cr_data_core  = cr_ro.pc_0;
             CR_THREAD1_PC              : cr_data_core  = cr_ro.pc_1;
             CR_THREAD2_PC              : cr_data_core  = cr_ro.pc_2;
             CR_THREAD3_PC              : cr_data_core  = cr_ro.pc_3;
             CR_THREAD0_DFD_REG_DATA    : cr_data_core  = cr_ro.dfd_data_0;
             CR_THREAD1_DFD_REG_DATA    : cr_data_core  = cr_ro.dfd_data_1;
             CR_THREAD2_DFD_REG_DATA    : cr_data_core  = cr_ro.dfd_data_2;
             CR_THREAD3_DFD_REG_DATA    : cr_data_core  = cr_ro.dfd_data_3;
             CR_THREAD0_DFD_REG_DATA    : cr_data_core  = scratch_pad_0;
             CR_THREAD1_DFD_REG_DATA    : cr_data_core  = scratch_pad_1;
             CR_THREAD2_DFD_REG_DATA    : cr_data_core  = scratch_pad_2;
             CR_THREAD3_DFD_REG_DATA    : cr_data_core  = scratch_pad_3;
             
            default       : cr_data_core  = 32'b0                      ;
        endcase
    end
end

//sample the read (synchornic read)
`LOTR_MSFF(cr_q, cr_data_core, clock)
//`LOTR_EN_MSFF(cr_q, cr_data_core, clock, match_cr_region) ????????
`LOTR_MSFF(match_cr_regionQ104H , match_cr_region ,clock)
`LOTR_MSFF(MatchD_MemRegionQ104H , MatchD_MemRegionQ103H ,clock)
`LOTR_MSFF(MatchLocalCoreQ104H , MatchLocalCoreQ103H ,clock)

//mux between the CR and the DATA
always_comb begin
    q        = match_cr_regionQ104H    ? cr_q :
               MatchD_MemRegionQ104H   ? data_q :
                                            32'b0  ;
    
end

endmodule
