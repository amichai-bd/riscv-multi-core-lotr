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
//`timescale 1ns/1ps  
`include "lotr_defines.sv"

module rc
    import lotr_pkg::*;  
    (
    //General Interface
    input   logic         QClk                   ,
    input   logic         RstQnnnH               ,
    input   logic  [7:0]  CoreID                 ,

    
    //Ring ---> RC , RingReqIn
    input   logic         RingReqInValidQ500H    ,
    input   logic  [9:0]  RingReqRequestorQ500H  ,    
    input   t_opcode      RingReqInOpcodeQ500H   ,
    input   logic  [31:0] RingReqInAddressQ500H  ,
    input   logic  [31:0] RingReqInDataQ500H     ,

    //Ring ---> RC , RingRspIn
    input   logic         RingRspInValidQ500H    ,
    input   logic  [9:0]  RingRspRequestorQ500H  ,    
    input   t_opcode      RingRspInOpcodeQ500H   ,
    input   logic  [31:0] RingRspInAddressQ500H  ,
    input   logic  [31:0] RingRspInDataQ500H     ,

    //RC   ---> Ring , RingReqOut
    output  logic         RingReqOutValidQ502H     ,
    output  logic  [9:0]  RingReqOutRequestorQ502H ,    
    output  t_opcode      RingReqOutOpcodeQ502H    ,
    output  logic  [31:0] RingReqOutAddressQ502H   ,
    output  logic  [31:0] RingReqOutDataQ502H      ,

     //RC   ---> Ring , RingRspOut
    output  logic         RingRspOutValidQ502H     ,
    output  logic  [9:0]  RingRspOutRequestorQ502H ,    
    output  t_opcode      RingRspOutOpcodeQ502H    ,
    output  logic  [31:0] RingRspOutAddressQ502H   ,
    output  logic  [31:0] RingRspOutDataQ502H      , 
    
      
    //RC   Req/Rsp <---> Core
    input   logic         F2C_RspValidQ500H      ,
    input   t_opcode      F2C_RspOpcodeQ500H     , // Fixme -  not sure neccesery - the core recieve on;y read responses
    input   logic  [31:0] F2C_RspAddressQ500H    ,
    input   logic  [31:0] F2C_RspDataQ500H       ,
    
    output  logic         F2C_ReqValidQ502H      ,
    output  t_opcode      F2C_ReqOpcodeQ502H     ,
    output  logic  [31:0] F2C_ReqAddressQ502H    ,
    output  logic  [31:0] F2C_ReqDataQ502H 
);

//=========================================
//=====    Data Path Signals    ===========
//=========================================


logic         RingReqInValidQ501H   ; //FIXME -check use
logic  [9:0]  RingReqRequestorQ501H ;    
t_opcode      RingReqInOpcodeQ501H  ; 
logic  [31:0] RingReqInAddressQ501H ; 
logic  [31:0] RingReqInDataQ501H    ; 

logic         PreRingRspInValidQ501H   ; //FIXME -check use
logic         RingRspInValidQ501H   ; 
logic  [9:0]  RingRspRequestorQ501H ;    
t_opcode      RingRspInOpcodeQ501H  ; 
logic  [31:0] RingRspInAddressQ501H ; 
logic  [31:0] RingRspInDataQ501H    ; 

logic         RingReqOutValidQ501H     ;  
logic  [9:0]  RingReqOutRequestorQ501H ;     
t_opcode      RingReqOutOpcodeQ501H    ; 
logic  [31:0] RingReqOutAddressQ501H   ;
logic  [31:0] RingReqOutDataQ501H      ;

logic         RingRspOutValidQ501H     ;
logic  [9:0]  RingRspOutRequestorQ501H ;   
t_opcode      RingRspOutOpcodeQ501H    ;
logic  [31:0] RingRspOutAddressQ501H   ;
logic  [31:0] RingRspOutDataQ501H      ;
    
// F2C BUFFER
logic    [F2C_MSB:0]       F2C_BufferValidQnnnH     ;
logic    [F2C_MSB:0][9:0]  F2C_BufferRequestorQnnnH ;
logic    [F2C_MSB:0][31:0] F2C_BufferAddressQnnnH   ;
logic    [F2C_MSB:0][31:0] F2C_BufferDataQnnnH      ;
t_state  [F2C_MSB:0]       F2C_BufferStateQnnnH     ;

logic   [F2C_MSB:0][9:0]  F2C_NextBufferRequestorQnnnH ;
logic   [F2C_MSB:0][31:0] F2C_NextBufferAddressQnnnH   ;
logic   [F2C_MSB:0][31:0] F2C_NextBufferDataQnnnH      ;
t_state [F2C_MSB:0]       F2C_NextBufferStateQnnnH     ;

logic                     F2C_RspValidQ501H     ;
logic  [9:0]              F2C_RspRequestorQ501H ;     
t_opcode                  F2C_RspOpcodeQ501H    ;
logic   [31:0]            F2C_RspAddressQ501H   ;
logic   [31:0]            F2C_RspDataQ501H      ;


//=========================================
//=====    Control Bits Signals   =========
//=========================================
// === General ===
t_winner              SelRingReqOutQ501H     ;
t_winner              SelRingRspOutQ501H     ;
logic                 CoreIDMatchRspQ501H    ;
t_state               state ; 

// === F2C ===
logic [F2C_MSB:0]     F2C_EnAllocEntryQ501H ;
logic [F2C_MSB:0]     F2C_EnWrDataQnnnH     ;
logic [F2C_MSB:0]     F2C_SelDataSrcQnnnH   ;
// F2C data out
logic [F2C_ENC_MSB:0] F2C_SelRdRingQ501H    ;
logic [F2C_ENC_MSB:0] F2C_SelRdCoreQ502H    ;


logic [F2C_MSB:0]     F2C_EnCoreWrQ500H     ;

// === FIXME description
logic [F2C_MSB:0] F2C_FirstFreeEntryQ501H          ; 
logic [F2C_MSB:0] F2C_FreeEntriesQ501H             ; 
logic             F2C_MatchIdQ501H                 ; //FIXME -who is this 
logic [F2C_MSB:0] F2C_RspMatchQ500H                ;  
logic [F2C_MSB:0] F2C_FirstReadResponseMatcesQ500H ; 
logic [F2C_MSB:0] F2C_ResetValidQnnnH              ;
// ==== init F2C MRO ==========
logic [F2C_MSB:0] F2C_DeallocMroQnnnH ;
logic [F2C_MSB:0] F2C_Mask0MroQnnnH   ;
logic [F2C_MSB:0] F2C_Mask1MroQnnnH   ;
logic [F2C_MSB:0] F2C_DecodedSelRdRingQ501H;
logic [F2C_MSB:0] F2C_DecodedSelRdCoreQ502H;
// === Rsp ventilation
logic[1:0]        VentilationCounterRspQnnnH    ;
logic[1:0]        NextVentilationCounterRspQnnnH;
logic             EnVentilationRspQnnnH         ;
logic             RstVentilationRspQnnnH        ;
// prepreation for ventilation counter for req -- not implemented yet.
logic[1:0]        VentilationCounterReqQnnnH    ;
logic[1:0]        NextVentilationCounterReqQnnnH;
logic             EnVentilationReqQnnnH         ;
logic             RstVentilationReqQnnnH        ;

// F2C data in selector muxs
logic [F2C_MSB:0] F2C_SelDataSrc = '0;


//======================================================================================
//=========================     Module Content      ====================================
//======================================================================================
//  TODO - add discription of this module structure and blockes
//
//======================================================================================

//=========================================
// Ring input Interface
//=========================================

`LOTR_MSFF( RingReqInValidQ501H    ,  RingReqInValidQ500H   , QClk )
`LOTR_MSFF( RingReqRequestorQ501H  ,  RingReqRequestorQ500H , QClk )
`LOTR_MSFF( RingReqInOpcodeQ501H   ,  RingReqInOpcodeQ500H  , QClk )
`LOTR_MSFF( RingReqInAddressQ501H  ,  RingReqInAddressQ500H , QClk )
`LOTR_MSFF( RingReqInDataQ501H     ,  RingReqInDataQ500H    , QClk )


