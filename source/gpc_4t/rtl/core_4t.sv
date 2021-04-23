//-----------------------------------------------------------------------------
// Title            : core_4t 
// Project          : gpc_4t
//-----------------------------------------------------------------------------
// File             : core_4t 
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Created          : 2/2021
//-----------------------------------------------------------------------------
// Description :
// The "core_4t" in a single RTL core module that supports 4 threads
// ----4 PipeStage----
// 1) Q100H Send Pc to Instruction Memory - Instruction Fetch
// 2) Q101H Instruction Decode 
// 3) Q102H Excecute 
// 4) Q103H Sent Address+Data to Data Memory 
// 4) Q104H Writeback data from Memory/ALU to Registerfile

//------------------------------------------------------------------------------
// Modification history :
//
//
//------------------------------------------------------------------------------

`include "gpc_4t_defines.sv"
module core_4t 
    import gpc_4t_pkg::*;  
    (
    input  logic        QClk            ,
    input  logic        RstQnnnH        ,
    //Instruction Memory
    output logic [31:0] PcQ100H         ,
    input  logic [31:0] InstFetchQ101H, 		//the input from the i_mem. the instruction. already sampled in a @ff at the i_mem
    //Data Memory
    output logic [31:0] MemAdrsQ102H    ,
    output logic [31:0] MemWrDataWQ102H ,
    output logic        CtrlMemWrQ102H  ,
    output logic        CtrlMemRdQ102H  ,
    output logic [3:0]  MemByteEnQ102H  ,
    input  logic [31:0] MemRdDataQ103H  ,
    //MMIO
    input  t_cr         CRQnnnH,
    output t_dfd_reg    DftSignlasQnnnH
    );
//	general signals
logic 	RstQnn1H;
logic 	DervRstQnn1H;

//  program counter
logic [31:0]        PcPlus4Q101H; 
logic [31:0]        NextPcQnnnH;
logic               EnPcQnnnH;

//  registers
logic [4:0]         RegRdPtr1Q101H;
logic [4:0]         RegRdPtr2Q101H;
logic [31:0]        RegRdData1Q101H;
logic [31:0]        RegRdData2Q101H;
logic [31:0]        RegRdData3Q101H;
logic [4:0]         RegWrPtrQ101H;
logic [4:0]         RegWrPtrQ102H;
logic [4:0]         RegWrPtrQ103H;
logic [31:0]        RegWrDataQ103H;
logic [31:0][31:0]  RegisterQnnnH;
logic [31:0][31:0]  NextRegisterQnnnH;
logic               CtrlRegWrQ102H;

//  ALU
logic [31:0]        AluOutQ101H; 
logic [31:0]        AluOutQ102H;
logic [31:0]        AluOutQ103H;
logic [31:0]        AluIn1Q101H;
logic [31:0]        AluIn1Q102H;
logic [31:0]        AluIn2Q101H;

//  Immediate Formats
logic [31:0]        InstructionQ101H;			//intenal logic to assign the input instruction or a NOP
logic [31:0]        I_ImmediateQ101H; 
logic [31:0]        S_ImmediateQ101H; 
logic [31:0]        B_ImmediateQ101H; 
logic [31:0]        U_ImmediateQ101H; 
logic [31:0]        J_ImmediateQ101H; 
logic [2:0]         Funct3Q101H;
logic [6:0]         Funct7Q101H;
logic [4:0]         ShamtQ101H;

//  control signals
logic [3:0]         CtrlAluOpQ101H    ;
logic               CtrlJalQ101H      ;
logic               CtrlJalrQ101h     ;
logic               CtrlBranchQ101H   ;
logic               CtrlITypeImmQ101H ;
logic               CtrlRegWrQ101H    ;
logic               CtrlLuiQ101H      ;
logic               CtrlAuiPcQ101H    ;
logic               CtrlMemToRegQ101H ;
logic               CtrlMemRdQ101H    ;
logic               CtrlMemWrQ101H    ;
logic               CtrlStoreQ101H    ;
logic               CtrlInsertNopQ101H;
logic               CtrlInsertNopQ102H;
logic               CtrlMemToRegQ102H;
logic               CtrlPcToRegQ102H;

logic [6:0]         OpcodeQ101H;


logic [31:0]        PcPlus4Q102H;
logic [31:0]        PcBranchQ101H;
logic [31:0]        PcQ101H;
logic [31:0]        PcPlus4Q100H;
logic               BranchCondMetQ101H;
logic               CtrlMemToRegQ103H;
logic               CtrlPcToRegQ103H;
logic [31:0]        PcPlus4Q103H;
logic               CtrlRegWrQ103H;

logic [3:0]         NextThreadQ100H;
logic [3:0]         ThreadQ100H;
logic [3:0]         ThreadQ101H;
logic [3:0]         ThreadQ102H;
logic [3:0]         ThreadQ103H;
logic [3:0]         ShftRegQ100H;
logic [3:0]         NextShftRegQ100H;
logic [3:0]         EnPCQnnnH;
logic               T0EnPcQnnnH;
logic               T1EnPcQnnnH;
logic               T2EnPcQnnnH;
logic               T3EnPcQnnnH;
logic [31:0]        T0PcQ100H;
logic [31:0]        T1PcQ100H;
logic [31:0]        T2PcQ100H;
logic [31:0]        T3PcQ100H;

////////////////////////////////////////////////////////////////////////////////////////
//          CORE_4t Module Code
////////////////////////////////////////////////////////////////////////////////////////


//**************************************************************Q100H**************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//


// ========= Thread Logic ==============
// 		Shift register to move the "valid" thread for each Cycle.
//		As long as RstQnnnH is up, ThreadQ100H is 0001 (Thread 0)
//		Due to the assign bits breakdown form , NextThreadQ100H gets the value 0010 from ThreadQ100H bits
//		ThreadQ101H, ThreadQ102H and ThreadQ103H will get the values 1000 , 0100 ,0010 
//		When RstQnnnH sets down the Shift register start moving the valid bit with only a single flip-flop that
//		sets ThreadQ100H to NextThreadQ100H value (0010) in the next cycle and because of assign statments all other Threads
//		are shifted as shows on the table
//		The assign statments are equivalent to use `GPC_MSFF with much less resources
// 		Great credit to Amichai Ben-David for the economical and efficient implementation

