//-----------------------------------------------------------------------------
// Title            : core_4t 
// Project          : gpc_4t
//-----------------------------------------------------------------------------
// File             : core_4t 
// Original Author  : Saar Adi
// Code Owner       : 
// Adviser          : Amichai Ben-David
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

`include "lotr_defines.sv"
module core_4t 
    import gpc_4t_pkg::*;  
    (
    input  logic        QClk            ,
    input  logic        RstQnnnH        ,
    //Instruction Memory
    output logic [31:0] PcQ100H         ,
    input  logic [31:0] InstFetchQ101H  ,   //the input from the i_mem. the instruction. already sampled in a @ff at the i_mem
    //Data Memory
    output logic [31:0] MemAdrsQ103H    ,
    output logic [31:0] MemWrDataWQ103H ,
    output logic        CtrlMemWrQ103H  ,
    output logic        CtrlMemRdQ103H  ,
    output logic [3:0]  MemByteEnQ103H  ,
    input  logic [31:0] MemRdDataQ104H  ,
    //MMIO
    input  t_cr         CRQnnnH
    );
//  general signals
logic    RstQnn1H;
logic    RstQnn2H;

logic    DervRstQnn1H;

//  program counter
logic [31:0]    PcQ101H;
logic [31:0]    PcQ102H;
logic [31:0]    PcQ103H;
logic [31:0]    PcPlus4Q100H;
logic [31:0]    PcPlus4Q101H;
logic [31:0]    PcPlus4Q102H;
logic [31:0]    PcPlus4Q103H;
logic [31:0]    PcPlus4Q104H; 
logic [31:0]    NextPcQ102H;

// Threads
logic [3:0]     EnPCQnnnH;
logic           T0EnPcQnnnH;
logic           T1EnPcQnnnH;
logic           T2EnPcQnnnH;
logic           T3EnPcQnnnH;
logic [31:0]    T0PcQ100H;
logic [31:0]    T1PcQ100H;
logic [31:0]    T2PcQ100H;
logic [31:0]    T3PcQ100H;
logic [3:0]     NextThreadQ100H;
logic [3:0]     ThreadQ100H;
logic [3:0]     ThreadQ101H;
logic [3:0]     ThreadQ102H;
logic [3:0]     ThreadQ103H;
logic [3:0]     ThreadQ104H;



//  registers
logic [4:0]         RegRdPtr1Q101H;
logic [4:0]         RegRdPtr2Q101H;
logic [31:0]        RegRdData1Q101H;
logic [31:0]        RegRdData1Q102H;
logic [31:0]        RegRdData1Q103H;
logic [31:0]        RegRdData2Q101H;
logic [31:0]        RegRdData2Q102H;
logic [31:0]        RegRdData2Q103H;
logic [4:0]         RegWrPtrQ102H;
logic [4:0]         RegWrPtrQ103H;
logic [4:0]         RegWrPtrQ104H;
logic [31:0]        RegWrDataQ104H;
logic [15:0][31:0]  Register0QnnnH;
logic [15:0][31:0]  Register1QnnnH;
logic [15:0][31:0]  Register2QnnnH;
logic [15:0][31:0]  Register3QnnnH;
logic [15:0][31:0]  NextRegister0Q104H;
logic [15:0][31:0]  NextRegister1Q104H;
logic [15:0][31:0]  NextRegister2Q104H;
logic [15:0][31:0]  NextRegister3Q104H;
logic               CtrlRegWrQ102H;

//  ALU
logic [31:0]        AluOutQ102H; 
logic [31:0]        AluOutQ103H;
logic [31:0]        AluOutQ104H;
logic [31:0]        AluIn1Q102H;
logic [31:0]        AluIn2Q102H;

//  Immediate Formats
logic [31:0]        InstructionQ101H;   //intenal logic to assign the input instruction or a NOP
logic [31:0]        InstructionQ102H;
logic [31:0]        I_ImmediateQ102H; 
logic [31:0]        S_ImmediateQ102H; 
logic [31:0]        B_ImmediateQ102H; 
logic [31:0]        U_ImmediateQ102H; 
logic [31:0]        J_ImmediateQ102H; 
logic [4:0]         ShamtQ102H;
logic [2:0]         Funct3Q102H;
logic [2:0]         Funct3Q103H;
logic [6:0]         Funct7Q102H;

//  control signals
logic [3:0]         CtrlAluOpQ101H    ;
logic               CtrlJalQ101H      ;
logic               CtrlJalrQ101H     ;
logic               CtrlBranchQ101H   ;
logic               CtrlITypeImmQ101H ;
logic               CtrlRegWrQ101H    ;
logic               CtrlLuiQ101H      ;
logic               CtrlAuiPcQ101H    ;
logic               CtrlMemToRegQ101H ;
logic               CtrlMemRdQ101H    ;
logic               CtrlMemWrQ101H    ;
logic               CtrlStoreQ101H    ;
logic [3:0]         CtrlAluOpQ102H    ;
logic               CtrlJalQ102H      ;
logic               CtrlJalrQ102H     ;
logic               CtrlBranchQ102H   ;
logic               CtrlITypeImmQ102H ;
logic               CtrlLuiQ102H      ;
logic               CtrlAuiPcQ102H    ;
logic               CtrlMemToRegQ102H ;
logic               CtrlMemRdQ102H    ;
logic               CtrlMemWrQ102H    ;
logic               CtrlStoreQ102H    ;
logic               CtrlInsertNopQ101H;
logic               CtrlInsertNopQ102H;
logic               CtrlMemToRegQ103H;
logic               CtrlMemToRegQ104H;
logic               CtrlPcToRegQ101H;
logic               CtrlPcToRegQ102H;
logic               CtrlPcToRegQ103H;
logic               CtrlPcToRegQ104H;

logic [6:0]         OpcodeQ101H;
logic [6:0]         OpcodeQ102H;

logic [31:0]        PcBranchQ102H;
logic               BranchCondMetQ102H;
logic               CtrlRegWrQ103H;
logic               CtrlRegWrQ104H;



////////////////////////////////////////////////////////////////////////////////////////
//          CORE_4t Module Code
////////////////////////////////////////////////////////////////////////////////////////


// ========= Thread Logic ==============
//  Shift register to move the "valid" thread for each Cycle.
//  As long as RstQnnnH is up, ThreadQ100H is 0001 (Thread 0)
//  Due to the assign bits breakdown form , NextThreadQ100H gets the value 0010 from ThreadQ100H bits
//  ThreadQ101H, ThreadQ102H and ThreadQ103H will get the values 1000 , 0100 ,0010 
//  When RstQnnnH sets down the Shift register start moving the valid bit with only a single flip-flop that
//  sets ThreadQ100H to NextThreadQ100H value (0010) in the next cycle and because of assign statments all other Threads
//  are shifted as shows on the table
//  The assign statments are equivalent to use `LOTR_MSFF with much less resources
//  Great credit to Amichai Ben-David for the economical and efficient implementation

