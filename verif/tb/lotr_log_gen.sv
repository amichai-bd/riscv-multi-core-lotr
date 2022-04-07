//place holder - see gpc_4t_log_gen.sv as reference
`include "lotr_defines.sv"
integer trk_rc_transactions;

initial begin
    $timeformat(-9, 1, " ", 6);
    trk_rc_transactions   = $fopen({"../target/",hpath,"/trk_RC_transactions.log"},"w");
    $fwrite(trk_rc_transactions,"----------------------------------------------------------------------------\n");
    $fwrite(trk_rc_transactions,"Time\t| Tile ID \t| Channel \t| Requestor \t| OpCode \t| Address \t| Data\t|\n");
    $fwrite(trk_rc_transactions,"----------------------------------------------------------------------------\n");
        

end //initial

//===================================
// Ring Controler <-> Core Interface
//===================================

//****RC <---> Core C2F*****//
//RC <-- CORE C2F
logic         C2F_ReqValidQ501H      ;
t_opcode      C2F_ReqOpcodeQ501H     ;
logic  [31:0] C2F_ReqAddressQ501H    ;
logic  [31:0] C2F_ReqDataQ501H       ;
logic  [1:0]  C2F_ReqThreadIDQ501H   ;
//RC --> CORE C2F                    ;
logic         C2F_RspValidQ503H      ;
t_opcode      C2F_RspOpcodeQ503H     ;
logic  [31:0] C2F_RspDataQ503H       ;
logic         C2F_RspStall           ;
logic  [1:0]  C2F_RspThreadIDQ503H   ;
                                     ;
//******RC <---> Core F2C*****//     ;
//RC_F2C <-- CORE                    ;
logic         F2C_RspValidQ501H      ;
t_opcode      F2C_RspOpcodeQ501H     ;
logic  [31:0] F2C_RspAddressQ501H    ;
logic  [31:0] F2C_RspDataQ501H       ;
//RC _F2C --> CORE                   ;
logic         F2C_ReqValidQ503H      ;
t_opcode      F2C_ReqOpcodeQ503H     ; 
logic  [31:0] F2C_ReqAddressQ503H    ;
logic  [31:0] F2C_ReqDataQ503H       ;

//===================================
// Ring Controler <-> Fabric Inteface
//===================================
//Ring ---> RC , RingReqIn
logic         RingReqInValidQ501H    ;
logic  [9:0]  RingReqInRequestorQ501H;
t_opcode      RingReqInOpcodeQ501H   ;
logic  [31:0] RingReqInAddressQ501H  ;
logic  [31:0] RingReqInDataQ501H     ;
//Ring ---> RC , RingRspIn           ;
logic         RingRspInValidQ501H    ;
logic  [9:0]  RingRspInRequestorQ501H;
t_opcode      RingRspInOpcodeQ501H   ;
logic  [31:0] RingRspInAddressQ501H  ;
logic  [31:0] RingRspInDataQ501H     ;
//RC   ---> Ring , RingReqOut
logic         RingReqOutValidQ503H     ;
logic  [9:0]  RingReqOutRequestorQ503H ;
t_opcode      RingReqOutOpcodeQ503H    ;
logic  [31:0] RingReqOutAddressQ503H   ;
logic  [31:0] RingReqOutDataQ503H      ;
 //RC   ---> Ring , RingRspOut         ;
logic         RingRspOutValidQ503H     ;
logic  [9:0]  RingRspOutRequestorQ503H ;
t_opcode      RingRspOutOpcodeQ503H    ;
logic  [31:0] RingRspOutAddressQ503H   ;
logic  [31:0] RingRspOutDataQ503H      ;
logic        AssertEBREAK       ;
assign AssertEBREAK = (lotr_tb.lotr.gpc_4t_tile_0.gpc_4t.core_4t.OpcodeQ101H == 7'b1110011);



`LOTR_MSFF(C2F_ReqValidQ501H     , lotr_tb.lotr.gpc_4t_tile_0.rc.C2F_ReqValidQ500H               , clk)
`LOTR_MSFF(C2F_ReqOpcodeQ501H    , lotr_tb.lotr.gpc_4t_tile_0.rc.C2F_ReqOpcodeQ500H              , clk)
`LOTR_MSFF(C2F_ReqAddressQ501H   , lotr_tb.lotr.gpc_4t_tile_0.rc.C2F_ReqAddressQ500H             , clk)
`LOTR_MSFF(C2F_ReqDataQ501H      , lotr_tb.lotr.gpc_4t_tile_0.rc.C2F_ReqDataQ500H                , clk)
`LOTR_MSFF(C2F_ReqThreadIDQ501H  , lotr_tb.lotr.gpc_4t_tile_0.rc.C2F_ReqThreadIDQ500H            , clk)
                                                                 
