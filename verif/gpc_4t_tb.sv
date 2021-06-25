`timescale 1ns/1ps

`include "lotr_defines.sv"

module gpc_4t_tb ();
    // clock and reset for tb
    import gpc_4t_pkg::*; 
    logic                   clk;
    logic                   rst;
    
    // allow vcd dump
    //initial begin
    //    if ($test$plusargs("vcd")) begin
    //        $dumpfile("gpc_4t_tb.vcd");
    //        $dumpvars(0, gpc_4t_tb);
    //    end
    //end

    // clock generation
    initial begin: clock_gen
        forever begin
            #5 clk = 1'b0;
            #5 clk = 1'b1;
        end
    end: clock_gen

    // reset generation
    initial begin: reset_gen
            rst = 1'b1;
        #40 rst = 1'b0;
    end: reset_gen


    initial begin: test_seq
            $readmemh("../verif/Tests/Fibonucci/Fibonucci_inst_mem_rv32i.sv", gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.next_mem);
            $readmemh("../verif/Tests/Fibonucci/Fibonucci_inst_mem_rv32i.sv", gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.mem);
            //gpc_4t_tb.gpc_4t.d_mem_wrap.d_mem.mem[SIZE_D_MEM-4] = 0;
            //while (gpc_4t_tb.gpc_4t.d_mem_wrap.d_mem.mem[SIZE_D_MEM-4]==0)  
            //    #4000
           //  //wait until sequence is done. 
           
            //gpc_4t_tb.gpc_4t.d_mem_wrap.d_mem.mem[SIZE_D_MEM-4] = 0;
           // gpc_4t_tb.gpc_4t.d_mem_wrap.d_mem.mem[SIZE_D_MEM-1] = 0;
            //$readmemh("../apps/alive/test_inst_mem_rv32i.sv", gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.next_mem);
            //$readmemh("../apps/alive/test_inst_mem_rv32i.sv", gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.mem);
            //while (gpc_4t_tb.gpc_4t.d_mem_wrap.d_mem.mem[SIZE_D_MEM-1]==0) begin 
            // //wait until sequence is done.   
            //end
            #200000 
            $fclose(f1);  
            $fclose(f2);  
            $fclose(f3);  
            $fclose(f4);
            $fclose(f5);
            $fclose(f6);    
            $finish;
            
    end: test_seq
    