logic [3:0]	RstVal = 4'b0001;
assign NextThreadQ100H = {ThreadQ100H[2:0], ThreadQ100H[3]};
`LOTR_RST_VAL_MSFF(ThreadQ100H, NextThreadQ100H, QClk, RstQnnnH, RstVal)
assign ThreadQ101H = {ThreadQ100H[0] , ThreadQ100H[3:1]} ; //`LOTR_MSFF(ThreadQ101H, ThreadQ100H, QClk)
assign ThreadQ102H = {ThreadQ101H[0] , ThreadQ101H[3:1]} ; //`LOTR_MSFF(ThreadQ102H, ThreadQ101H, QClk)
assign ThreadQ103H = {ThreadQ102H[0] , ThreadQ102H[3:1]} ; //`LOTR_MSFF(ThreadQ103H, ThreadQ102H, QClk) 
assign ThreadQ104H = ThreadQ100H;
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



//////////////////////////////////////////////////////////////////////////////////////////////////
//   _____  __     __   _____   _        ______          ____    __    ___     ___    _    _ 
//  / ____| \ \   / /  / ____| | |      |  ____|        / __ \  /_ |  / _ \   / _ \  | |  | |
// | |       \ \_/ /  | |      | |      | |__          | |  | |  | | | | | | | | | | | |__| |
// | |        \   /   | |      | |      |  __|         | |  | |  | | | | | | | | | | |  __  |
// | |____     | |    | |____  | |____  | |____        | |__| |  | | | |_| | | |_| | | |  | |
//  \_____|    |_|     \_____| |______| |______|        \___\_\  |_|  \___/   \___/  |_|  |_|
//
//////////////////////////////////////////////////////////////////////////////////////////////////
//  Instruction "Fetch" - Send Pc to Instruction Memory 
//  4 Seperate Program Counters - one for each thread.
//  The next PC for each thread calculated at Q102H pipe stage
//  Each PC samples the value from Q102H and its enable signal toggle when 
//  the thread he represents is currently running on Q102H
//////////////////////////////////////////////////////////////////////////////////////////////////
   
