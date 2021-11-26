//-----------------------------------------------------------------------------
// Title            : RC - Ring Controller 
// Project          : LOTR: Lord-Of-The-Ring
//-----------------------------------------------------------------------------
// File             : c2f.sv 
// Original Author  : Amichai Ben-David
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
module c2f
    import lotr_pkg::*;  
    (
    //General Interface
    input   logic         QClk                   ,
    input   logic         RstQnnnH               ,
    input   logic  [7:0]  CoreID                 ,
    input   t_winner      SelRingReqOutQ501H     ,
    //===================================
    // Request Flow
    //===================================
    //Core ---> C2F
    input   logic         C2F_ReqValidQ500H      ,
    input   t_opcode      C2F_ReqOpcodeQ500H     ,
    input   logic  [31:0] C2F_ReqAddressQ500H    ,
    input   logic  [31:0] C2F_ReqDataQ500H       ,
    input   logic  [1:0]  C2F_ReqThreadIDQ500H   ,
    //F2C ---> RING , RingRspOut
    output  logic         C2F_ReqValidQ501H      ,
    output  logic  [9:0]  C2F_ReqRequestorQ501H  ,     
    output  t_opcode      C2F_ReqOpcodeQ501H     ,
    output  logic  [31:0] C2F_ReqAddressQ501H    ,
    output  logic  [31:0] C2F_ReqDataQ501H       ,
    //===================================
    // Response Flow
    //===================================
    //Ring ---> F2C , RingReqIn
    input   logic         RingRspInValidQ501H    ,
    input   logic  [9:0]  RingRspInRequestorQ501H,    
    input   t_opcode      RingRspInOpcodeQ501H   ,
    input   logic  [31:0] RingRspInAddressQ501H  ,
    input   logic  [31:0] RingRspInDataQ501H     ,
    //C2F ---> Core
    output  logic         C2F_RspValidQ502H      ,
    output  t_opcode      C2F_RspOpcodeQ502H     ,
    output  logic  [31:0] C2F_RspDataQ502H       ,
    output  logic         C2F_RspStall           ,
    output  logic  [1:0]  C2F_RspThreadIDQ502H   
);
//=====    Req Interface - not implemenntaed , related to C2F    ===========
logic  [1:0]  C2F_ReqThreadIdQ501H;

    
    
    
    
  
//=========================================
//=====    Data Path Signals    ===========
//=========================================
// C2F BUFFER
logic   [C2F_MSB:0][9:0]  C2F_BufferRequestorQnnnH ;
logic   [C2F_MSB:0][31:0] C2F_BufferAddressQnnnH   ;
logic   [C2F_MSB:0][31:0] C2F_BufferDataQnnnH      ;
t_state [C2F_MSB:0]       C2F_BufferStateQnnnH     ;
logic   [C2F_MSB:0][9:0]  C2F_NextBufferRequestorQnnnH ;
logic   [C2F_MSB:0][31:0] C2F_NextBufferAddressQnnnH   ;
logic   [C2F_MSB:0][31:0] C2F_NextBufferDataQnnnH      ;
t_state [C2F_MSB:0]       C2F_NextBufferStateQnnnH     ;
//=========================================
//=====    Control Bits Signals   =========
//=========================================
// === F2C ===
logic [C2F_MSB:0]     C2F_EnAllocEntryQ501H ;
logic [C2F_MSB:0]     C2F_EnWrDataQnnnH     ;
logic [C2F_MSB:0]     C2F_SelDataSrcQnnnH   ;
// F2C data out
logic [C2F_ENC_MSB:0] C2F_SelRdRingQ501H    ;
logic [C2F_ENC_MSB:0] C2F_SelRdCoreQ502H    ;
// === FIXME description
logic [C2F_MSB:0]     C2F_FirstFreeEntryQ501H          ; 
logic [C2F_MSB:0]     C2F_FreeEntriesQ501H             ; 
logic [C2F_MSB:0]     C2F_RspMatchQ500H                ;  
logic [C2F_MSB:0]     C2F_FirstReadResponseMatcesQ500H ; 
logic [C2F_MSB:0]     C2F_ResetValidQnnnH              ;
// ==== init C2F MRO ==========
logic [C2F_MSB:0]     C2F_DeallocMroQnnnH ;
logic [C2F_MSB:0]     C2F_Mask0MroQnnnH   ;
logic [C2F_MSB:0]     C2F_Mask1MroQnnnH   ;
logic [C2F_MSB:0]     C2F_DecodedSelRdRingQ501H;
logic [C2F_MSB:0]     C2F_DecodedSelRdCoreQ502H;