logic [3:0]	RstVal = 4'b0001;
assign NextThreadQ100H = {ThreadQ100H[2:0], ThreadQ100H[3]};
`GPC_RST_VAL_MSFF(ThreadQ100H, NextThreadQ100H, QClk, RstQnnnH, RstVal)
assign ThreadQ101H = {ThreadQ100H[0] , ThreadQ100H[3:1]} ; //`GPC_MSFF(ThreadQ101H, ThreadQ100H, QClk)
assign ThreadQ102H = {ThreadQ101H[0] , ThreadQ101H[3:1]} ; //`GPC_MSFF(ThreadQ102H, ThreadQ101H, QClk)
assign ThreadQ103H = {ThreadQ102H[0] , ThreadQ102H[3:1]} ; //`GPC_MSFF(ThreadQ103H, ThreadQ102H, QClk) 
//    	-----------------------------------------
//    	          |  Q100H  Q101H  Q102H  Q103H
//    	-----------------------------------------
//    	 cycle 0  |  0001   1000   0100   0010
//    	 cycle 1  |  0010   0001   1000   0100   
//    	 cycle 2  |  0100   0010   0001   1000
//    	 cycle 3  |  1000   0100   0010   0001
//    	 cycle 4  |  0001   1000   0100   0010
//    	 cycle 5  |  0010   0001   1000   0100   
//    	 cycle 6  |  0100   0010   0001   1000
//    	 cycle 7  |  1000   0100   0010   0001


////////////////////////////////////////////////////////////////////////////////////////
//          Instruction "Fetch" - Send Pc to Instruction Memory 
//			Four Seperate Program Counters - one for each thread.
//			The next PC for each thread calculated at Q102H pipe stage
//			Each PC samples the value from Q102H and its enable signal toggle when 
//			the thread he represents is currently running on Q102H
////////////////////////////////////////////////////////////////////////////////////////   
   
   
assign EnPCQnnnH   = 4'b0001; //Enable Only Thread 0 FIXME - this is Temp for Enabling the PIPE for Single Thread.
assign T0EnPcQ100H = EnPCQnnnH[0] && ThreadQ102H[0];
assign T1EnPcQ100H = EnPCQnnnH[1] && ThreadQ102H[1];
assign T2EnPcQ100H = EnPCQnnnH[2] && ThreadQ102H[2];
assign T3EnPcQ100H = EnPCQnnnH[3] && ThreadQ102H[3];
  
