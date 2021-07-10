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
                input  logic        F2C_ReqValidQ503H     ,
                input  t_opcode     F2C_ReqOpcodeQ503H    ,
                input  logic [31:0] F2C_ReqAddressQ503H   ,
                input  logic [31:0] F2C_ReqDataQ503H      ,
                output logic        F2C_RspDMemValidQ504H , 
                output logic [31:0] F2C_D_MemRspDataQ504H 
               );

logic [31:0] cr_q;
logic [31:0] cr_data_core;
logic [31:0] RdDataQ104H;
logic [31:0] StkOffsetQ103H;
logic [31:0] TlsOffsetQ103H;
logic [4:0]  DfdThreadQ103H;
logic        MatchLocalCoreQ103H  ;
logic        MatchD_MemRegionQ103H;
logic        MatchD_MemRegionQ104H;
logic        MatchCrRegionQ103H   ;
logic        MatchCrRegionQ104H   ;
logic [31:0] CrRdDataQ104H;
logic        RdEnQ104H;
logic        RdEnMatchQ103H;
logic        WrEnMatchQ103H;

logic [31:0] F2C_RspDataQ504H;
logic [31:0] F2C_CrRspDataQ504H;
logic        F2C_D_MemHitQ503H ;
logic        F2C_RdEnQ503H     ;
logic        F2C_RdEnQ504H     ;
logic        F2C_WrEnQ503H     ;
logic        F2C_CR_MemHitQ503H;
logic        F2C_CrRdEnQ503H   ;
logic        F2C_CrRdEnQ504H   ;
logic        F2C_CrWrEnQ503H   ;
//===========================================
//    core interface
//===========================================
always_comb begin
    MatchLocalCoreQ103H   = (AddressQ103H[MSB_CORE_ID:LSB_CORE_ID] == 8'b0 || AddressQ103H[MSB_CORE_ID:LSB_CORE_ID] == CoreIdStrap);
    MatchD_MemRegionQ103H = (AddressQ103H[MSB_REGION:LSB_REGION] == D_MEM_REGION);
    MatchCrRegionQ103H    = (AddressQ103H[MSB_REGION:LSB_REGION] == CR_REGION);
end
assign RdEnMatchQ103H = RdEnQ103H && MatchD_MemRegionQ103H && MatchLocalCoreQ103H;
assign WrEnMatchQ103H = WrEnQ103H && MatchD_MemRegionQ103H && MatchLocalCoreQ103H;

//===========================================
//    ring interface
//===========================================
assign F2C_D_MemHitQ503H =(F2C_ReqAddressQ503H[MSB_REGION:LSB_REGION] == D_MEM_REGION);
assign F2C_RdEnQ503H     = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == RD) && F2C_D_MemHitQ503H;
assign F2C_WrEnQ503H     = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == WR) && F2C_D_MemHitQ503H;

assign F2C_CR_MemHitQ503H=(F2C_ReqAddressQ503H[MSB_REGION:LSB_REGION] == CR_REGION);
assign F2C_CrRdEnQ503H   = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == RD) && F2C_CR_MemHitQ503H;
assign F2C_CrWrEnQ503H   = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == WR) && F2C_CR_MemHitQ503H;


//=======================================================
//================   D_MEM Access  ======================
//=======================================================
`ifdef FPGA
d_mem d_mem ( //FIXME - point to altera Memory
`else
d_mem d_mem (                                                             
`endif
    .clock    (QClk),
    //============================================
    //      core interface
    //============================================
    .address_a  (AddressQ103H[MSB_D_MEM:0]),
    .byteena_a  (ByteEnQ103H),
    .data_a     (WrDataQ103H),
    .rden_a     (RdEnMatchQ103H),
    .wren_a     (WrEnMatchQ103H),
    .q_a        (RdDataQ104H),
    //============================================
    //      Ring interface
    //============================================
    .address_b  (F2C_ReqAddressQ503H[MSB_D_MEM:0]),
    .byteena_b  (4'b1111),
    .data_b     (F2C_ReqDataQ503H),
    .rden_b     (F2C_RdEnQ503H),
    .wren_b     (F2C_WrEnQ503H),
    .q_b        (F2C_RspDataQ504H)
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
    .CrAddressQ103H (AddressQ103H[MSB_D_MEM:0]),
    .ThreadQ103H    (ThreadQ103H),
    .PcQ103H        (PcQ103H),
    .CrWrDataQ103H  (WrDataQ103H),
    .CrRdEnQ103H    (RdEnQ103H && MatchCrRegionQ103H && MatchLocalCoreQ103H),  
    .CrWrEnQ103H    (WrEnQ103H && MatchCrRegionQ103H && MatchLocalCoreQ103H),  
    .CrRdDataQ104H  (CrRdDataQ104H),     
    .core_cr        (CRQnnnH),
    //============================================
    //      Ring interface
    //============================================
    .F2C_AddressQ503H    (F2C_ReqAddressQ503H[MSB_D_MEM:0]),
    .F2C_WrDataQ503H     (F2C_ReqDataQ503H),
    .F2C_CrRdEnQ503H     (F2C_CrRdEnQ503H),
    .F2C_CrWrEnQ503H     (F2C_CrWrEnQ503H),
    .F2C_CrRspDataQ504H  (F2C_CrRspDataQ504H)
    );

`LOTR_MSFF(MatchCrRegionQ104H    , MatchCrRegionQ103H    , QClk)
`LOTR_MSFF(MatchD_MemRegionQ104H , MatchD_MemRegionQ103H , QClk)
`LOTR_MSFF(RdEnQ104H             , RdEnQ103H             , QClk)
// Mux between the CR and the DATA
assign MemRdDataQ104H  = (RdEnQ104H && MatchCrRegionQ104H   ) ? CrRdDataQ104H :
                         (RdEnQ104H && MatchD_MemRegionQ104H) ? RdDataQ104H   :
                                                                32'b0         ;

//Set th RspEn and the Read Rsp Data to F2C Requests.
`LOTR_MSFF(F2C_RdEnQ504H    , F2C_RdEnQ503H    , QClk)
`LOTR_MSFF(F2C_CrRdEnQ504H  , F2C_CrRdEnQ503H  , QClk)
assign F2C_RspDMemValidQ504H = F2C_RdEnQ504H || F2C_CrRdEnQ504H;
assign F2C_D_MemRspDataQ504H = F2C_RdEnQ504H    ? F2C_RspDataQ504H   : 
                               F2C_CrRdEnQ504H  ? F2C_CrRspDataQ504H :
                                                  '0;
endmodule