logic                 C2F_MatchIdQ501H ; 
logic                 C2F_RspValidQ501H    ;
t_opcode              C2F_RspOpcodeQ501H   ;
logic  [31:0]         C2F_RspDataQ501H     ;
logic  [1:0]          C2F_RspThreadIDQ501H ; 
logic                 RingRspValidMatchQ501H;
logic                 RequestorMatchIdQ501H;
//==================================================================================
//              The C2F Buffer - Core 2 Fabric
//==================================================================================
always_comb begin : find_free_candidate_F2C
    for (int i=0 ; i< C2F_ENTRIESNUM ; i++) begin 
            C2F_FreeEntriesQ501H[i] = C2F_BufferStateQnnnH[i] == FREE ;  
    end // for
end // always_comb

`FIND_FIRST(C2F_FirstFreeEntryQ501H ,C2F_FreeEntriesQ501H)

always_comb begin : find_read_response_match_C2F
    for (int i=0 ; i < C2F_ENTRIESNUM ; i++ ) begin
            C2F_RspMatchQ500H[i] = ((C2F_RspAddressQ500H == C2F_BufferAddressQnnnH[i]) && 
                                    (C2F_BufferStateQnnnH[i] == READ_PRGRS)            &&
                                    (C2F_ReqOpcodeQ500H == RD_RSP)                     &&
                                    (C2F_ReqValidQ500H  == 1'b1)) ;
    end //for
end //always_comb

// in case read respones matches to entry, we want one entry to alloc
    `FIND_FIRST(C2F_FirstReadResponseMatcesQ500H ,C2F_RspMatchQ500H)

always_comb begin : check_if_request_from_the_ring_to_the_rc
    C2F_MatchIdQ501H = ((RingReqInValidQ501H)                 && 
                       (RingReqInOpcodeQ501H != RD_RSP)       &&
                       ((RingReqInAddressQ501H[31:24] == CoreID) || (RingReqInOpcodeQ501H == WR_BCAST )));
end // always_comb


always_comb begin : set_enalloc_c2f
    for (int i=0 ; i < C2F_ENTRIESNUM ; i++ ) begin
            C2F_EnAllocEntryQ501H[i]  = C2F_FirstFreeEntryQ501H[i] &&
                                        RingReqInValidQ501H        &&
                                        C2F_MatchIdQ501H ; 
    end //for
end //always_comb

always_comb begin : set_enwritedata_c2f
    for (int i=0 ; i < C2F_ENTRIESNUM ; i++ ) begin
        C2F_EnWrDataQnnnH[i]  = ( C2F_EnAllocEntryQ501H[i] ||
                                (C2F_ReqValidQ500H             && 
                                (C2F_ReqOpcodeQ500H == RD_RSP) &&
                                 C2F_ReqMatchQ500H[i]           &&
                                 C2F_BufferStateQnnnH == READ_PRGRS ) 
                                ) ; 
    end //for
end //always_comb

always_comb begin : set_selector_data_src_mux_C2F
    for (int i=0 ; i < C2F_ENTRIESNUM ; i++ ) begin
        C2F_SelDataSrcQnnnH[i]  = C2F_EnAllocEntryQ501H[i];
    end // for
end // always_comb

  
    
    
// ===== C2F Buffer Input =========
assign C2F_EnCoreWrQ500H = C2F_FirstFreeEntryQ500H & C2F_IsValidReqQ500H ;
assign C2F_EnRingWrQ501H = C2F_FirstReadResponseMatchesQ501H  ; 
logic [C2F_MSB:0] C2F_ResetValidQnnnH ;

