`timescale 1ns/1ps

`include "lotr_defines.sv"

module gpc_4t_tb ();

import gpc_4t_pkg::*; 
parameter REG_NUM = 15;

  // sv task that initiate ending routine :
  // 1.snapshot of data memory to text file
  // 2.snapshot of shared data memory to text file
  // 3.snapshot of registers to text file    
  // 4.fclose on all open files    
  // 5.exit test with message   
    task end_tb;
        input string msg;
        integer out1,out2,t0,t1,t2,t3,i,j,l;
        out1=$fopen({"../target/",hpath,"/d_mem_snapshot.log"},"w");
        out2=$fopen({"../target/",hpath,"/shrd_mem_snapshot.log"},"w");  
        t0=$fopen({"../target/",hpath,"/thread0_reg_snapshot.log"},"w");  
        t1=$fopen({"../target/",hpath,"/thread1_reg_snapshot.log"},"w");  
        t2=$fopen({"../target/",hpath,"/thread2_reg_snapshot.log"},"w");  
        t3=$fopen({"../target/",hpath,"/thread3_reg_snapshot.log"},"w");          
        for (i = SIZE_D_MEM; i >= 0; i = i-1) begin  
            $fwrite(out1,"%8b ",gpc_4t_tb.gpc_4t.d_mem_wrap.d_mem.mem[i]);
        end
        for (j = SIZE_D_MEM; j >= SIZE_SHRD_MEM; j = j-1) begin  
            $fwrite(out2,"%8b ",gpc_4t_tb.gpc_4t.d_mem_wrap.d_mem.mem[j]);
        end

        for (l = REG_NUM ; l >= 0; l = l-1) begin  
            $fwrite(t0,"Reg x%1d :%8h \n",l,gpc_4t_tb.gpc_4t.core_4t.Register0QnnnH[l]);
            $fwrite(t1,"Reg x%1d :%8h \n",l,gpc_4t_tb.gpc_4t.core_4t.Register1QnnnH[l]);
            $fwrite(t2,"Reg x%1d :%8h \n",l,gpc_4t_tb.gpc_4t.core_4t.Register2QnnnH[l]);
            $fwrite(t3,"Reg x%1d :%8h \n",l,gpc_4t_tb.gpc_4t.core_4t.Register3QnnnH[l]);            
        end

        $fclose(f1);
        $fclose(f2);  
        $fclose(f3);  
        $fclose(f4);
        $fclose(f5);
        $fclose(f6); 
        $fclose(out1);
        $fclose(out2);
        $fclose(t0);        
        $fclose(t1);
        $fclose(t2);  
        $fclose(t3);          
        $display({"Test : ",hpath,msg});        
        $finish;
        
    endtask
    
    // clock and reset for tb

    logic                   clk;
    logic                   rst;
    
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
    
        `define TEST_DEFINE(x) `"x`"
        `define HPATH 
        string hpath = `TEST_DEFINE(`HPATH);
        integer out,i;
        logic [7:0] outp;
        initial begin: test_seq
                $display(hpath);
                $readmemh({"../verif/Tests/",hpath,"/",hpath,"_inst_mem_rv32i.sv"}, gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.next_mem);
                $readmemh({"../verif/Tests/",hpath,"/",hpath,"_inst_mem_rv32i.sv"}, gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.mem);
                #120000         
                end_tb(" Finished Successfully");
         
    end: test_seq
    


gpc_4t gpc_4t(
              .QClk                 (clk)  ,
              .RstQnnnH             (rst)  ,
              .CoreID               (8'b01) ,
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
    f1 = $fopen({"../target/",hpath,"/trk_write_registers.log"},"w");
    f2 = $fopen({"../target/",hpath,"/trk_d_mem_access.log"},"w");
    f3 = $fopen({"../target/",hpath,"/trk_brach_op.log"},"w");
    f4 = $fopen({"../target/",hpath,"/trk_alu.log"},"w");
    f5 = $fopen({"../target/",hpath,"/trk_error.log"},"w");
    f6 = $fopen({"../target/",hpath,"/trk_shared_space.log"},"w");
    
         $fwrite(f1,"-------------------------------------------------\n");
         $fwrite(f1,"Time\t| Thread| PC \t |Register Num\t| Wr Data\t|\n");
         $fwrite(f1,"-------------------------------------------------\n");
         $fwrite(f2,"-----------------------------------------------------\n");
         $fwrite(f2,"Time\t|     PC   \t | Address\t| Read/Write| data\t\t|\n");
         $fwrite(f2,"-----------------------------------------------------\n");
         $fwrite(f3,"---------------------------------------------------------\n");
         $fwrite(f3,"Time\t|     PC   \t | Branch Op\t| AluIn1\t| AluIn2\t| BranchCond|\n");
         $fwrite(f3,"---------------------------------------------------------\n");
         $fwrite(f4,"---------------------------------------------------------\n");
         $fwrite(f4,"Time\t|\tPC \t  | Alu Op\t\t| AluIn1\t| AluIn2\t| AluOut\t|\n");
         $fwrite(f4,"---------------------------------------------------------\n");    
         $fwrite(f6,"---------------------------------------------------------\n");
         $fwrite(f6,"Time\t\t|\t PC \t | Address\t| Read/Write|\t data\t|\n");
         $fwrite(f6,"---------------------------------------------------------\n");         

end

logic        CtrlMemRdQ104H     ;
logic        CtrlMemWrQ104H     ;
logic        CtrlRegWrQ104H     ;
logic        CtrlBranchQ102H    ;
logic        CtrlBranchQ103H    ;
logic        BranchCondMetQ102H ;
logic        BranchCondMetQ103H ;
logic [6:0]  ALU_OPQ102H        ;
logic [6:0]  ALU_OPQ103H        ;
logic [31:0] AluIn1Q103H        ;
logic [31:0] AluIn2Q103H        ;
logic [31:0] AluOutQ103H        ;
logic [3:0]  RegWrPtrQ104H      ;
logic [3:0]  Funct3Q103H        ;
logic [31:0] MemAdrsQ104H       ;
logic [31:0] MemWrDataWQ104H    ;
logic [31:0] PcQ103H            ;
logic [31:0] PcQ104H            ;
logic [1:0]  threadnum          ;


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
`LOTR_MSFF(AluIn1Q103H  , gpc_4t_tb.gpc_4t.core_4t.AluIn1Q102H , clk)
`LOTR_MSFF(AluIn2Q103H  , gpc_4t_tb.gpc_4t.core_4t.AluIn2Q102H , clk)
`LOTR_MSFF(AluOutQ103H  , gpc_4t_tb.gpc_4t.core_4t.AluOutQ102H , clk)
`LOTR_MSFF(CtrlRegWrQ104H  , gpc_4t_tb.gpc_4t.core_4t.CtrlRegWrQ103H , clk)
`LOTR_MSFF(RegWrPtrQ104H  , gpc_4t_tb.gpc_4t.core_4t.RegWrPtrQ103H , clk)
`LOTR_MSFF(PcQ103H  , gpc_4t_tb.gpc_4t.core_4t.PcQ102H , clk)
`LOTR_MSFF(PcQ104H  , PcQ103H , clk)

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
        $fwrite(f2,"%t\t| %8h\t| %8h\t| READ\t\t| %8h\t| \n", $realtime,PcQ104H, MemAdrsQ104H , gpc_4t_tb.gpc_4t.MemRdDataQ104H);
        end
    if (CtrlMemWrQ104H) begin 
        $fwrite(f2,"%t\t| %8h\t| %8h\t| WRITE\t\t| %8h\t| \n", $realtime,PcQ104H, MemAdrsQ104H , MemWrDataWQ104H);
        end
end

//tracker on write to registers
always @(posedge clk) begin : write_to_registers
    if (CtrlRegWrQ104H && RegWrPtrQ104H!=0) begin 
        $fwrite(f1,"%t\t|\t%2h \t|%8h|\tx%1d \t\t|%8h \t| \n", $realtime,threadnum, PcQ104H, RegWrPtrQ104H , gpc_4t_tb.gpc_4t.core_4t.RegWrDataQ104H);
        end
end

//tracker on ALU operations
always @(posedge clk) begin : alu_print
    if(OPCODE!="NO       " ) begin
        $fwrite(f4,"%t\t| %8h |%s \t|%8h \t|%8h \t|%8h \t| \n", $realtime,PcQ103H,OPCODE, AluIn1Q103H , AluIn2Q103H,AluOutQ103H);
    end
end

//tracker on branch comperator
always @(posedge clk) begin : brnch_print
    if(CtrlBranchQ103H) begin
        $fwrite(f3,"%t\t| %8h |%s \t\t|%8h \t|%8h \t|%8h \t| \n", $realtime,PcQ103H,BrnchOP, AluIn1Q103H , AluIn2Q103H,BranchCondMetQ103H);
    end
end

//tracker to shared space
always @(posedge clk) begin : write_to_shrd
    if (CtrlMemWrQ104H && MemAdrsQ104H > 32'h400800 && MemAdrsQ104H < 32'h400fff ) begin 
        $fwrite(f6,"%t\t| %8h\t| %8h\t| WRITE\t\t| %8h\t| \n", $realtime,PcQ104H,MemAdrsQ104H , MemWrDataWQ104H);
        end
end













//asserssions//
always_comb begin


if(gpc_4t_tb.gpc_4t.core_4t.AssertBadMemAccessReg)begin
    $fwrite(f5,"ERROR : AssertBadMemAccess - Memory access to forbiden memory Region on time %t\nThe Address: %8h",$realtime ,MemAdrsQ104H);
    //$finish;
    end
if(gpc_4t_tb.gpc_4t.core_4t.AssertBadMemAccessCore)begin
    $fwrite(f5,"ERROR : AssertBadMemAccess - Memory access to forbiden memory Core region on time %t\nThe Address: %8h",$realtime ,MemAdrsQ104H);
    //$finish;
    end
if ( gpc_4t_tb.gpc_4t.core_4t.AssertBadMemR_W)begin
    $fwrite(f5, "ERROR : AssertBadMemR_W - RD && WR to memory indication same cycle on time %t\n",$realtime);
    end_tb(" Finished with R\W Error");
    end
if(gpc_4t_tb.gpc_4t.core_4t.AssertIllegalRegister) begin
    $fwrite(f5, "ERROR : AssertIllegalRegister - Illegal register .above 16 on time %t\n",$realtime);
    //$finish;
    end
if(gpc_4t_tb.gpc_4t.core_4t.AssertIllegalPC) begin
    $fwrite(f5, "ERROR : AssertIllegalPC",$realtime);
    end_tb(" Finished with PC overflow");
    end
if(AssertIllegalOpCode) begin
    $fwrite(f5, "ERROR : AssertIllegalOpCode - Illegal OpCode : %7b on time %t\n" ,ALU_OPQ103H,$realtime);
    //$finish;
    end
end
    



endmodule // tb_top