assign EnPCQnnnH   = 4'b1111; //Enable all Threads FIXME - this is Temp for Enabling the PIPE - should come from the mmio_CR register

//  Enable bits for Thread's Pc - indicated from Q102H
assign T0EnPcQ100H = EnPCQnnnH[0] && ThreadQ102H[0];
assign T1EnPcQ100H = EnPCQnnnH[1] && ThreadQ102H[1];
assign T2EnPcQ100H = EnPCQnnnH[2] && ThreadQ102H[2];
assign T3EnPcQ100H = EnPCQnnnH[3] && ThreadQ102H[3];
  
  // The PCs
`LOTR_EN_RST_MSFF( T0PcQ100H, NextPcQ102H, QClk, T0EnPcQ100H, RstQnnnH) 
`LOTR_EN_RST_MSFF( T1PcQ100H, NextPcQ102H, QClk, T1EnPcQ100H, RstQnnnH) 
`LOTR_EN_RST_MSFF( T2PcQ100H, NextPcQ102H, QClk, T2EnPcQ100H, RstQnnnH) 
`LOTR_EN_RST_MSFF( T3PcQ100H, NextPcQ102H, QClk, T3EnPcQ100H, RstQnnnH) 

always_comb begin : next_threads_pc_sel
  
    //mux 4:1
    unique casez (ThreadQ100H) 
        4'b0001  : PcQ100H = T0PcQ100H; 
        4'b0010  : PcQ100H = T1PcQ100H; 
        4'b0100  : PcQ100H = T2PcQ100H; 
        4'b1000  : PcQ100H = T3PcQ100H;
        default  : PcQ100H = T0PcQ100H; //TODO - set an Assertion incaes we reach the default  case
    endcase
end

