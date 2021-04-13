`timescale 1ns/1ps

`include "gpc_4t_defines.sv"

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
            $readmemh("../apps/alive/alive_rv32e_inst_mem.sv", gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.next_mem);
            rst = 1'b1;
        #80 rst = 1'b0;
    end: reset_gen

gpc_4t gpc_4t(
              .QClk      (clk),
              .RstQnnnH  (rst)
             );
initial begin 
end
//====================================make logs====================================
//integer f1;
//integer f2;
//integer f3;
//initial begin
//    $timeformat(-9, 1, " ", 6);
//    f1 = $fopen("../target/write_regirsters_trks.log","w");
//    f2 = $fopen("../target/data_mem_access_trks.log","w");
//    f3 = $fopen("../target/all_registers_trks.log","w");
//
//         $fwrite(f1,"---------------------------------------------\n");
//         $fwrite(f1,"Time\t| inst\t| CMD\t| data\t| register\t|\n");
//         $fwrite(f1,"---------------------------------------------\n");
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
//    #10000
//    $fclose(f1);  
//    $fclose(f2);  
//    $fclose(f3);  
//end

//$timeformat params:
//$timeformat(-9, 1, " ", 6);
//1) Scaling factor (-9 for nanoseconds, -12 for picoseconds)
//2) Number of digits to the right of the decimal point
//3) A string to print after the time value
//4) Minimum field width
//always @(posedge clk) begin
//    if(gpc_4t.core.ctl_reg_wr) begin
//        $fwrite(f1,"%t\t| %0h  \t| WRITE\t|  %0h \t|   %0h   \t|\n", $realtime, gpc_4t.inst_memory.address_1, gpc_4t.core.reg_wr_data, gpc_4t.core.reg_wr_ptr );
//    end
//    
//    if(gpc_4t.core.ctl_reg_wr) begin
//        for(int i=0; i<32; i++) begin
//            $fwrite(f3,"  %0h\t ", gpc_4t.core.registers.register[i]);
//        end
//        $fwrite(f3,"|\n") ;
//    end
//end 
//
//always @(posedge clk) begin //FIXME - make better logs
//    if (gpc_4t.data_mem.ctl_mem_rd_1) begin 
//        $fwrite(f2,"%t\t| Instraction:\t%0h\t| Adrs:\t%0h\t| READ\t| rd_data:\t%0h\n", $realtime, gpc_4t.inst_memory.address_1 ,gpc_4t.data_mem.address_1, gpc_4t.data_mem.mem_rd_data_1);
//        end
//    if (gpc_4t.data_mem.ctl_mem_wr_1) begin 
//        $fwrite(f2,"%t\t| Instraction:\t%0h\t| Adrs:\t%0h\t| WRITE\t| wr_data:\t%0h\n", $realtime,gpc_4t.inst_memory.address_1 ,gpc_4t.data_mem.address_1, gpc_4t.data_mem.mem_wr_data_1);
//        end
//end

endmodule // tb_top