`GPC_EN_RST_MSFF( T0PcQ100H, PcQ102H, QClk, T0EnPcQnnnH, RstQnnnH) 
`GPC_EN_RST_MSFF( T1PcQ100H, PcQ102H, QClk, T1EnPcQnnnH, RstQnnnH) 
`GPC_EN_RST_MSFF( T2PcQ100H, PcQ102H, QClk, T2EnPcQnnnH, RstQnnnH) 
`GPC_EN_RST_MSFF( T3PcQ100H, PcQ102H, QClk, T3EnPcQnnnH, RstQnnnH) 

always_comb begin : next_thread's_pc_sel
	//mux 4:1
    unique casez (ThreadQ100H) 
        4'b0001  : PcQ100H = T0PcQ100H; 
        4'b0010  : PcQ100H = T1PcQ100H; 
        4'b0100  : PcQ100H = T2PcQ100H; 
        default  : PcQ100H = T3PcQ100H;
    endcase
end

//the PC+4 adder
PcPlus4Q100H  = PcQ100H + 32'd4;


/// 	Q100H to Q101H Flip Flops. 
///		Data from I_MEM is sampled inside I_MEM module
`GPC_MSFF       ( PcQ101H, PcQ100H,  QClk ) 
`GPC_MSFF       ( PcPlus4Q101H, PcPlus4Q100H,  QClk ) 


//**************************************************************Q101H**************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//


////////////////////////////////////////////////////////////////////////////////////////
//          Instruction "Decode" per Opcode Type - R/I/S/B/U/J Types
// 			Here we break the InstructionQ101H into every possible Type 
////////////////////////////////////////////////////////////////////////////////////////

