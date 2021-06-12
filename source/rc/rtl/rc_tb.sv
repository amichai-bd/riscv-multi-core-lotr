`timescale 1ns/1ps

`include "/users/eptzsh/Project/LOTR/riscv-multi-core-lotr/source/rc/rtl/design/lotr_defines.sv"

module rc_tb ();
	// clock and reset for tb
	logic  clk_tb;
	logic  rst_tb;

	// clock generation
	initial begin: clock_gen
		forever begin
			#5 clk_tb = 1'b0;
			#5 clk_tb = 1'b1;
		end
	end: clock_gen

	// reset generation
	initial begin: reset_gen
		rst_tb = 1'b1;
		#40 rst_tb = 1'b0;
	end: reset_gen
	
	logic         RingInputValidQ500H_tb     = '0 ; 
	logic  [1:0]  RingInputOpcodeQ500H_tb    = '0 ; 
	logic  [31:0] RingInputAddressQ500H_tb   = '0 ; 
	logic  [31:0] RingInputDataQ500H_tb      = '0 ; 
	
	logic         RingOutputValidQ502H_tb    = '0 ; 
	logic  [1:0]  RingOutputOpcodeQ502H_tb   = '0 ; 
	logic  [31:0] RingOutputAddressQ502H_tb  = '0 ; 
	logic  [31:0] RingOutputDataQ502H_tb     = '0 ; 
	
	logic         C2F_ReqValidQ500H_tb       = '0 ; 
	logic  [1:0]  C2F_ReqOpcodeQ500H_tb      = '0 ; 
	logic  [1:0]  C2F_ReqThreadIDQ500H_tb    = '0 ; 
	logic  [31:0] C2F_ReqAddressQ500H_tb     = '0 ; 
	logic  [31:0] C2F_ReqDataQ500H_tb        = '0 ; 	
	
	logic  [7:0]  coreID_tb  		         = 8'b0000_0010 ; 
	
	logic         C2F_RspValidQ502H_tb       = '0 ; 
	logic [1:0]   C2F_RspThreadIDQ502H_tb    = '0 ; 
	logic [31:0]  C2F_RspDataQ502H_tb        = '0 ; 
	logic         C2F_RspStall_tb            = '0 ; 
	
	logic         F2C_RspValidQ500H_tb       = '0 ; 
	logic  [1:0]  F2C_RspOpcodeQ500H_tb      = '0 ;  // Fixme -  not sure neccesety - the core recieve only read responses
	logic  [31:0] F2C_RspAddressQ500H_tb     = '0 ; 
	logic  [31:0] F2C_RspDataQ500H_tb        = '0 ; 
	
	logic         F2C_ReqValidQ502H_tb       = '0 ; 
	logic  [1:0]  F2C_ReqOpcodeQ502H_tb      = '0 ; 
	logic  [31:0] F2C_ReqAddressQ502H_tb     = '0 ; 
	logic  [31:0] F2C_ReqDataQ502H_tb 		 = '0 ; 
	
	initial begin: wr_req_in_ring_input
		#95
		RingInputValidQ500H_tb     = 1'b1 ; 
		RingInputOpcodeQ500H_tb    = 2'b10 ; //write
		RingInputAddressQ500H_tb   = 32'h0200_0001 ; 
		RingInputDataQ500H_tb      = 32'h0200_0001 ; 
	end: wr_req_in_ring_input
	
	initial begin: rd_req_from_the_core
		#105
		C2F_ReqValidQ500H_tb       = 1'b1 ; 
		C2F_ReqOpcodeQ500H_tb      = 2'b00 ; //read
		C2F_ReqThreadIDQ500H_tb    = 2'b01 ; 
		C2F_ReqAddressQ500H_tb     = 32'h2000_0001 ; 
		C2F_ReqDataQ500H_tb        = 32'hDEAD_BEEF ; 	
	end: rd_req_from_the_core
	
	initial begin: forward_req
		#115
		RingInputValidQ500H_tb     = 1'b1 ; 
		RingInputOpcodeQ500H_tb    = 2'b10 ;  //write
		RingInputAddressQ500H_tb   = 32'h1100_0001 ; 
		RingInputDataQ500H_tb      = 32'h0000_1111 ; 
	end: forward_req

