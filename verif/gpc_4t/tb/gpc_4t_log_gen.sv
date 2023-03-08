integer trk_write_registers;
integer trk_d_mem_access;
integer trk_brach_op;
integer trk_alu;
integer trk_PC0;
integer trk_error;
integer trk_shared_space;
integer trk_thread0_reg_write,trk_thread1_reg_write,trk_thread2_reg_write,trk_thread3_reg_write,trk_cr_space;


initial begin
    $timeformat(-9, 1, " ", 6);
    trk_write_registers   = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_write_registers.log"},"w");
    trk_d_mem_access      = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_d_mem_access.log"},"w");
    trk_brach_op          = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_brach_op.log"},"w");
    trk_alu               = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_alu.log"},"w");
    trk_error             = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_error.log"},"w");
    trk_shared_space      = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_shared_space.log"},"w");
    trk_cr_space          = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_cr_space.log"},"w");
    trk_thread0_reg_write = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_thread0_reg_write.log"},"w");  
    trk_thread1_reg_write = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_thread1_reg_write.log"},"w");  
    trk_thread2_reg_write = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_thread2_reg_write.log"},"w");  
    trk_thread3_reg_write = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_thread3_reg_write.log"},"w");    
    trk_PC0               = $fopen({"../../../target/gpc_4t/tests/",hpath,"/trk_PC0.log"},"w"); 
    $fwrite(trk_write_registers,"-------------------------------------------------\n");
    $fwrite(trk_write_registers,"Time\t| Thread| PC \t |Register Num\t| Wr Data\t|\n");
    $fwrite(trk_write_registers,"-------------------------------------------------\n");
    $fwrite(trk_d_mem_access,"-----------------------------------------------------\n");
    $fwrite(trk_d_mem_access,"Time\t|  Thread|    PC   \t | Address\t| Read/Write| data\t\t|\n");
    $fwrite(trk_d_mem_access,"-----------------------------------------------------\n");
    $fwrite(trk_brach_op,"---------------------------------------------------------\n");
    $fwrite(trk_brach_op,"Time\t|     PC   \t | Branch Op\t| AluIn1\t| AluIn2\t| BranchCond|\n");
    $fwrite(trk_brach_op,"---------------------------------------------------------\n");
    $fwrite(trk_alu,"---------------------------------------------------------\n");
    $fwrite(trk_alu,"Time\t|\tPC \t  | Alu Op\t\t| AluIn1\t| AluIn2\t| AluOut\t|\n");
    $fwrite(trk_alu,"---------------------------------------------------------\n");    
    $fwrite(trk_shared_space,"---------------------------------------------------------\n");
    $fwrite(trk_shared_space,"Time\t\t|\t PC \t | Address\t| Read/Write|\t data\t|\n");
    $fwrite(trk_shared_space,"---------------------------------------------------------\n");         

end //initial


logic        CtrlMemRdQ104H     ;
logic        CtrlMemWrQ104H     ;
logic        CtrlRegWrQ104H     ;
logic        CtrlBranchQ102H    ;
logic        CtrlBranchQ103H    ;
logic        BranchCondMetQ102H ;
logic        BranchCondMetQ103H ;
logic        AssertEBREAK       ;
logic [6:0]  ALU_OPQ102H        ;
logic [6:0]  ALU_OPQ103H        ;
logic [31:0] AluIn1Q103H        ;
logic [31:0] AluIn2Q103H        ;
logic [31:0] AluOutQ103H        ;
logic [4:0]  RegWrPtrQ104H      ;
logic [3:0]  Funct3Q103H        ;
logic [31:0] MemAdrsQ104H       ;
logic [31:0] MemWrDataWQ104H    ;
logic [31:0] PcQ103H            ;
logic [31:0] PcQ104H            ;
logic [1:0]  threadnumQ104H     ;


