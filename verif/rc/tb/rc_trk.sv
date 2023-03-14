integer rc_trk;
initial begin
    if ($value$plusargs ("STRING=%s", test_name))
        $display("creating tracker in test directory: target/rc/tests/%s", test_name);
    $timeformat(-12, 0, "", 6);
    rc_trk = $fopen({"../../../target/rc/tests/",test_name,"/rc_trk.log"},"w");
    $fwrite(rc_trk, "==================================================================================\n");
    $fwrite(rc_trk, "                      CACHE TOP TRACKER  -  Test: ",test_name,"\n");
    $fwrite(rc_trk, "==================================================================================\n");
    $fwrite(rc_trk,"-----------------------------------------------------------------------------------\n");
    $fwrite(rc_trk," Time  ||      IO       ||    Opcode    ||   Address    ||    Data   ||  Requestor \n");
    $fwrite(rc_trk,"-----------------------------------------------------------------------------------\n");
end
//==================================================
// tracker of the Cache Top Level Interface
//==================================================
always @(posedge QClk_tb) begin
    if(RingReqInValidQ500H_tb) begin
        $fwrite(rc_trk,"%t     RingReqIn       %10s       %h        %h     %h     \n",
        $realtime, 
        RingReqInOpcodeQ500H_tb.name(), 
        RingReqInAddressQ500H_tb, 
        RingReqInDataQ500H_tb,
        RingReqInRequestorQ500H_tb
        );      
    end
    if(RingRspInValidQ500H_tb) begin
        $fwrite(rc_trk,"%t     RingRspIn       %10s       %h        %h     %h     \n",
        $realtime, 
        RingRspInOpcodeQ500H_tb.name(), 
        RingRspInAddressQ500H_tb, 
        RingRspInDataQ500H_tb,
        RingRspInRequestorQ500H_tb
        );      
    end
    if(RingReqOutValidQ502H_tb) begin
        $fwrite(rc_trk,"%t     RingReqOut      %10s       %h        %h     %h     \n",
        $realtime, 
        RingReqOutOpcodeQ502H_tb.name(), 
        RingReqOutAddressQ502H_tb, 
        RingReqOutDataQ502H_tb,
        RingReqOutRequestorQ502H_tb
        );      
    end
    if(RingRspOutValidQ502H_tb) begin
        $fwrite(rc_trk,"%t     RingRspOut      %10s       %h        %h     %h     \n",
        $realtime, 
        RingRspOutOpcodeQ502H_tb.name(), 
        RingRspOutAddressQ502H_tb, 
        RingRspOutDataQ502H_tb,
        RingRspOutRequestorQ502H_tb
        );      
    end
    if(C2F_ReqValidQ500H_tb) begin
        $fwrite(rc_trk,"%t     C2F_Req         %10s       %h        %h     %h     \n",
        $realtime, 
        C2F_ReqOpcodeQ500H_tb.name(), 
        C2F_ReqAddressQ500H_tb, 
        C2F_ReqDataQ500H_tb,
        C2F_ReqThreadIDQ500H_tb
        );      
    end
    if(C2F_RspValidQ502H_tb) begin
        $fwrite(rc_trk,"%t     C2F_Rsp         %10s       %h        %h            \n",
        $realtime, 
        C2F_RspOpcodeQ502H_tb.name(), 
        C2F_RspThreadIDQ502H_tb, 
        C2F_RspDataQ502H_tb 
        );      
    end
    if(F2C_ReqValidQ502H_tb) begin
        $fwrite(rc_trk,"%t     F2C_Req         %10s       %h        %h            \n",
        $realtime, 
        F2C_ReqOpcodeQ502H_tb.name(), 
        F2C_ReqAddressQ502H_tb, 
        F2C_ReqDataQ502H_tb 
        );      
    end
    if(F2C_RspValidQ500H_tb) begin
        $fwrite(rc_trk,"%t     F2C_Rsp         %10s       %h        %h            \n",
        $realtime, 
        F2C_RspOpcodeQ500H_tb.name(), 
        F2C_RspAddressQ500H_tb, 
        F2C_RspDataQ500H_tb 
        );      
    end

end