always_comb begin : next_c2f_buffer_per_buffer_entry
    C2F_EnWrQnnnH           = C2F_EnCoreWrQ500H | C2F_EnRingWrQ501H;
    C2F_SelWrQnnnH          = C2F_EnCoreWrQ500H;
    C2F_NextBufferStateQnnnH= C2F_BufferStateQnnnH ; // default value for state machine 
    RingInputValidQ501H     = PreRingInputValidQ501H;
    C2F_ResetValidQnnnH = '0 ; 
    for(int i =0; i < C2F_ENTRIESNUM; i++) begin
        C2F_NextBufferOpcodeQnnnH[i]   = C2F_SelWrQnnnH[i] ? C2F_ReqOpcodeQ500H   : RingInputOpcodeQ501H ;
        C2F_NextBufferThreadIDQnnnH[i] = C2F_SelWrQnnnH[i] ? C2F_ReqThreadIDQ500H : C2F_BufferThreadIDQnnnH[i] ;
        C2F_NextBufferAddressQnnnH[i]  = C2F_SelWrQnnnH[i] ? C2F_ReqAddressQ500H  : RingInputAddressQ501H ;
        C2F_NextBufferDataQnnnH[i]     = C2F_SelWrQnnnH[i] ? C2F_ReqDataQ500H     : RingInputDataQ501H   ;
        state = C2F_BufferStateQnnnH[i]; 
        case(state)
            //Slot is FREE
            FREE : 
                    C2F_NextBufferStateQnnnH[i] =  (C2F_NextBufferOpcodeQnnnH[i] == RD)       ? READ        :
                                                   (C2F_NextBufferOpcodeQnnnH[i] == WR)       ? WRITE       :
                                                   (C2F_NextBufferOpcodeQnnnH[i] == WR_BCAST) ? WRITE_BCAST :
                                                                                                FREE        ; 
            //Slot is WRITE
            WRITE : // FIXME  if there is enable for the mux buffer exit .add it to the if .
                    // if the C2F out mux choose this entry , and out mux passing C2F_req
                if (C2F_DecodedSelRdRingQ501H[i] == 1'b1 && (SelRingReqOutQ501H == C2F_REQUEST ))begin
                        C2F_NextBufferStateQnnnH[i] =  FREE ;
                        C2F_ResetValidQnnnH[i] = 1'b1; 
                        end //if 

            //Slot is READ
            READ :// FIXME  if there is enable for the mux buffer exit .add it to the if .
                    // if the C2F out mux choose this entry , and out mux passing C2F_req
                    if (C2F_DecodedSelRdRingQ501H[i] == 1'b1  && (SelRingOutQ501H == C2F_REQUEST ))
                        C2F_NextBufferStateQnnnH[i] =  READ_PRGRS ;

            //Slot is READ PRGRS
            READ_PRGRS :// FIXME  if there is enable from the core , indicates for new command from it.
                    if (( C2F_NextBufferOpcodeQnnnH[i] == RD_RSP) && (C2F_NextBufferAddressQnnnH[i] == C2F_BufferAddressQnnnH[i] )) begin
                        C2F_NextBufferStateQnnnH[i] =  READ_RDY ;
                      //  MatchReadResponseQ501H[i]   =  1'b1 ; 
                    end //if 
            //Slot is READ_RDY
            READ_RDY :// FIXME  if there is enable for the mux buffer exit towared the core
                    if ( C2F_DecodedSelRdRingQ501H[i] == 1'b1 ) begin
                        C2F_NextBufferStateQnnnH[i] =  FREE ;
                        C2F_ResetValidQnnnH[i] = 1'b1; 
                    end //if                         

            //Slot is WRITE BCAST
            WRITE_BCAST :// FIXME  if there is enable for the mux buffer exit
                    if (C2F_DecodedSelRdRingQ501H[i] == 1'b1 && (SelRingOutQ501H == C2F_REQUEST ))
                        C2F_NextBufferStateQnnnH[i] =  WRITE_BCAST_PRGRS ;

            //Slot is WRITE BCAST PRGRS
            WRITE_BCAST_PRGRS :// FIXME  if there is enable for the mux buffer exit
                    if (( RingInputOpcodeQ501H == WR_BCAST ) &&  ( C2F_BufferAddressQnnnH[i] == RingInputAddressQ501H ))begin
                        C2F_NextBufferStateQnnnH[i] =  FREE ;
                        RingInputValidQ501H = 1'b0;
                        C2F_ResetValidQnnnH[i] = 1'b1;                         
                       // MatchWriteBroadCastQ501H[i] = 1'b1 ;
                    end //if
        endcase
        // this set is after the FSM , because RingInputValidQ501H can be changed during the FSM . so we want to hold the correct value . 
        C2F_NextBufferValidQnnnH[i]    = C2F_SelWrQnnnH[i] ? C2F_ReqValidQ500H    : RingInputValidQ501H ;
    end //for C2F_BUFFER_SIZE
end //always_comb

    
    
    
    
   
    
    
   // ==== C2F Buffer =================
genvar C2F_ENTRY;
generate for ( C2F_ENTRY =0 ; C2F_ENTRY < C2F_ENTRIESNUM ; C2F_ENTRY++) begin : the_c2f_buffer_array
    `LOTR_EN_RST_MSFF      ( C2F_BufferValidQnnnH   [C2F_ENTRY], C2F_NextBufferValidQnnnH   [C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY], RstQnnnH || C2F_ResetValidQnnnH[C2F_ENTRY] )
    `LOTR_EN_MSFF          ( C2F_BufferOpcodeQnnnH  [C2F_ENTRY], C2F_NextBufferOpcodeQnnnH  [C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY])
    `LOTR_EN_MSFF          ( C2F_BufferThreadIDQnnnH[C2F_ENTRY], C2F_NextBufferThreadIDQnnnH[C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY])
    `LOTR_EN_MSFF          ( C2F_BufferAddressQnnnH [C2F_ENTRY], C2F_NextBufferAddressQnnnH [C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY])
    `LOTR_EN_MSFF          ( C2F_BufferDataQnnnH    [C2F_ENTRY], C2F_NextBufferDataQnnnH    [C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY])
    `LOTR_RST_VAL_MSFF     ( C2F_BufferStateQnnnH   [C2F_ENTRY], C2F_NextBufferStateQnnnH   [C2F_ENTRY], QClk, RstQnnnH , FREE )
end endgenerate // for , generate


// ==== init C2F MRO ==========
always_comb begin : create_mro_input
    for (int i =0 ; i <C2F_ENTRIESNUM ; i++ ) begin
        C2F_DeallocMroQnnnH[i] = (C2F_NextBufferStateQnnnH[i] == FREE);
        C2F_Mask0MroQnnnH[i]   = (C2F_BufferStateQnnnH[i]     == READ_RDY); 
        C2F_Mask1MroQnnnH[i]   = (C2F_BufferStateQnnnH[i]     == READ )      ||
                                 (C2F_BufferStateQnnnH[i]     == WRITE)      ||
                                 (C2F_BufferStateQnnnH[i]     == WRITE_BCAST );
    end //for 
end //always_comb create_mro_input

mro #(.MRO_MSB(C2F_MSB) )
mro_C2F (
     .Clk(QClk),
     .Rst(RstQnnnH),
     .EnAlloc(|(C2F_EnCoreWrQ500H)),
     .NextAlloc(C2F_EnCoreWrQ500H),
     .Dealloc(C2F_DeallocMroQnnnH),
     .Mask0(C2F_Mask0MroQnnnH), // mask 0 for read response
     .Mask1(C2F_Mask1MroQnnnH), // mask 1 for all other commands  
     .Oldest0(C2F_DecodedSelRdCoreQ502H),
     .Oldest1(C2F_DecodedSelRdRingQ501H)
      ) ; 
`ONE_HOT_TO_ENC(C2F_SelRdCoreQ502H , C2F_DecodedSelRdCoreQ502H)
`ONE_HOT_TO_ENC(C2F_SelRdRingQ501H , C2F_DecodedSelRdRingQ501H)

always_comb begin : select_C2F_from_buffer
    // C2F_buferr -> Ring (Request)
    C2F_ReqValidQ501H   = C2F_BufferValidQnnnH  [C2F_SelRdRingQ501H];
    C2F_ReqOpcodeQ501H  = C2F_BufferOpcodeQnnnH [C2F_SelRdRingQ501H];
    C2F_ReqAddressQ501H = C2F_BufferAddressQnnnH[C2F_SelRdRingQ501H]; // NOTE: The 501 Cycle is due to the origin of the Request (CoreReqQ500H)
    C2F_ReqDataQ501H    = C2F_BufferDataQnnnH   [C2F_SelRdRingQ501H];
    // C2F_buffer -> Core (Response)
    // C2F_RspAddressQ502H = C2F_BufferAddressQnnnH[C2F_SelRdCoreQ502H]; // Note: The 502 Cycle is due to the origin of the Response (RingInputQ500H->RingInputQ501H)
    C2F_RspDataQ502H    = C2F_BufferDataQnnnH    [C2F_SelRdCoreQ502H];
    C2F_RspThreadIDQ502H= C2F_BufferThreadIDQnnnH[C2F_SelRdCoreQ502H];
end //always_comb
    
// ==== stall signal logic ==========
logic [C2F_MSB:0] StallHelper = 0 ; 
always_comb begin : raise_stall_signal
    for (int i=0 ; i< C2F_ENTRIESNUM ;i++) begin
          StallHelper[i]= (C2F_BufferStateQnnnH[i] == FREE ) ; 
    end //for
end //always_comb

assign C2F_RspStallQnnnH =  !(|(StallHelper[C2F_MSB:0])); 
    
    
    
    
    
    
    
    
    
`LOTR_RST_MSFF( C2F_ReqValidQ501H, C2F_ReqValidQ500H   , QClk ,RstQnnnH)
`LOTR_MSFF( C2F_ReqOpcodeQ501H   , C2F_ReqOpcodeQ500H  , QClk )
`LOTR_MSFF( C2F_ReqAddressQ501H  , C2F_ReqAddressQ500H , QClk )
`LOTR_MSFF( C2F_ReqDataQ501H     , C2F_ReqDataQ500H    , QClk )
`LOTR_MSFF( C2F_ReqRequestorQ501H , {CoreID,C2F_ReqThreadIDQ500H}, QClk )
//==========================================================================
//FIXME - temporary until the C2F BUFFER will be ready:

assign C2F_RspStall             = '0;

`LOTR_MSFF( C2F_RspValidQ502H     , C2F_RspValidQ501H    , QClk )
`LOTR_MSFF( C2F_RspOpcodeQ502H    , C2F_RspOpcodeQ501H    , QClk )
`LOTR_MSFF( C2F_RspDataQ502H      , C2F_RspDataQ501H     , QClk )
`LOTR_MSFF( C2F_RspThreadIDQ502H  , C2F_RspThreadIDQ501H , QClk )

endmodule // module c2f

