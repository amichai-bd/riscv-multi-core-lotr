//place holder - see gpc_4t_log_gen.sv as reference
`include "lotr_defines.sv"
integer trk_rc_transactions;

initial begin
    $timeformat(-9, 1, " ", 6);
    trk_rc_transactions   = $fopen({"../../../target/lotr/tests/",hpath,"/trk_RC_transactions.log"},"w");
    $fwrite(trk_rc_transactions,"------------------------------------------------------------------------------------\n");
    $fwrite(trk_rc_transactions,"Time\t| Tile ID\t\t| Channel\t| Requestor \t| OpCode \t| Address \t| Data\t|\n");
    $fwrite(trk_rc_transactions,"------------------------------------------------------------------------------------\n");
        

end //initial

//===================================
// Ring Controler <-> Core Interface
//===================================

//****RC <---> Core C2F*****//
//RC <-- CORE C2F
logic  [2:1]       C2F_ReqValidQ500H;
t_opcode[2:1]      C2F_ReqOpcodeQ500H;
logic  [2:1][31:0] C2F_ReqAddressQ500H;
logic  [2:1][31:0] C2F_ReqDataQ500H;
logic  [2:1][9:0]  C2F_ReqThreadIDQ500H;
//RC --> CORE C2F;
logic   [2:1]      C2F_RspValidQ502H;
t_opcode[2:1]      C2F_RspOpcodeQ502H;
logic  [2:1][31:0] C2F_RspDataQ502H;
logic  [2:1]       C2F_RspStall;
logic  [2:1][9:0]  C2F_RspThreadIDQ502H;
//******RC <---> Core F2C*****//     
//RC_F2C <-- CORE                 
logic  [2:1]       F2C_RspValidQ500H      ;
t_opcode[2:1]      F2C_RspOpcodeQ500H     ;
logic  [2:1][31:0] F2C_RspAddressQ500H    ;
logic  [2:1][31:0] F2C_RspDataQ500H       ;
//RC _F2C --> CORE                
logic  [2:1]       F2C_ReqValidQ502H      ;
t_opcode[2:1]      F2C_ReqOpcodeQ502H     ; 
logic  [2:1][31:0] F2C_ReqAddressQ502H    ;
logic  [2:1][31:0] F2C_ReqDataQ502H       ;

//===================================
// Ring Controler <-> Fabric Inteface
//===================================
//Ring ---> RC , RingReqIn
logic  [3:1]       RingReqInValidQ500H    ;
logic  [3:1][9:0]  RingReqInRequestorQ500H;
t_opcode[3:1]      RingReqInOpcodeQ500H   ;
logic  [3:1][31:0] RingReqInAddressQ500H  ;
logic  [3:1][31:0] RingReqInDataQ500H     ;
//Ring ---> RC , RingRspIn           ;
logic   [2:1]      RingRspInValidQ500H    ;
logic  [2:1][9:0]  RingRspInRequestorQ500H;
t_opcode[2:1]      RingRspInOpcodeQ500H   ;
logic  [2:1][31:0] RingRspInAddressQ500H  ;
logic  [2:1][31:0] RingRspInDataQ500H     ;
//RC   ---> Ring , RingReqOut
logic  [2:1]       RingReqOutValidQ502H     ;
logic  [2:1][9:0]  RingReqOutRequestorQ502H ;
t_opcode[2:1]      RingReqOutOpcodeQ502H    ;
logic  [2:1][31:0] RingReqOutAddressQ502H   ;
logic  [2:1][31:0] RingReqOutDataQ502H      ;
 //RC   ---> Ring , RingRspOut         ;
logic  [4:1]       RingRspOutValidQ502H     ;
logic  [4:1][9:0]  RingRspOutRequestorQ502H ;
t_opcode[4:1]      RingRspOutOpcodeQ502H    ;
logic  [4:1][31:0] RingRspOutAddressQ502H   ;
logic  [4:1][31:0] RingRspOutDataQ502H      ;
logic        AssertEBREAK       ;

string opCode;

assign AssertEBREAK = (lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.core_4t.OpcodeQ101H == 7'b1110011)
                    ||(lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.core_4t.OpcodeQ101H == 7'b1110011);

assign C2F_ReqValidQ500H       [1] = lotr_tb.lotr.gpc_4t_tile_1.C2F_ReqValidQ500H         ;
assign C2F_ReqOpcodeQ500H      [1] = lotr_tb.lotr.gpc_4t_tile_1.C2F_ReqOpcodeQ500H        ;
assign C2F_ReqAddressQ500H     [1] = lotr_tb.lotr.gpc_4t_tile_1.C2F_ReqAddressQ500H       ;
assign C2F_ReqDataQ500H        [1] = lotr_tb.lotr.gpc_4t_tile_1.C2F_ReqDataQ500H          ;
assign C2F_ReqThreadIDQ500H    [1] = lotr_tb.lotr.gpc_4t_tile_1.C2F_ReqThreadIDQ500H      ;
                                                                                              
assign C2F_ReqValidQ500H       [2] = lotr_tb.lotr.gpc_4t_tile_2.C2F_ReqValidQ500H         ;
assign C2F_ReqOpcodeQ500H      [2] = lotr_tb.lotr.gpc_4t_tile_2.C2F_ReqOpcodeQ500H        ;
assign C2F_ReqAddressQ500H     [2] = lotr_tb.lotr.gpc_4t_tile_2.C2F_ReqAddressQ500H       ;
assign C2F_ReqDataQ500H        [2] = lotr_tb.lotr.gpc_4t_tile_2.C2F_ReqDataQ500H          ;
assign C2F_ReqThreadIDQ500H    [2] = lotr_tb.lotr.gpc_4t_tile_2.C2F_ReqThreadIDQ500H      ;
                                                                                        
                                                                                        
assign C2F_RspValidQ502H       [1] = lotr_tb.lotr.gpc_4t_tile_1.C2F_RspValidQ502H         ;
assign C2F_RspOpcodeQ502H      [1] = lotr_tb.lotr.gpc_4t_tile_1.C2F_RspOpcodeQ502H        ;
assign C2F_RspDataQ502H        [1] = lotr_tb.lotr.gpc_4t_tile_1.C2F_RspDataQ502H          ;
assign C2F_RspStall            [1] = lotr_tb.lotr.gpc_4t_tile_1.C2F_RspStall              ;
assign C2F_RspThreadIDQ502H    [1] = lotr_tb.lotr.gpc_4t_tile_1.C2F_RspThreadIDQ502H      ;
                                                                                              
assign C2F_RspValidQ502H       [2] = lotr_tb.lotr.gpc_4t_tile_2.C2F_RspValidQ502H         ;
assign C2F_RspOpcodeQ502H      [2] = lotr_tb.lotr.gpc_4t_tile_2.C2F_RspOpcodeQ502H        ;
assign C2F_RspDataQ502H        [2] = lotr_tb.lotr.gpc_4t_tile_2.C2F_RspDataQ502H          ;
assign C2F_RspStall            [2] = lotr_tb.lotr.gpc_4t_tile_2.C2F_RspStall              ;
assign C2F_RspThreadIDQ502H    [2] = lotr_tb.lotr.gpc_4t_tile_2.C2F_RspThreadIDQ502H      ;
                                                                                          
                                                                                          
assign F2C_ReqValidQ502H       [1] = lotr_tb.lotr.gpc_4t_tile_1.F2C_ReqValidQ502H         ;
assign F2C_ReqOpcodeQ502H      [1] = lotr_tb.lotr.gpc_4t_tile_1.F2C_ReqOpcodeQ502H        ;
assign F2C_ReqAddressQ502H     [1] = lotr_tb.lotr.gpc_4t_tile_1.F2C_ReqAddressQ502H       ;
assign F2C_ReqDataQ502H        [1] = lotr_tb.lotr.gpc_4t_tile_1.F2C_ReqDataQ502H          ;
                                                                                          
assign F2C_ReqValidQ502H       [2] = lotr_tb.lotr.gpc_4t_tile_2.F2C_ReqValidQ502H         ;
assign F2C_ReqOpcodeQ502H      [2] = lotr_tb.lotr.gpc_4t_tile_2.F2C_ReqOpcodeQ502H        ;
assign F2C_ReqAddressQ502H     [2] = lotr_tb.lotr.gpc_4t_tile_2.F2C_ReqAddressQ502H       ;
assign F2C_ReqDataQ502H        [2] = lotr_tb.lotr.gpc_4t_tile_2.F2C_ReqDataQ502H          ;
                                                                                           
                                                                                           
assign F2C_RspValidQ500H       [1] = lotr_tb.lotr.gpc_4t_tile_1.F2C_RspValidQ500H         ;
assign F2C_RspOpcodeQ500H      [1] = lotr_tb.lotr.gpc_4t_tile_1.F2C_RspOpcodeQ500H        ;
assign F2C_RspAddressQ500H     [1] = lotr_tb.lotr.gpc_4t_tile_1.F2C_RspAddressQ500H       ;
assign F2C_RspDataQ500H        [1] = lotr_tb.lotr.gpc_4t_tile_1.F2C_RspDataQ500H          ;
                                                                                          
assign F2C_RspValidQ500H       [2] = lotr_tb.lotr.gpc_4t_tile_2.F2C_RspValidQ500H         ;
assign F2C_RspOpcodeQ500H      [2] = lotr_tb.lotr.gpc_4t_tile_2.F2C_RspOpcodeQ500H        ;
assign F2C_RspAddressQ500H     [2] = lotr_tb.lotr.gpc_4t_tile_2.F2C_RspAddressQ500H       ;
assign F2C_RspDataQ500H        [2] = lotr_tb.lotr.gpc_4t_tile_2.F2C_RspDataQ500H          ;
                                                                                             
                                                                                             
assign RingReqInValidQ500H     [1] =lotr_tb.lotr.gpc_4t_tile_1.RingReqInValidQ500H        ;
assign RingReqInRequestorQ500H [1] =lotr_tb.lotr.gpc_4t_tile_1.RingReqInRequestorQ500H    ;
assign RingReqInOpcodeQ500H    [1] =lotr_tb.lotr.gpc_4t_tile_1.RingReqInOpcodeQ500H       ;
assign RingReqInAddressQ500H   [1] =lotr_tb.lotr.gpc_4t_tile_1.RingReqInAddressQ500H      ;
assign RingReqInDataQ500H      [1] =lotr_tb.lotr.gpc_4t_tile_1.RingReqInDataQ500H         ;
                                                                                          
assign RingReqInValidQ500H     [2] =lotr_tb.lotr.gpc_4t_tile_2.RingReqInValidQ500H        ;
assign RingReqInRequestorQ500H [2] =lotr_tb.lotr.gpc_4t_tile_2.RingReqInRequestorQ500H    ;
assign RingReqInOpcodeQ500H    [2] =lotr_tb.lotr.gpc_4t_tile_2.RingReqInOpcodeQ500H       ;
assign RingReqInAddressQ500H   [2] =lotr_tb.lotr.gpc_4t_tile_2.RingReqInAddressQ500H      ;
assign RingReqInDataQ500H      [2] =lotr_tb.lotr.gpc_4t_tile_2.RingReqInDataQ500H         ;
                                                                                             
                                                                                             
assign RingRspInValidQ500H     [1] = lotr_tb.lotr.gpc_4t_tile_1.RingRspInValidQ500H       ;
assign RingRspInRequestorQ500H [1] = lotr_tb.lotr.gpc_4t_tile_1.RingRspInRequestorQ500H   ;
assign RingRspInOpcodeQ500H    [1] = lotr_tb.lotr.gpc_4t_tile_1.RingRspInOpcodeQ500H      ;
assign RingRspInAddressQ500H   [1] = lotr_tb.lotr.gpc_4t_tile_1.RingRspInAddressQ500H     ;
assign RingRspInDataQ500H      [1] = lotr_tb.lotr.gpc_4t_tile_1.RingRspInDataQ500H        ;
                                                                                          
                                                                                          
assign RingRspInValidQ500H     [2] = lotr_tb.lotr.gpc_4t_tile_2.RingRspInValidQ500H       ;                                                              
assign RingRspInRequestorQ500H [2] = lotr_tb.lotr.gpc_4t_tile_2.RingRspInRequestorQ500H   ;
assign RingRspInOpcodeQ500H    [2] = lotr_tb.lotr.gpc_4t_tile_2.RingRspInOpcodeQ500H      ;
assign RingRspInAddressQ500H   [2] = lotr_tb.lotr.gpc_4t_tile_2.RingRspInAddressQ500H     ;
assign RingRspInDataQ500H      [2] = lotr_tb.lotr.gpc_4t_tile_2.RingRspInDataQ500H        ;
                                                                                             
                                                                                             
assign RingReqOutValidQ502H     [1] = lotr_tb.lotr.gpc_4t_tile_1.RingReqOutValidQ502H     ;
assign RingReqOutRequestorQ502H [1] = lotr_tb.lotr.gpc_4t_tile_1.RingReqOutRequestorQ502H ;
assign RingReqOutOpcodeQ502H    [1] = lotr_tb.lotr.gpc_4t_tile_1.RingReqOutOpcodeQ502H    ;
assign RingReqOutAddressQ502H   [1] = lotr_tb.lotr.gpc_4t_tile_1.RingReqOutAddressQ502H   ;
assign RingReqOutDataQ502H      [1] = lotr_tb.lotr.gpc_4t_tile_1.RingReqOutDataQ502H      ;
                                                                                          
assign RingReqOutValidQ502H     [2] = lotr_tb.lotr.gpc_4t_tile_2.RingReqOutValidQ502H     ;
assign RingReqOutRequestorQ502H [2] = lotr_tb.lotr.gpc_4t_tile_2.RingReqOutRequestorQ502H ;
assign RingReqOutOpcodeQ502H    [2] = lotr_tb.lotr.gpc_4t_tile_2.RingReqOutOpcodeQ502H    ;                                                                                            
assign RingReqOutAddressQ502H   [2] = lotr_tb.lotr.gpc_4t_tile_2.RingReqOutAddressQ502H   ;
assign RingReqOutDataQ502H      [2] = lotr_tb.lotr.gpc_4t_tile_2.RingReqOutDataQ502H      ;  
                                                                                             
                                                                                             
assign RingRspOutValidQ502H     [1] = lotr_tb.lotr.gpc_4t_tile_1.RingRspOutValidQ502H      ;
assign RingRspOutRequestorQ502H [1] = lotr_tb.lotr.gpc_4t_tile_1.RingRspOutRequestorQ502H  ;
assign RingRspOutOpcodeQ502H    [1] = lotr_tb.lotr.gpc_4t_tile_1.RingRspOutOpcodeQ502H     ;
assign RingRspOutAddressQ502H   [1] = lotr_tb.lotr.gpc_4t_tile_1.RingRspOutAddressQ502H    ;
assign RingRspOutDataQ502H      [1] = lotr_tb.lotr.gpc_4t_tile_1.RingRspOutDataQ502H       ;
                                                                                           
assign RingRspOutValidQ502H     [2] = lotr_tb.lotr.gpc_4t_tile_2.RingRspOutValidQ502H      ;
assign RingRspOutRequestorQ502H [2] = lotr_tb.lotr.gpc_4t_tile_2.RingRspOutRequestorQ502H  ;
assign RingRspOutOpcodeQ502H    [2] = lotr_tb.lotr.gpc_4t_tile_2.RingRspOutOpcodeQ502H     ;
assign RingRspOutAddressQ502H   [2] = lotr_tb.lotr.gpc_4t_tile_2.RingRspOutAddressQ502H    ;
assign RingRspOutDataQ502H      [2] = lotr_tb.lotr.gpc_4t_tile_2.RingRspOutDataQ502H       ;

                                                                                             
assign RingReqInValidQ500H     [3] = lotr_tb.lotr.RingReqValidQnnnH       [3] ;
assign RingReqInRequestorQ500H [3] = lotr_tb.lotr.RingReqRequestorQnnnH   [3] ;
assign RingReqInOpcodeQ500H    [3] = lotr_tb.lotr.RingReqOpcodeQnnnH      [3] ;
assign RingReqInAddressQ500H   [3] = lotr_tb.lotr.RingReqAddressQnnnH     [3] ;
assign RingReqInDataQ500H      [3] = lotr_tb.lotr.RingReqDataQnnnH        [3] ;


assign RingRspOutValidQ502H     [4] = lotr_tb.lotr.RingRspValidQnnnH     [4] ;
assign RingRspOutRequestorQ502H [4] = lotr_tb.lotr.RingRspRequestorQnnnH [4] ;
assign RingRspOutOpcodeQ502H    [4] = lotr_tb.lotr.RingRspOpcodeQnnnH    [4] ;
assign RingRspOutAddressQ502H   [4] = lotr_tb.lotr.RingRspAddressQnnnH   [4] ;
assign RingRspOutDataQ502H      [4] = lotr_tb.lotr.RingRspDataQnnnH      [4] ;

//FPGA CR TILE transaction
always @(posedge clk) begin : FPGA_transactions
    if (RingRspOutValidQ502H[4] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s| %8b\t\t | %s \t\t| %8h\t| %8h \n",
        $realtime, 3 ,"RingRspOut", RingRspOutRequestorQ502H[4] , RingRspOutOpcodeQ502H[4].name(),RingRspOutAddressQ502H[4] ,RingRspOutDataQ502H[4]  );
    end //if
    if (RingReqInValidQ500H[3] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s | %8b\t\t | %s \t\t| %8h\t| ",
        $realtime, 3 ,"RingReqIn", RingReqInRequestorQ500H[3] , RingReqInOpcodeQ500H[3].name(),RingReqInAddressQ500H[3] );
        if (RingReqInOpcodeQ500H[3].name() == "RD") begin
            $fwrite(trk_rc_transactions,"%s \n" ,"--------" );end
        else begin
            $fwrite(trk_rc_transactions,"%8h \n"  ,RingReqInDataQ500H[3]  );end             
    end //if
end //always

//tracker on memory transactions
always @(posedge clk) begin : transactions
    if (C2F_ReqValidQ500H[1]) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s \t | %8b\t\t | %s \t\t| %8h\t| ",
        $realtime, 1 ,"C2F_Req", C2F_ReqThreadIDQ500H[1] , C2F_ReqOpcodeQ500H[1].name(),C2F_ReqAddressQ500H[1] );
        if (C2F_ReqOpcodeQ500H[1].name() == "RD") begin
            $fwrite(trk_rc_transactions,"%s \n" ,"--------" );end
        else begin
            $fwrite(trk_rc_transactions,"%8h \n"  ,C2F_ReqDataQ500H[1]  );end             
    end
    
    if (C2F_RspValidQ502H[1] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s \t| %8b\t\t | %s \t\t| %s\t| %8h \n",
        $realtime, 1 ,"C2F_Rsp", C2F_RspThreadIDQ502H[1] , C2F_RspOpcodeQ502H[1].name(),"--------" ,C2F_RspDataQ502H[1]  );
    end //if

    if (F2C_ReqValidQ502H[1] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s \t| %s\t\t | %s \t\t| %8h\t| ",
        $realtime, 1 ,"F2C_Req", "--------" , F2C_ReqOpcodeQ502H[1].name(), F2C_ReqAddressQ502H[1] );
        if (F2C_ReqOpcodeQ502H[1].name() == "RD") begin
            $fwrite(trk_rc_transactions,"%s \n" ,"--------" );end
        else begin
            $fwrite(trk_rc_transactions,"%8h \n"  ,F2C_ReqDataQ502H[1]  );end                     
    end //if

    if (F2C_RspValidQ500H[1] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s \t| %s\t\t | %s \t\t| %8h\t| %8h \n",
        $realtime, 1 ,"F2C_Rsp", "--------" , F2C_RspOpcodeQ500H[1].name(),F2C_RspAddressQ500H[1] ,F2C_RspDataQ500H[1]  );
    end //if

    //if (RingReqOutValidQ502H[1] ) begin 
    //    $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s| %8b\t\t | %s \t\t| %8h\t| ",
    //    $realtime, 1 ,"RingReqOut", RingReqOutRequestorQ502H[1] , RingReqOutOpcodeQ502H[1].name(),RingReqOutAddressQ502H[1] );
    //    if (RingReqOutOpcodeQ502H[1].name() == "RD") begin
    //        $fwrite(trk_rc_transactions,"%s \n" ,"--------" );end
    //    else begin
    //        $fwrite(trk_rc_transactions,"%8h \n" ,RingReqOutDataQ502H[1]  );end         
    //end //if

    if (RingRspOutValidQ502H[1] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s| %8b\t\t | %s \t\t| %8h\t| %8h \n",
        $realtime, 1 ,"RingRspOut", RingRspOutRequestorQ502H[1] , RingRspOutOpcodeQ502H[1].name(),RingRspOutAddressQ502H[1] ,RingRspOutDataQ502H[1]  );
    end //if
    if (RingReqInValidQ500H[1] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s | %8b\t\t | %s \t\t| %8h\t| ",
        $realtime, 1 ,"RingReqIn", RingReqInRequestorQ500H[1] , RingReqInOpcodeQ500H[1].name(),RingReqInAddressQ500H[1]);
        if (RingReqInOpcodeQ500H[1].name() == "RD") begin
            $fwrite(trk_rc_transactions,"%s \n" ,"--------" );end
        else begin
            $fwrite(trk_rc_transactions,"%8h \n"  ,RingReqInDataQ500H[1]  );end             
    end //if

    if (RingRspInValidQ500H[1] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s | %8b\t\t | %s \t\t| %8h\t| %8h \n",
        $realtime, 1 ,"RingRspIn", RingRspInRequestorQ500H[1] , RingRspInOpcodeQ500H[1].name(),RingRspInAddressQ500H[1] ,RingRspInDataQ500H[1]  );
    end //if


    
    
    
    
    
        
    if (C2F_ReqValidQ500H[2]) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s \t | %8b\t\t | %s \t\t| %8h\t| ",
        $realtime, 2 ,"C2F_Req", C2F_ReqThreadIDQ500H[2] , C2F_ReqOpcodeQ500H[2].name(),C2F_ReqAddressQ500H[2]  );
        if (C2F_ReqOpcodeQ500H[2].name() == "RD") begin
            $fwrite(trk_rc_transactions,"%s \n" ,"--------" );end
        else begin
            $fwrite(trk_rc_transactions,"%8h \n"  ,C2F_ReqDataQ500H[2]  );end         
    end
        
     if (C2F_RspValidQ502H[2] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s \t| %8b\t\t | %s \t\t| %s\t| %8h \n",
        $realtime, 2 ,"C2F_Rsp", C2F_RspThreadIDQ502H[2] , C2F_RspOpcodeQ502H[2].name(),"--------" ,C2F_RspDataQ502H[2]  );
    end //if

    if (F2C_ReqValidQ502H[2] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s \t| %s\t\t | %s \t\t| %8h\t| ",
        $realtime, 2 ,"F2C_Req", "--------" , F2C_ReqOpcodeQ502H[2].name(), F2C_ReqAddressQ502H[2]  );
        if (F2C_ReqOpcodeQ502H[2].name() == "RD") begin
            $fwrite(trk_rc_transactions,"%s \n" ,"--------" );end
        else begin
            $fwrite(trk_rc_transactions,"%8h \n"  ,F2C_ReqDataQ502H[2]  );end             
    end //if

    if (F2C_RspValidQ500H[2] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s \t| %s\t\t | %s \t\t| %8h\t| %8h \n",
        $realtime, 2 ,"F2C_Rsp", "--------" , F2C_RspOpcodeQ500H[2].name(),F2C_RspAddressQ500H[2] ,F2C_RspDataQ500H[2]  );
    end //if

    
    //if (RingReqOutValidQ502H[2] ) begin 
    //    $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s| %8b\t\t | %s \t\t| %8h\t| ",
    //    $realtime, 2 ,"RingReqOut", RingReqOutRequestorQ502H[2] , RingReqOutOpcodeQ502H[2].name(),RingReqOutAddressQ502H[2]  );
    //    if (RingReqOutOpcodeQ502H[2].name() == "RD") begin
    //        $fwrite(trk_rc_transactions,"%s \n" ,"--------" );end
    //    else begin
    //        $fwrite(trk_rc_transactions,"%8h \n" ,RingReqOutDataQ502H[2]  );end 
    //end //if
    
    
    if (RingRspOutValidQ502H[2] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s| %8b\t\t | %s \t\t| %8h\t| %8h \n",
        $realtime, 2 ,"RingRspOut", RingRspOutRequestorQ502H[2] , RingRspOutOpcodeQ502H[2].name(),RingRspOutAddressQ502H[2] ,RingRspOutDataQ502H[2]  );
    end //if
    if (RingReqInValidQ500H[2] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s | %8b\t\t | %s \t\t| %8h\t| ",
        $realtime, 2 ,"RingReqIn", RingReqInRequestorQ500H[2] , RingReqInOpcodeQ500H[2].name(),RingReqInAddressQ500H[2] );
        if (RingReqInOpcodeQ500H[2].name() == "RD") begin
            $fwrite(trk_rc_transactions,"%s \n" ,"--------" );end
        else begin
            $fwrite(trk_rc_transactions,"%8h \n"  ,RingReqInDataQ500H[2]  );end             
    end //if

    if (RingRspInValidQ500H[2] ) begin 
        $fwrite(trk_rc_transactions,"%t\t|  %2d\t | %s | %8b\t\t | %s \t\t| %8h\t| %8h \n",
        $realtime, 2 ,"RingRspIn", RingRspInRequestorQ500H[2] , RingRspInOpcodeQ500H[2].name(),RingRspInAddressQ500H[2] ,RingRspInDataQ500H[2]  );
    end //if

end 


always_comb begin
    if(AssertEBREAK) begin
        end_tb(" Finished with EBREAK command");
    end
    
end