assign InstructionQ101H = CtrlInsertNopQ101H ? NOP : InstFetchQ101H;		//internal logic for the instruction - the input or NOP
////////////////////////////////////////
//			Immediate Generator
////////////////////////////////////////
assign U_ImmediateQ101H = { InstructionQ101H[31:12] , 12'b0 } ; 
assign I_ImmediateQ101H = { {20{InstructionQ101H[31]}} , InstructionQ101H[31:25] , InstructionQ101H[24:20] }; 
assign S_ImmediateQ101H = { {20{InstructionQ101H[31]}} , InstructionQ101H[31:25] , InstructionQ101H[11:7]  }; 
assign B_ImmediateQ101H = { {20{InstructionQ101H[31]}} , InstructionQ101H[7]     , InstructionQ101H[30:25] , InstructionQ101H[11:8]  , 1'b0}; 
assign J_ImmediateQ101H = { {12{InstructionQ101H[31]}} , InstructionQ101H[19:12] , InstructionQ101H[20]    , InstructionQ101H[30:21] , 1'b0}; 
////////////////////////////////////////
//			Instruction "BreakDown"
////////////////////////////////////////
assign RegRdPtr1Q101H   = InstructionQ101H[19:15];			// rs1 register for R/S/I/B Type
assign RegRdPtr2Q101H   = InstructionQ101H[24:20];			// rs2 register for R/S/B Type
assign RegWrPtrQ101H    = InstructionQ101H[11:7];			// rd register for R/I/U/J Type
assign Funct3Q101H      = InstructionQ101H[14:12];			// function3 for R/S/I/B Type
assign Funct7Q101H      = InstructionQ101H[31:25];			// function7 for R Type
assign ShamtQ101H       = InstructionQ101H[24:20];			// number to logical shift 
assign OpcodeQ101H      = InstructionQ101H[6:0];			// opcode for each possible Type  

// Insert NOP - (back pressure, Wait for Read, ext..)
// FIXME - currently Enable only Thread0; ->Insert NOP for any other Thread
assign CtrlInsertNopQ101H = (ThreadQ101H != 4'b0001);       

////////////////////////////////////////////////////////////////////////////////////////
//          Registers
////////////////////////////////////////////////////////////////////////////////////////
//Align Latency of registers write Data and Pointers to Q103H
`GPC_MSFF( AluOutQ102H,     AluOutQ101H  , QClk)
`GPC_MSFF( AluOutQ103H,     AluOutQ102H  , QClk)
`GPC_MSFF( RegWrPtrQ102H,   RegWrPtrQ101H, QClk)
`GPC_MSFF( RegWrPtrQ103H,   RegWrPtrQ102H, QClk)
 
//write to register file using the Q103H Data & Ptr
always_comb begin : write_register_file
    unique casez ({CtrlMemToRegQ103H,CtrlPcToRegQ103H}) 
        2'b01   : RegWrDataQ103H = PcPlus4Q103H   ; //Data from PC
        2'b10   : RegWrDataQ103H = MemRdDataQ103H ; //Data from Memory
        default : RegWrDataQ103H = AluOutQ103H    ; //Data from ALU (Common case)
    endcase
    //write to register
    NextRegisterQnnnH            = RegisterQnnnH;   // defualt -> keep old value
    if ( CtrlRegWrQ103H ) begin
        NextRegisterQnnnH[RegWrPtrQ103H] = RegWrDataQ103H;// If CtrlRegWrQ103H - Write to register file Only in the RegWrPtrQ103H location
    end //if
	
	//init for stack pointer
    NextRegisterQnnnH[0]         = 32'b0;           // Register[0] always '0;
	if (DervRstQnn1H) begin
		NextRegisterQnnnH[2]		 = 32'hf00;		//sp
		NextRegisterQnnnH[8] 		 = 32'hf00; 	//s0		
	end


end //always_comb
`GPC_MSFF(RstQnn1H,RstQnnnH,QClk)
assign DervRstQnn1H = (RstQnn1H && (!RstQnnnH));
//========The registers=========================
`GPC_RST_MSFF(RegisterQnnnH, NextRegisterQnnnH, QClk, RstQnnnH) 
//==============================================

//Read from RegisterQnnnH - Include fowording units 
always_comb begin : read_register_file
    RegRdData1Q101H = RegisterQnnnH[RegRdPtr1Q101H];
    RegRdData2Q101H = RegisterQnnnH[RegRdPtr2Q101H];
    //////////////////////
    //   fowording units  - no need
    //////////////////////
    // Q102H WrPtr == Q101H RdPtr
    // if((RegRdPtr1Q101H == RegWrPtrQ102H ) && CtrlRegWrQ102H && (RegWrPtrQ102H!=5'b0)) begin
        // RegRdData1Q101H = AluOutQ102H; 
    // end
    // if((RegRdPtr2Q101H == RegWrPtrQ102H ) && CtrlRegWrQ102H && (RegWrPtrQ102H!=5'b0)) begin
        // RegRdData2Q101H = AluOutQ102H; 
    // end
    // // Q103H WrPtr == Q101H RdPtr
    // if((RegRdPtr1Q101H == RegWrPtrQ103H ) && CtrlRegWrQ103H && (RegWrPtrQ103H!=5'b0)) begin
        // RegRdData1Q101H = RegWrDataQ103H; 
    // end
    // if((RegRdPtr2Q101H == RegWrPtrQ103H ) && CtrlRegWrQ103H && (RegWrPtrQ103H!=5'b0)) begin
        // RegRdData2Q101H = RegWrDataQ103H; 
    // end
end

`GPC_MSFF(PcPlus4Q103H,      PcPlus4Q102H,      QClk)
`GPC_MSFF(CtrlMemToRegQ102H, CtrlMemToRegQ101H, QClk)
`GPC_MSFF(CtrlMemToRegQ103H, CtrlMemToRegQ102H, QClk)
`GPC_MSFF(CtrlPcToRegQ103H,  CtrlPcToRegQ102H,  QClk)
`GPC_MSFF(CtrlRegWrQ102H,    CtrlRegWrQ101H  ,  QClk) 
`GPC_MSFF(CtrlRegWrQ103H,    CtrlRegWrQ102H  ,  QClk) 

`GPC_MSFF       ( PcQ102H, PcQ101H,  QClk ) 
`GPC_MSFF       ( PcPlus4Q102H, PcPlus4Q101H,  QClk ) 
//**************************************************************Q102H**************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//

always_comb begin : branch_calc
    PcBranchQ102H = PcQ102H + B_ImmediateQ102H; // ALU will set if branch condition met			
end


////		PC Selector
always_comb begin : set_next_pc	
	//mux 4:1
    unique casez ({ CtrlJalrQ101h , CtrlJalQ101H , BranchCondMetQ101H}) 
        3'b001  : NextPcQnnnH = PcBranchQ102H;     // OP_BRANCH 			
        3'b010  : NextPcQnnnH = J_ImmediateQ102H;  // OP_JAL
        3'b100  : NextPcQnnnH = AluOutQ102H;       // OP_JALR ALU output I_ImmediateUQ101H + rs1
        default : NextPcQnnnH = PcPlus4Q102H;
    endcase
end

assign BrOrJmpQ102H = ( CtrlJalrQ101h || CtrlJalQ101H || BranchCondMetQ101H);	//102


////////////////////////////////////////////////////////////////////////////////////////
//          ALU
////////////////////////////////////////////////////////////////////////////////////////
always_comb begin : choose_alu_input
    unique casez ({ CtrlLuiQ101H, CtrlAuiPcQ101H, CtrlITypeImmQ101H, CtrlStoreQ101H }) 
        4'b1000 : begin // OP_LUI - TODO - Maybe Move to the Q102H - no need to use the ALU for LUI.
            AluIn1Q101H = 32'b0;          
            AluIn2Q101H = U_ImmediateQ101H;
        end
        4'b0100 : begin // OP_AUIPC
            AluIn1Q101H = PcQ101H;
            AluIn2Q101H = U_ImmediateQ101H;
        end
        4'b0010 : begin // OP_JALR || OP_OPIMM || OP_LOAD
            AluIn1Q101H = RegRdData1Q101H;
            AluIn2Q101H = I_ImmediateQ101H;
        end
        4'b0001 : begin // OP_STORE
            AluIn1Q101H = RegRdData1Q101H;
            AluIn2Q101H = S_ImmediateQ101H;
        end
        default : begin // OP_OP || OP_BRANCH
            AluIn1Q101H = RegRdData1Q101H;
            AluIn2Q101H = RegRdData2Q101H;
        end //default
    endcase
end //always_comb

always_comb begin : alu_logic
    unique casez (CtrlAluOpQ101H) 
        //use adder
        4'b0000  : AluOutQ101H = AluIn1Q101H +   AluIn2Q101H                          ;//ADD
        4'b1000  : AluOutQ101H = AluIn1Q101H + (~AluIn2Q101H) + 1'b1                  ;//SUB
        4'b0010  : AluOutQ101H = {31'b0, $signed(AluIn1Q101H) < $signed(AluIn2Q101H)} ;//SLT
        4'b0011  : AluOutQ101H = {31'b0 , AluIn1Q101H < AluIn2Q101H}                  ;//SLTU
        //shift
        4'b0001  : AluOutQ101H = AluIn1Q101H << ShamtQ101H                            ;//SLL
        4'b0101  : AluOutQ101H = AluIn1Q101H >> ShamtQ101H                            ;//SRL
        4'b1101  : AluOutQ101H = $signed(AluIn1Q101H) >>> ShamtQ101H                  ;//SRA
        //bit wise opirations
        4'b0100  : AluOutQ101H = AluIn1Q101H ^ AluIn2Q101H                            ;//XOR
        4'b0110  : AluOutQ101H = AluIn1Q101H | AluIn2Q101H                            ;//OR
        4'b0111  : AluOutQ101H = AluIn1Q101H & AluIn2Q101H                            ;//AND
        default  : AluOutQ101H = 32'b0                                                ;
    endcase
end

always_comb begin : branch_comp
    //for branch condition.
    unique casez ({CtrlBranchQ101H , Funct3Q101H})
       4'b1_000 : BranchCondMetQ101H =  (AluIn1Q101H==AluIn1Q102H)                   ;// BEQ
       4'b1_001 : BranchCondMetQ101H = ~(AluIn1Q101H==AluIn1Q102H)                   ;// BNE
       4'b1_100 : BranchCondMetQ101H =  ($signed(AluIn1Q101H)<$signed(AluIn1Q102H))  ;// BLT
       4'b1_101 : BranchCondMetQ101H = ~($signed(AluIn1Q101H)<$signed(AluIn1Q102H))  ;// BGE
       4'b1_110 : BranchCondMetQ101H =  (AluIn1Q101H<AluIn1Q102H)                    ;// BLTU
       4'b1_111 : BranchCondMetQ101H = ~(AluIn1Q101H<AluIn1Q102H)                    ;// BGEU
       default  : BranchCondMetQ101H = 1'b0                                          ;
    endcase
end



////////////////////////////////////////////////////////////////////////////////////////
//          Control
////////////////////////////////////////////////////////////////////////////////////////
always_comb begin : decode_opcode
    //Decode control bits
    CtrlJalQ101H        =   (OpcodeQ101H == OP_JAL);
    CtrlJalrQ101h       =   (OpcodeQ101H == OP_JALR);
    CtrlBranchQ101H     =   (OpcodeQ101H == OP_BRANCH);
    CtrlITypeImmQ101H   =   (OpcodeQ101H == OP_OPIMM) || (OpcodeQ101H == OP_LOAD) || (OpcodeQ101H == OP_JALR) ;
    CtrlRegWrQ101H      = ~((OpcodeQ101H == OP_STORE) || (OpcodeQ101H == OP_BRANCH)) ;
    CtrlLuiQ101H        =   (OpcodeQ101H == OP_LUI);
    CtrlAuiPcQ101H      =   (OpcodeQ101H == OP_AUIPC);
    CtrlMemToRegQ101H   =   (OpcodeQ101H == OP_LOAD);
    CtrlMemRdQ101H      =   (OpcodeQ101H == OP_LOAD);
    CtrlMemWrQ101H      =   (OpcodeQ101H == OP_STORE);
    CtrlStoreQ101H      =   (OpcodeQ101H == OP_STORE);

    // ALU will perform the encoded fubct3 operation.
    CtrlAluOpQ101H      = {1'b0,Funct3Q101H};
    // incase of  OP_OP || (OP_OPIMM && (funct3[1:0]==2'b01)) take funct7[5]
    if( (OpcodeQ101H == OP_OP) || ((OpcodeQ101H == OP_OPIMM) && (Funct3Q101H[1:0]==2'b01))) begin
       CtrlAluOpQ101H[3] = Funct7Q101H[5];
    end
end



//**************************************************************Q103H**************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//

////////////////////////////////////////////////////////////////////////////////////////
//          Data Memory
////////////////////////////////////////////////////////////////////////////////////////
//Byte Enable acording to Funct3 of the Opcode.
assign MemByteEnQ101H   = (Funct3Q101H[1:0] == 2'b00 ) ? 4'b0001 : // LB/SB
                          (Funct3Q101H[1:0] == 2'b01 ) ? 4'b0011 : // LH/SH
                          (Funct3Q101H[1:0] == 2'b10 ) ? 4'b1111 : // LW/SW
                                                         4'b0000 ; // 2'b11 is an illegal Funct3 //FIXME - ADD assetion 
// Align Memory Accsses to Q102H
`GPC_MSFF( CtrlMemWrQ102H,    CtrlMemWrQ101H  , QClk)
`GPC_MSFF( CtrlMemRdQ102H,    CtrlMemRdQ101H  , QClk)
`GPC_MSFF( MemByteEnQ102H,    MemByteEnQ101H  , QClk)
`GPC_MSFF( MemWrDataWQ102H,   RegRdData1Q101H , QClk)
assign     MemAdrsQ102H     = AluOutQ102H;
//**************************************************************Q104H**************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//
//*********************************************************************************************************************//
////////////////////////////////////////////////////////////////////////////////////////
//          DFD - Design for Debug
////////////////////////////////////////////////////////////////////////////////////////
//assign expose_reg.register  = RegRdData3Q101H; //read register acording to CRQnnnH.rd_ptr;
//assign expose_reg.pc        = PcPlus4Q101H;  //expose the pc


endmodule
//this will solve the conflict