`LOTR_MSFF(C2F_RspValidQ503H     , lotr_tb.lotr.gpc_4t_tile_0.rc.C2F_RspValidQ502H               , clk)
`LOTR_MSFF(C2F_RspOpcodeQ503H    , lotr_tb.lotr.gpc_4t_tile_0.rc.C2F_RspOpcodeQ502H              , clk)
`LOTR_MSFF(C2F_RspDataQ503H      , lotr_tb.lotr.gpc_4t_tile_0.rc.C2F_RspDataQ502H                , clk)
`LOTR_MSFF(C2F_RspStall          , lotr_tb.lotr.gpc_4t_tile_0.rc.C2F_RspStall                    , clk)
`LOTR_MSFF(C2F_RspThreadIDQ503H  , lotr_tb.lotr.gpc_4t_tile_0.rc.C2F_RspThreadIDQ502H            , clk)
                                                                 
`LOTR_MSFF(F2C_ReqValidQ503H      ,lotr_tb.lotr.gpc_4t_tile_0.rc.F2C_ReqValidQ502H                , clk)
`LOTR_MSFF(F2C_ReqOpcodeQ503H     ,lotr_tb.lotr.gpc_4t_tile_0.rc.F2C_ReqOpcodeQ502H               , clk)
`LOTR_MSFF(F2C_ReqAddressQ503H    ,lotr_tb.lotr.gpc_4t_tile_0.rc.F2C_ReqAddressQ502H              , clk)
`LOTR_MSFF(F2C_ReqDataQ503H       ,lotr_tb.lotr.gpc_4t_tile_0.rc.F2C_ReqDataQ502H                 , clk)

`LOTR_MSFF(F2C_RspValidQ501H      ,lotr_tb.lotr.gpc_4t_tile_0.rc.F2C_RspValidQ500H                , clk)
`LOTR_MSFF(F2C_RspOpcodeQ501H     ,lotr_tb.lotr.gpc_4t_tile_0.rc.F2C_RspOpcodeQ500H               , clk)
`LOTR_MSFF(F2C_RspAddressQ501H    ,lotr_tb.lotr.gpc_4t_tile_0.rc.F2C_RspAddressQ500H              , clk)
`LOTR_MSFF(F2C_RspDataQ501H       ,lotr_tb.lotr.gpc_4t_tile_0.rc.F2C_RspDataQ500H                 , clk)
                                                                 
`LOTR_MSFF(RingReqInValidQ501H       , lotr_tb.lotr.gpc_4t_tile_0.rc.RingReqInValidQ500H       , clk)
`LOTR_MSFF(RingReqInRequestorQ501H   , lotr_tb.lotr.gpc_4t_tile_0.rc.RingReqInRequestorQ500H   , clk)
`LOTR_MSFF(RingReqInOpcodeQ501H      , lotr_tb.lotr.gpc_4t_tile_0.rc.RingReqInOpcodeQ500H      , clk)
`LOTR_MSFF(RingReqInAddressQ501H     , lotr_tb.lotr.gpc_4t_tile_0.rc.RingReqInAddressQ500H     , clk)
`LOTR_MSFF(RingReqInDataQ501H        , lotr_tb.lotr.gpc_4t_tile_0.rc.RingReqInDataQ500H        , clk)
                                                                                             
`LOTR_MSFF(RingRspInValidQ501H       , lotr_tb.lotr.gpc_4t_tile_0.rc.RingRspInValidQ500H       , clk)
`LOTR_MSFF(RingRspInRequestorQ501H   , lotr_tb.lotr.gpc_4t_tile_0.rc.RingRspInRequestorQ500H   , clk)
`LOTR_MSFF(RingRspInOpcodeQ501H      , lotr_tb.lotr.gpc_4t_tile_0.rc.RingRspInOpcodeQ500H      , clk)
`LOTR_MSFF(RingRspInAddressQ501H     , lotr_tb.lotr.gpc_4t_tile_0.rc.RingRspInAddressQ500H     , clk)
`LOTR_MSFF(RingRspInDataQ501H        , lotr_tb.lotr.gpc_4t_tile_0.rc.RingRspInDataQ500H        , clk)
                                                                     
`LOTR_MSFF(RingReqOutValidQ503H      , lotr_tb.lotr.gpc_4t_tile_0.rc.RingReqOutValidQ502H      , clk)
`LOTR_MSFF(RingReqOutRequestorQ503H  , lotr_tb.lotr.gpc_4t_tile_0.rc.RingReqOutRequestorQ502H  , clk)
`LOTR_MSFF(RingReqOutOpcodeQ503H     , lotr_tb.lotr.gpc_4t_tile_0.rc.RingReqOutOpcodeQ502H     , clk)
`LOTR_MSFF(RingReqOutAddressQ503H    , lotr_tb.lotr.gpc_4t_tile_0.rc.RingReqOutAddressQ502H    , clk)
`LOTR_MSFF(RingReqOutDataQ503H       , lotr_tb.lotr.gpc_4t_tile_0.rc.RingReqOutDataQ502H       , clk)
                                                                                             
