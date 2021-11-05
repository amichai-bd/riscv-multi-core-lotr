//-----------------------------------------------------------------------------
// Title            : RC - Ring Controller 
// Project          : LOTR: Lord-Of-The-Ring
//-----------------------------------------------------------------------------
// File             : rc.sv 
// Original Author  : Tzahi Peretz, Shimi Haleluya 
// Adviser          : Amichai Ben-David
// Created          : 5/2021
//-----------------------------------------------------------------------------
// Description :
// 
//------------------------------------------------------------------------------
// Modification history :
//
//------------------------------------------------------------------------------
`include "lotr_defines.sv"
module rc
    import lotr_pkg::*;  
    (
    //General Interface
    input   logic         QClk                   ,
    input   logic         RstQnnnH               ,
    input   logic  [7:0]  CoreID                 ,
    //===================================
    // Ring Controler <-> Fabric Inteface
    //===================================
    //Ring ---> RC , RingReqIn
    input   logic         RingReqInValidQ500H    ,
    input   logic  [9:0]  RingReqInRequestorQ500H  ,    
    input   t_opcode      RingReqInOpcodeQ500H   ,
    input   logic  [31:0] RingReqInAddressQ500H  ,
    input   logic  [31:0] RingReqInDataQ500H     ,
    //Ring ---> RC , RingRspIn
    input   logic         RingRspInValidQ500H    ,
    input   logic  [9:0]  RingRspInRequestorQ500H  ,    
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
    //===================================
    // Ring Controler <-> Core Interface
    //===================================
    //RC <---> Core F2C
    input   logic         F2C_RspValidQ500H      ,
    input   t_opcode      F2C_RspOpcodeQ500H     ,
    input   logic  [31:0] F2C_RspAddressQ500H    ,
    input   logic  [31:0] F2C_RspDataQ500H       ,
    output  logic         F2C_ReqValidQ502H      ,
    output  t_opcode      F2C_ReqOpcodeQ502H     ,
    output  logic  [31:0] F2C_ReqAddressQ502H    ,
    output  logic  [31:0] F2C_ReqDataQ502H       ,
    //RC <---> Core C2F
    input   logic         C2F_ReqValidQ500H      ,
    input   t_opcode      C2F_ReqOpcodeQ500H     ,
    input   logic  [31:0] C2F_ReqAddressQ500H    ,
    input   logic  [31:0] C2F_ReqDataQ500H       ,
    input   logic  [1:0]  C2F_ReqThreadIDQ500H   ,
    output  logic         C2F_RspValidQ502H      ,
    output  logic  [31:0] C2F_RspDataQ502H       ,
    output  logic         C2F_RspStall           ,
    output  logic  [1:0]  C2F_RspThreadIDQ502H     
);


//=========================================
//=====    Data Path Signals    ===========
//=========================================

logic         RingReqInValidQ501H    ;
logic  [9:0]  RingReqInRequestorQ501H;    
t_opcode      RingReqInOpcodeQ501H   ; 
logic  [31:0] RingReqInAddressQ501H  ; 
logic  [31:0] RingReqInDataQ501H     ; 
logic         RingRspInValidQ501H    ; 
logic  [9:0]  RingRspInRequestorQ501H;    
t_opcode      RingRspInOpcodeQ501H   ; 
logic  [31:0] RingRspInAddressQ501H  ; 
logic  [31:0] RingRspInDataQ501H     ; 
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
logic   [F2C_MSB:0]       F2C_BufferValidQnnnH     ;
logic   [F2C_MSB:0][9:0]  F2C_BufferRequestorQnnnH ;
logic   [F2C_MSB:0][31:0] F2C_BufferAddressQnnnH   ;
logic   [F2C_MSB:0][31:0] F2C_BufferDataQnnnH      ;
t_state [F2C_MSB:0]       F2C_BufferStateQnnnH     ;
logic   [F2C_MSB:0][9:0]  F2C_NextBufferRequestorQnnnH ;
logic   [F2C_MSB:0][31:0] F2C_NextBufferAddressQnnnH   ;
logic   [F2C_MSB:0][31:0] F2C_NextBufferDataQnnnH      ;
t_state [F2C_MSB:0]       F2C_NextBufferStateQnnnH     ;
logic                     F2C_RspValidQ501H     ;
logic   [9:0]             F2C_RspRequestorQ501H ;     
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
// === FIXME description
logic [F2C_MSB:0] F2C_FirstFreeEntryQ501H          ; 
logic [F2C_MSB:0] F2C_FreeEntriesQ501H             ; 
logic             F2C_MatchIdQ501H                 ;
logic [F2C_MSB:0] F2C_RspMatchQ500H                ;  
logic [F2C_MSB:0] F2C_FirstReadResponseMatcesQ500H ; 
logic [F2C_MSB:0] F2C_ResetValidQnnnH              ;
// ==== init F2C MRO ==========
logic [F2C_MSB:0] F2C_DeallocMroQnnnH ;
logic [F2C_MSB:0] F2C_Mask0MroQnnnH   ;
logic [F2C_MSB:0] F2C_Mask1MroQnnnH   ;
logic [F2C_MSB:0] F2C_DecodedSelRdRingQ501H;
logic [F2C_MSB:0] F2C_DecodedSelRdCoreQ502H;
// ==== C2F =====================
logic         C2F_ReqValidQ501H      ;
logic  [9:0]  C2F_ReqRequestorQ501H  ;     
t_opcode      C2F_ReqOpcodeQ501H     ;
logic  [31:0] C2F_ReqAddressQ501H    ;
logic  [31:0] C2F_ReqDataQ501H       ;
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
//Ring request Channel Input
`LOTR_RST_MSFF( RingReqInValidQ501H, RingReqInValidQ500H    , QClk ,RstQnnnH)
`LOTR_MSFF( RingReqInRequestorQ501H, RingReqInRequestorQ500H, QClk )
`LOTR_MSFF( RingReqInOpcodeQ501H   , RingReqInOpcodeQ500H   , QClk )
`LOTR_MSFF( RingReqInAddressQ501H  , RingReqInAddressQ500H  , QClk )
`LOTR_MSFF( RingReqInDataQ501H     , RingReqInDataQ500H     , QClk )
//Ring request Channel output 
`LOTR_RST_MSFF( RingReqOutValidQ502H, RingReqOutValidQ501H    , QClk ,RstQnnnH)
`LOTR_MSFF( RingReqOutRequestorQ502H, RingReqOutRequestorQ501H, QClk )
`LOTR_MSFF( RingReqOutOpcodeQ502H   , RingReqOutOpcodeQ501H   , QClk )
`LOTR_MSFF( RingReqOutAddressQ502H  , RingReqOutAddressQ501H  , QClk )
`LOTR_MSFF( RingReqOutDataQ502H     , RingReqOutDataQ501H     , QClk )
//Ring Response Channel Input
`LOTR_RST_MSFF( RingRspInValidQ501H, RingRspInValidQ500H    , QClk ,RstQnnnH)
`LOTR_MSFF( RingRspInRequestorQ501H, RingRspInRequestorQ500H, QClk )
`LOTR_MSFF( RingRspInOpcodeQ501H   , RingRspInOpcodeQ500H   , QClk )
`LOTR_MSFF( RingRspInAddressQ501H  , RingRspInAddressQ500H  , QClk )
`LOTR_MSFF( RingRspInDataQ501H     , RingRspInDataQ500H     , QClk )
//Ring Respone Channel Output
`LOTR_RST_MSFF( RingRspOutValidQ502H , RingRspOutValidQ501H     , QClk ,RstQnnnH)
`LOTR_MSFF( RingRspOutRequestorQ502H , RingRspOutRequestorQ501H , QClk )
`LOTR_MSFF( RingRspOutOpcodeQ502H    , RingRspOutOpcodeQ501H    , QClk )
`LOTR_MSFF( RingRspOutAddressQ502H   , RingRspOutAddressQ501H   , QClk )
`LOTR_MSFF( RingRspOutDataQ502H      , RingRspOutDataQ501H      , QClk )



//==================================================================================
//              The C2F Buffer - Core 2 Fabric
//==================================================================================
c2f c2f (
    //General Interface
    .QClk                   (QClk              ),//input   logic         
    .RstQnnnH               (RstQnnnH          ),//input   logic         
    .CoreID                 (CoreID            ),//input   logic  [7:0]  
    .SelRingReqOutQ501H     (SelRingReqOutQ501H),//input   t_winner      
    //===================================
    // Request Flow
    //===================================
    //Core ---> C2F
    .C2F_ReqValidQ500H      (C2F_ReqValidQ500H    ),//input   logic         
    .C2F_ReqOpcodeQ500H     (C2F_ReqOpcodeQ500H   ),//input   t_opcode      
    .C2F_ReqAddressQ500H    (C2F_ReqAddressQ500H  ),//input   logic  [31:0] 
    .C2F_ReqDataQ500H       (C2F_ReqDataQ500H     ),//input   logic  [31:0] 
    .C2F_ReqThreadIDQ500H   (C2F_ReqThreadIDQ500H ),//input   logic  [1:0]  
    //F2C ---> RING , RingRspOut
    .C2F_ReqValidQ501H      (C2F_ReqValidQ501H    ),//output  logic         
    .C2F_ReqRequestorQ501H  (C2F_ReqRequestorQ501H),//output  logic  [9:0]       
    .C2F_ReqOpcodeQ501H     (C2F_ReqOpcodeQ501H   ),//output  t_opcode      
    .C2F_ReqAddressQ501H    (C2F_ReqAddressQ501H  ),//output  logic  [31:0] 
    .C2F_ReqDataQ501H       (C2F_ReqDataQ501H     ),//output  logic  [31:0] 
    //===================================
    // Response Flow
    //===================================
    //Ring ---> F2C , RingReqIn
    .RingRspInValidQ501H    (RingRspInValidQ501H    ),//input   logic         
    .RingRspInRequestorQ501H(RingRspInRequestorQ501H),//input   logic  [9:0]      
    .RingRspInOpcodeQ501H   (RingRspInOpcodeQ501H   ),//input   t_opcode      
    .RingRspInAddressQ501H  (RingRspInAddressQ501H  ),//input   logic  [31:0] 
    .RingRspInDataQ501H     (RingRspInDataQ501H     ),//input   logic  [31:0] 
    //C2F ---> Core          /C2F ---> Core
    .C2F_RspValidQ502H      (C2F_RspValidQ502H      ),//output  logic         
    .C2F_RspDataQ502H       (C2F_RspDataQ502H       ),//output  logic  [31:0] 
    .C2F_RspStall           (C2F_RspStall           ),//output  logic         
    .C2F_RspThreadIDQ502H   (C2F_RspThreadIDQ502H   ) //output  logic  [1:0]  
);
//==========================================================================
//      FIXME - Make correct Arbiter for the RingReq Output Channel.
//==========================================================================
// C2F_ReqValidQ501H || RingReqInValidQ501H -> FIXME - The C2F_ReqValidQ501H come from C2F Buffer
assign RingReqOutValidQ501H     = (C2F_ReqValidQ501H) || (RingReqInValidQ501H && ((!F2C_MatchIdQ501H) || (RingReqInOpcodeQ501H == WR_BCAST)));
assign RingReqOutRequestorQ501H = C2F_ReqValidQ501H ? C2F_ReqRequestorQ501H : RingReqInRequestorQ501H;
assign RingReqOutOpcodeQ501H    = C2F_ReqValidQ501H ? C2F_ReqOpcodeQ501H    : RingReqInOpcodeQ501H   ;
assign RingReqOutAddressQ501H   = C2F_ReqValidQ501H ? C2F_ReqAddressQ501H   : RingReqInAddressQ501H  ;
assign RingReqOutDataQ501H      = C2F_ReqValidQ501H ? C2F_ReqDataQ501H      : RingReqInDataQ501H     ;
//==========================================================================

//==================================================================================
//              The F2C Buffer - Fabric 2 Core
//==================================================================================
f2c f2c (
    //General Interface
    .QClk                   (QClk              ),//input   logic         
    .RstQnnnH               (RstQnnnH          ),//input   logic         
    .CoreID                 (CoreID            ),//input   logic  [7:0]  
    .SelRingRspOutQ501H     (SelRingRspOutQ501H),//input   t_winner      
    .F2C_MatchIdQ501H       (F2C_MatchIdQ501H  ),//input   t_winner      
    //===================================
    // Ring Controler <-> Fabric Inteface
    //===================================
    //Ring ---> F2C , RingReqIn
    .RingReqInValidQ501H    (RingReqInValidQ501H    ),//input   logic         
    .RingReqInRequestorQ501H(RingReqInRequestorQ501H),//input   logic  [9:0]      
    .RingReqInOpcodeQ501H   (RingReqInOpcodeQ501H   ),//input   t_opcode      
    .RingReqInAddressQ501H  (RingReqInAddressQ501H  ),//input   logic  [31:0] 
    .RingReqInDataQ501H     (RingReqInDataQ501H     ),//input   logic  [31:0] 
    //F2C ---> RING , RingRspOut
    .F2C_RspValidQ501H      (F2C_RspValidQ501H      ),//output  logic         
    .F2C_RspRequestorQ501H  (F2C_RspRequestorQ501H  ),//output  logic  [9:0]       
    .F2C_RspOpcodeQ501H     (F2C_RspOpcodeQ501H     ),//output  t_opcode      
    .F2C_RspAddressQ501H    (F2C_RspAddressQ501H    ),//output  logic  [31:0] 
    .F2C_RspDataQ501H       (F2C_RspDataQ501H       ),//output  logic  [31:0] 
    //===================================
    // Ring Controler <-> Core Interface
    //===================================
    //F2C  ---> Core , F2C_ReqQ502H
    .F2C_ReqValidQ502H      (F2C_ReqValidQ502H      ),//output  logic         
    .F2C_ReqOpcodeQ502H     (F2C_ReqOpcodeQ502H     ),//output  t_opcode      
    .F2C_ReqAddressQ502H    (F2C_ReqAddressQ502H    ),//output  logic  [31:0] 
    .F2C_ReqDataQ502H       (F2C_ReqDataQ502H       ),//output  logic  [31:0] 
    //Core ---> F2C 
    .F2C_RspValidQ500H      (F2C_RspValidQ500H      ),//input   logic         
    .F2C_RspOpcodeQ500H     (F2C_RspOpcodeQ500H     ),//input   t_opcode      
    .F2C_RspAddressQ500H    (F2C_RspAddressQ500H    ),//input   logic  [31:0] 
    .F2C_RspDataQ500H       (F2C_RspDataQ500H       ) //input   logic  [31:0] 
);
//==================================================================================

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
assign MustFwdOutQ501H     = (RingRspInValidQ501H && !CoreIDMatchRspQ501H) ; // need to consider about check if we are the initiators of this BC not implemented due to lack of C2F

logic  NeedToventilateQnnnH;
assign NeedToVentilateQnnnH = (VentilationCounterRspQnnnH ==  2'b11);
always_comb begin : set_the_select_next_ring_output_logic_from_F2C
    unique casez ({MustFwdOutQ501H, NeedToVentilateQnnnH, F2C_RspValidQ501H})
        3'b1??  : SelRingRspOutQ501H = RING_INPUT   ;
        3'b01?  : SelRingRspOutQ501H = BUBBLE_OUT   ;  
        3'b001  : SelRingRspOutQ501H = F2C_RESPONSE ;
        default : SelRingRspOutQ501H = BUBBLE_OUT   ; 
    endcase
end //always_comb

always_comb begin : select_next_ring_output
    //mux 4:1
    unique casez (SelRingRspOutQ501H)
        BUBBLE_OUT   : begin // Insert BUBBLE_OUT Cycle
            RingRspOutValidQ501H     = 1'b0;
            RingRspOutRequestorQ501H = 10'b0;
            RingRspOutOpcodeQ501H    = RD; //RD == 2'b00 
            RingRspOutAddressQ501H   = 32'b0;
            RingRspOutDataQ501H      = 32'b0;
        end
        RING_INPUT   : begin // Foword the Ring Input
            RingRspOutValidQ501H     = RingRspInValidQ501H  ; 
            RingRspOutRequestorQ501H = RingRspInRequestorQ501H;
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
        default        : begin
            RingRspOutValidQ501H     = 1'b0;
            RingRspOutRequestorQ501H = 10'b0;
            RingRspOutOpcodeQ501H    = RD;
            RingRspOutAddressQ501H   = 32'b0;
            RingRspOutDataQ501H      = 32'b0;
        end
    endcase
end


endmodule // module rc

