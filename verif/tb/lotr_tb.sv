`timescale 1ns/1ns

`include "lotr_defines.sv"
module lotr_tb ();
import lotr_pkg::*;
	logic         clk      ;
	logic         RstQnnnH  ;
    logic Button_0      ;     
    logic Button_1     ;
    logic [9:0] Switch ;
    logic [6:0] SEG7_0;
    logic [6:0] SEG7_1;
    logic [6:0] SEG7_2;
    logic [6:0] SEG7_3;
    logic [6:0] SEG7_4;
    logic [6:0] SEG7_5;
    logic [9:0] LED ;    
	// clock generation
	initial begin: clock_gen
		forever begin
            #5 
            clk = 1'b0;
            #5 
            clk = 1'b1;
		end
	end// clock_gen

	// reset generation
	initial begin: reset_gen
		RstQnnnH = 1'b1;
		#80 
        RstQnnnH = 1'b0;
	end// reset_gen

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
localparam    NUM_TILE = 2;
genvar TILE;
int TILE_FOR;
int i,j,k,l;
initial begin: test_seq
    $display(hpath);
    //======================================
    //load the program to the TB
    //======================================
    $readmemh({"../verif/Tests/",hpath,"/",hpath,"_inst_mem_rv32i.sv"}, IMemQnnnH);
    $readmemh({"../verif/Tests/",hpath,"/",hpath,"_data_mem_rv32i.sv"}, DMemQnnnH);
    ////TILE 0    
        // Backdoor load the Instruction memory
        lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.i_mem_wrap.i_mem.next_mem = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
        lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.i_mem_wrap.i_mem.mem      = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
        // Backdoor load the Inst1uction memory
        lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.d_mem_wrap.d_mem.next_mem = DMemQnnnH[D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];
        lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.d_mem_wrap.d_mem.mem      = DMemQnnnH[D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];
    ////TILE 1    
        // Backdoor load the Instruction memory
        lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.i_mem_wrap.i_mem.next_mem = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
        lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.i_mem_wrap.i_mem.mem      = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
        // Backdoor load the Inst2uction memory
        lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.d_mem_wrap.d_mem.next_mem = DMemQnnnH[D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];
        lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.d_mem_wrap.d_mem.mem      = DMemQnnnH[D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];
    #300000         
    end_tb(" Finished With time out");
end: test_seq

//generate for ( TILE=0 ; TILE<NUM_TILE ; TILE++) begin : gen_gpc_tile
//initial begin
//    force lotr_tb.lotr.gen_gpc_tile[TILE].gpc_4t_tile.gpc_4t.i_mem_wrap.i_mem.next_mem = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
//    force lotr_tb.lotr.gen_gpc_tile[TILE].gpc_4t_tile.gpc_4t.i_mem_wrap.i_mem.mem      = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
//    #10
//    release lotr_tb.lotr.gen_gpc_tile[TILE].gpc_4t_tile.gpc_4t.i_mem_wrap.i_mem.next_mem;
//    release lotr_tb.lotr.gen_gpc_tile[TILE].gpc_4t_tile.gpc_4t.i_mem_wrap.i_mem.mem     ;
//end
//end endgenerate // generate for


//================================================================================
//==========================     LOTR instanse   ===============================
//================================================================================
lotr lotr(
    //general signals input
    .QClk  		(clk),   //input
    .CLK_50  		(clk),   //input
    .Button_0    (~RstQnnnH),
    .Button_1    (1'b0),
    .Switch      (10'b0),

    //utputs
    .SEG7_0  (SEG7_0),
    .SEG7_1  (SEG7_1),
    .SEG7_2  (SEG7_2),
    .SEG7_3  (SEG7_3),
    .SEG7_4  (SEG7_4),
    .SEG7_5  (SEG7_5),
    .RED     (),//output logic [3:0] 
    .GREEN   (),//output logic [3:0] 
    .BLUE    (),//output logic [3:0] 
    .v_sync  (),//output logic       
    .h_sync  (),//output logic      
    .LED     (LED)
    );

//================================================================================
//==========================  tracker and logs  ==================================
//================================================================================
`include "lotr_log_gen.sv"
//================================================================================


//================================================================================
//===============================  End-Of-Test  ==================================
//================================================================================
// sv task that initiate ending routine :
// 1.snapshot of data memory to text file
// 2.snapshot of shared data memory to text file
// 3.snapshot of registers to text file    
// 4.fclose on all open files    
// 5.exit test with message   
// define data memory sizes


// define VGA memory sizes
parameter SIZE_VGA_MEM       = 38400;


task end_tb;
    input string msg;
    integer SHRD_1,SHRD_2,fd1;
    string draw;
    SHRD_1=$fopen({"../target/",hpath,"/shrd_mem_1_snapshot.log"},"w");   
    SHRD_2=$fopen({"../target/",hpath,"/shrd_mem_2_snapshot.log"},"w");   
    for (i = SIZE_SHRD_MEM ; i < SIZE_D_MEM; i = i+4) begin  
        $fwrite(SHRD_1,"Offset %08x : %02x%02x%02x%02x\n",i+D_MEM_OFFSET, lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.d_mem_wrap.d_mem.mem[i+3],
                                                                          lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.d_mem_wrap.d_mem.mem[i+2],
                                                                          lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.d_mem_wrap.d_mem.mem[i+1],
                                                                          lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.d_mem_wrap.d_mem.mem[i]);
        $fwrite(SHRD_2,"Offset %08x : %02x%02x%02x%02x\n",i+D_MEM_OFFSET, lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.d_mem_wrap.d_mem.mem[i+3],
                                                                          lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.d_mem_wrap.d_mem.mem[i+2],
                                                                          lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.d_mem_wrap.d_mem.mem[i+1],
                                                                          lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.d_mem_wrap.d_mem.mem[i]);
    end 
        // VGA memory snapshot - simulate a screen
    fd1 = $fopen({"../target/",hpath,"/screen.log"},"w");
    if (fd1) $display("File was open succesfully : %0d", fd1);
    else $display("File was not open succesfully : %0d", fd1);
    for (i = 0 ; i < 38400; i = i+320) begin // Lines
        for (j = 0 ; j < 4; j = j+1) begin // Bytes
            for (k = 0 ; k < 320; k = k+4) begin // Words
                for (l = 0 ; l < 8; l = l+1) begin // Bits  
                    draw = (lotr_tb.lotr.fpga_tile.DE10Lite_MMIO.vga_ctrl.vga_mem.VGAMem[k+j+i][l] === 1'b1) ? "x" : " ";
                    $fwrite(fd1,"%s",draw);
                end        
            end 
            $fwrite(fd1,"\n");
        end
    end
    $fclose(fd1);
    $fclose(SHRD_1);
    $fclose(SHRD_2);
    $fclose(trk_rc_transactions);
    $display({"Test : ",hpath,msg});        
    $finish;
endtask
endmodule // tb_top

