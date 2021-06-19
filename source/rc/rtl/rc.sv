//-----------------------------------------------------------------------------
// Title            : RC - Ring Controller 
// Project          : LOTR: Lord-Of-The-Ring
//-----------------------------------------------------------------------------
// File             : rc.sv 
// Original Author  : Tzahi Peretz, Shimi Haleluya 
// Created          : 5/2021
//-----------------------------------------------------------------------------
// Description :
// 
//
// 
//------------------------------------------------------------------------------
// Modification history :
//
//
//------------------------------------------------------------------------------
`include "/users/eptzsh/Project/LOTR/riscv-multi-core-lotr/source/rc/rtl/design/lotr_defines.sv"
`include "/users/eptzsh/Project/LOTR/riscv-multi-core-lotr/source/rc/rtl/design/mro.sv"
    
module rc
(
    //General Interface
    input   logic         QClk                   ,
    input   logic         RstQnnnH               ,
    input   logic  [7:0]  coreID                 ,
    
    //Ring ---> RC
    input   logic         RingInputValidQ500H    ,
    input   logic  [1:0]  RingInputOpcodeQ500H   ,
    input   logic  [31:0] RingInputAddressQ500H  ,
    input   logic  [31:0] RingInputDataQ500H     ,
    //RC   ---> Ring
    output  logic         RingOutputValidQ502H   ,
    output  logic  [1:0]  RingOutputOpcodeQ502H  ,
    output  logic  [31:0] RingOutputAddressQ502H ,
    output  logic  [31:0] RingOutputDataQ502H    ,
    
    //Core Req/Rsp <---> RC
    input   logic         C2F_ReqValidQ500H      ,
    input   logic  [1:0]  C2F_ReqOpcodeQ500H     ,
    input   logic  [1:0]  C2F_ReqThreadIDQ500H   ,
    input   logic  [31:0] C2F_ReqAddressQ500H    ,
    input   logic  [31:0] C2F_ReqDataQ500H       ,

    output   logic        C2F_RspValidQ502H      ,
    output   logic [1:0]  C2F_RspThreadIDQ502H   ,
    output   logic [31:0] C2F_RspDataQ502H       ,
    output   logic        C2F_RspStall           ,
    
    //RC   Req/Rsp <---> Core
    input   logic         F2C_RspValidQ500H      ,
    input   logic  [1:0]  F2C_RspOpcodeQ500H     , // Fixme -  not sure neccesery - the core recieve on;y read responses
    input   logic  [31:0] F2C_RspAddressQ500H    ,
    input   logic  [31:0] F2C_RspDataQ500H       ,
    
    output  logic         F2C_ReqValidQ502H      ,
    output  logic  [1:0]  F2C_ReqOpcodeQ502H     ,
    output  logic  [31:0] F2C_ReqAddressQ502H    ,
    output  logic  [31:0] F2C_ReqDataQ502H 
);

//=========================================
//============    enum    =================
//=========================================
// States : FREE '000' , WRITE '001' , READ '010' , READ_PRGRS '011' , READ_RDY '100'
//          WRITE_BCAST '101' , WRITE_BCAST_PRGRS '110'
// Opcodes : Command type - RD=00 , RD_RSP=01 ,WR=10 , WR_BCAST=11

enum logic [1:0] {RD=2'b00 , RD_RSP= 2'b01 ,WR=2'b10 , WR_BCAST=2'b11 } opcode ;
enum logic [2:0] {FREE=3'b000 ,WRITE=3'b001 ,READ=3'b010 ,READ_PRGRS=3'b011 ,READ_RDY=3'b100,WRITE_BCAST =3'b101,WRITE_BCAST_PRGRS =3'b110 ,ERROR=3'b111} state; 
enum logic [1:0] {NOP=0 , RingInput=1 ,F2CResponse=2 , C2FRequest=3 } WINNER ;

//=========================================
//=========    Parameters    ==============
//=========================================
parameter C2F_EntriesNum = 4                      ; 
parameter C2F_MSB = C2F_EntriesNum -1             ;
parameter C2F_ENC_MSB = $clog2(C2F_EntriesNum)-1  ; 

parameter F2C_EntriesNum = 4                      ; 
parameter F2C_MSB = F2C_EntriesNum -1             ;
parameter F2C_ENC_MSB = $clog2(F2C_EntriesNum)-1  ;


