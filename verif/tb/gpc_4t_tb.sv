`timescale 1ns/1ps

`include "lotr_defines.sv"

module gpc_4t_tb ();

import lotr_pkg::*; 


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

//================================================================================
//==========================      test_seq      ==================================
//================================================================================
// loading the test from verif/Tests/ - getting the HPATH from Environment
`define TEST_DEFINE(x) `"x`"
`define HPATH 
string hpath = `TEST_DEFINE(`HPATH);

// 

logic [7:0]  IMemQnnnH     [I_MEM_OFFSET+SIZE_I_MEM-1:I_MEM_OFFSET];
logic [7:0]  DMemQnnnH     [D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];

`LOTR_MSFF(IMemQnnnH, IMemQnnnH, clk)
`LOTR_MSFF(DMemQnnnH, DMemQnnnH, clk)

initial begin: test_seq
    $display(hpath);
    //$readmemh({"../verif/Tests/",hpath,"/",hpath,"_inst_mem_rv32i.sv"}, gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.next_mem);
    //$readmemh({"../verif/Tests/",hpath,"/",hpath,"_inst_mem_rv32i.sv"}, gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.mem);
    //======================================
    //load the program to the TB
    //======================================
    $readmemh({"../verif/Tests/",hpath,"/",hpath,"_inst_mem_rv32i.sv"}, IMemQnnnH);
    $readmemh({"../verif/Tests/",hpath,"/",hpath,"_data_mem_rv32i.sv"}, DMemQnnnH);
    // Backdoor load the Instruction memory
    gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.next_mem = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
    gpc_4t_tb.gpc_4t.i_mem_wrap.i_mem.mem      = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
    // Backdoor load the Instruction memory
    gpc_4t_tb.gpc_4t.d_mem_wrap.d_mem.next_mem = DMemQnnnH[D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];
    gpc_4t_tb.gpc_4t.d_mem_wrap.d_mem.mem      = DMemQnnnH[D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];
    #200000         
    end_tb(" Finished Successfully");
end: test_seq
    
//================================================================================
//==========================     GPC_4T instanse   ===============================
//================================================================================
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


//================================================================================
//==========================  tracker and logs  ==================================
//================================================================================
`include "gpc_4t_log_gen.sv"
//================================================================================

// sv task that initiate ending routine :
// 1.snapshot of data memory to text file
// 2.snapshot of shared data memory to text file
// 3.snapshot of registers to text file    
// 4.fclose on all open files    
// 5.exit test with message   
task end_tb;
    input string msg;
    integer out1,out2,i,j,l;
    out1=$fopen({"../target/",hpath,"/d_mem_snapshot.log"},"w");
    $fwrite(out1,"Offset 00000000 : ");
    for (i = 0 ; i < SIZE_D_MEM; i++) begin  
        $fwrite(out1,"%02x ",gpc_4t_tb.gpc_4t.d_mem_wrap.d_mem.mem[i]);
        if ( (i%8)==7) begin
            $fwrite(out1,"\n");
            $fwrite(out1,"Offset %08x : ",i);
        end
    end
    out2=$fopen({"../target/",hpath,"/shrd_mem_snapshot.log"},"w");  
    $fwrite(out2,"Offset %08x : ",SIZE_SHRD_MEM);
    for (j = SIZE_SHRD_MEM; j < SIZE_D_MEM; j++) begin  
        $fwrite(out2,"%02x ",gpc_4t_tb.gpc_4t.d_mem_wrap.d_mem.mem[j]);
        if ( (j%8)==7) begin
            $fwrite(out2,"\n");
            $fwrite(out2,"Offset %08x : ",j);
        end
    end
    $fclose(trk_write_registers);
    $fclose(trk_d_mem_access);  
    $fclose(trk_brach_op);  
    $fclose(trk_alu);
    $fclose(trk_error);
    $fclose(trk_shared_space); 
    $fclose(out1);
    $fclose(out2);
    $fclose(trk_thread0_reg_write);        
    $fclose(trk_thread1_reg_write);
    $fclose(trk_thread2_reg_write);  
    $fclose(trk_thread3_reg_write);          
    $display({"Test : ",hpath,msg});        
    $finish;
endtask
    

endmodule // tb_top