`LOTR_MSFF(RingRspOutValidQ503H      , lotr_tb.lotr.gpc_4t_tile_0.rc.RingRspOutValidQ502H      , clk)
`LOTR_MSFF(RingRspOutRequestorQ503H  , lotr_tb.lotr.gpc_4t_tile_0.rc.RingRspOutRequestorQ502H  , clk)
`LOTR_MSFF(RingRspOutOpcodeQ503H     , lotr_tb.lotr.gpc_4t_tile_0.rc.RingRspOutOpcodeQ502H     , clk)
`LOTR_MSFF(RingRspOutAddressQ503H    , lotr_tb.lotr.gpc_4t_tile_0.rc.RingRspOutAddressQ502H    , clk)
`LOTR_MSFF(RingRspOutDataQ503H       , lotr_tb.lotr.gpc_4t_tile_0.rc.RingRspOutDataQ502H       , clk)


//tracker on memory transactions
always @(posedge clk) begin : C2F_Req
    if (C2F_ReqValidQ501H) begin 
        $fwrite(trk_rc_transactions,"%t\t| \t%d | %s \t| %4b\t | %d \t| %8h\t| %8h \n",
        $realtime, 0 ,"C2F_Req", C2F_ReqThreadIDQ501H , C2F_ReqOpcodeQ501H,C2F_ReqAddressQ501H ,C2F_ReqDataQ501H  );
    end //if
end 

always @(posedge clk) begin : C2F_Rsp
    if (C2F_RspValidQ503H) begin 
        $fwrite(trk_rc_transactions,"%t\t| \t%d | %s \t| %4b\t | %d \t| %8h\t| %8h \n",
        $realtime, 0 ,"C2F_Rsp", C2F_RspThreadIDQ503H , C2F_RspOpcodeQ503H,C2F_ReqAddressQ501H ,C2F_RspDataQ503H  );
    end //if
end 

always @(posedge clk) begin : F2C_Req
    if (F2C_ReqValidQ503H) begin 
        $fwrite(trk_rc_transactions,"%t\t| \t%d | %s \t| %4b\t | %d \t| %8h\t| %8h \n",
        $realtime, 0 ,"F2C_Req", C2F_ReqThreadIDQ501H , F2C_ReqOpcodeQ503H, F2C_ReqAddressQ503H ,F2C_ReqDataQ503H  );
    end //if
end 

always @(posedge clk) begin : F2C_Rsp
    if (F2C_RspValidQ501H) begin 
        $fwrite(trk_rc_transactions,"%t\t| \t%d | %s \t| %4b\t | %d \t| %8h\t| %8h \n",
        $realtime, 0 ,"F2C_Rsp", C2F_RspThreadIDQ503H , F2C_RspOpcodeQ501H,F2C_RspAddressQ501H ,F2C_RspDataQ501H  );
    end //if
end 




always @(posedge clk) begin : RingReqIn
    if (RingReqInValidQ501H) begin 
        $fwrite(trk_rc_transactions,"%t\t| \t%d | %s \t| %4b\t | %d \t| %8h\t| %8h \n",
        $realtime, 0 ,"RingReqIn", RingReqInRequestorQ501H , RingReqInOpcodeQ501H,RingReqInAddressQ501H ,RingReqInDataQ501H  );
    end //if
end 

always @(posedge clk) begin : RingRspIn
    if (RingRspInValidQ501H) begin 
        $fwrite(trk_rc_transactions,"%t\t| \t%d | %s \t| %4b\t | %d \t| %8h\t| %8h \n",
        $realtime, 0 ,"RingRspIn", RingRspInRequestorQ501H , RingRspInOpcodeQ501H,RingRspInAddressQ501H ,RingRspInDataQ501H  );
    end //if
end 

always @(posedge clk) begin : RingReqOut
    if (RingReqOutValidQ503H) begin 
        $fwrite(trk_rc_transactions,"%t\t| \t%d | %s \t| %4b\t | %d \t| %8h\t| %8h \n",
        $realtime, 0 ,"RingReqOut", RingReqOutRequestorQ503H , RingReqOutOpcodeQ503H,RingReqOutAddressQ503H ,RingReqOutDataQ503H  );
    end //if
end 

always @(posedge clk) begin : RingRspOut
    if (RingRspOutValidQ503H) begin 
        $fwrite(trk_rc_transactions,"%t\t| \t%d | %s \t| %4b\t | %d \t| %8h\t| %8h \n",
        $realtime, 0 ,"RingRspOut", RingRspOutRequestorQ503H , RingRspOutOpcodeQ503H,RingRspOutAddressQ503H ,RingRspOutDataQ503H  );
    end //if
end 

always_comb begin
    if(AssertEBREAK) begin
        end_tb(" Finished with EBREAK command");
    end
    
end