`LOTR_MSFF( RingRspInValidQ501H    ,  RingRspInValidQ500H   , QClk )
`LOTR_MSFF( RingRspRequestorQ501H  ,  RingRspRequestorQ500H , QClk )
`LOTR_MSFF( RingRspInOpcodeQ501H   ,  RingRspInOpcodeQ500H  , QClk )
`LOTR_MSFF( RingRspInAddressQ501H  ,  RingRspInAddressQ500H , QClk )
`LOTR_MSFF( RingRspInDataQ501H     ,  RingRspInDataQ500H    , QClk )


//=====    Req Interface - not implemenntaed , related to C2F    ===========
assign RingReqOutValidQ501H = RingReqInValidQ501H && ((!F2C_MatchIdQ501H) || (RingReqInOpcodeQ501H == WR_BCAST));
`LOTR_MSFF( RingReqOutValidQ502H     ,  RingReqOutValidQ501H   , QClk )
`LOTR_MSFF( RingReqOutRequestorQ502H ,  RingReqRequestorQ501H , QClk )
`LOTR_MSFF( RingReqOutOpcodeQ502H    ,  RingReqInOpcodeQ501H  , QClk )
`LOTR_MSFF( RingReqOutAddressQ502H   ,  RingReqInAddressQ501H , QClk )
`LOTR_MSFF( RingReqOutDataQ502H      ,  RingReqInDataQ501H    , QClk )

