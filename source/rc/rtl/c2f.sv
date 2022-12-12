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
    input   logic  [9:0]  C2F_ReqRequestorQ500H  ,
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
    output  logic  [9:0]  C2F_RspRequestorQ502H  ,
    // Incase of brodcast:
    input   logic         RingReqInValidQ501H    ,
    input   logic  [9:0]  RingReqInRequestorQ501H,
    input   t_opcode      RingReqInOpcodeQ501H   ,
    input   logic  [31:0] RingReqInAddressQ501H  

);
//=========================================
//=====    Data Path Signals    ===========
//=========================================
// C2F BUFFER
logic   [C2F_MSB:0][9:0]  C2F_BufferRequestorQnnnH ;
logic   [C2F_MSB:0][31:0] C2F_BufferAddressQnnnH   ;
logic   [C2F_MSB:0][31:0] C2F_BufferDataQnnnH      ;
t_state                   C2F_BufferStateQnnnH [C2F_MSB:0]  ;
logic   [C2F_MSB:0][9:0]  C2F_NextBufferRequestorQnnnH ;
logic   [C2F_MSB:0][31:0] C2F_NextBufferAddressQnnnH   ;
logic   [C2F_MSB:0][31:0] C2F_NextBufferDataQnnnH      ;
t_state                   C2F_NextBufferStateQnnnH [C2F_MSB:0]   ;
//=========================================
//=====    Control Bits Signals   =========
//=========================================
// === F2C ===
logic [C2F_MSB:0]     C2F_EnAllocEntryQ501H ;
logic [C2F_MSB:0]     C2F_SelDataSrcQnnnH   ;
// F2C data out
logic [C2F_ENC_MSB:0] C2F_Sel2RingQ501H    ;
logic [C2F_ENC_MSB:0] C2F_Sel2CoreQ502H    ;
// === FIXME description
logic [C2F_MSB:0]     C2F_FirstFreeEntryQ501H          ; 
logic [C2F_MSB:0]     C2F_FreeEntriesQ501H             ; 
logic [C2F_MSB:0]     C2F_RspMatchQ500H                ;  
logic [C2F_MSB:0]     C2F_FirstReadResponseMatcesQ500H ; 
// ==== init C2F MRO ==========
logic [C2F_MSB:0]     C2F_DeallocMroQnnnH ;
logic [C2F_MSB:0]     C2F_Mask0MroQnnnH   ;
logic [C2F_MSB:0]     C2F_Mask1MroQnnnH   ;
logic [C2F_MSB:0]     C2F_DecodedSel2RingQ501H;
logic [C2F_MSB:0]     C2F_DecodedSel2CoreQ502H;

logic                 C2F_RspValidQ501H    ;
t_opcode              C2F_RspOpcodeQ501H   ;
logic  [31:0]         C2F_RspDataQ501H     ;
logic                 RingRspValidMatchQ501H;
logic                 RequestorMatchIdQ501H;

//======================================================================================
//=========================     Module Content      ====================================
//======================================================================================
//==================================================================================
//              The C2F Buffer - Core 2 Fabric
//==================================================================================
logic [3:0] C2F_FreeEntriesQ500H;
logic [3:0] C2F_FirstFreeEntryQ500H;
logic [3:0] C2F_RspMatchQ501H;
logic [3:0] C2F_EnAllocEntryQ500H;
logic [3:0] C2F_EnRingWrQ501H;
logic [3:0] C2F_EnCoreWrQ500H;
logic [3:0] C2F_EnWrQnnnH;
logic [3:0] C2F_SelWrQnnnH;

always_comb begin : find_free_candidate_F2C
    for (int i=0 ; i< C2F_ENTRIESNUM ; i++) begin 
            C2F_FreeEntriesQ500H[i] = C2F_BufferStateQnnnH[i] == FREE ;  
    end // for