//=========================================
//=====    Data Path Signals    ===========
//=========================================
// Ring Interface
logic                   RingInputValidQ501H     ;
logic [1:0]             RingInputOpcodeQ501H    ; // try to declare enum style
logic [31:0]            RingInputAddressQ501H   ;
logic [31:0]            RingInputDataQ501H      ;

logic                   RingOutputValidQ501H    ;
logic [1:0]             RingOutputOpcodeQ501H   ;
logic [31:0]            RingOutputAddressQ501H  ;
logic [31:0]            RingOutputDataQ501H     ;


logic [C2F_MSB:0]       C2F_BufferValidQnnnH    ;
logic [C2F_MSB:0][1:0]  C2F_BufferOpcodeQnnnH   ;
logic [C2F_MSB:0][1:0]  C2F_BufferThreadIDQnnnH ;
logic [C2F_MSB:0][31:0] C2F_BufferAddressQnnnH  ;
logic [C2F_MSB:0][31:0] C2F_BufferDataQnnnH     ;
logic [C2F_MSB:0][2:0]  C2F_BufferStateQnnnH    ;

logic [C2F_MSB:0]       C2F_NextBufferValidQnnnH     ;
logic [C2F_MSB:0][1:0]  C2F_NextBufferOpcodeQnnnH    ;
logic [C2F_MSB:0][1:0]  C2F_NextBufferThreadIDQnnnH  ;
logic [C2F_MSB:0][31:0] C2F_NextBufferAddressQnnnH   ;
logic [C2F_MSB:0][31:0] C2F_NextBufferDataQnnnH      ;
logic [C2F_MSB:0][2:0]  C2F_NextBufferStateQnnnH     ;


logic                   C2F_ReqValidQ501H       ;
logic [1:0]             C2F_ReqOpcodeQ501H      ;
logic [31:0]            C2F_ReqAddressQ501H     ;
logic [31:0]            C2F_ReqDataQ501H        ;


// F2C BUFFER
logic [F2C_MSB:0]       F2C_BufferValidQnnnH    ;
logic [F2C_MSB:0][1:0]  F2C_BufferOpcodeQnnnH   ;
logic [F2C_MSB:0][31:0] F2C_BufferAddressQnnnH  ;
logic [F2C_MSB:0][31:0] F2C_BufferDataQnnnH     ;
logic [F2C_MSB:0][2:0]  F2C_BufferStateQnnnH    ;

logic [F2C_MSB:0]       F2C_NextBufferValidQnnnH    ;
logic [F2C_MSB:0][1:0]  F2C_NextBufferOpcodeQnnnH   ;
logic [F2C_MSB:0][31:0] F2C_NextBufferAddressQnnnH  ;
logic [F2C_MSB:0][31:0] F2C_NextBufferDataQnnnH     ;
logic [F2C_MSB:0][2:0]  F2C_NextBufferStateQnnnH    ;

logic                   F2C_RspValidQ501H     ;
logic [1:0]             F2C_RspOpcodeQ501H    ;
logic [31:0]            F2C_RspAddressQ501H   ;
logic [31:0]            F2C_RspDataQ501H      ;


//=========================================
//=====    Control Bits Signals   =========
//=========================================
// === General ===
logic [1:0]       SelRingOutQ501H ;
logic AddressComprasionFlag       ; 

// === C2F ===
logic [C2F_ENC_MSB:0] C2F_SelRdRingQ501H    ;
logic [C2F_ENC_MSB:0] C2F_SelRdCoreQ502H    ;
logic [C2F_MSB:0]     C2F_EnRingWrQ501H     ;
logic [C2F_MSB:0]     C2F_EnCoreWrQ500H     ; 
logic [C2F_MSB:0]     C2F_EnWrQnnnH         ;
logic [C2F_MSB:0]     C2F_SelWrQnnnH        ;

// === F2C ===
logic [F2C_ENC_MSB:0] F2C_SelRdRingQ501H    ;
logic [F2C_ENC_MSB:0] F2C_SelRdCoreQ502H    ;
logic [F2C_MSB:0]     F2C_EnRingWrQ501H     ;
logic [F2C_MSB:0]     F2C_EnCoreWrQ500H     ;
logic [F2C_MSB:0]     F2C_EnWrQnnnH         ;
logic [F2C_MSB:0]     F2C_SelWrQnnnH        ;