/// Q100H to Q101H Flip Flops. 
/// Data from I_MEM is sampled inside I_MEM module ????????
`LOTR_MSFF   ( PcQ101H,    PcQ100H,    QClk ) 


//////////////////////////////////////////////////////////////////////////////////////////////////
//   _____  __     __   _____   _        ______          ____    __    ___    __   _    _ 
//  / ____| \ \   / /  / ____| | |      |  ____|        / __ \  /_ |  / _ \  /_ | | |  | |
// | |       \ \_/ /  | |      | |      | |__          | |  | |  | | | | | |  | | | |__| |
// | |        \   /   | |      | |      |  __|         | |  | |  | | | | | |  | | |  __  |
// | |____     | |    | |____  | |____  | |____        | |__| |  | | | |_| |  | | | |  | |
//  \_____|    |_|     \_____| |______| |______|        \___\_\  |_|  \___/   |_| |_|  |_|
//
//////////////////////////////////////////////////////////////////////////////////////////////////
//  Instruction "Decode" per Opcode Type - R/I/S/B/U/J Types
//  Here we break the InstructionQ101H into every possible Type 
//  This pipe stage extract all data neccesary to complete command 
//////////////////////////////////////////////////////////////////////////////////////////////////

// Insert NOP - (back pressure, Wait for Read, ext..)
assign CtrlInsertNopQ101H = 1'b0;////Enable all Threads FIXME - this is Temp for Enabling the PIPE - should come from the mmio_CR register

assign InstructionQ101H = CtrlInsertNopQ101H ? NOP : InstFetchQ101H;    //internal logic for the instruction - the input or NOP
assign RegRdPtr1Q101H   = InstructionQ101H[19:15];  // rs1 register for R/S/I/B Type
assign RegRdPtr2Q101H   = InstructionQ101H[24:20];  // rs2 register for R/S/B Type
assign OpcodeQ101H      = InstructionQ101H[6:0];    // opcode       for each possible Type  


////////////////////////////////////////////////////////////////////////////////////////
//          Control
//////////////////////////////////////////////////S//////////////////////////////////////
always_comb begin : decode_opcode
    //Decode control bits
    CtrlJalQ101H        =   (OpcodeQ101H == OP_JAL);
	CtrlPcToRegQ101H    =   (OpcodeQ101H == OP_JAL) || (OpcodeQ101H == OP_JALR);;
    CtrlJalrQ101H       =   (OpcodeQ101H == OP_JALR);
    CtrlBranchQ101H     =   (OpcodeQ101H == OP_BRANCH);
    CtrlITypeImmQ101H   =   (OpcodeQ101H == OP_OPIMM) || (OpcodeQ101H == OP_LOAD) || (OpcodeQ101H == OP_JALR) ;
    CtrlRegWrQ101H      = ~((OpcodeQ101H == OP_STORE) || (OpcodeQ101H == OP_BRANCH)) ;
    CtrlLuiQ101H        =   (OpcodeQ101H == OP_LUI);
    CtrlAuiPcQ101H      =   (OpcodeQ101H == OP_AUIPC);
    CtrlMemToRegQ101H   =   (OpcodeQ101H == OP_LOAD);
    CtrlMemRdQ101H      =   (OpcodeQ101H == OP_LOAD);
    CtrlMemWrQ101H      =   (OpcodeQ101H == OP_STORE);
    CtrlStoreQ101H      =   (OpcodeQ101H == OP_STORE);

end



////////////////////////////////////////////////////////////////////////////////////////
//  Registers
//  The resister file RegisterQnnnH contains 4 register files (RegisterQnnnH[0] , RegisterQnnnH[1] ,etc)
//  each contains 16 32-bit registers 
//  all 4 registers's output is assign to a multiplexer that his selector
//  is determine by the current thread running (ThreadQ101H)
//  The NextRegister<#>Q104H value comes from Pipe Stage Q104H -> PcPlus4Q104H or MemRdDataQ104H or AluOutQ104H
////////////////////////////////////////////////////////////////////////////////////////



//========The 4 registers - one for each thread=========================
`LOTR_MSFF(Register0QnnnH, NextRegister0Q104H, QClk) 
`LOTR_MSFF(Register1QnnnH, NextRegister1Q104H, QClk) 
`LOTR_MSFF(Register2QnnnH, NextRegister2Q104H, QClk) 
`LOTR_MSFF(Register3QnnnH, NextRegister3Q104H, QClk) 
//======================================================================

//Read from RegisterQnnnH 
always_comb begin : read_register_file
    //write to register
    unique casez (ThreadQ101H) 
        4'b0001   : begin 
            RegRdData1Q101H = Register0QnnnH[RegRdPtr1Q101H];
            RegRdData2Q101H = Register0QnnnH[RegRdPtr2Q101H]; 
		end
        4'b0010   : begin 
            RegRdData1Q101H = Register1QnnnH[RegRdPtr1Q101H];
            RegRdData2Q101H = Register1QnnnH[RegRdPtr2Q101H]; 
		end
        4'b0100   : begin 
            RegRdData1Q101H = Register2QnnnH[RegRdPtr1Q101H];
            RegRdData2Q101H = Register2QnnnH[RegRdPtr2Q101H]; 
		end
        default	  : begin
            RegRdData1Q101H = Register3QnnnH[RegRdPtr1Q101H];
            RegRdData2Q101H = Register3QnnnH[RegRdPtr2Q101H]; 
		end
    endcase
end


`LOTR_MSFF   ( OpcodeQ102H       , OpcodeQ101H       , QClk) 
`LOTR_MSFF   ( InstructionQ102H  , InstructionQ101H  , QClk)        //save flops. TODO more info
`LOTR_MSFF   ( PcQ102H           , PcQ101H           , QClk) 
`LOTR_MSFF   ( RegRdData1Q102H   , RegRdData1Q101H   , QClk)
`LOTR_MSFF   ( RegRdData2Q102H   , RegRdData2Q101H   , QClk)        //fix
`LOTR_MSFF   ( CtrlJalQ102H      , CtrlJalQ101H      , QClk)
`LOTR_MSFF   ( CtrlJalrQ102H     , CtrlJalrQ101H     , QClk)
`LOTR_MSFF   ( CtrlPcToRegQ102H  , CtrlPcToRegQ101H  , QClk)
`LOTR_MSFF   ( CtrlBranchQ102H   , CtrlBranchQ101H   , QClk)
`LOTR_MSFF   ( CtrlITypeImmQ102H , CtrlITypeImmQ101H , QClk)
`LOTR_MSFF   ( CtrlRegWrQ102H    , CtrlRegWrQ101H    , QClk)
`LOTR_MSFF   ( CtrlLuiQ102H      , CtrlLuiQ101H      , QClk)
`LOTR_MSFF   ( CtrlAuiPcQ102H    , CtrlAuiPcQ101H    , QClk)
`LOTR_MSFF   ( CtrlMemToRegQ102H , CtrlMemToRegQ101H , QClk)
`LOTR_MSFF   ( CtrlMemRdQ102H    , CtrlMemRdQ101H    , QClk)
`LOTR_MSFF   ( CtrlMemWrQ102H    , CtrlMemWrQ101H    , QClk)
`LOTR_MSFF   ( CtrlStoreQ102H    , CtrlStoreQ101H    , QClk)


