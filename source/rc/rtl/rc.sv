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
    output  t_opcode      C2F_RspOpcodeQ502H     ,
    output  logic  [31:0] C2F_RspDataQ502H       ,
    output  logic         C2F_RspStall           ,
    output  logic  [1:0]  C2F_RspThreadIDQ502H     
);


//=========================================
//=====    Data Path Signals    ===========
//=========================================
//            RingReqInQ501H             RingRspInQ501H    
logic         RingReqInValidQ501H      , RingRspInValidQ501H      ;
logic  [9:0]  RingReqInRequestorQ501H  , RingRspInRequestorQ501H  ;
t_opcode      RingReqInOpcodeQ501H     , RingRspInOpcodeQ501H     ;
logic  [31:0] RingReqInAddressQ501H    , RingRspInAddressQ501H    ;
logic  [31:0] RingReqInDataQ501H       , RingRspInDataQ501H       ;
//            RingReqOutQ501H            RingRspOutQ501H 
logic         RingReqOutValidQ501H     , RingRspOutValidQ501H     ;  
logic  [9:0]  RingReqOutRequestorQ501H , RingRspOutRequestorQ501H ;     
t_opcode      RingReqOutOpcodeQ501H    , RingRspOutOpcodeQ501H    ; 
logic  [31:0] RingReqOutAddressQ501H   , RingRspOutAddressQ501H   ;
logic  [31:0] RingReqOutDataQ501H      , RingRspOutDataQ501H      ;
    
logic         F2C_RspValidQ501H        , C2F_ReqValidQ501H      ;
logic  [9:0]  F2C_RspRequestorQ501H    , C2F_ReqRequestorQ501H  ;
t_opcode      F2C_RspOpcodeQ501H       , C2F_ReqOpcodeQ501H     ;
logic  [31:0] F2C_RspAddressQ501H      , C2F_ReqAddressQ501H    ;
logic  [31:0] F2C_RspDataQ501H         , C2F_ReqDataQ501H       ;

//=========================================
//=====    Control Bits Signals   =========
//=========================================
// === General ===
t_winner          SelRingReqOutQ501H ;
t_winner          SelRingRspOutQ501H ;
logic             CoreIDMatchRspQ501H;
logic             F2C_MatchIdQ501H   ;
// === Rsp ventilation
logic[1:0]        VentilationCounterRspQnnnH    ;
logic[1:0]        NextVentilationCounterRspQnnnH;
logic             EnVentilationRspQnnnH         ;
logic             RstVentilationRspQnnnH        ;
// === Req ventilation counter - not implemented yet.
logic[1:0]        VentilationCounterReqQnnnH    ;
logic[1:0]        NextVentilationCounterReqQnnnH;
logic             EnVentilationReqQnnnH         ;
logic             RstVentilationReqQnnnH        ;

// === General ===
logic             CoreIDMatchReqQ501H;
// === Req ventilation counter - not implemented yet.
logic             MustFwdOutReqQ501H ; 
    

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
logic [9:0] C2F_ReqRequestorQ500H;
logic [9:0] C2F_RspRequestorQ502H;
assign C2F_ReqRequestorQ500H = { CoreID,C2F_ReqThreadIDQ500H};
assign C2F_RspThreadIDQ502H  = C2F_RspRequestorQ502H[1:0];
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
    .C2F_ReqRequestorQ500H  (C2F_ReqRequestorQ500H),//input   logic  [1:0]  
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
    .C2F_RspOpcodeQ502H     (C2F_RspOpcodeQ502H     ),//output  t_opcode
    .C2F_RspDataQ502H       (C2F_RspDataQ502H       ),//output  logic  [31:0] 
    .C2F_RspStall           (C2F_RspStall           ),//output  logic         
    .C2F_RspRequestorQ502H  (C2F_RspRequestorQ502H  ),//output  logic  [9:0]  
    // Incase of brodcast:
    .RingReqInValidQ501H    (RingReqInValidQ501H    ),//input
    .RingReqInRequestorQ501H(RingReqInRequestorQ501H),//input
    .RingReqInOpcodeQ501H   (RingReqInOpcodeQ501H   ),//input
    .RingReqInAddressQ501H  (RingReqInAddressQ501H  ) //input

);
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
// =============== RingRspOut
//==================================================================================
always_comb begin : ventilation_rsp_counter_asserting
    NextVentilationCounterRspQnnnH = VentilationCounterRspQnnnH + 2'b01 ; 
    EnVentilationRspQnnnH  = ( SelRingRspOutQ501H == F2C_RESPONSE ); 
    RstVentilationRspQnnnH = ((SelRingRspOutQ501H == BUBBLE_OUT ) || 
                             ((SelRingRspOutQ501H == RING_INPUT) && (!RingRspInValidQ501H))) ;
end //always_comb