//======================================================================================
//=========================     Module Content      ====================================
//======================================================================================
//  TODO - add discription of this module structure and blockes
//
//======================================================================================

//=========================================
// Ring input Interface
//=========================================

`LOTR_MSFF( RingInputValidQ501H   , RingInputValidQ500H  , QClk )
`LOTR_MSFF( RingInputOpcodeQ501H ,  RingInputOpcodeQ500H , QClk )
`LOTR_MSFF( RingInputAddressQ501H,  RingInputAddressQ500H, QClk )
`LOTR_MSFF( RingInputDataQ501H   ,  RingInputDataQ500H   , QClk )


//==================================================================================
//              The C2F Buffer - Core 2 Fabric
//==================================================================================
//  TODO - add description of this block
//  only read responses aredont coming from the ring input, therefore if read response arrives from the
//   rinrg ,we  need to update the next buffer data only .
// but if command (read/write) comes from the core , we need to update all
// the next buffers(data,adress, thredid ...)
//==================================================================================

logic [C2F_MSB:0] C2F_FirstFreeEntry                     ; 
logic [C2F_MSB:0] C2F_FreeEntries                        ; 
logic [C2F_MSB:0] C2F_ReadResponseMatchesQ501H           ; 
logic [C2F_MSB:0] C2F_FirstReadResponseMatchesQ501H      ; 
logic [C2F_MSB:0] C2F_IsValidReq                         ;

always_comb begin : find_free_candidate
    for (int i=0 ; i< C2F_EntriesNum ; i++) begin 
            C2F_FreeEntries[i] = C2F_BufferStateQnnnH[i] == FREE ;  
    end // for
end // always_comb find_free_candidate

`FIND_FIRST(C2F_FirstFreeEntry ,C2F_FreeEntries)

always_comb begin : check_isValidReq_from_core_to_C2F
    if (C2F_ReqValidQ500H && C2F_ReqOpcodeQ500H != RD_RSP && C2F_ReqAddressQ500H[31:24] != coreID  )
        C2F_IsValidReq = '1 ; 
    else 
        C2F_IsValidReq = '0 ; 
end // always_comb

always_comb begin : find_read_response_match    
    for (int i=0 ; i < C2F_EntriesNum ; i++ ) begin
        if ((RingInputAddressQ501H == C2F_BufferAddressQnnnH[i]) && (C2F_BufferStateQnnnH[i] == READ_PRGRS))
            C2F_ReadResponseMatchesQ501H[i] = 1'b1 ;  
        else
            C2F_ReadResponseMatchesQ501H[i] = 1'b0 ;  
    end
end
// in case read response matches to entry, we want one entry to alloc
`FIND_FIRST(C2F_FirstReadResponseMatchesQ501H ,C2F_ReadResponseMatchesQ501H)

// ===== C2F Buffer Input =========
assign C2F_EnCoreWrQ500H = C2F_FirstFreeEntry & C2F_IsValidReq ;
assign C2F_EnRingWrQ501H = C2F_FirstReadResponseMatchesQ501H  ; 