`LOTR_MSFF(CtrlMemRdQ104H      , gpc_4t_tb.gpc_4t.CtrlMemRdQ103H              , clk)
`LOTR_MSFF(CtrlMemWrQ104H      , gpc_4t_tb.gpc_4t.CtrlMemWrQ103H              , clk)
`LOTR_MSFF(MemAdrsQ104H        , gpc_4t_tb.gpc_4t.MemAdrsQ103H                , clk)
`LOTR_MSFF(MemWrDataWQ104H     , gpc_4t_tb.gpc_4t.MemWrDataQ103H              , clk)
`LOTR_MSFF(ALU_OPQ102H         , gpc_4t_tb.gpc_4t.core_4t.OpcodeQ101H         , clk)
`LOTR_MSFF(ALU_OPQ103H         , ALU_OPQ102H                                  , clk)
`LOTR_MSFF(Funct3Q103H         , gpc_4t_tb.gpc_4t.core_4t.Funct3Q102H         , clk)
`LOTR_MSFF(CtrlBranchQ103H     , CtrlBranchQ102H                              , clk)
`LOTR_MSFF(CtrlBranchQ103H     , CtrlBranchQ102H                              , clk)
`LOTR_MSFF(BranchCondMetQ103H  , gpc_4t_tb.gpc_4t.core_4t.BranchCondMetQ102H  , clk)
`LOTR_MSFF(AluIn1Q103H         , gpc_4t_tb.gpc_4t.core_4t.AluIn1Q102H         , clk)
`LOTR_MSFF(AluIn2Q103H         , gpc_4t_tb.gpc_4t.core_4t.AluIn2Q102H         , clk)
`LOTR_MSFF(AluOutQ103H         , gpc_4t_tb.gpc_4t.core_4t.AluOutQ102H         , clk)
`LOTR_MSFF(CtrlRegWrQ104H      , gpc_4t_tb.gpc_4t.core_4t.CtrlRegWrQ103H      , clk)
`LOTR_MSFF(RegWrPtrQ104H       , gpc_4t_tb.gpc_4t.core_4t.RegWrPtrQ103H       , clk)
`LOTR_MSFF(PcQ103H             , gpc_4t_tb.gpc_4t.core_4t.PcQ102H             , clk)
`LOTR_MSFF(PcQ104H             , PcQ103H                                      , clk)

string OPCODE ,BrnchOP;
logic AssertIllegalOpCode;
assign CtrlBranchQ102H = gpc_4t_tb.gpc_4t.core_4t.CtrlBranchQ102H;
assign AssertIllegalOpCode = (OPCODE == "NO       " && BrnchOP == "NO  " && $realtime > 41);
assign AssertEBREAK = (ALU_OPQ103H == 7'b1110011);


always_comb begin 
    unique casez (gpc_4t_tb.gpc_4t.core_4t.ThreadQ104H)
            4'b0001 : threadnumQ104H = 0;
            4'b0010 : threadnumQ104H = 1;
            4'b0100 : threadnumQ104H = 2;
            4'b1000 : threadnumQ104H = 3;
            default : threadnumQ104H = 0; 
        endcase
    unique casez (Funct3Q103H)
            3'b000  : BrnchOP = "BEQ ";
            3'b001  : BrnchOP = "BNE ";
            3'b100  : BrnchOP = "BLT ";
            3'b101  : BrnchOP = "BGE ";
            3'b110  : BrnchOP = "BLTU";
            3'b111  : BrnchOP = "BGEU";
            default : BrnchOP = "NO  ";
        endcase
    unique casez (ALU_OPQ103H)
            7'b0110111 : OPCODE ="OP_LUI   ";
            7'b0010111 : OPCODE ="OP_AUIPC ";
            7'b1101111 : OPCODE ="OP_JAL   ";
            7'b1100111 : OPCODE ="OP_JALR  ";
            7'b0000011 : OPCODE ="OP_LOAD  ";
            7'b0100011 : OPCODE ="OP_STORE ";
            7'b0010011 : OPCODE ="OP_OPIMM ";
            7'b0110011 : OPCODE ="OP_OP    ";
            7'b0001111 : OPCODE ="OP_FENCE ";
            7'b1110011 : OPCODE ="OP_SYSTEM";
            default    : OPCODE ="NO       ";

        endcase
end

//tracker on memory transactions
always @(posedge clk) begin : memory_access_print
    if (CtrlMemRdQ104H) begin 
        $fwrite(trk_d_mem_access,"%t\t|\t%2h | %8h\t| %8h\t| READ\t\t| %8h\t| \n", $realtime,threadnumQ104H,PcQ104H, MemAdrsQ104H , gpc_4t_tb.gpc_4t.MemRdDataQ104H);
    end //if
    if (CtrlMemWrQ104H) begin 
        $fwrite(trk_d_mem_access,"%t\t|\t%2h | %8h\t| %8h\t| WRITE\t\t| %8h\t| \n", $realtime,threadnumQ104H,PcQ104H, MemAdrsQ104H , MemWrDataWQ104H);
    end //if
end //shared_space

//tracker to shared space
always @(posedge clk) begin : write_to_shrd
    if (CtrlMemWrQ104H && MemAdrsQ104H > 32'h400800 && MemAdrsQ104H < 32'h400fff ) begin 
        $fwrite(trk_shared_space,"%t\t| %8h\t| %8h\t| WRITE\t\t| %8h\t| \n", $realtime,PcQ104H,MemAdrsQ104H , MemWrDataWQ104H);
    end //if
end

//tracker to CR space
always @(posedge clk) begin : CR
    if (CtrlMemWrQ104H && MemAdrsQ104H > 32'hc00000 && MemAdrsQ104H < 32'hc0020c  ) begin 
        $fwrite(trk_cr_space,"%t\t| %8h\t| %8h\t| WRITE\t\t| %8h\t| \n", $realtime,PcQ104H,MemAdrsQ104H , MemWrDataWQ104H);
    end //if
end

//tracker on write to registers
always @(posedge clk) begin : write_to_registers
    if (CtrlRegWrQ104H && RegWrPtrQ104H!=0) begin 
        $fwrite(trk_write_registers,"%t\t|\t%2h \t|%08x|\tx%1d \t\t|%8h \t| \n", $realtime, threadnumQ104H, PcQ104H, RegWrPtrQ104H , gpc_4t_tb.gpc_4t.core_4t.RegWrDataQ104H);
    end //if
end

//tracker on ALU operations
always @(posedge clk) begin : alu_print
    if(OPCODE!="NO       " ) begin
        $fwrite(trk_alu,"%t\t| %8h |%s \t|%8h \t|%8h \t|%8h \t| \n", $realtime,PcQ103H,OPCODE, AluIn1Q103H , AluIn2Q103H,AluOutQ103H);
    end //if
end

//tracker on branch comperator
always @(posedge clk) begin : brnch_print
    if(CtrlBranchQ103H) begin
        $fwrite(trk_brach_op,"%t\t| %8h |%s \t\t|%8h \t|%8h \t|%8h \t| \n", $realtime,PcQ103H,BrnchOP, AluIn1Q103H , AluIn2Q103H,BranchCondMetQ103H);
    end //if
end

//tracker on PC0
always @(posedge clk) begin : trk_PC00
    if(threadnumQ104H==0) begin
        $fwrite(trk_PC0,"%t\t| %8h  \n", $realtime,PcQ104H);
    end //if
end




//tracker on register file
always @(posedge clk) begin : write_register_log
    if (CtrlRegWrQ104H && RegWrPtrQ104H!=0) begin 
        if (threadnumQ104H ==0) begin 
            $fwrite(trk_thread0_reg_write,"%08x)", PcQ104H);
            for (int l = 0 ; l <32; l++) begin  
                 $fwrite(trk_thread0_reg_write," %08x  |",gpc_4t_tb.gpc_4t.core_4t.Register0QnnnH[l]);
            end //for
                 $fwrite(trk_thread0_reg_write,"\n");
        end //if threadnumQ104H
        if (threadnumQ104H ==1) begin 
                 $fwrite(trk_thread1_reg_write,"%08x)", PcQ104H);
            for (int l = 0 ; l <32; l++) begin  
                 $fwrite(trk_thread1_reg_write," %08x  |",gpc_4t_tb.gpc_4t.core_4t.Register1QnnnH[l]);
            end //for
                 $fwrite(trk_thread1_reg_write,"\n");
        end //if threadnumQ104H
        if (threadnumQ104H ==2) begin 
                 $fwrite(trk_thread2_reg_write,"%08x)", PcQ104H);
            for (int l = 0 ; l <32; l++) begin  
                 $fwrite(trk_thread2_reg_write," %08x  |",gpc_4t_tb.gpc_4t.core_4t.Register2QnnnH[l]);
            end //for
                 $fwrite(trk_thread2_reg_write,"\n");
        end //if threadnumQ104H
        if (threadnumQ104H ==3) begin 
                 $fwrite(trk_thread3_reg_write,"%08x)", PcQ104H);
            for (int l = 0 ; l <32; l++) begin  
                 $fwrite(trk_thread3_reg_write," %08x  |",gpc_4t_tb.gpc_4t.core_4t.Register3QnnnH[l]);
            end //for
                 $fwrite(trk_thread3_reg_write,"\n");
        end //if threadnumQ104H
    end
end



//assertions//
always_comb begin
    if(gpc_4t_tb.gpc_4t.core_4t.AssertBadMemAccessReg)begin
        $fwrite(trk_error,"ERROR : AssertBadMemAccess - Memory access to forbiden memory Region on time %t The Address: %8h\n",$realtime ,MemAdrsQ104H);
    end
    if(gpc_4t_tb.gpc_4t.core_4t.AssertBadMemAccessCore)begin
        $fwrite(trk_error,"ERROR : AssertBadMemAccess - Memory access to forbiden memory Core region on time %t The Address: %8h\n",$realtime ,MemAdrsQ104H);
    end
    if ( gpc_4t_tb.gpc_4t.core_4t.AssertBadMemR_W)begin
        $fwrite(trk_error, "ERROR : AssertBadMemR_W - RD && WR to memory indication same cycle on time %t\n",$realtime);
        end_tb(" Finished with R\W Error");
    end
    if(gpc_4t_tb.gpc_4t.core_4t.AssertIllegalRegister) begin
        $fwrite(trk_error, "ERROR : AssertIllegalRegister - Illegal register .above 16 on time %t\n",$realtime);
    end
    if(AssertEBREAK) begin
        end_tb(" Finished with EBREAK command");
    end
    if(gpc_4t_tb.gpc_4t.core_4t.AssertIllegalPC) begin
        $fwrite(trk_error, "ERROR : AssertIllegalPC %t\n",$realtime);
        end_tb(" Finished with PC overflow");
    end    
    if(AssertIllegalOpCode) begin
        $fwrite(trk_error, "ERROR : AssertIllegalOpCode - Illegal OpCode : %7b on time %t\n" ,ALU_OPQ103H, $realtime);
    end
end //always_comb
//    
//