gpc_4t gpc_4t(
              .QClk                 (clk)  ,
              .RstQnnnH             (rst)  ,
              .C2F_RspValidQ502H    ('0)   ,
              .C2F_RspOpcodeQ502H   ('0)   ,
              .C2F_RspThreadIDQ502H ('0)   ,
              .C2F_RspDataQ502H     ('0)   ,
              .C2F_RspStall         ('0)   ,
              .C2F_ReqValidQ500H    (   )  ,
              .C2F_ReqOpcodeQ500H   (   )  ,
              .C2F_ReqThreadIDQ500H (   )  ,
              .C2F_ReqAddressQ500H  (   )  ,
              .C2F_ReqDataQ500H     (   )  ,
              .F2C_ReqValidQ502H    ('0)   ,
              .F2C_ReqOpcodeQ502H   ('0)   ,
              .F2C_ReqAddressQ502H  ('0)   ,
              .F2C_ReqDataQ502H     ('0)   ,
              .F2C_RspValidQ500H    (   )  ,
              .F2C_RspOpcodeQ500H   (   )  ,
              .F2C_RspAddressQ500H  (   )  ,
              .F2C_RspDataQ500H     (   )     
              
             );


//====================================make logs====================================
integer f1;
integer f2;
integer f3;
integer f4;
integer f5;
integer f6;
initial begin
    $timeformat(-9, 1, " ", 6);
    f1 = $fopen("../target/trk_write_registers.log","w");
    f2 = $fopen("../target/trk_d_mem_access.log","w");
    f3 = $fopen("../target/trk_brach_op.log","w");
    f4 = $fopen("../target/trk_alu.log","w");
    f5 = $fopen("../target/trk_error.log","w");
    f6 = $fopen("../target/trk_shared_space.log","w");
    
         $fwrite(f1,"-------------------------------------------------\n");
         $fwrite(f1,"Time\t| Thread | Register Num\t| Wr Data\t|\n");
         $fwrite(f1,"-------------------------------------------------\n");
         $fwrite(f2,"---------------------------------------------\n");
         $fwrite(f2,"Time\t| Address\t| Read/Write| data\t\t|\n");
         $fwrite(f2,"---------------------------------------------\n");
         $fwrite(f3,"---------------------------------------------------------\n");
         $fwrite(f3,"Time\t| Branch Op\t| AluIn1\t| AluIn2\t| BranchCond|\n");
         $fwrite(f3,"---------------------------------------------------------\n");
         $fwrite(f4,"---------------------------------------------------------\n");
         $fwrite(f4,"Time\t| Alu Op\t| AluIn1\t| AluIn2\t| AluOut\t|\n");
         $fwrite(f4,"---------------------------------------------------------\n");         
//    #2000
//    for(int i =0; i<100; i++) begin
//    #500
//        $fwrite(f1,"---------------------------------------------\n");
//        $fwrite(f1,"Time\t| inst\t| CMD\t| data\t| register\t|\n");
//        $fwrite(f1,"---------------------------------------------\n");
//        $fwrite(f3,"---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
//        $fwrite(f3,"  0 |  1\t|  2\t|  3\t|  4\t|  5\t|  6\t|  7\t|  8\t|  9\t|  10\t|  11\t|  12\t|  13\t|  14\t|  15\t|  16\t|  17\t|  18\t|  19\t|\n");
//        $fwrite(f3,"---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
//    end


end

//$timeformat params:
//$timeformat(-9, 1, " ", 6);
//1) Scaling factor (-9 for nanoseconds, -12 for picoseconds)
//2) Number of digits to the right of the decimal point
//3) A string to print after the time value
//4) Minimum field width

//always @(posedge clk) begin : 
//    //if(gpc_4t.core.ctl_reg_wr) begin : register_write_log
//    //    $fwrite(f1,"%t\t| %0h  \t| WRITE\t|  %0h \t|   %0h   \t|\n", $realtime, gpc_4t.inst_memory.address_1, gpc_4t.core.reg_wr_data, gpc_4t.core.reg_wr_ptr );
//    //end
//    
//    //if(gpc_4t.core.ctl_reg_wr) begin
//    //    for(int i=0; i<32; i++) begin
//    //        $fwrite(f3,"  %0h\t ", gpc_4t.core.registers.register[i]);
//    //    end
//    //    $fwrite(f3,"|\n") ;
//    //end
//end 
logic        CtrlMemRdQ104H     ;
logic        CtrlMemWrQ104H     ;
logic        CtrlRegWrQ104H     ;
logic        CtrlBranchQ102H    ;
logic        CtrlBranchQ103H    ;
logic        BranchCondMetQ102H ;
logic        BranchCondMetQ103H ;
logic [6:0]  ALU_OPQ102H        ;
logic [6:0]  ALU_OPQ103H        ;
logic [31:0] AluIn1Q102H        ;
logic [31:0] AluIn2Q102H        ;
logic [31:0] AluOutQ102H        ;
logic [3:0]  RegWrPtrQ104H      ;
logic [3:0]  Funct3Q103H        ;
logic [31:0] MemAdrsQ104H       ;
logic [31:0] MemWrDataWQ104H    ;
logic [1:0]  threadnum          ;
logic r;

`LOTR_MSFF(CtrlMemRdQ104H   , gpc_4t_tb.gpc_4t.CtrlMemRdQ103H  , clk)
`LOTR_MSFF(CtrlMemWrQ104H   , gpc_4t_tb.gpc_4t.CtrlMemWrQ103H  , clk)
`LOTR_MSFF(MemAdrsQ104H     , gpc_4t_tb.gpc_4t.MemAdrsQ103H    , clk)
`LOTR_MSFF(MemWrDataWQ104H  , gpc_4t_tb.gpc_4t.MemWrDataWQ103H , clk)
`LOTR_MSFF(ALU_OPQ102H  , gpc_4t_tb.gpc_4t.core_4t.OpcodeQ101H , clk)
`LOTR_MSFF(ALU_OPQ103H  , ALU_OPQ102H , clk)
`LOTR_MSFF(Funct3Q103H  , gpc_4t_tb.gpc_4t.core_4t.Funct3Q102H , clk)
`LOTR_MSFF(CtrlBranchQ103H  , CtrlBranchQ102H , clk)
`LOTR_MSFF(CtrlBranchQ103H  , CtrlBranchQ102H , clk)
`LOTR_MSFF(BranchCondMetQ103H  , gpc_4t_tb.gpc_4t.core_4t.BranchCondMetQ102H , clk)
`LOTR_MSFF(AluIn1Q102H  , gpc_4t_tb.gpc_4t.core_4t.AluIn1Q102H , clk)
`LOTR_MSFF(AluIn2Q102H  , gpc_4t_tb.gpc_4t.core_4t.AluIn2Q102H , clk)
`LOTR_MSFF(AluOutQ102H  , gpc_4t_tb.gpc_4t.core_4t.AluOutQ102H , clk)
`LOTR_MSFF(CtrlRegWrQ104H  , gpc_4t_tb.gpc_4t.core_4t.CtrlRegWrQ103H , clk)
`LOTR_MSFF(RegWrPtrQ104H  , gpc_4t_tb.gpc_4t.core_4t.RegWrPtrQ103H , clk)

string OPCODE ,BrnchOP;
assign CtrlBranchQ102H = gpc_4t_tb.gpc_4t.core_4t.CtrlBranchQ102H;
assign AssertIllegalOpCode = (OPCODE == "NO       " && BrnchOP == "NO  " && $realtime > 41);


always_comb begin 
    unique casez (gpc_4t_tb.gpc_4t.core_4t.ThreadQ104H)
            4'b0001 : threadnum = 0;
            4'b0010 : threadnum = 1;
            4'b0100 : threadnum = 2;
            4'b1000 : threadnum = 3;
            default : threadnum = 0; 
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
        $fwrite(f2,"%t\t| %8h\t| READ\t\t| %8h\t| \n", $realtime, MemAdrsQ104H , gpc_4t_tb.gpc_4t.MemRdDataQ104H);
        end
    if (CtrlMemWrQ104H) begin 
        $fwrite(f2,"%t\t| %8h\t| WRITE\t\t| %8h\t| \n", $realtime,MemAdrsQ104H , MemWrDataWQ104H);
        end
end

//tracker on write to registers
always @(posedge clk) begin : write_to_registers
    if (CtrlRegWrQ104H && RegWrPtrQ104H!=0 && threadnum == 0) begin 
        $fwrite(f1,"%t\t|\t%2h \t|\tx%02d \t\t|%d \t| \n", $realtime,threadnum, RegWrPtrQ104H , gpc_4t_tb.gpc_4t.core_4t.RegWrDataQ104H);
        end
end

//tracker on ALU operations
always @(posedge clk) begin : alu_print
    if(OPCODE!="NO       " ) begin
        $fwrite(f4,"%t\t|%s \t|%8h \t|%8h \t|%8h \t| \n", $realtime,OPCODE, AluIn1Q102H , AluIn2Q102H,AluOutQ102H);
    end
end

//tracker on branch comperator
always @(posedge clk) begin : brnch_print
    if(CtrlBranchQ103H) begin
        $fwrite(f3,"%t\t|%s \t\t|%8h \t|%8h \t|%8h \t| \n", $realtime,BrnchOP, AluIn1Q102H , AluIn2Q102H,BranchCondMetQ103H);
    end
end

//tracker to shared space
always @(posedge clk) begin : write_to_shrd
    if (CtrlMemWrQ104H && MemAdrsQ104H >= 0'h400f00 && MemAdrsQ104H < 0'h400fff ) begin 
        $fwrite(f6,"%t\t| %8h\t| WRITE\t\t| %d\t| \n", $realtime,MemAdrsQ104H , MemWrDataWQ104H);
        end
end













//asserssions//
always_comb begin
if(gpc_4t_tb.gpc_4t.core_4t.AssertBadMemAccessReg)begin
    $fwrite(f5,"ERROR : AssertBadMemAccess - Memory access to forbiden memory Region on time %t\nThe Address: %8h",$realtime ,MemAdrsQ104H);
    $finish;
    end
if(gpc_4t_tb.gpc_4t.core_4t.AssertBadMemAccessCore)begin
    $fwrite(f5,"ERROR : AssertBadMemAccess - Memory access to forbiden memory Core region on time %t\nThe Address: %8h",$realtime ,MemAdrsQ104H);
    $finish;
    end
if ( gpc_4t_tb.gpc_4t.core_4t.AssertBadMemR_W)begin
    $fwrite(f5, "ERROR : AssertBadMemR_W - RD && WR to memory indication same cycle on time %t\n",$realtime);
    $finish;
    end
if(gpc_4t_tb.gpc_4t.core_4t.AssertIllegalRegister) begin
    $fwrite(f5, "ERROR : AssertIllegalRegister - Illegal register .above 16 on time %t\n",$realtime);
    $finish;
    end
if(gpc_4t_tb.gpc_4t.core_4t.AssertIllegalPC) begin
    $fwrite(f5, "ERROR : AssertIllegalPC",$realtime);
    $display("ERROR: Failed assertion");
    $finish;
    end
if(AssertIllegalOpCode) begin
    $fwrite(f5, "ERROR : AssertIllegalOpCode - Illegal OpCode : %7b on time %t\n" ,ALU_OPQ103H,$realtime);
    //$finish;
    end
end
    
    //illegal register
    //illegal opcode
    //func3+7
    
//if ( gpc_4t_tb.gpc_4t.core_4t.AssertBadMemAccess) begin
//    $display( "ERROR : AssertBadMemAccess - RD && WR to memory indication same cycle")
//    $finish;
//end



endmodule // tb_top

