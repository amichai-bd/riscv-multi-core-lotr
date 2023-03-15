`timescale 1ns/1ns

`include "lotr_defines.sv"
module lotr_tb;
import lotr_pkg::*;
	logic         clk      ;
	logic         RstQnnnH  ;
    logic Button_0     ;     
    logic Button_1     ;
    logic [15:0]Arduino_dg_io     ;
    logic [9:0] Switch ;
    logic [7:0] SEG7_0;
    logic [7:0] SEG7_1;
    logic [7:0] SEG7_2;
    logic [7:0] SEG7_3;
    logic [7:0] SEG7_4;
    logic [7:0] SEG7_5;
    logic [9:0] LED ;    
	// clock generation 50MHz
	initial begin: clock_gen
		forever begin
            #10 
            clk = 1'b0;
            #10 
            clk = 1'b1;
		end
	end// clock_gen

	// reset generation
	initial begin: reset_gen
		RstQnnnH = 1'b1;
		#80 
        RstQnnnH = 1'b0;
	end// reset_gen

   // UART PROTOCOL PARAMS
   localparam bit     LSB_FIRST=1;        //[0/1] 0: MSB first,   1: LSB first
   localparam bit     PARITY_EN=0;        //[0/1] 0: disable,     1: enable
   localparam bit     SINGLE_STOP_BIT=1;  //[0/1] 0: 2 stop bits, 1: single
   localparam integer N_DATA_BITS=8;      //[5:8] can be any number between 5 and 8
   localparam integer BUADRATE=115200;    //[] bits per sec
   localparam integer NANOSECOND=1e+9;
   localparam         UART_BIT_PERIOD=(NANOSECOND/BUADRATE);

   logic 	      uart_master_tx; //pc side to uart
   logic 	      uart_master_rx; //pc side to uart
   
   task print(string str);
      $display("-I- time=%0t[ns]: %s",
               $time, str);   
   endtask // print

   task uart_bit_wait(int bits);
      #(bits*UART_BIT_PERIOD);
   endtask // uart_bit_wait

    //uart host to device transmit
   task UART_H2D_transmit;
      input logic [N_DATA_BITS-1:0] data;      
      print($sformatf("UART transmiting Host to Device, Bin:%b, Dec:%d, 0x%x", data, data, data));
      // start bit
      uart_master_tx=1'b0;
      uart_bit_wait(1);       
      // data bits
      for(int i=0; i<N_DATA_BITS; i++) begin
        if(LSB_FIRST) uart_master_tx = data[i];
        else 	      uart_master_tx = data[N_DATA_BITS-1-i] ; 
	 uart_bit_wait(1);
      end		     
      // parity
      if(PARITY_EN) begin 
        uart_master_tx = ^data;
        uart_bit_wait(1);
      end
      // end bits
      uart_master_tx = 1'b1;
      uart_bit_wait((SINGLE_STOP_BIT) ? 1 : 2);
   endtask // UART_H2D_transmit

    task Terminal_Write;
      input logic [3:0][7:0] address;
      input logic [3:0][7:0] data;
      print($sformatf("Terminal transmit opcode: %d address: 0x%x, data: 0x%x", "W", address, data));
      UART_H2D_transmit(32'd87); //W in Ascci
      for(int i=4; i>0; i--)
	      UART_H2D_transmit(address[i-1]);
      for(int i=4; i>0; i--)
	      UART_H2D_transmit(data[i-1]);
   endtask // Terminal_Write
   
   task Terminal_Read;
      input logic [3:0][7:0] address;
      print($sformatf("Terminal transmit opcode: %d address: 0x%x", "R", address));
      UART_H2D_transmit(32'd82); //R in Ascci
      for(int i=4; i>0; --i)
	      UART_H2D_transmit(address[i-1]);
   endtask // Terminal_Read

    task Terminal_Burst_Write;
        input logic [3:0][7:0] address;
        input logic [3:0][7:0] size;
        logic [3:0][7:0] data;
        print($sformatf("Terminal transmit opcode: %d address: 0x%x, size: 0x%x", "WB", address, size));
        UART_H2D_transmit(32'd74);
        for(int i=4; i>0; i--)
            UART_H2D_transmit(address[i-1]);
        for(int i=4; i>0; i--)
            UART_H2D_transmit(size[i-1]);
        repeat(3) begin
            data = $random();
            for(int i=4; i>0; i--)
                UART_H2D_transmit(data[i-1]);
        end
    endtask // Terminal_Write

    task Terminal_Burst_Read;
        input logic [3:0][7:0] address;
        input logic [3:0][7:0] size;
        print($sformatf("Terminal transmit opcode: %d address: 0x%x, size: 0x%x", "RB", address, size));
        UART_H2D_transmit(32'd77);
        for(int i=4; i>0; i--)
            UART_H2D_transmit(address[i-1]);
        for(int i=4; i>0; i--)
            UART_H2D_transmit(size[i-1]);
        repeat(2) begin
            uart_bit_wait(44);
        end
    endtask // Terminal_Write

/*
    initial begin
        uart_master_tx=1'b1;
        uart_bit_wait(1);
        Terminal_Write(32'h03d02018,32'hDEADBEEF);
        uart_bit_wait(10);
        Terminal_Write(32'h03d02018,32'h0);
        uart_bit_wait(10);
        Terminal_Write(32'h03d02018,32'hDEADBEEF);
        uart_bit_wait(10);
        Terminal_Read(32'h03d02018);
        uart_bit_wait(50);
        Terminal_Burst_Write(32'h03d02000, 32'd12);
        uart_bit_wait(10);
        Terminal_Burst_Read(32'h03d02000, 32'd12);
        uart_bit_wait(10);
        $finish;
    end
*/

//================================================================================
//==========================      test_seq      ==================================
//================================================================================
string hpath;
integer file;
logic [7:0]  IMemQnnnH     [I_MEM_OFFSET+SIZE_I_MEM-1:I_MEM_OFFSET];
logic [7:0]  DMemQnnnH     [D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];

`LOTR_MSFF(IMemQnnnH, IMemQnnnH, clk)
`LOTR_MSFF(DMemQnnnH, DMemQnnnH, clk)
localparam    NUM_TILE = 2;
genvar TILE;
int TILE_FOR;
int i,j,k,l;
initial begin: test_seq
    if ($value$plusargs ("STRING=%s", hpath))
        $display("STRING value %s", hpath);
    //======================================
    //load the program to the TB
    //======================================
    $readmemh({"../../../target/lotr/tests/",hpath,"/gcc_files/inst_mem.sv"}, IMemQnnnH);
    file = $fopen({"../../../target/lotr/tests/",hpath,"/gcc_files/data_mem.sv"}, "r");
    if (file) begin
        $fclose(file);
        $readmemh({"../../../target/lotr/tests/",hpath,"/gcc_files/data_mem.sv"}, DMemQnnnH);
    end
    ////TILE 1    
        // Backdoor load the Instruction memory
        lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.i_mem_wrap.i_mem.next_mem = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
        lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.i_mem_wrap.i_mem.mem      = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
        // Backdoor load the Inst1uction memory
        lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.d_mem_wrap.d_mem.next_mem = DMemQnnnH[D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];
        lotr_tb.lotr.gpc_4t_tile_1.gpc_4t.d_mem_wrap.d_mem.mem      = DMemQnnnH[D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];
    ////TILE 2    
        // Backdoor load the Instruction memory
        lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.i_mem_wrap.i_mem.next_mem = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
        lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.i_mem_wrap.i_mem.mem      = IMemQnnnH[I_MEM_OFFSET+SIZE_I_MEM-1:0];
        // Backdoor load the Inst2uction memory
        lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.d_mem_wrap.d_mem.next_mem = DMemQnnnH[D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];
        lotr_tb.lotr.gpc_4t_tile_2.gpc_4t.d_mem_wrap.d_mem.mem      = DMemQnnnH[D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];
    #1000000         
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

logic interrupt;
lotr lotr(
    //general signals input
    .QClk  		(clk),   //input
    .CLK_50  	(clk),   //input
    .Button_0   (~RstQnnnH),
    .Button_1   (1'b0),
    .Switch     (10'h04),
    .Arduino_dg_io (16'b0),
    .uart_master_tx (uart_master_tx),
    .uart_master_rx (uart_master_rx),
    .interrupt      (interrupt),

    //outputs
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
    SHRD_1=$fopen({"../../../target/lotr/tests/",hpath,"/shrd_mem_1_snapshot.log"},"w");   
    SHRD_2=$fopen({"../../../target/lotr/tests/",hpath,"/shrd_mem_2_snapshot.log"},"w");   
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
    fd1 = $fopen({"../../../target/lotr/tests/",hpath,"/screen.log"},"w");
    if (fd1) $display("File was open successfully : %0d", fd1);
    else $display("File was not open successfully : %0d", fd1);
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
    $display({" EOT Test : ",hpath,msg});        
    $finish;
endtask
endmodule // tb_top

