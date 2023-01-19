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
                input  logic         ALL_PC_RESET        ,
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
                output logic         C2F_RspMatchQ104H,
                output logic         T0RcAccess     ,
                output logic         T1RcAccess     ,
                output logic         T2RcAccess     ,
                output logic         T3RcAccess     ,
                
                //============================================
                //      RC interface
                //============================================
                input  logic        F2C_ReqValidQ503H     ,
                input  t_opcode     F2C_ReqOpcodeQ503H    ,
                input  logic [31:0] F2C_ReqAddressQ503H   ,
                input  logic [31:0] F2C_ReqDataQ503H      ,
                output logic        F2C_RspDMemValidQ504H , 
                output logic [31:0] F2C_D_MemRspDataQ504H ,
                
                
                input logic         C2F_RspValidQ502H     ,
                input t_opcode      C2F_RspOpcodeQ502H    ,
                input logic [1:0]   C2F_RspThreadIDQ502H  ,
                input logic [31:0]  C2F_RspDataQ502H      ,
                input logic         C2F_RspStall          ,
                                                        
                output logic        C2F_ReqValidQ500H     ,
                output t_opcode    C2F_ReqOpcodeQ500H     ,
                output logic [1:0] C2F_ReqThreadIDQ500H   ,
                output logic [31:0]C2F_ReqAddressQ500H    ,
                output logic [31:0]C2F_ReqDataQ500H     
                
                
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

logic        T0C2FReq          ;
logic        T1C2FReq          ;
logic        T2C2FReq          ;
logic        T3C2FReq          ;
logic        T0C2FRes          ;
logic        T1C2FRes          ;
logic        T2C2FRes          ;
logic        T3C2FRes          ;

logic        RstT0RcAccess;
logic        RstT1RcAccess;
logic        RstT2RcAccess;
logic        RstT3RcAccess;

logic [31:0] T0Data            ;
logic [31:0] T1Data            ;
logic [31:0] T2Data            ;
logic [31:0] T3Data            ;
logic [31:0] C2F_RspDataQ503H  ;
logic [31:0] C2F_RspDataQ504H  ;

logic       T0C2F_Match        ;
logic       T1C2F_Match        ;
logic       T2C2F_Match        ;
logic       T3C2F_Match        ;
logic       C2F_Match_Q103H    ;




assign C2F_ReqValidQ500H    = (WrEnQ103H||RdEnQ103H) && !MatchLocalCoreQ103H;
assign C2F_ReqOpcodeQ500H   = WrEnQ103H ? WR : 
                              RdEnQ103H ? RD : RD;
