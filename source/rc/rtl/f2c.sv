//-----------------------------------------------------------------------------
// Title            : RC - Ring Controller 
// Project          : LOTR: Lord-Of-The-Ring
//-----------------------------------------------------------------------------
// File             : f2c.sv 
// Original Author  : Tzahi Peretz, Shimi Haleluya 
// Adviser          : Amichai Ben-David
// Created          : 11/2021
//-----------------------------------------------------------------------------
// Description :
// 
//------------------------------------------------------------------------------
// Modification history :
//
//------------------------------------------------------------------------------
`include "lotr_defines.sv"
module f2c
    import lotr_pkg::*;  
    (
    //General Interface
    input   logic         QClk                   ,
    input   logic         RstQnnnH               ,
    input   logic  [7:0]  CoreID                 ,
    input   t_winner      SelRingRspOutQ501H     ,
    output  logic         F2C_MatchIdQ501H       ,
    //===================================
    // Ring Controler <-> Fabric Inteface
    //===================================
    //Ring ---> F2C , RingReqIn
    input   logic         RingReqInValidQ501H    ,
    input   logic  [9:0]  RingReqInRequestorQ501H,    
    input   t_opcode      RingReqInOpcodeQ501H   ,
    input   logic  [31:0] RingReqInAddressQ501H  ,
    input   logic  [31:0] RingReqInDataQ501H     ,
    //F2C ---> RING , RingRspOut
    output  logic         F2C_RspValidQ501H      ,
    output  logic  [9:0]  F2C_RspRequestorQ501H  ,     
    output  t_opcode      F2C_RspOpcodeQ501H     ,
    output  logic  [31:0] F2C_RspAddressQ501H    ,
    output  logic  [31:0] F2C_RspDataQ501H       ,
    //===================================
    // Ring Controler <-> Core Interface
    //===================================
    //F2C  ---> Core , F2C_ReqQ502H
    output  logic         F2C_ReqValidQ502H      ,
    output  t_opcode      F2C_ReqOpcodeQ502H     ,
    output  logic  [31:0] F2C_ReqAddressQ502H    ,
    output  logic  [31:0] F2C_ReqDataQ502H       ,
    //Core ---> F2C 
    input   logic         F2C_RspValidQ500H      ,
    input   t_opcode      F2C_RspOpcodeQ500H     ,
    input   logic  [31:0] F2C_RspAddressQ500H    ,
    input   logic  [31:0] F2C_RspDataQ500H        
);

//=========================================
//=====    Data Path Signals    ===========
//=========================================
// F2C BUFFER
logic   [F2C_MSB:0][9:0]  F2C_BufferRequestorQnnnH ;
logic   [F2C_MSB:0][31:0] F2C_BufferAddressQnnnH   ;
logic   [F2C_MSB:0][31:0] F2C_BufferDataQnnnH      ;
t_state                   F2C_BufferStateQnnnH  [F2C_MSB:0]   ;
logic   [F2C_MSB:0][9:0]  F2C_NextBufferRequestorQnnnH ;
logic   [F2C_MSB:0][31:0] F2C_NextBufferAddressQnnnH   ;
logic   [F2C_MSB:0][31:0] F2C_NextBufferDataQnnnH      ;
t_state                   F2C_NextBufferStateQnnnH   [F2C_MSB:0]  ;
//=========================================
//=====    Control Bits Signals   =========
//=========================================
// === F2C ===
logic [F2C_MSB:0]     F2C_EnAllocEntryQ501H ;
logic [F2C_MSB:0]     F2C_EnWrDataQnnnH     ;
logic [F2C_MSB:0]     F2C_SelDataSrcQnnnH   ;
// F2C data out
logic [F2C_ENC_MSB:0] F2C_SelRdRingQ501H    ;
logic [F2C_ENC_MSB:0] F2C_SelRdCoreQ502H    ;
// === FIXME description
logic [F2C_MSB:0]     F2C_FirstFreeEntryQ501H          ; 
logic [F2C_MSB:0]     F2C_FreeEntriesQ501H             ; 
logic [F2C_MSB:0]     F2C_RspMatchQ500H                ;  
// ==== init F2C MRO ==========
logic [F2C_MSB:0]     F2C_DeallocMroQnnnH ;
logic [F2C_MSB:0]     F2C_Mask0MroQnnnH   ;
logic [F2C_MSB:0]     F2C_Mask1MroQnnnH   ;
logic [F2C_MSB:0]     F2C_DecodedSelRdRingQ501H;
logic [F2C_MSB:0]     F2C_DecodedSelRdCoreQ502H;

//======================================================================================
//=========================     Module Content      ====================================
//======================================================================================
//==================================================================================
//              The F2C Buffer - Fabric 2 Core
//==================================================================================
always_comb begin : find_free_candidate_F2C
    for (int i=0 ; i< F2C_ENTRIESNUM ; i++) begin 
            F2C_FreeEntriesQ501H[i] = F2C_BufferStateQnnnH[i] == FREE ;  
    end // for
end // always_comb

`FIND_FIRST(F2C_FirstFreeEntryQ501H ,F2C_FreeEntriesQ501H)