always_comb begin : next_c2f_buffer_per_buffer_entry
    C2F_EnWrQnnnH   = C2F_EnCoreWrQ500H | C2F_EnRingWrQ501H;
    C2F_SelWrQnnnH  = C2F_EnCoreWrQ500H;
    C2F_NextBufferStateQnnnH = C2F_BufferStateQnnnH ; // default value for state machine 
    for(int i =0; i < C2F_EntriesNum; i++) begin
        C2F_NextBufferValidQnnnH[i]    = C2F_SelWrQnnnH[i] ? C2F_ReqValidQ500H    : RingInputValidQ501H ;
        C2F_NextBufferOpcodeQnnnH[i]   = C2F_SelWrQnnnH[i] ? C2F_ReqOpcodeQ500H   : RingInputOpcodeQ501H ;
        C2F_NextBufferThreadIDQnnnH[i] = C2F_SelWrQnnnH[i] ? C2F_ReqThreadIDQ500H : C2F_BufferThreadIDQnnnH[i] ;
        C2F_NextBufferAddressQnnnH[i]  = C2F_SelWrQnnnH[i] ? C2F_ReqAddressQ500H  : RingInputAddressQ501H ;
        C2F_NextBufferDataQnnnH[i]     = C2F_SelWrQnnnH[i] ? C2F_ReqDataQ500H     : RingInputDataQ501H   ;
        state = C2F_BufferStateQnnnH[i]; 
        
        case(state)
            //Slot is FREE
            FREE : // given Opcode is Read
                    C2F_NextBufferStateQnnnH[i] =  (C2F_NextBufferOpcodeQnnnH[i] == RD)       ? READ        :
                                                   (C2F_NextBufferOpcodeQnnnH[i] == WR)       ? WRITE       :
                                                   (C2F_NextBufferOpcodeQnnnH[i] == WR_BCAST) ? WRITE_BCAST :
                                                                                                FREE        ; 
            //Slot is WRITE
            WRITE : // FIXME  if there is enable for the mux buffer exit .add it to the if .
                    // if the C2F out mux choose this entry , and out mux passing C2F_req
                    if (C2F_SelRdRingQ501H == i && SelRingOutQ501H == 3 )
                        C2F_NextBufferStateQnnnH[i] =  FREE ;

            //Slot is READ
            READ :// FIXME  if there is enable for the mux buffer exit .add it to the if .
                    // if the C2F out mux choose this entry , and out mux passing C2F_req
                    if (C2F_SelRdRingQ501H == i && SelRingOutQ501H == 3 )
                        C2F_NextBufferStateQnnnH[i] =  READ_PRGRS ;

            //Slot is READ PRGRS
            READ_PRGRS :// FIXME  if there is enable from the core , indicates for new command from it.
                    if ( C2F_NextBufferOpcodeQnnnH[i] == RD_RSP && C2F_NextBufferAddressQnnnH[i] == C2F_BufferAddressQnnnH[i] )
                        C2F_NextBufferStateQnnnH[i] =  READ_RDY ;
                    else
                        C2F_NextBufferStateQnnnH[i] = READ_PRGRS ;
            //Slot is READ_RDY
            READ_RDY :// FIXME  if there is enable for the mux buffer exit towared the core
                    if ( C2F_SelRdCoreQ502H == i )
                        C2F_NextBufferStateQnnnH[i] =  FREE ;

            //Slot is WRITE BCAST
            WRITE_BCAST :// FIXME  if there is enable for the mux buffer exit
                    if (C2F_SelRdRingQ501H == i && SelRingOutQ501H == 3 )
                        C2F_NextBufferStateQnnnH[i] =  WRITE_BCAST_PRGRS ;

            //Slot is WRITE BCAST PRGRS
            WRITE_BCAST_PRGRS :// FIXME  if there is enable for the mux buffer exit
                    if ( RingInputOpcodeQ501H == WR_BCAST &&   C2F_BufferAddressQnnnH[i] == RingInputAddressQ501H )
                        C2F_NextBufferStateQnnnH[i] =  FREE ;

        endcase
    end //for C2F_BUFFER_SIZE
end //always_comb

// ==== C2F Buffer =================
genvar C2F_ENTRY;
generate for ( C2F_ENTRY =0 ; C2F_ENTRY < C2F_EntriesNum ; C2F_ENTRY++) begin : the_c2f_buffer_array
    `LOTR_EN_RST_MSFF( C2F_BufferValidQnnnH[C2F_ENTRY]   , C2F_NextBufferValidQnnnH[C2F_ENTRY] ,  QClk, C2F_EnWrQnnnH[C2F_ENTRY],RstQnnnH)
    `LOTR_EN_RST_MSFF( C2F_BufferOpcodeQnnnH[C2F_ENTRY]  , C2F_NextBufferOpcodeQnnnH[C2F_ENTRY],  QClk, C2F_EnWrQnnnH[C2F_ENTRY],RstQnnnH)
    `LOTR_EN_RST_MSFF( C2F_BufferThreadIDQnnnH[C2F_ENTRY], C2F_NextBufferThreadIDQnnnH[C2F_ENTRY],QClk, C2F_EnWrQnnnH[C2F_ENTRY],RstQnnnH)
    `LOTR_EN_RST_MSFF( C2F_BufferAddressQnnnH[C2F_ENTRY] , C2F_NextBufferAddressQnnnH[C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY],RstQnnnH)
    `LOTR_EN_RST_MSFF( C2F_BufferDataQnnnH   [C2F_ENTRY] , C2F_NextBufferDataQnnnH   [C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY],RstQnnnH)
    `LOTR_EN_RST_MSFF( C2F_BufferStateQnnnH   [C2F_ENTRY] ,C2F_NextBufferStateQnnnH  [C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY],RstQnnnH)
    
