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
module d_mem_wrap 
import lotr_pkg::*;  
                (
                input  logic         QClk           ,
                input  logic         RstQnnnH       ,
                input  logic [7:0]   CoreIdStrap    ,
                output t_core_cr     CRQnnnH        ,
                //============================================
                //      core interface
                //============================================
                input  logic [3:0]   ThreadQ103H    ,
                input  logic [31:0]  PcQ103H        ,
                input  logic [31:0]  AddressQ103H   ,
                input  logic [3:0]   ByteEnQ103H    ,
                input  logic [31:0]  WrDataQ103H    ,
                input  logic         RdEnQ103H      ,
                input  logic         WrEnQ103H      ,
                output logic [31:0]  MemRdDataQ104H ,
                //============================================
                //      RC interface
                //============================================
                input  logic [31:0]  F2C_AddressQ503H  ,
                input  logic [31:0]  F2C_WrDataQ503H   ,
                input  logic         F2C_RdEnQ503H     ,
                input  logic         F2C_WrEnQ503H     ,
                output logic [31:0]  F2C_MemRdDataQ504H
               );

logic [31:0] cr_q;
logic [31:0] cr_data_core;
logic [31:0] RdDataQ104H;
logic [31:0] StkOffsetQ103H;
logic [31:0] TlsOffsetQ103H;
logic [4:0]  DfdThreadQ103H;
logic        MatchLocalCoreQ103H  ;
logic        MatchLocalCoreQ104H  ;
logic        MatchD_MemRegionQ103H;
logic        MatchD_MemRegionQ104H;
logic        MatchCrRegionQ103H   ;
logic        MatchCrRegionQ104H   ;
logic [31:0] CrRdDataQ104H;
always_comb begin
    MatchLocalCoreQ103H   = (AddressQ103H[MSB_CORE_ID:LSB_CORE_ID] == 8'b0 || AddressQ103H[MSB_CORE_ID:LSB_CORE_ID] == CoreIdStrap);
    MatchD_MemRegionQ103H = (AddressQ103H[MSB_REGION:LSB_REGION] == D_MEM_REGION);
    MatchCrRegionQ103H    = (AddressQ103H[MSB_REGION:LSB_REGION] == CR_REGION);
end

//=======================================================
//================   D_MEM Access  ======================
//=======================================================
`ifdef FPGA
d_mem d_mem ( //FIXME - point to altera Memory
`else
d_mem d_mem (                                                             
`endif
    .clock    (QClk),
    .address  (AddressQ103H[MSB_D_MEM:0]),
    .byteena  (ByteEnQ103H),
    .data     (WrDataQ103H),
    .rden     (RdEnQ103H && MatchD_MemRegionQ103H && MatchLocalCoreQ103H),
    .wren     (WrEnQ103H && MatchD_MemRegionQ103H && MatchLocalCoreQ103H),
    .q        (RdDataQ104H)
    );

//=======================================================
//================   CR Access     ======================
//=======================================================
cr_mem cr_mem (                                                             
    .QClk           (QClk),          
    .RstQnnnH       (RstQnnnH),          
    .CoreIdStrap    (CoreIdStrap),          
    //============================================
    //      core interface
    //============================================
    .CrAddressQ103H (AddressQ103H),
    .ThreadQ103H    (ThreadQ103H),
    .PcQ103H        (PcQ103H),
    .CrWrDataQ103H  (WrDataQ103H),
    .CrRdEnQ103H    (RdEnQ103H && MatchCrRegionQ103H && MatchLocalCoreQ103H),  
    .CrWrEnQ103H    (WrEnQ103H && MatchCrRegionQ103H && MatchLocalCoreQ103H),  
    .CrRdDataQ104H  (CrRdDataQ104H),     
    .core_cr        (CRQnnnH)
    );
`LOTR_MSFF(MatchCrRegionQ104H    , MatchCrRegionQ103H    , QClk)
`LOTR_MSFF(MatchD_MemRegionQ104H , MatchD_MemRegionQ103H , QClk)
`LOTR_MSFF(MatchLocalCoreQ104H   , MatchLocalCoreQ103H   , QClk)
logic RdEnQ104H;
`LOTR_MSFF(RdEnQ104H             , RdEnQ103H             , QClk)
//mux between the CR and the DATA
always_comb begin
    MemRdDataQ104H  = (RdEnQ104H && MatchCrRegionQ104H   ) ? CrRdDataQ104H :
                      (RdEnQ104H && MatchD_MemRegionQ104H) ? RdDataQ104H   :
                                                             32'b0         ;
end

endmodule