rc i_rc(	  
			  .QClk  		(clk_tb)         ,
			  .RstQnnnH  	(rst_tb)         ,
			  .RingInputValidQ500H    (RingInputValidQ500H_tb) ,
			  .RingInputOpcodeQ500H   (RingInputOpcodeQ500H_tb) ,
			  .RingInputAddressQ500H  (RingInputAddressQ500H_tb) ,
			  .RingInputDataQ500H     (RingInputDataQ500H_tb) ,
			  .RingOutputValidQ502H   () , // out
			  .RingOutputOpcodeQ502H  () ,// out
			  .RingOutputAddressQ502H () , // out 
			  .RingOutputDataQ502H    () ,// out
			  .C2F_ReqValidQ500H      (C2F_ReqValidQ500H_tb) ,
			  .C2F_ReqOpcodeQ500H     (C2F_ReqOpcodeQ500H_tb) ,
			  .C2F_ReqThreadIDQ500H   (C2F_ReqThreadIDQ500H_tb) ,
			  .C2F_ReqAddressQ500H    (C2F_ReqAddressQ500H_tb) ,
			  .C2F_ReqDataQ500H       (C2F_ReqDataQ500H_tb) ,
			  .coreID       (coreID_tb) ,

			  .C2F_RspValidQ502H      () ,// out
			  .C2F_RspThreadIDQ502H   () ,//out
			  .C2F_RspDataQ502H       () ,//out
			  .C2F_RspStall           () ,	//out		  
			  
			  .F2C_RspValidQ500H      (F2C_RspValidQ500H_tb) ,
			  .F2C_RspOpcodeQ500H     (F2C_RspOpcodeQ500H_tb) , 
			  .F2C_RspAddressQ500H    (F2C_RspAddressQ500H_tb) ,
			  .F2C_RspDataQ500H       (F2C_RspDataQ500H_tb) ,
			  
			  .F2C_ReqValidQ502H      () ,//out
			  .F2C_ReqOpcodeQ502H     () ,//out
			  .F2C_ReqAddressQ502H    () ,//out
			  .F2C_ReqDataQ502H  	  () //out
			 );

initial begin 
   #10000 $finish;
end
//====================================make logs====================================
/*
integer f1;
integer f2;
integer f3;
integer f4;
integer f5;
initial begin
	$timeformat(-9, 1, " ", 6);
	f1 = $fopen("../target/trk_write_registers.log","w");
	f2 = $fopen("../target/trk_d_mem_access.log","w");
	f3 = $fopen("../target/trk_brach_op.log","w");
	f4 = $fopen("../target/trk_alu.log","w");
	f5 = $fopen("../target/trk_error.log","w");

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
logic        CtrlMemRdQ104H     ;
logic        CtrlMemWrQ104H     ;
logic        CtrlRegWrQ104H     ;
logic        CtrlBranchQ102H    ;
logic        CtrlBranchQ103H    ;
logic        BranchCondMetQ102H ;
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

`LOTR_MSFF(CtrlMemRdQ104H   , gpc_4t_tb.gpc_4t.CtrlMemRdQ103H  , clk)
`LOTR_MSFF(CtrlMemWrQ104H   , gpc_4t_tb.gpc_4t.CtrlMemWrQ103H  , clk)
`LOTR_MSFF(MemAdrsQ104H     , gpc_4t_tb.gpc_4t.MemAdrsQ103H    , clk)
`LOTR_MSFF(MemWrDataWQ104H  , gpc_4t_tb.gpc_4t.MemWrDataWQ103H , clk)
`LOTR_MSFF(MemWrDataWQ104H  , gpc_4t_tb.gpc_4t.MemWrDataWQ103H , clk)
`LOTR_MSFF(ALU_OPQ102H  , gpc_4t_tb.gpc_4t.core_4t.OpcodeQ101H , clk)
`LOTR_MSFF(ALU_OPQ103H  , ALU_OPQ102H , clk)
`LOTR_MSFF(Funct3Q103H  , gpc_4t_tb.gpc_4t.core_4t.Funct3Q102H , clk)
`LOTR_MSFF(CtrlBranchQ103H  , CtrlBranchQ102H , clk)
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
	if (CtrlRegWrQ104H && RegWrPtrQ104H!=0 ) begin 
		$fwrite(f1,"%t\t|\t%2h \t|\tx%02d \t\t|%8h \t| \n", $realtime,threadnum, RegWrPtrQ104H , gpc_4t_tb.gpc_4t.core_4t.RegWrDataQ104H);
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
		$fwrite(f3,"%t\t|%s \t\t|%8h \t|%8h \t|%8h \t| \n", $realtime,BrnchOP, AluIn1Q102H , AluIn2Q102H,gpc_4t_tb.gpc_4t.core_4t.BranchCondMetQ102H);
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
if(AssertIllegalOpCode) begin
	$fwrite(f5, "ERROR : AssertIllegalOpCode - Illegal OpCode : %7b on time %t\n" ,ALU_OPQ103H,$realtime);
	$finish;
	end
end
	
	//illegal register
	//illegal opcode
	//func3+7
	
//if ( gpc_4t_tb.gpc_4t.core_4t.AssertBadMemAccess) begin
//    $display( "ERROR : AssertBadMemAccess - RD && WR to memory indication same cycle")
//    $finish;
//end


*/
endmodule // tb_top
