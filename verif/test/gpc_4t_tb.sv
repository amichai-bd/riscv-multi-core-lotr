`timescale 1ns/1ps

`include "lotr_defines.sv"

module gpc_4t_tb ();
    // clock and reset for tb
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
        #80 rst = 1'b0;
    end: reset_gen


    initial begin: backdoor_set_i_mem
            $readmemh("../apps/alive/alive_rv32e_inst_mem.sv", gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.next_mem);
            $readmemh("../apps/alive/alive_rv32e_inst_mem.sv", gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.mem);
    end: backdoor_set_i_mem


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

initial begin 
   #2000 $finish;
end
//====================================make logs====================================
integer f1;
integer f2;
integer f3;
integer f4;
initial begin
    $timeformat(-9, 1, " ", 6);
    f1 = $fopen("../target/trk_write_registers.log","w");
    f2 = $fopen("../target/trk_d_mem_access.log","w");
    f3 = $fopen("../target/trk_all_registers.log","w");
    f4 = $fopen("../target/trk_alu.log","w");

         $fwrite(f1,"---------------------------------------------\n");
         $fwrite(f1,"Time\t| inst\t| CMD\t| data\t| register\t|\n");
         $fwrite(f1,"---------------------------------------------\n");
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
    #10000
    $fclose(f1);  
    $fclose(f2);  
    $fclose(f3);  
    $fclose(f4);  
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
logic        CtrlMemRdQ104H;
logic        CtrlMemWrQ104H;
logic [31:0] MemAdrsQ104H;
logic [31:0] MemWrDataWQ104H;

`LOTR_MSFF(CtrlMemRdQ104H   , gpc_4t_tb.gpc_4t.CtrlMemRdQ103H  , clk)
`LOTR_MSFF(CtrlMemWrQ104H   , gpc_4t_tb.gpc_4t.CtrlMemWrQ103H  , clk)
`LOTR_MSFF(MemAdrsQ104H     , gpc_4t_tb.gpc_4t.MemAdrsQ103H    , clk)
`LOTR_MSFF(MemWrDataWQ104H  , gpc_4t_tb.gpc_4t.MemWrDataWQ103H , clk)
always @(posedge clk) begin : memory_access_print
    if (CtrlMemRdQ104H) begin 
        $fwrite(f2,"%t\t| Adrs:\t%0h \t   \t  | READ\t| rd_data:\t%0h\n", $realtime, MemAdrsQ104H , gpc_4t_tb.gpc_4t.MemRdDataQ104H);
        end
    if (CtrlMemWrQ104H) begin 
        $fwrite(f2,"%t\t| Adrs:\t%0h \t   \t  | WRITE\t| wr_data:\t%0h\n", $realtime,MemAdrsQ104H , MemWrDataWQ104H);
        end
end

always @(posedge clk) begin : alu_print
        $fwrite(f4,"%t\t| ALU_OP:\t%b \t  |AluIn1Q102H \t| rd_data:\t%0h\n", $realtime, MemAdrsQ104H , gpc_4t_tb.gpc_4t.MemRdDataQ104H);
end


//if ( gpc_4t_tb.gpc_4t.core_4t.AssertBadMemAccess) begin
//    $display( "ERROR : AssertBadMemAccess - RD && WR to memory indication same cycle")
//    $finish;
//end



endmodule // tb_top