assign C2F_ReqThreadIDQ500H = (ThreadQ103H == 4'b0001) ? 2'b00 :
                              (ThreadQ103H == 4'b0010) ? 2'b01 :
                              (ThreadQ103H == 4'b0100) ? 2'b10 :
                                                         2'b11 ;
assign C2F_ReqAddressQ500H  = C2F_ReqValidQ500H ? AddressQ103H : 0;
assign C2F_ReqDataQ500H     = WrDataQ103H;

assign T0C2FReq = (C2F_ReqValidQ500H && RdEnQ103H && C2F_ReqThreadIDQ500H == 2'b00);
assign T1C2FReq = (C2F_ReqValidQ500H && RdEnQ103H && C2F_ReqThreadIDQ500H == 2'b01);
assign T2C2FReq = (C2F_ReqValidQ500H && RdEnQ103H && C2F_ReqThreadIDQ500H == 2'b10);
assign T3C2FReq = (C2F_ReqValidQ500H && RdEnQ103H && C2F_ReqThreadIDQ500H == 2'b11);

`LOTR_EN_RST_MSFF (T0RcAccess , T0C2FReq , QClk ,T0C2FReq ,  ( RstQnnnH || RstT0RcAccess ))
`LOTR_EN_RST_MSFF (T1RcAccess , T1C2FReq , QClk ,T1C2FReq ,  ( RstQnnnH || RstT1RcAccess ))
`LOTR_EN_RST_MSFF (T2RcAccess , T2C2FReq , QClk ,T2C2FReq ,  ( RstQnnnH || RstT2RcAccess ))
`LOTR_EN_RST_MSFF (T3RcAccess , T3C2FReq , QClk ,T3C2FReq ,  ( RstQnnnH || RstT3RcAccess ))

assign T0C2FRes = (C2F_RspValidQ502H && C2F_RspThreadIDQ502H == 2'b00);
assign T1C2FRes = (C2F_RspValidQ502H && C2F_RspThreadIDQ502H == 2'b01);
assign T2C2FRes = (C2F_RspValidQ502H && C2F_RspThreadIDQ502H == 2'b10);
assign T3C2FRes = (C2F_RspValidQ502H && C2F_RspThreadIDQ502H == 2'b11);

`LOTR_EN_RST_MSFF (T0Data , C2F_RspDataQ502H , QClk ,T0C2FRes , RstQnnnH)
`LOTR_EN_RST_MSFF (T1Data , C2F_RspDataQ502H , QClk ,T1C2FRes , RstQnnnH)
`LOTR_EN_RST_MSFF (T2Data , C2F_RspDataQ502H , QClk ,T2C2FRes , RstQnnnH)
`LOTR_EN_RST_MSFF (T3Data , C2F_RspDataQ502H , QClk ,T3C2FRes , RstQnnnH)

assign C2F_RspDataQ503H =      (ThreadQ103H == 4'b0001) ? T0Data :
                               (ThreadQ103H == 4'b0010) ? T1Data :
                               (ThreadQ103H == 4'b0100) ? T2Data :
                                                          T3Data ;
`LOTR_RST_MSFF (C2F_RspDataQ504H , C2F_RspDataQ503H , QClk , RstQnnnH)


`LOTR_EN_RST_MSFF (T0C2F_Match ,  1'b1 , QClk ,T0C2FRes , RstQnnnH||(ThreadQ103H == 4'b0001))
`LOTR_EN_RST_MSFF (T1C2F_Match ,  1'b1 , QClk ,T1C2FRes , RstQnnnH||(ThreadQ103H == 4'b0010))
`LOTR_EN_RST_MSFF (T2C2F_Match ,  1'b1 , QClk ,T2C2FRes , RstQnnnH||(ThreadQ103H == 4'b0100))
`LOTR_EN_RST_MSFF (T3C2F_Match ,  1'b1 , QClk ,T3C2FRes , RstQnnnH||(ThreadQ103H == 4'b1000))

assign C2F_Match_Q103H = (T0C2F_Match && ThreadQ103H[0])  ||
                         (T1C2F_Match && ThreadQ103H[1])  ||
                         (T2C2F_Match && ThreadQ103H[2])  ||
                         (T3C2F_Match && ThreadQ103H[3]);

assign RstT0RcAccess   = (C2F_Match_Q103H && ThreadQ103H[0]);
assign RstT1RcAccess   = (C2F_Match_Q103H && ThreadQ103H[1]);
assign RstT2RcAccess   = (C2F_Match_Q103H && ThreadQ103H[2]);
assign RstT3RcAccess   = (C2F_Match_Q103H && ThreadQ103H[3]);

`LOTR_RST_MSFF (C2F_RspMatchQ104H , C2F_Match_Q103H , QClk , RstQnnnH) 

                  
                       
//===========================================
//    core interface
//===========================================
always_comb begin
    MatchLocalCoreQ103H   = (AddressQ103H[MSB_CORE_ID:LSB_CORE_ID] == 8'b0 || AddressQ103H[MSB_CORE_ID:LSB_CORE_ID] == CoreIdStrap);
    MatchD_MemRegionQ103H = (AddressQ103H[MSB_REGION:LSB_REGION] == D_MEM_REGION);
    MatchCrRegionQ103H    = (AddressQ103H[MSB_REGION:LSB_REGION] == CR_REGION);

end


//always_comb begin
//unique case (C2F_ReqThreadIDQ500H)
//               2'b00         : CrFreezeAddress       = 32'h00C00150 ;
//               2'b01         : CrFreezeAddress       = 32'h00C00154 ;
//               2'b10         : CrFreezeAddress       = 32'h00C00158 ;
//               2'b11         : CrFreezeAddress       = 32'h00C0015C ;
//               default         : /*do nothing - TODO add assertion*/;
//            endcase
//unique case (C2F_RspThreadIDQ502H)
//               2'b00         : CrUnFreezeAddress       = 32'h00C00150 ;
//               2'b01         : CrUnFreezeAddress       = 32'h00C00154 ;
//               2'b10         : CrUnFreezeAddress       = 32'h00C00158 ;
//               2'b11         : CrUnFreezeAddress       = 32'h00C0015C ;
//               default         : /*do nothing - TODO add assertion*/;
//            endcase
//
//
//end

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
`ifdef DE10_LITE
	`ifdef DMEM_8K
		d_mem_8k i_mem (
	`else
		d_mem_4k d_mem (
	`endif //IMEM_8K
`else 
d_mem d_mem (                                                             
`endif
    .clock    (QClk),
    //============================================
    //      core interface
    //============================================
    .address_a  (AddressQ103H[MSB_D_MEM:2]),
    .byteena_a  (ByteEnQ103H),
    .data_a     (WrDataQ103H),
    .rden_a     (RdEnMatchQ103H),
    .wren_a     (WrEnMatchQ103H),
    .q_a        (RdDataQ104H),
    //============================================
    //      Ring interface
    //============================================
    .address_b  (F2C_ReqAddressQ503H[MSB_D_MEM:2]),
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
    .ALL_PC_RESET(ALL_PC_RESET),
    //============================================
    //      core interface
    //============================================
    //.CrAddressQ103H (CrAddressQ103H[MSB_D_MEM:0]),
    //.ThreadQ103H    (ThreadQ103H),
    //.PcQ103H        (PcQ103H),
    //.CrWrDataQ103H  (CrWrDataQ103H),
    //.CrRdEnQ103H    (CrRdEnQ103H),  
    //.CrWrEnQ103H    (CrWrEnQ103H),  
    //.CrRdDataQ104H  (CrRdDataQ104H),     
    //.core_cr        (CRQnnnH),
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
assign MemRdDataQ104H  = (C2F_RspMatchQ104H )                 ? C2F_RspDataQ504H :
                         (RdEnQ104H && MatchCrRegionQ104H   ) ? CrRdDataQ104H    :
                         (RdEnQ104H && MatchD_MemRegionQ104H) ? RdDataQ104H      :
                                                                32'b0            ;

//assign MemRdDataQ104H  = (RdEnQ104H && MatchCrRegionQ104H   ) ? CrRdDataQ104H    :
//                         (RdEnQ104H && MatchD_MemRegionQ104H) ? RdDataQ104H      :
//                                                                32'b0            ;
                                                                
//Set th RspEn and the Read Rsp Data to F2C Requests.
`LOTR_MSFF(F2C_RdEnQ504H    , F2C_RdEnQ503H    , QClk)
`LOTR_MSFF(F2C_CrRdEnQ504H  , F2C_CrRdEnQ503H  , QClk)
assign F2C_RspDMemValidQ504H = F2C_RdEnQ504H || F2C_CrRdEnQ504H;
assign F2C_D_MemRspDataQ504H = F2C_RdEnQ504H    ? F2C_RspDataQ504H   : 
                               F2C_CrRdEnQ504H  ? F2C_CrRspDataQ504H :
                                                  '0;
endmodule