end // always_comb
`FIND_FIRST(C2F_FirstFreeEntryQ500H ,C2F_FreeEntriesQ500H)

always_comb begin : find_read_response_match_C2F
    for (int i=0 ; i < C2F_ENTRIESNUM ; i++ ) begin
            C2F_RspMatchQ501H[i] = ((RingRspInAddressQ501H   == C2F_BufferAddressQnnnH[i]   ) &&
                                    (READ_PRGRS              == C2F_BufferStateQnnnH[i]     ) &&
                                    (RingRspInRequestorQ501H == C2F_BufferRequestorQnnnH[i] ) &&
                                    (RingRspInOpcodeQ501H    == RD_RSP)                       &&
                                    (RingRspInValidQ501H     == 1'b1)) ;
    end //for
end //always_comb

always_comb begin : set_enalloc_c2f
    for (int i=0 ; i < C2F_ENTRIESNUM ; i++ ) begin
        C2F_EnAllocEntryQ500H[i] = C2F_FirstFreeEntryQ500H[i] && C2F_ReqValidQ500H;
    end //for
end //always_comb


// ===== C2F Buffer Input =========
assign C2F_EnRingWrQ501H = C2F_RspMatchQ501H; 
assign C2F_EnCoreWrQ500H = C2F_EnAllocEntryQ500H;
assign C2F_EnWrQnnnH     = C2F_EnCoreWrQ500H | C2F_EnRingWrQ501H;
assign C2F_SelWrQnnnH    = C2F_EnCoreWrQ500H;

always_comb begin : next_c2f_buffer_per_buffer_entry
    for(int i =0; i < C2F_ENTRIESNUM; i++) begin
        C2F_NextBufferStateQnnnH[i]     = C2F_BufferStateQnnnH[i] ; // default value for state machine 
        C2F_NextBufferRequestorQnnnH[i] = C2F_ReqRequestorQ500H;
        C2F_NextBufferAddressQnnnH[i]   = C2F_ReqAddressQ500H;
        C2F_NextBufferDataQnnnH[i]      = C2F_SelWrQnnnH[i] ? C2F_ReqDataQ500H : RingRspInDataQ501H;
        case(C2F_BufferStateQnnnH[i])
            //Slot is FREE
            FREE :  
            if( C2F_EnAllocEntryQ500H[i] ) begin
                C2F_NextBufferStateQnnnH[i] =  (C2F_ReqOpcodeQ500H == RD)       ? READ        :
                                               (C2F_ReqOpcodeQ500H == WR)       ? WRITE       :
                                               (C2F_ReqOpcodeQ500H == WR_BCAST) ? WRITE_BCAST :
                                                                                  FREE        ; 
            end
            //Slot is WRITE
            WRITE :
                if (C2F_DecodedSel2RingQ501H[i] && (SelRingReqOutQ501H == C2F_REQUEST ))begin
                        C2F_NextBufferStateQnnnH[i] =  FREE ;
                end //if 
            //Slot is WRITE BCAST
            WRITE_BCAST :
                if (C2F_DecodedSel2RingQ501H[i] == 1'b1 && (SelRingReqOutQ501H == C2F_REQUEST )) begin
                    C2F_NextBufferStateQnnnH[i] =  WRITE_BCAST_PRGRS ;
                end
            //Slot is READ
            READ :
                // if the C2F out mux choose this entry , and out mux passing C2F_req
                if (C2F_DecodedSel2RingQ501H[i] && (SelRingReqOutQ501H == C2F_REQUEST ))begin
                    C2F_NextBufferStateQnnnH[i] =  READ_PRGRS ;
                end
            //Slot is READ PRGRS
            READ_PRGRS :
                if (C2F_RspMatchQ501H) begin
                    C2F_NextBufferStateQnnnH[i] =  READ_RDY ;
                end //if 
            //Slot is READ_RDY
            READ_RDY :
                if (C2F_DecodedSel2CoreQ502H[i]) begin
                    C2F_NextBufferStateQnnnH[i] = FREE ;
                end //if                         
            //Slot is WRITE BCAST PRGRS
            WRITE_BCAST_PRGRS ://NOTE - must look at the request Channel!! (not the Rsp Channel)
                if (( RingReqInOpcodeQ501H    == WR_BCAST                   ) &&  
                    ( RingReqInAddressQ501H   == C2F_BufferAddressQnnnH[i]  ) &&
                    ( RingReqInRequestorQ501H == C2F_BufferRequestorQnnnH[i]) &&
                    ( RingReqInValidQ501H                                   )) begin
                    C2F_NextBufferStateQnnnH[i] =  FREE ;
                end //if
            default  : C2F_NextBufferStateQnnnH = C2F_BufferStateQnnnH;
        endcase
    end //for C2F_BUFFER_SIZE
end //always_comb

// ==== C2F Buffer =================
genvar C2F_ENTRY;
generate for ( C2F_ENTRY =0 ; C2F_ENTRY < C2F_ENTRIESNUM ; C2F_ENTRY++) begin : the_c2f_buffer_array
    `LOTR_RST_VAL_MSFF     ( C2F_BufferStateQnnnH    [C2F_ENTRY], C2F_NextBufferStateQnnnH    [C2F_ENTRY], QClk, RstQnnnH , FREE )
    `LOTR_EN_MSFF          ( C2F_BufferAddressQnnnH  [C2F_ENTRY], C2F_NextBufferAddressQnnnH  [C2F_ENTRY], QClk, C2F_EnAllocEntryQ500H[C2F_ENTRY])
    `LOTR_EN_MSFF          ( C2F_BufferRequestorQnnnH[C2F_ENTRY], C2F_NextBufferRequestorQnnnH[C2F_ENTRY], QClk, C2F_EnAllocEntryQ500H[C2F_ENTRY])
    `LOTR_EN_MSFF          ( C2F_BufferDataQnnnH     [C2F_ENTRY], C2F_NextBufferDataQnnnH     [C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY])
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
     .Oldest0(C2F_DecodedSel2CoreQ502H),
     .Oldest1(C2F_DecodedSel2RingQ501H)
      ) ; 
`ONE_HOT_TO_ENC(C2F_Sel2CoreQ502H , C2F_DecodedSel2CoreQ502H)
`ONE_HOT_TO_ENC(C2F_Sel2RingQ501H , C2F_DecodedSel2RingQ501H)

always_comb begin : select_C2F_from_buffer
    // C2F_buferr -> Ring (Request)
    C2F_ReqValidQ501H     = (C2F_BufferStateQnnnH    [C2F_Sel2RingQ501H] == READ)        ||
                            (C2F_BufferStateQnnnH    [C2F_Sel2RingQ501H] == WRITE)       ||
                            (C2F_BufferStateQnnnH    [C2F_Sel2RingQ501H] == WRITE_BCAST) ;
    C2F_ReqOpcodeQ501H    = (C2F_BufferStateQnnnH    [C2F_Sel2RingQ501H] == READ)        ? RD        :
                            (C2F_BufferStateQnnnH    [C2F_Sel2RingQ501H] == WRITE)       ? WR        :
                            (C2F_BufferStateQnnnH    [C2F_Sel2RingQ501H] == WRITE_BCAST) ? WR_BCAST  : WR_BCAST;
    C2F_ReqAddressQ501H   =  C2F_BufferAddressQnnnH  [C2F_Sel2RingQ501H];
    C2F_ReqDataQ501H      =  C2F_BufferDataQnnnH     [C2F_Sel2RingQ501H];
    C2F_ReqRequestorQ501H =  C2F_BufferRequestorQnnnH[C2F_Sel2RingQ501H];
    // C2F_buffer -> Core (Response)
    C2F_RspValidQ502H     = (C2F_BufferStateQnnnH    [C2F_Sel2CoreQ502H] == READ_RDY);
    C2F_RspOpcodeQ502H    =  RD_RSP;
    C2F_RspDataQ502H      =  C2F_BufferDataQnnnH     [C2F_Sel2CoreQ502H];
    C2F_RspRequestorQ502H =  C2F_BufferRequestorQnnnH[C2F_Sel2CoreQ502H];
end //always_comb
    
// ==== stall signal logic ==========
logic [C2F_MSB:0] StallHelper; 
always_comb begin : raise_stall_signal
    StallHelper = 0 ;
    for (int i=0 ; i< C2F_ENTRIESNUM ;i++) begin
          StallHelper[i]= (C2F_BufferStateQnnnH[i] == FREE ) ; 
    end //for
end //always_comb

assign  C2F_RspStall =  !(|(StallHelper[C2F_MSB:0])); 
    
endmodule // module c2f