always_comb begin : find_read_response_match_F2C
    for (int i=0 ; i < F2C_ENTRIESNUM ; i++ ) begin
            F2C_RspMatchQ500H[i] = ((F2C_RspAddressQ500H == F2C_BufferAddressQnnnH[i]) && 
                                    (F2C_BufferStateQnnnH[i] == READ_PRGRS)            &&
                                    (F2C_RspOpcodeQ500H == RD_RSP)                     &&
                                    (F2C_RspValidQ500H  == 1'b1)) ;
    end //for
end //always_comb


always_comb begin : check_if_request_from_the_ring_to_the_rc
    F2C_MatchIdQ501H = ((RingReqInValidQ501H)                 && 
                       (RingReqInOpcodeQ501H != RD_RSP)       &&
                       ((RingReqInAddressQ501H[31:24] == CoreID) || (RingReqInOpcodeQ501H == WR_BCAST )));
end // always_comb


always_comb begin : set_enalloc_f2c
    for (int i=0 ; i < F2C_ENTRIESNUM ; i++ ) begin
            F2C_EnAllocEntryQ501H[i]  = F2C_FirstFreeEntryQ501H[i] &&
                                        RingReqInValidQ501H        &&
                                        F2C_MatchIdQ501H ; 
    end //for
end //always_comb

always_comb begin : set_enwritedata_f2c
    for (int i=0 ; i < F2C_ENTRIESNUM ; i++ ) begin
            F2C_EnWrDataQnnnH[i]  = ( F2C_EnAllocEntryQ501H[i] ||
                                     (F2C_RspValidQ500H             && 
                                     (F2C_RspOpcodeQ500H == RD_RSP) &&
                                     F2C_RspMatchQ500H[i]           &&
                                     F2C_BufferStateQnnnH[i] == READ_PRGRS ) 
                                    ) ; 
    end //for
end //always_comb

always_comb begin : set_selector_data_src_mux_f2c
    for (int i=0 ; i < F2C_ENTRIESNUM ; i++ ) begin
            F2C_SelDataSrcQnnnH[i]  = F2C_EnAllocEntryQ501H[i];
    end // for
end // always_comb

// =================================
// ===== F2C Buffer State Machine =========
// =================================
always_comb begin : next_f2c_buffer_per_buffer_entry
    for(int i =0; i < F2C_ENTRIESNUM; i++) begin
        F2C_NextBufferStateQnnnH[i]     = F2C_BufferStateQnnnH[i] ; // default value for state machine .
        F2C_NextBufferRequestorQnnnH[i] = RingReqInRequestorQ501H;
        F2C_NextBufferAddressQnnnH[i]   = RingReqInAddressQ501H;
        F2C_NextBufferDataQnnnH[i]      = F2C_SelDataSrcQnnnH[i]   ? RingReqInDataQ501H  :  F2C_RspDataQ500H;
        case(F2C_BufferStateQnnnH[i])
        //Slot is FREE
            FREE :
                if (F2C_EnAllocEntryQ501H[i]) begin 
                F2C_NextBufferStateQnnnH[i] = (RingReqInOpcodeQ501H == RD)       ? READ  : 
                                              (RingReqInOpcodeQ501H == WR )      ? WRITE :
                                              (RingReqInOpcodeQ501H == WR_BCAST) ? WRITE :
                                                                                   FREE  ; // this should not occure.
                end
        //Slot is WRITE
            WRITE : 
                if (F2C_DecodedSelRdCoreQ502H[i] == 1'b1) begin
                    F2C_NextBufferStateQnnnH[i] =  FREE ;
                end // end if
        //Slot is READ
            READ :
                if (F2C_DecodedSelRdCoreQ502H[i] ==  1'b1)
                    F2C_NextBufferStateQnnnH[i] =  READ_PRGRS ;
        //Slot is READ PRGRS
            READ_PRGRS :            
                if (F2C_RspMatchQ500H[i])
                    F2C_NextBufferStateQnnnH[i] =  READ_RDY ;
        //Slot is READ_RDY
            READ_RDY :
                if ((F2C_DecodedSelRdRingQ501H[i] == 1'b1) && ( SelRingRspOutQ501H == F2C_RESPONSE)) begin 
                    F2C_NextBufferStateQnnnH[i] =  FREE ;
                end
            default  : F2C_NextBufferStateQnnnH[i] = F2C_BufferStateQnnnH[i];
        endcase
    end //for F2C_BUFFER_SIZE
end //always_comb
// =================================
// ==== F2C Buffer ================= 
// =================================
genvar F2C_ENTRY;
generate for ( F2C_ENTRY =0 ; F2C_ENTRY < F2C_ENTRIESNUM ; F2C_ENTRY++) begin : the_f2c_buffer_array
    `LOTR_RST_VAL_MSFF( F2C_BufferStateQnnnH    [F2C_ENTRY], F2C_NextBufferStateQnnnH    [F2C_ENTRY], QClk, RstQnnnH , FREE )
    `LOTR_EN_MSFF     ( F2C_BufferAddressQnnnH  [F2C_ENTRY], F2C_NextBufferAddressQnnnH  [F2C_ENTRY], QClk, F2C_EnAllocEntryQ501H[F2C_ENTRY])
    `LOTR_EN_MSFF     ( F2C_BufferRequestorQnnnH[F2C_ENTRY], F2C_NextBufferRequestorQnnnH[F2C_ENTRY], QClk, F2C_EnAllocEntryQ501H[F2C_ENTRY])
    `LOTR_EN_MSFF     ( F2C_BufferDataQnnnH     [F2C_ENTRY], F2C_NextBufferDataQnnnH     [F2C_ENTRY], QClk, F2C_EnWrDataQnnnH    [F2C_ENTRY])
end endgenerate // for , generate

// ==== init F2C MRO ==========
always_comb begin : create_mro_input_f2c
    for (int i =0 ; i <F2C_ENTRIESNUM ; i++ ) begin
        F2C_DeallocMroQnnnH[i] = (F2C_NextBufferStateQnnnH[i] == FREE);
        F2C_Mask0MroQnnnH[i]   = (F2C_BufferStateQnnnH[i]     == READ_RDY); 
        F2C_Mask1MroQnnnH[i]   = (F2C_BufferStateQnnnH[i]     == READ)  ||
                                 (F2C_BufferStateQnnnH[i]     == WRITE) ;
    end //for 
end //always_comb create_mro_input_f2c
mro #( .MRO_MSB(F2C_MSB) )
mro_F2C
(
     .Clk(QClk),
     .Rst(RstQnnnH),
     .EnAlloc((|F2C_EnAllocEntryQ501H)), //Review this
     .NextAlloc(F2C_EnAllocEntryQ501H),
     .Dealloc(F2C_DeallocMroQnnnH),
     .Mask0(F2C_Mask0MroQnnnH), // mask 0 for read response
     .Mask1(F2C_Mask1MroQnnnH), // mask 1 for all other commands  
     .Oldest0(F2C_DecodedSelRdRingQ501H),
     .Oldest1(F2C_DecodedSelRdCoreQ502H)
      ) ; 

`ONE_HOT_TO_ENC(F2C_SelRdRingQ501H , F2C_DecodedSelRdRingQ501H )
`ONE_HOT_TO_ENC(F2C_SelRdCoreQ502H , F2C_DecodedSelRdCoreQ502H )

always_comb begin : select_f2c_from_buffer
    // F2C_buferr -> Ring (Response)
    F2C_RspValidQ501H     = (F2C_BufferStateQnnnH    [F2C_SelRdRingQ501H] == READ_RDY) ; 
    F2C_RspOpcodeQ501H    = RD_RSP;
    F2C_RspAddressQ501H   = F2C_BufferAddressQnnnH   [F2C_SelRdRingQ501H] ; // NOTE: The 501 Cycle is due to the origin of the Request (CoreReqQ500H)
    F2C_RspDataQ501H      = F2C_BufferDataQnnnH      [F2C_SelRdRingQ501H] ;
    F2C_RspRequestorQ501H = F2C_BufferRequestorQnnnH [F2C_SelRdRingQ501H] ;

    // F2C_buffer -> Core (Request)
    F2C_ReqValidQ502H     = (F2C_BufferStateQnnnH     [F2C_SelRdCoreQ502H] == READ) || (F2C_BufferStateQnnnH [F2C_SelRdCoreQ502H] == WRITE) ;
    F2C_ReqOpcodeQ502H    = (F2C_BufferStateQnnnH     [F2C_SelRdCoreQ502H] == READ)  ? RD : 
                            (F2C_BufferStateQnnnH     [F2C_SelRdCoreQ502H] == WRITE) ? WR :RD ; // defualt value.
    F2C_ReqAddressQ502H   =  F2C_BufferAddressQnnnH   [F2C_SelRdCoreQ502H]; // Note: The 502 Cycle is due to the origin of the Response (RingInputQ500H->RingInputQ501H)
    F2C_ReqDataQ502H      =  F2C_BufferDataQnnnH      [F2C_SelRdCoreQ502H];
end //always_comb


endmodule // module f2c