//////////////////////////////////////////////////////////////////////////////////////////////////
//    _____  __     __   _____   _        ______          ____    __    ___    ___    _    _ 
//   / ____| \ \   / /  / ____| | |      |  ____|        / __ \  /_ |  / _ \  |__ \  | |  | |
//  | |       \ \_/ /  | |      | |      | |__          | |  | |  | | | | | |    ) | | |__| |
//  | |        \   /   | |      | |      |  __|         | |  | |  | | | | | |   / /  |  __  |
//  | |____     | |    | |____  | |____  | |____        | |__| |  | | | |_| |  / /_  | |  | |
//   \_____|    |_|     \_____| |______| |______|        \___\_\  |_|  \___/  |____| |_|  |_|
//                                                                                           
//////////////////////////////////////////////////////////////////////////////////////////////////
//  Instruction "Execute" 
//  Contains the ALU - Arithmatic Logical Unit that calculate arithmatic operations
//  Also contains a Branch Comperator that determine if brach condition 
//  and also branch prediction calculator that calculate where to jump
////////////////////////////////////////
//  Immediate Generator
////////////////////////////////////////
assign U_ImmediateQ102H = { InstructionQ102H[31:12]    ,12'b0 } ; 
assign I_ImmediateQ102H = { {20{InstructionQ102H[31]}} , InstructionQ102H[31:25] , InstructionQ102H[24:20] }; 
assign S_ImmediateQ102H = { {20{InstructionQ102H[31]}} , InstructionQ102H[31:25] , InstructionQ102H[11:7]  }; 
assign B_ImmediateQ102H = { {20{InstructionQ102H[31]}} , InstructionQ102H[7]     , InstructionQ102H[30:25] , InstructionQ102H[11:8]  , 1'b0}; 
assign J_ImmediateQ102H = { {12{InstructionQ102H[31]}} , InstructionQ102H[19:12] , InstructionQ102H[20]    , InstructionQ102H[30:21] , 1'b0}; 
////////////////////////////////////////
//  Instruction "BreakDown"
////////////////////////////////////////
assign RegWrPtrQ102H    = InstructionQ102H[11:7];   // rd register  for R/I/U/J Type
assign Funct3Q102H      = InstructionQ102H[14:12];  // function3    for R/S/I/B Type
assign Funct7Q102H      = InstructionQ102H[31:25];  // function7    for R Type

////////////////////////////////////////////////////////////////////////////////////////
//			ALU controller
////////////////////////////////////////////////////////////////////////////////////////
// incase of  OP_OP || (OP_OPIMM && (funct3[1:0]==2'b01)) take funct7[5]
always_comb begin : alu_ctrl
    // ALU will perform the encoded fubct3 operation.
    CtrlAluOpQ102H  = {1'b0,Funct3Q102H};
    if (OpcodeQ102H == OP_STORE || OpcodeQ102H == OP_LOAD) begin 
        CtrlAluOpQ102H[3] = 1'b1;
    end
    if( (OpcodeQ102H == OP_OP) || ((OpcodeQ102H == OP_OPIMM) && (Funct3Q102H[1:0]==2'b01))) begin
       CtrlAluOpQ102H[3] = Funct7Q102H[5];
    end
end   
////////////////////////////////////////////////////////////////////////////////////////
//			Branch Calculator for label jumps
////////////////////////////////////////////////////////////////////////////////////////
always_comb begin : next_pc_options_calc
    PcBranchQ102H = PcQ102H + B_ImmediateQ102H; // ALU will set if branch condition met	
    PcPlus4Q102H  = PcQ102H + 32'd4;    
end
////////////////////////////////////////////////////////////////////////////////////////
////    PC Selector
////////////////////////////////////////////////////////////////////////////////////////
always_comb begin : set_next_pc
    //mux 4:1
    unique casez ({ CtrlJalrQ102H , CtrlJalQ102H , BranchCondMetQ102H}) 
        3'b001  : NextPcQ102H = PcBranchQ102H;     // OP_BRANCH
        3'b010  : NextPcQ102H = J_ImmediateQ102H + PcQ102H;  // OP_JAL
        3'b100  : NextPcQ102H = AluOutQ102H;       // OP_JALR ALU output I_ImmediateUQ101H + rs1
        default : NextPcQ102H = PcPlus4Q102H;
    endcase
end


////////////////////////////////////////////////////////////////////////////////////////
//          ALU
////////////////////////////////////////////////////////////////////////////////////////
always_comb begin : choose_alu_input
    unique casez ({ CtrlLuiQ102H, CtrlAuiPcQ102H, CtrlITypeImmQ102H, CtrlStoreQ102H }) 
        4'b1000 : begin // OP_LUI - TODO - Maybe Move to the Q102H - no need to use the ALU for LUI.
            AluIn1Q102H = 32'b0;          
            AluIn2Q102H = U_ImmediateQ102H;
        end
        4'b0100 : begin // OP_AUIPC
            AluIn1Q102H = PcQ102H;
            AluIn2Q102H = U_ImmediateQ102H;
        end
        4'b0010 : begin // OP_JALR || OP_OPIMM || OP_LOAD
            AluIn1Q102H = RegRdData1Q102H;
            AluIn2Q102H = I_ImmediateQ102H;
        end
        4'b0001 : begin // OP_STORE
            AluIn1Q102H = RegRdData1Q102H;
            AluIn2Q102H = S_ImmediateQ102H;
        end
        default : begin // OP_OP || OP_BRANCH
            AluIn1Q102H = RegRdData1Q102H;
            AluIn2Q102H = RegRdData2Q102H;
        end //default
    endcase
end //always_comb

assign ShamtQ102H = AluIn2Q102H[4:0];
always_comb begin : alu_logic
    unique casez (CtrlAluOpQ102H) 
        //use adder
        4'b0000  : AluOutQ102H = AluIn1Q102H +   AluIn2Q102H                          ;//ADD
        4'b1010  : AluOutQ102H = AluIn1Q102H +   AluIn2Q102H                          ;//LW/SW
        4'b1000  : AluOutQ102H = AluIn1Q102H + (~AluIn2Q102H) + 1'b1                  ;//SUB
        4'b0010  : AluOutQ102H = {31'b0, $signed(AluIn1Q102H) < $signed(AluIn2Q102H)} ;//SLT
        4'b0011  : AluOutQ102H = {31'b0 , AluIn1Q102H < AluIn2Q102H}                  ;//SLTU
        //shift
        4'b0001  : AluOutQ102H = AluIn1Q102H << ShamtQ102H                            ;//SLL
        4'b0101  : AluOutQ102H = AluIn1Q102H >> ShamtQ102H                            ;//SRL
        4'b1101  : AluOutQ102H = $signed(AluIn1Q102H) >>> ShamtQ102H                  ;//SRA
        //bit wise opirations
        4'b0100  : AluOutQ102H = AluIn1Q102H ^ AluIn2Q102H                            ;//XOR
        4'b0110  : AluOutQ102H = AluIn1Q102H | AluIn2Q102H                            ;//OR
        4'b0111  : AluOutQ102H = AluIn1Q102H & AluIn2Q102H                            ;//AND
        default  : AluOutQ102H = 32'b0                                                ;
    endcase
end

always_comb begin : branch_comp
    //for branch condition.
    unique casez ({CtrlBranchQ102H , Funct3Q102H})
       4'b1_000 : BranchCondMetQ102H =  (AluIn1Q102H==AluIn2Q102H)                   ;// BEQ
       4'b1_001 : BranchCondMetQ102H = ~(AluIn1Q102H==AluIn2Q102H)                   ;// BNE
       4'b1_100 : BranchCondMetQ102H =  ($signed(AluIn1Q102H)<$signed(AluIn2Q102H))  ;// BLT
       4'b1_101 : BranchCondMetQ102H = ~($signed(AluIn1Q102H)<$signed(AluIn2Q102H))  ;// BGE
       4'b1_110 : BranchCondMetQ102H =  (AluIn1Q102H<AluIn1Q102H)                    ;// BLTU
       4'b1_111 : BranchCondMetQ102H = ~(AluIn1Q102H<AluIn1Q102H)                    ;// BGEU
       default  : BranchCondMetQ102H = 1'b0                                          ;
    endcase
end


`LOTR_MSFF   ( PcPlus4Q103H      , PcPlus4Q102H      , QClk) 
`LOTR_MSFF   ( AluOutQ103H       , AluOutQ102H       , QClk)
`LOTR_MSFF   ( Funct3Q103H       , Funct3Q102H       , QClk) 
`LOTR_MSFF   ( RegWrPtrQ103H     , RegWrPtrQ102H     , QClk)
`LOTR_MSFF   ( RegRdData1Q103H   , RegRdData1Q102H   , QClk)
`LOTR_MSFF   ( RegRdData2Q103H   , RegRdData2Q102H   , QClk)
`LOTR_MSFF   ( CtrlMemRdQ103H    , CtrlMemRdQ102H    , QClk) // output to DMEM
`LOTR_MSFF   ( CtrlMemWrQ103H    , CtrlMemWrQ102H    , QClk) //output to DMEM
`LOTR_MSFF   ( CtrlMemToRegQ103H , CtrlMemToRegQ102H , QClk)
`LOTR_MSFF   ( CtrlPcToRegQ103H  , CtrlPcToRegQ102H  , QClk)
`LOTR_MSFF   ( CtrlRegWrQ103H    , CtrlRegWrQ102H    , QClk)


//////////////////////////////////////////////////////////////////////////////////////////////////
//   _____  __     __   _____   _        ______          ____    __    ___    ____    _    _ 
//  / ____| \ \   / /  / ____| | |      |  ____|        / __ \  /_ |  / _ \  |___ \  | |  | |
// | |       \ \_/ /  | |      | |      | |__          | |  | |  | | | | | |   __) | | |__| |
// | |        \   /   | |      | |      |  __|         | |  | |  | | | | | |  |__ <  |  __  |
// | |____     | |    | |____  | |____  | |____        | |__| |  | | | |_| |  ___) | | |  | |
//  \_____|    |_|     \_____| |______| |______|        \___\_\  |_|  \___/  |____/  |_|  |_|
//
//////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////
//          Data Memory
////////////////////////////////////////////////////////////////////////////////////////
//Byte Enable acording to Funct3 of the Opcode.
assign MemByteEnQ103H   = (Funct3Q103H[1:0] == 2'b00 ) ? 4'b0001 : // LB/SB
                          (Funct3Q103H[1:0] == 2'b01 ) ? 4'b0011 : // LH/SH
                          (Funct3Q103H[1:0] == 2'b10 ) ? 4'b1111 : // LW/SW
                                                         4'b0000 ; // 2'b11 is an illegal Funct3 //FIXME - ADD assetion 
// The value read from register assign to the output signal MemWrDataWQ103H that goes right into the D_MEM module
assign  MemWrDataWQ103H = RegRdData2Q103H;
// the address from ALU assign to the output signal MemAdrsQ103H that goes right into the D_MEM module
assign  MemAdrsQ103H = AluOutQ103H;


`LOTR_MSFF   ( PcPlus4Q104H      , PcPlus4Q103H      , QClk) 
`LOTR_MSFF   ( AluOutQ104H       , AluOutQ103H       , QClk)
`LOTR_MSFF   ( RegWrPtrQ104H     , RegWrPtrQ103H     , QClk)
`LOTR_MSFF   (CtrlMemToRegQ104H  , CtrlMemToRegQ103H , QClk)
`LOTR_MSFF   (CtrlPcToRegQ104H   , CtrlPcToRegQ103H  , QClk)
`LOTR_MSFF   ( CtrlRegWrQ104H    , CtrlRegWrQ103H    , QClk)
//`LOTR_MSFF   ( MemRdDataQ104H    , MemRdDataQ103H    , QClk) // input signal from D_MEM ????? relevant


//////////////////////////////////////////////////////////////////////////////////////////////////
//    _____  __     __   _____   _        ______          ____    __    ___    _  _     _    _ 
//  / ____| \ \   / /  / ____| | |      |  ____|        / __ \  /_ |  / _ \  | || |   | |  | |
// | |       \ \_/ /  | |      | |      | |__          | |  | |  | | | | | | | || |_  | |__| |
// | |        \   /   | |      | |      |  __|         | |  | |  | | | | | | |__   _| |  __  |
// | |____     | |    | |____  | |____  | |____        | |__| |  | | | |_| |    | |   | |  | |
//  \_____|    |_|     \_____| |______| |______|        \___\_\  |_|  \___/     |_|   |_|  |_|
//
//////////////////////////////////////////////////////////////////////////////////////////////////
 

always_comb begin : candidates_for_register_write_data
    unique casez ({CtrlMemToRegQ104H , CtrlPcToRegQ104H}) 
        2'b01   : RegWrDataQ104H = PcPlus4Q104H   ; //Data from PC - for JAL?
        2'b10   : RegWrDataQ104H = MemRdDataQ104H ; //Data from Memory
        default : RegWrDataQ104H = AluOutQ104H    ; //Data from ALU (Common case)
    endcase	
end // always_comb
	
//--------------------------------------------------------

always_comb begin : write_register_file         //ADLV : Ask ABD about this comb
    NextRegister0Q104H = Register0QnnnH; // defualt -> keep old value
    NextRegister1Q104H = Register1QnnnH; // defualt -> keep old value	
    NextRegister2Q104H = Register2QnnnH; // defualt -> keep old value
    NextRegister3Q104H = Register3QnnnH; // defualt -> keep old value
	
	
    if ( CtrlRegWrQ104H ) begin
        unique casez (ThreadQ104H)
            4'b0001 : NextRegister0Q104H[RegWrPtrQ104H] = RegWrDataQ104H;
            4'b0010 : NextRegister1Q104H[RegWrPtrQ104H] = RegWrDataQ104H;
            4'b0100 : NextRegister2Q104H[RegWrPtrQ104H] = RegWrDataQ104H;
            4'b1000 : NextRegister3Q104H[RegWrPtrQ104H] = RegWrDataQ104H;
            default : NextRegister0Q104H[RegWrPtrQ104H] = RegWrDataQ104H; //TODO - set an Assertion incaes we reach the default  case
        endcase
    end //if
	
	
 //------------------------------------------------------------
 //Register[0] will always be tied to '0;
    NextRegister0Q104H[0] = 32'b0;  
    NextRegister1Q104H[0] = 32'b0;  
    NextRegister2Q104H[0] = 32'b0;  
    NextRegister3Q104H[0] = 32'b0;  
end // always_comb

////////////////////////////////////////////////////////////////////////////////////////
//          DFD - Design for Debug
////////////////////////////////////////////////////////////////////////////////////////
//assign expose_reg.register  = RegRdData3Q101H; //read register acording to CRQnnnH.rd_ptr;
//assign expose_reg.pc        = PcPlus4Q101H;  //expose the pc

endmodule
//this will solve the conflict