//==========================================================================


//==================================================================================
//              The F2C Buffer - Fabric 2 Core
//==================================================================================
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

// in case read respones matches to entry, we want one entry to alloc
`FIND_FIRST(F2C_FirstReadResponseMatcesQ500H ,F2C_RspMatchQ500H)

always_comb begin : check_if_request_from_the_ring_to_the_RC
    F2C_MatchIdQ501H = ((RingReqInValidQ501H)                 && 
                       (RingReqInOpcodeQ501H != RD_RSP)          &&
                       ((RingReqInAddressQ501H[31:24] == CoreID) || (RingReqInOpcodeQ501H == WR_BCAST )));
end // always_comb


always_comb begin : set_EnAlloc_F2C
    for (int i=0 ; i < F2C_ENTRIESNUM ; i++ ) begin
            F2C_EnAllocEntryQ501H[i]  = F2C_FirstFreeEntryQ501H[i] &&
                                        RingReqInValidQ501H        &&
                                        F2C_MatchIdQ501H ; 
    end //for
end //always_comb

always_comb begin : set_EnWriteData_F2C
    for (int i=0 ; i < F2C_ENTRIESNUM ; i++ ) begin
            F2C_EnWrDataQnnnH[i]  = ( F2C_EnAllocEntryQ501H[i] ||
                                     (F2C_RspValidQ500H             && 
                                     (F2C_RspOpcodeQ500H == RD_RSP) &&
                                     F2C_RspMatchQ500H[i]           &&
                                     F2C_BufferStateQnnnH == READ_PRGRS ) 
                                    ) ; 
    end //for
end //always_comb


always_comb begin : set_selector_data_src_mux_F2C
    for (int i=0 ; i < F2C_ENTRIESNUM ; i++ ) begin
            F2C_SelDataSrc[i]  = F2C_EnAllocEntryQ501H[i];
    end // for
end // always_comb



// ===== F2C Buffer Input =========
always_comb begin : next_f2c_buffer_per_buffer_entry
    F2C_NextBufferStateQnnnH = F2C_BufferStateQnnnH ; // default value for state machine .
    F2C_ResetValidQnnnH = '0 ;
    for(int i =0; i < F2C_ENTRIESNUM; i++) begin
        F2C_NextBufferRequestorQnnnH[i] = RingReqRequestorQ501H;
        F2C_NextBufferAddressQnnnH[i]   = RingReqInAddressQ501H;
        F2C_NextBufferDataQnnnH[i]      = F2C_SelDataSrc[i]   ? RingReqInDataQ501H  :  F2C_RspDataQ500H;
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
                    F2C_ResetValidQnnnH[i] = 1'b1 ; 
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
                    F2C_ResetValidQnnnH[i] = 1'b1 ; 
                end
            default  : F2C_NextBufferStateQnnnH = F2C_BufferStateQnnnH;
                    
        endcase
    end //for F2C_BUFFER_SIZE
end //always_comb

// ==== F2C Buffer ================= 
genvar F2C_ENTRY;
generate for ( F2C_ENTRY =0 ; F2C_ENTRY < F2C_ENTRIESNUM ; F2C_ENTRY++) begin : the_f2c_buffer_array
    `LOTR_RST_VAL_MSFF    ( F2C_BufferStateQnnnH    [F2C_ENTRY], F2C_NextBufferStateQnnnH    [F2C_ENTRY], QClk, RstQnnnH , FREE )
    `LOTR_EN_MSFF         ( F2C_BufferAddressQnnnH  [F2C_ENTRY], F2C_NextBufferAddressQnnnH  [F2C_ENTRY], QClk, F2C_EnAllocEntryQ501H[F2C_ENTRY])
    `LOTR_EN_MSFF         ( F2C_BufferRequestorQnnnH[F2C_ENTRY], F2C_NextBufferRequestorQnnnH[F2C_ENTRY], QClk, F2C_EnAllocEntryQ501H[F2C_ENTRY])
    `LOTR_EN_MSFF         ( F2C_BufferDataQnnnH     [F2C_ENTRY], F2C_NextBufferDataQnnnH     [F2C_ENTRY], QClk, F2C_EnWrDataQnnnH    [F2C_ENTRY])
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
mro 
#( 
   .MRO_MSB(F2C_MSB) )
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
    F2C_ReqValidQ502H     = (F2C_BufferStateQnnnH [F2C_SelRdCoreQ502H] == READ) || (F2C_BufferStateQnnnH [F2C_SelRdCoreQ502H] == WRITE) ;
    F2C_ReqOpcodeQ502H    = (F2C_BufferStateQnnnH [F2C_SelRdCoreQ502H] == READ)  ? RD : 
                            (F2C_BufferStateQnnnH [F2C_SelRdCoreQ502H] == WRITE) ? WR :
                                                                                   RD ; // defualt value.
    F2C_ReqAddressQ502H   =  F2C_BufferAddressQnnnH[F2C_SelRdCoreQ502H]; // Note: The 502 Cycle is due to the origin of the Response (RingInputQ500H->RingInputQ501H)
    F2C_ReqDataQ502H      =  F2C_BufferDataQnnnH   [F2C_SelRdCoreQ502H];
    
end //always_comb


//==================================================================================
//                  Ring output Interface
//==================================================================================
//  TODO - add more detailed discription of this block
//  Select the Ring Output.
//  C2F_Req / F2C_Rsp / RingInput
//==================================================================================

always_comb begin : ventilation_counter_asserting
    NextVentilationCounterRspQnnnH = VentilationCounterRspQnnnH + 2'b01 ; 
    EnVentilationRspQnnnH  = ( SelRingRspOutQ501H == F2C_RESPONSE ); 
    RstVentilationRspQnnnH = ((SelRingRspOutQ501H == BUBBLE_OUT ) || 
                             ((SelRingRspOutQ501H == RING_INPUT) && (!RingRspInValidQ501H))) ;
end //always_comb

`LOTR_EN_RST_MSFF(VentilationCounterRspQnnnH , NextVentilationCounterRspQnnnH , QClk, EnVentilationRspQnnnH, (RstVentilationRspQnnnH || RstQnnnH))