end endgenerate // for , generate


// ==== init C2F MRO ==========

logic [C2F_MSB:0] C2F_DeallocMroQnnnH ;
logic [C2F_MSB:0] C2F_Mask0MroQnnnH   ;
logic [C2F_MSB:0] C2F_Mask1MroQnnnH   ;

always_comb begin : create_mro_input
    for (int i =0 ; i <C2F_EntriesNum ; i++ ) begin
        C2F_DeallocMroQnnnH[i] = (C2F_NextBufferStateQnnnH[i] == FREE);
        C2F_Mask0MroQnnnH[i] = (C2F_BufferStateQnnnH[i] == READ_RDY); 
        C2F_Mask1MroQnnnH[i] = (C2F_BufferStateQnnnH[i] == READ )||(C2F_BufferStateQnnnH[i] == WRITE )||(C2F_BufferStateQnnnH[i] == WRITE_BCAST );
    end //for 
end //always_comb create_mro_input

mro
#( 
   .MRO_MSB(C2F_EntriesNum) )
mro_C2F
(
     .Clk(QClk),
     .Rst(RstQnnnH),
     .EnAlloc(|(C2F_EnCoreWrQ500H)),
     .NextAlloc(C2F_EnCoreWrQ500H),
     .Dealloc(C2F_DeallocMroQnnnH),
     .Mask0(C2F_Mask0MroQnnnH), // mask 0 for read response
     .Mask1(C2F_Mask1MroQnnnH), // mask 1 for all other commands  
     .Oldest0(C2F_SelRdCoreQ502H),
     .Oldest1(C2F_SelRdRingQ501H)
      ) ; 


always_comb begin : select_C2F_from_buffer
    // C2F_buferr -> Ring (Requist)
    C2F_ReqValidQ501H   = C2F_BufferValidQnnnH[C2F_SelRdRingQ501H]  ;
    C2F_ReqOpcodeQ501H  = C2F_BufferOpcodeQnnnH[C2F_SelRdRingQ501H] ;
    C2F_ReqAddressQ501H = C2F_BufferAddressQnnnH[C2F_SelRdRingQ501H]; // NOTE: The 501 Cycle is due to the origin of the Request (CoreReqQ500H)
    C2F_ReqDataQ501H    = C2F_BufferDataQnnnH   [C2F_SelRdRingQ501H];
    // C2F_buffer -> Core (Response)
    // C2F_RspAddressQ502H = C2F_BufferAddressQnnnH[C2F_SelRdCoreQ502H]; // Note: The 502 Cycle is due to the origin of the Response (RingInputQ500H->RingInputQ501H)
    C2F_RspDataQ502H    = C2F_BufferDataQnnnH[C2F_SelRdCoreQ502H]      ;
    C2F_RspThreadIDQ502H =  C2F_BufferThreadIDQnnnH[C2F_SelRdCoreQ502H];
    
end //always_comb
    // C2F_buferr -> Ring (Requist)
    