`LOTR_EN_RST_MSFF(VentilationCounterRspQnnnH , NextVentilationCounterRspQnnnH , QClk, EnVentilationRspQnnnH, (RstVentilationRspQnnnH || RstQnnnH))
logic MustFwdOutQ501H;
assign CoreIDMatchRspQ501H = (RingRspInRequestorQ501H[9:2] == CoreID) ; 
assign MustFwdOutQ501H     = (RingRspInValidQ501H && !CoreIDMatchRspQ501H) ; // need to consider about check if we are the initiators of this BC not implemented due to lack of C2F

logic  NeedToVentilateQnnnH;
assign NeedToVentilateQnnnH = (VentilationCounterRspQnnnH ==  2'b11);
always_comb begin : set_the_select_next_ring_output_logic_from_F2C
    unique casez ({MustFwdOutQ501H, NeedToVentilateQnnnH, F2C_RspValidQ501H})
        3'b1??  : SelRingRspOutQ501H = RING_INPUT   ;
        3'b01?  : SelRingRspOutQ501H = BUBBLE_OUT   ;  
        3'b001  : SelRingRspOutQ501H = F2C_RESPONSE ;
        default : SelRingRspOutQ501H = BUBBLE_OUT   ; 
    endcase
end //always_comb

always_comb begin : select_next_ring_rsp_output
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

    
//==================================================================================
// =============== RingReqOut
//==================================================================================

    
always_comb begin : ventilation_req_counter_asserting
    NextVentilationCounterReqQnnnH = VentilationCounterReqQnnnH + 2'b01 ; 
    EnVentilationReqQnnnH  = ( SelRingReqOutQ501H == C2F_REQUEST ); 
    RstVentilationReqQnnnH = ((SelRingReqOutQ501H == BUBBLE_OUT ) || 
                              ((SelRingReqOutQ501H == RING_INPUT) && (!RingReqInValidQ501H))) ;
end //always_comb

    `LOTR_EN_RST_MSFF(VentilationCounterReqQnnnH , NextVentilationCounterReqQnnnH , QClk, EnVentilationReqQnnnH, (RstVentilationReqQnnnH || RstQnnnH))

assign CoreIDMatchReqQ501H = (RingReqInAddressQ501H[31:24] == CoreID) ; 
assign MustFwdOutReqQ501H     = (RingReqInValidQ501H && !CoreIDMatchReqQ501H) ; // need to consider about check if we are the initiators of this BC not implemented due to lack of C2F

logic  NeedToVentilateReqQnnnH;
assign NeedToVentilateReqQnnnH = (VentilationCounterReqQnnnH ==  2'b11);
    
    
always_comb begin : set_the_select_next_ring_output_logic_from_C2F
    unique casez ({MustFwdOutReqQ501H, NeedToVentilateReqQnnnH, C2F_ReqValidQ501H})
        3'b1??  : SelRingReqOutQ501H = RING_INPUT   ;
        3'b01?  : SelRingReqOutQ501H = BUBBLE_OUT   ;  
        3'b001  : SelRingReqOutQ501H = C2F_REQUEST  ;
        default : SelRingReqOutQ501H = BUBBLE_OUT   ; 
    endcase
end //always_comb

always_comb begin : select_next_ring_req_output
    //mux 4:1
    unique casez (SelRingReqOutQ501H)
        BUBBLE_OUT   : begin // Insert BUBBLE_OUT Cycle
            RingReqOutValidQ501H     = 1'b0;
            RingReqOutRequestorQ501H = 10'b0;
            RingReqOutOpcodeQ501H    = RD; //RD == 2'b00 
            RingReqOutAddressQ501H   = 32'b0;
            RingReqOutDataQ501H      = 32'b0;
        end
        RING_INPUT   : begin // Foword the Ring Input
            RingReqOutValidQ501H     = RingReqInValidQ501H  ; 
            RingReqOutRequestorQ501H = RingReqInRequestorQ501H;
            RingReqOutOpcodeQ501H    = RingReqInOpcodeQ501H ;
            RingReqOutAddressQ501H   = RingReqInAddressQ501H;
            RingReqOutDataQ501H      = RingReqInDataQ501H   ;
        end
        C2F_REQUEST   : begin 
            RingReqOutValidQ501H     = C2F_ReqValidQ501H    ;
            RingReqOutRequestorQ501H = C2F_ReqRequestorQ501H;            
            RingReqOutOpcodeQ501H    = C2F_ReqOpcodeQ501H   ;
            RingReqOutAddressQ501H   = C2F_ReqAddressQ501H  ;
            RingReqOutDataQ501H      = C2F_ReqDataQ501H     ;
        end
        default        : begin
            RingReqOutValidQ501H     = 1'b0;
            RingReqOutRequestorQ501H = 10'b0;
            RingReqOutOpcodeQ501H    = RD;
            RingReqOutAddressQ501H   = 32'b0;
            RingReqOutDataQ501H      = 32'b0;
        end
    endcase
end

    
    

endmodule // module rc