assign CoreIDMatchRspQ501H = (RingRspInAddressQ501H[31:24] == CoreID) ; 
assign MustFwdOutQ501H = (RingRspInValidQ501H && !CoreIDMatchRspQ501H) ; // need to consider about check if we are the initiators of this BC not implemented due to lack of C2F

always_comb begin : set_the_select_next_ring_output_logic_from_F2C
    if (MustFwdOutQ501H) begin
        SelRingRspOutQ501H = RING_INPUT ;
    end //if  
    else if (VentilationCounterRspQnnnH ==  2'b11 ) 
        SelRingRspOutQ501H = BUBBLE_OUT ;  
    // FIXME - add round robin logic to allow fairness between F2C and C2F 
    else if (F2C_RspValidQ501H == 1'b1)
        SelRingRspOutQ501H = F2C_RESPONSE ; 
    else begin 
        SelRingRspOutQ501H = BUBBLE_OUT ; 
    end
end //always_comb

always_comb begin : select_next_ring_output
    //mux 4:1
    unique casez (SelRingRspOutQ501H)
        BUBBLE_OUT   : begin // Insert BUBBLE_OUT Cycle
            RingRspOutValidQ501H     = 1'b0; // FIXME - think and change the code to consider the valid bit 
            RingRspOutRequestorQ501H = 10'b0;
            RingRspOutOpcodeQ501H    = RD; //RD == 2'b00 
            RingRspOutAddressQ501H   = 32'b0;
            RingRspOutDataQ501H      = 32'b0;
        end
        RING_INPUT   : begin // Foword the Ring Input
            RingRspOutValidQ501H     = RingRspInValidQ501H  ; 
            RingRspOutRequestorQ501H = RingRspRequestorQ501H;
            RingRspOutOpcodeQ501H    = RingRspInOpcodeQ501H ;
            RingRspOutAddressQ501H   = RingRspInAddressQ501H;
            RingRspOutDataQ501H      = RingRspInDataQ501H   ;
        end
        F2C_RESPONSE   : begin // Send the F2C Rsp
            RingRspOutValidQ501H     = F2C_RspValidQ501H    ;
            RingRspOutRequestorQ501H = F2C_RspRequestorQ501H;            
            RingRspOutOpcodeQ501H    = F2C_RspOpcodeQ501H   ;
            RingRspOutAddressQ501H   = F2C_RspAddressQ501H  ;
            RingRspOutDataQ501H      = F2C_RspDataQ501H     ;
        end
    endcase
end

//The Sample before Ring Output
`LOTR_MSFF( RingRspOutValidQ502H     , RingRspOutValidQ501H     , QClk )
`LOTR_MSFF( RingRspOutRequestorQ502H , RingRspOutRequestorQ501H , QClk )
`LOTR_MSFF( RingRspOutOpcodeQ502H    , RingRspOutOpcodeQ501H    , QClk )
`LOTR_MSFF( RingRspOutAddressQ502H   , RingRspOutAddressQ501H   , QClk )
`LOTR_MSFF( RingRspOutDataQ502H      , RingRspOutDataQ501H      , QClk )

endmodule // module rc