// ==== stall signal logic ==========
always_comb begin : raise_stall_signal
    for (int C2F_ENTRY = 0 ; C2F_ENTRY < C2F_EntriesNum ; C2F_ENTRY++) begin 
        if ( C2F_BufferStateQnnnH[C2F_ENTRY] == 3'b000 ) begin 
            C2F_RspStall = 1'b0 ;
            break ; 
        end
        if (C2F_ENTRY == C2F_EntriesNum -1 ) begin 
            C2F_RspStall = 1'b1 ;
        end
    end
end //always_comb


//==================================================================================
//              The F2C Buffer - Fabric 2 Core
//==================================================================================
//  TODO - add discription of this block
//
//==================================================================================

logic [F2C_MSB:0] F2C_FirstFreeEntry               ; 
logic [F2C_MSB:0] F2C_FreeEntries                  ; 
logic [F2C_MSB:0] F2C_IsValidReq                   ; 
logic [F2C_MSB:0] F2C_ReadResponseMatchesQ500H     ; 
logic [F2C_MSB:0] F2C_FirstReadResponseMatcesQ500H ; 

always_comb begin : find_free_candidate_F2C
    for (int i=0 ; i< F2C_EntriesNum ; i++) begin 
            F2C_FreeEntries[i] = F2C_BufferStateQnnnH[i] == FREE ;  
    end // for
end // always_comb

`FIND_FIRST(F2C_FirstFreeEntry ,F2C_FreeEntries)

always_comb begin : find_read_response_match_F2C
    for (int i=0 ; i < F2C_EntriesNum ; i++ ) begin
        if ((F2C_RspAddressQ500H == F2C_BufferAddressQnnnH[i]) && (F2C_BufferStateQnnnH[i] == READ_PRGRS))
            F2C_ReadResponseMatchesQ500H[i] = 1'b1 ;  
        else
            F2C_ReadResponseMatchesQ500H[i] = 1'b0 ;  
    end
end
// in case read respones matches to entrey, we want one enntry to alloc
`FIND_FIRST(F2C_FirstReadResponseMatcesQ500H ,F2C_ReadResponseMatchesQ500H)

always_comb begin : check_if_request_from_the_ring_to_the_RC
    if (RingInputValidQ501H & RingInputOpcodeQ501H != RD_RSP & RingInputAddressQ501H[31:24] == coreID )
        F2C_IsValidReq = '1;     
    else 
        F2C_IsValidReq = '0;
end

assign F2C_EnCoreWrQ500H = F2C_FirstReadResponseMatcesQ500H    ;
assign F2C_EnRingWrQ501H = F2C_FirstFreeEntry & F2C_IsValidReq ; 


// ===== F2C Buffer Input =========
always_comb begin : next_f2c_buffer_per_buffer_entry
    F2C_EnWrQnnnH   = F2C_EnCoreWrQ500H | F2C_EnRingWrQ501H;
    F2C_SelWrQnnnH  = F2C_EnCoreWrQ500H;
    F2C_NextBufferStateQnnnH = F2C_BufferStateQnnnH ; // default value for state machine .
    for(int i =0; i < F2C_EntriesNum; i++) begin
        F2C_NextBufferValidQnnnH[i]   = F2C_SelWrQnnnH[i] ? F2C_RspValidQ500H   : RingInputValidQ501H   ;
        F2C_NextBufferOpcodeQnnnH[i]  = F2C_SelWrQnnnH[i] ? F2C_RspOpcodeQ500H  : RingInputOpcodeQ501H  ;
        F2C_NextBufferAddressQnnnH[i] = F2C_SelWrQnnnH[i] ? F2C_RspAddressQ500H : RingInputAddressQ501H ;
        F2C_NextBufferDataQnnnH[i]    = F2C_SelWrQnnnH[i] ? F2C_RspDataQ500H    : RingInputDataQ501H    ;
        AddressComprasionFlag  = (F2C_NextBufferAddressQnnnH[i] == F2C_BufferAddressQnnnH[i]) ? 1 : 0   ; 
        case(F2C_BufferStateQnnnH[i])
        //Slot is FREE
            FREE :// given Opcode is Read
                    
                F2C_NextBufferStateQnnnH[i] = (F2C_NextBufferOpcodeQnnnH[i] == RD)       ? READ  : 
                                              (F2C_NextBufferOpcodeQnnnH[i] == WR )      ? WRITE :
                                              (F2C_NextBufferOpcodeQnnnH[i] == WR_BCAST) ? WRITE :
                                                                                           FREE  ;
            
        //Slot is WRITE
            WRITE : // FIXME  if there is enable for the mux buffer exit .add it to the if .
                if (F2C_SelRdCoreQ502H == i  )
                    F2C_NextBufferStateQnnnH[i] =  FREE ;
        //Slot is READ
            READ :// FIXME  if there is enable for the mux buffer exit .add it to the if .
                // if the C2F out mux choose this entry , and out mux passing C2F_req
                if (F2C_SelRdCoreQ502H == i )
                    F2C_NextBufferStateQnnnH[i] =  READ_PRGRS ;

        //Slot is READ PRGRS
            READ_PRGRS :// FIXME  if there is enable from the core , indicates for new command from it.            
                if ( F2C_NextBufferOpcodeQnnnH[i] == RD_RSP && AddressComprasionFlag )
                    F2C_NextBufferStateQnnnH[i] =  READ_RDY ;

        //Slot is READ_RDY
            READ_RDY :// FIXME  if there is enable for the mux buffer exit towared the core
                if ( F2C_SelRdRingQ501H == i && SelRingOutQ501H == 2 )
                    F2C_NextBufferStateQnnnH[i] =  FREE ;
        endcase
    end //for F2C_BUFFER_SIZE
end //always_comb

// ==== F2C Buffer =================
genvar F2C_ENTRY;
generate for ( F2C_ENTRY =0 ; F2C_ENTRY < F2C_EntriesNum ; F2C_ENTRY++) begin : the_f2c_buffer_array
    `LOTR_EN_RST_MSFF( F2C_BufferValidQnnnH[F2C_ENTRY], F2C_NextBufferValidQnnnH[F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY],RstQnnnH)
    `LOTR_EN_RST_MSFF( F2C_BufferOpcodeQnnnH[F2C_ENTRY], F2C_NextBufferOpcodeQnnnH[F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY],RstQnnnH)
    `LOTR_EN_RST_MSFF( F2C_BufferStateQnnnH[F2C_ENTRY], F2C_NextBufferStateQnnnH[F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY],RstQnnnH)
    `LOTR_EN_RST_MSFF( F2C_BufferAddressQnnnH[F2C_ENTRY], F2C_NextBufferAddressQnnnH[F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY],RstQnnnH)
    `LOTR_EN_RST_MSFF( F2C_BufferDataQnnnH   [F2C_ENTRY], F2C_NextBufferDataQnnnH   [F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY],RstQnnnH)
end endgenerate // for , generate



// ==== init F2C MRO ==========
logic [F2C_MSB:0] F2C_DeallocMroQnnnH ;
logic [F2C_MSB:0] F2C_Mask0MroQnnnH   ;
logic [F2C_MSB:0] F2C_Mask1MroQnnnH   ;

always_comb begin : create_mro_input_f2c
    for (int i =0 ; i <F2C_EntriesNum ; i++ ) begin
        F2C_DeallocMroQnnnH[i] = (F2C_NextBufferStateQnnnH[i] == FREE);
        F2C_Mask0MroQnnnH[i] = (F2C_BufferStateQnnnH[i] == READ_RDY); 
        F2C_Mask1MroQnnnH[i] = (F2C_BufferStateQnnnH[i] == READ )||(C2F_BufferStateQnnnH[i] == WRITE )||(C2F_BufferStateQnnnH[i] == WRITE_BCAST );
    end //for 
end //always_comb create_mro_input_f2c

mro 
#( 
   .MRO_MSB(F2C_EntriesNum) )
mro_F2C
(
     .Clk(QClk),
     .Rst(RstQnnnH),
     .EnAlloc(|(F2C_EnRingWrQ501H)),
     .NextAlloc(F2C_EnRingWrQ501H),
     .Dealloc(F2C_DeallocMroQnnnH),
     .Mask0(F2C_Mask0MroQnnnH), // mask 0 for read response
     .Mask1(F2C_Mask1MroQnnnH), // mask 1 for all other commands  
     .Oldest0(F2C_SelRdRingQ501H),
     .Oldest1(F2C_SelRdCoreQ502H)
      ) ; 

always_comb begin : select_f2c_from_buffer
    // F2C_buferr -> Ring (Response)
    F2C_RspValidQ501H   = F2C_BufferValidQnnnH  [F2C_SelRdRingQ501H] ; 
    F2C_RspOpcodeQ501H  = F2C_BufferOpcodeQnnnH [F2C_SelRdRingQ501H] ; 
    F2C_RspAddressQ501H = F2C_BufferAddressQnnnH[F2C_SelRdRingQ501H] ; // NOTE: The 501 Cycle is due to the origin of the Request (CoreReqQ500H)
    F2C_RspDataQ501H    = F2C_BufferDataQnnnH   [F2C_SelRdRingQ501H] ;

    // F2C_buffer -> Core (Request)
    F2C_ReqValidQ502H  =  F2C_BufferValidQnnnH  [F2C_SelRdCoreQ502H];
    F2C_ReqOpcodeQ502H =  F2C_BufferOpcodeQnnnH [F2C_SelRdCoreQ502H];
    F2C_ReqAddressQ502H = F2C_BufferAddressQnnnH[F2C_SelRdCoreQ502H]; // Note: The 502 Cycle is due to the origin of the Response (RingInputQ500H->RingInputQ501H)
    F2C_ReqDataQ502H    = F2C_BufferDataQnnnH   [F2C_SelRdCoreQ502H];
    
end //always_comb


//==================================================================================
//                  Ring output Interface
//==================================================================================
//  TODO - add more detailed discription of this block
//  Select the Ring Output.
//  C2F_Req / F2C_Rsp / RingInput
//==================================================================================

logic[1:0] ventilationCounter = 2'b00 ;
always_comb begin : ventilation_counter_asserting
    if (SelRingOutQ501H == C2FRequest )
        ventilationCounter = ventilationCounter + 1 ; 
    else if ( SelRingOutQ501H == NOP || ventilationCounter == 3 || ((SelRingOutQ501H == RingInput) && !RingInputValidQ501H ))
        ventilationCounter = 2'b00 ; 
    
end //always_comb

always_comb begin : set_the_select_next_ring_output_logic
    if (ventilationCounter == 3) begin
        SelRingOutQ501H = NOP ;  
    //    ventilationCounter = 2'b00 ; 
    end
    else if (((F2C_IsValidReq == '0) || (F2C_IsValidReq == '1 && F2C_FirstFreeEntry == '0) ) && C2F_FirstReadResponseMatchesQ501H == '0)
        SelRingOutQ501H = RingInput ;  
    else if (F2C_RspValidQ501H == 1'b1)
        SelRingOutQ501H = F2CResponse ; 
    else if (C2F_ReqValidQ501H== 1'b1)
        SelRingOutQ501H = C2FRequest ; 
    else begin 
        SelRingOutQ501H = NOP ; 
    //    ventilationCounter = 2'b00 ; 
    end
end //always_comb


always_comb begin : select_next_ring_output
    //mux 4:1
    unique casez (SelRingOutQ501H)
        NOP   : begin // Insert Invalid Cycle
            RingOutputValidQ501H    = 1'b0; // FIXME - think and change the code to consider the valid bit 
            RingOutputOpcodeQ501H   = 2'b0;
            RingOutputAddressQ501H  = 32'b0;
            RingOutputDataQ501H     = 32'b0;
        end
        RingInput   : begin // Foword the Ring Input
            RingOutputValidQ501H    = RingInputValidQ501H  ;
            RingOutputOpcodeQ501H   = RingInputOpcodeQ501H ;
            RingOutputAddressQ501H  = RingInputAddressQ501H;
            RingOutputDataQ501H     = RingInputDataQ501H   ;
        end
        F2CResponse   : begin // Send the F2C Rsp
            RingOutputValidQ501H    = F2C_RspValidQ501H    ;
            RingOutputOpcodeQ501H   = F2C_RspOpcodeQ501H   ;
            RingOutputAddressQ501H  = F2C_RspAddressQ501H  ;
            RingOutputDataQ501H     = F2C_RspDataQ501H     ;
        end
        C2FRequest   : begin // Send the C2F Req
            RingOutputValidQ501H    = C2F_ReqValidQ501H    ;
            RingOutputOpcodeQ501H   = C2F_ReqOpcodeQ501H   ;
            RingOutputAddressQ501H  = C2F_ReqAddressQ501H  ;
            RingOutputDataQ501H     = C2F_ReqDataQ501H     ;
        end
    endcase
end

//The Sample before Ring Output
`LOTR_MSFF( RingOutputValidQ502H   , RingOutputValidQ501H  , QClk )
`LOTR_MSFF( RingOutputOpcodeQ502H  , RingOutputOpcodeQ501H , QClk )
`LOTR_MSFF( RingOutputAddressQ502H , RingOutputAddressQ501H, QClk )
`LOTR_MSFF( RingOutputDataQ502H    , RingOutputDataQ501H   , QClk )

endmodule // module rc

