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
    import lotr_pkg::*;  
    (
    input  logic        QClk            ,
    input  logic        RstQnnnH        ,
    //Instruction Memory
    output logic [31:0] PcQ100H         ,
    input  logic [31:0] InstFetchQ101H  ,   //the input from the i_mem. the instruction. already sampled in a @ff at the i_mem
    //Data Memory
    output logic [31:0] MemAdrsQ103H    ,
    output logic [31:0] MemWrDataQ103H  ,
    output logic        CtrlMemWrQ103H  ,
    output logic        CtrlMemRdQ103H  ,
    output logic [3:0]  MemByteEnQ103H  ,
    output logic [3:0]  ThreadQ103H     ,
    output logic [31:0] PcQ103H         ,
    input  logic [31:0] MemRdDataQ104H  ,
    input logic         C2F_RspMatchQ104H,
    input logic         T0RcAccess      ,
    input logic         T1RcAccess      ,
    input logic         T2RcAccess      ,
    input logic         T3RcAccess      ,
    
    //MMIO
    input  var t_core_cr         CRQnnnH
    );
//  program counter
logic [31:0]        PcQ101H;
logic [31:0]        PcQ102H;
logic [31:0]        PcPlus4Q102H;
logic [31:0]        PcPlus4Q103H;
logic [31:0]        PcPlus4Q104H; 
logic [31:0]        NextPcQ102H;
// Threads
logic [3:0]         EnPCQnnnH;
logic [31:0]        T0PcQ100H;
logic [31:0]        T1PcQ100H;
logic [31:0]        T2PcQ100H;
logic [31:0]        T3PcQ100H;
logic [3:0]         NextThreadQ100H;
logic [3:0]         ThreadQ100H;
logic [3:0]         ThreadQ101H;
logic [3:0]         ThreadQ102H;
logic [3:0]         ThreadQ104H;
//  registers
logic [4:0]         RegRdPtr1Q101H;
logic [4:0]         RegRdPtr2Q101H;
logic [31:0]        RegRdData1Q101H;
logic [31:0]        RegRdData1Q102H;
logic [31:0]        RegRdData2Q101H;
logic [31:0]        RegRdData2Q102H;
logic [31:0]        RegRdData2Q103H;
logic [4:0]         RegWrPtrQ102H;
logic [4:0]         RegWrPtrQ103H;
logic [4:0]         RegWrPtrQ104H;
logic [4:0]         RegWrPtrQ105H;
logic [4:0]         PreRegWrPtrQ104H;
logic [4:0]         T0RegWrPtrQnnnH;
logic [4:0]         T1RegWrPtrQnnnH;
logic [4:0]         T2RegWrPtrQnnnH;
logic [4:0]         T3RegWrPtrQnnnH;
logic [31:0]        RegWrDataQ104H;
logic [31:0][31:0]  Register0QnnnH;
logic [31:0][31:0]  Register1QnnnH;
logic [31:0][31:0]  Register2QnnnH;
logic [31:0][31:0]  Register3QnnnH;
logic [31:0][31:0]  NextRegister0Q104H;
logic [31:0][31:0]  NextRegister1Q104H;
logic [31:0][31:0]  NextRegister2Q104H;
logic [31:0][31:0]  NextRegister3Q104H;
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
logic [3:0]         CtrlAluOpQ101H;
logic [3:0]         CtrlAluOpQ102H;
logic [6:0]         OpcodeQ101H;
logic [6:0]         OpcodeQ102H;
logic [31:0]        PcBranchQ102H;
logic               CtrlJalQ101H      , CtrlJalQ102H      ;
logic               CtrlJalrQ101H     , CtrlJalrQ102H     ;
logic               CtrlBranchQ101H   , CtrlBranchQ102H   ;
logic               CtrlITypeImmQ101H , CtrlITypeImmQ102H ;
logic               CtrlLuiQ101H      , CtrlLuiQ102H      ;
logic               CtrlAuiPcQ101H    , CtrlAuiPcQ102H    ;
logic               CtrlMemRdQ101H    , CtrlMemRdQ102H    ;
logic               CtrlMemWrQ101H    , CtrlMemWrQ102H    ;
logic               CtrlStoreQ101H    , CtrlStoreQ102H    ;
logic               CtrlRegWrQ101H    , CtrlRegWrQ102H    , CtrlRegWrQ103H    , CtrlRegWrQ104H;
logic               CtrlMemToRegQ101H , CtrlMemToRegQ102H , CtrlMemToRegQ103H , CtrlMemToRegQ104H;
logic               CtrlPcToRegQ101H  , CtrlPcToRegQ102H  , CtrlPcToRegQ103H  , CtrlPcToRegQ104H;
logic               CtrlInsertNopQ102H, CtrlInsertNopQ101H, CtrlInsertNopQ100H;
logic               BranchCondMetQ102H;
logic [3:0]         MemByteEnQ104H  ;
logic               CtrlSignExtQ102H, CtrlSignExtQ103H, CtrlSignExtQ104H;
//Multi Core - Ring Controler (Fabric) access - Read Response
logic SampT0RcAccess;
logic SampT1RcAccess;
logic SampT2RcAccess;
logic SampT3RcAccess;
logic T0EnRegWrPtrQnnnH;
logic T1EnRegWrPtrQnnnH;
logic T2EnRegWrPtrQnnnH;
logic T3EnRegWrPtrQnnnH;

logic T0EnPcQ100H;
logic T1EnPcQ100H;
logic T2EnPcQ100H;
logic T3EnPcQ100H;
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
logic [3:0] RstVal = 4'b0001;
assign NextThreadQ100H = {ThreadQ100H[2:0], ThreadQ100H[3]};
`LOTR_RST_VAL_MSFF(ThreadQ100H, NextThreadQ100H, QClk, RstQnnnH, RstVal)
assign ThreadQ101H = {ThreadQ100H[0] , ThreadQ100H[3:1]} ; //`LOTR_MSFF(ThreadQ101H, ThreadQ100H, QClk)
assign ThreadQ102H = {ThreadQ101H[0] , ThreadQ101H[3:1]} ; //`LOTR_MSFF(ThreadQ102H, ThreadQ101H, QClk)
assign ThreadQ103H = {ThreadQ102H[0] , ThreadQ102H[3:1]} ; //`LOTR_MSFF(ThreadQ103H, ThreadQ102H, QClk) 
assign ThreadQ104H = ThreadQ100H;
// ----------------------------------------
//          |  Q100H  Q101H  Q102H  Q103H
// ----------------------------------------
// cycle 0  |  0001   1000   0100   0010
// cycle 1  |  0010   0001   1000   0100   
// cycle 2  |  0100   0010   0001   1000
// cycle 3  |  1000   0100   0010   0001
// cycle 4  |  0001   1000   0100   0010
// cycle 5  |  0010   0001   1000   0100   
// cycle 6  |  0100   0010   0001   1000
// cycle 7  |  1000   0100   0010   0001

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

assign EnPCQnnnH[0] = CRQnnnH.en_pc_0 && (!(T0RcAccess));
assign EnPCQnnnH[1] = CRQnnnH.en_pc_1 && (!(T1RcAccess));
assign EnPCQnnnH[2] = CRQnnnH.en_pc_2 && (!(T2RcAccess));
assign EnPCQnnnH[3] = CRQnnnH.en_pc_3 && (!(T3RcAccess));

//  Enable bits for Thread's Pc - indicated from Q102H
assign T0EnPcQ100H = EnPCQnnnH[0] && ThreadQ102H[0];
assign T1EnPcQ100H = EnPCQnnnH[1] && ThreadQ102H[1];
assign T2EnPcQ100H = EnPCQnnnH[2] && ThreadQ102H[2];
assign T3EnPcQ100H = EnPCQnnnH[3] && ThreadQ102H[3];
  
// The PCs
`LOTR_EN_RST_MSFF( T0PcQ100H, NextPcQ102H, QClk, T0EnPcQ100H && !CtrlInsertNopQ102H , CRQnnnH.rst_pc_0 || RstQnnnH) 
`LOTR_EN_RST_MSFF( T1PcQ100H, NextPcQ102H, QClk, T1EnPcQ100H && !CtrlInsertNopQ102H , CRQnnnH.rst_pc_1 || RstQnnnH) 
`LOTR_EN_RST_MSFF( T2PcQ100H, NextPcQ102H, QClk, T2EnPcQ100H && !CtrlInsertNopQ102H , CRQnnnH.rst_pc_2 || RstQnnnH) 
`LOTR_EN_RST_MSFF( T3PcQ100H, NextPcQ102H, QClk, T3EnPcQ100H && !CtrlInsertNopQ102H , CRQnnnH.rst_pc_3 || RstQnnnH) 

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

// Insert NOP - (back pressure, Wait for Read, ext..) - check if the thread PC is desabled.
// TODO - test this feature.
assign CtrlInsertNopQ100H = ((!EnPCQnnnH[0]) && ThreadQ100H[0]) ||
                            ((!EnPCQnnnH[1]) && ThreadQ100H[1]) ||
                            ((!EnPCQnnnH[2]) && ThreadQ100H[2]) ||
                            ((!EnPCQnnnH[3]) && ThreadQ100H[3]) ;
                            
/// Q100H to Q101H Flip Flops. 
`LOTR_MSFF   ( PcQ101H,    PcQ100H,    QClk ) 
`LOTR_MSFF   (CtrlInsertNopQ101H, CtrlInsertNopQ100H, QClk) 


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

assign InstructionQ101H   = CtrlInsertNopQ101H ? NOP : InstFetchQ101H;    //internal logic for the instruction - the input or NOP
assign RegRdPtr1Q101H     = InstructionQ101H[19:15];  // rs1 register for R/S/I/B Type
assign RegRdPtr2Q101H     = InstructionQ101H[24:20];  // rs2 register for R/S/B Type
assign OpcodeQ101H        = InstructionQ101H[6:0];    // opcode       for each possible Type  



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
        default   : begin
            RegRdData1Q101H = Register3QnnnH[RegRdPtr1Q101H];
            RegRdData2Q101H = Register3QnnnH[RegRdPtr2Q101H]; 
        end
    endcase
end


`LOTR_MSFF ( OpcodeQ102H       , OpcodeQ101H       , QClk) 
`LOTR_MSFF ( InstructionQ102H  , InstructionQ101H  , QClk)  //save flops. TODO more info
`LOTR_MSFF ( PcQ102H           , PcQ101H           , QClk) 
`LOTR_MSFF ( RegRdData1Q102H   , RegRdData1Q101H   , QClk)
`LOTR_MSFF ( RegRdData2Q102H   , RegRdData2Q101H   , QClk)  //fix
`LOTR_RST_MSFF ( CtrlJalQ102H      , CtrlJalQ101H      , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlJalrQ102H     , CtrlJalrQ101H     , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlPcToRegQ102H  , CtrlPcToRegQ101H  , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlBranchQ102H   , CtrlBranchQ101H   , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlITypeImmQ102H , CtrlITypeImmQ101H , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlRegWrQ102H    , CtrlRegWrQ101H    , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlLuiQ102H      , CtrlLuiQ101H      , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlAuiPcQ102H    , CtrlAuiPcQ101H    , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlMemToRegQ102H , CtrlMemToRegQ101H , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlMemRdQ102H    , CtrlMemRdQ101H    , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlMemWrQ102H    , CtrlMemWrQ101H    , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlStoreQ102H    , CtrlStoreQ101H    , QClk, RstQnnnH)
`LOTR_RST_MSFF ( CtrlInsertNopQ102H, CtrlInsertNopQ101H, QClk, RstQnnnH) 


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
assign CtrlSignExtQ102H = (OpcodeQ102H == OP_LOAD) && (!Funct3Q102H[2]); // Sign extend the LOAD from memory read.

////////////////////////////////////////////////////////////////////////////////////////
//          ALU controller
////////////////////////////////////////////////////////////////////////////////////////
// incase of  OP_OP || (OP_OPIMM && (funct3[1:0]==2'b01)) take funct7[5]
always_comb begin : alu_ctrl
    // ALU will perform the encoded fubct3 operation.
    if (OpcodeQ102H == OP_LUI || OpcodeQ102H == OP_AUIPC ) begin        //U-Type with no funct3
        CtrlAluOpQ102H = 4'b0000; end
    else
        begin
            CtrlAluOpQ102H  = {1'b0,Funct3Q102H};
            if (OpcodeQ102H == OP_STORE || OpcodeQ102H == OP_LOAD) begin 
                CtrlAluOpQ102H = 4'b1010;
            end
            if( (OpcodeQ102H == OP_OP) || ((OpcodeQ102H == OP_OPIMM) && (Funct3Q102H[1:0]==2'b01))) begin
               CtrlAluOpQ102H[3] = Funct7Q102H[5];
            end
        end
end   
////////////////////////////////////////////////////////////////////////////////////////
//          Branch Calculator for label jumps
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
        4'b1000 : begin // OP_LUI
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
       4'b1_110 : BranchCondMetQ102H =  (AluIn1Q102H<AluIn2Q102H)                    ;// BLTU
       4'b1_111 : BranchCondMetQ102H = ~(AluIn1Q102H<AluIn2Q102H)                    ;// BGEU
       default  : BranchCondMetQ102H = 1'b0                                          ;
    endcase
end

`LOTR_MSFF   ( PcPlus4Q103H      , PcPlus4Q102H      , QClk) 
`LOTR_MSFF   ( AluOutQ103H       , AluOutQ102H       , QClk)
`LOTR_MSFF   ( Funct3Q103H       , Funct3Q102H       , QClk) 
`LOTR_MSFF   ( RegWrPtrQ103H     , RegWrPtrQ102H     , QClk)
`LOTR_MSFF   ( RegRdData2Q103H   , RegRdData2Q102H   , QClk)
`LOTR_MSFF   ( CtrlMemRdQ103H    , CtrlMemRdQ102H    , QClk) // output to DMEM
`LOTR_MSFF   ( CtrlMemWrQ103H    , CtrlMemWrQ102H    , QClk) // output to DMEM
`LOTR_MSFF   ( CtrlMemToRegQ103H , CtrlMemToRegQ102H , QClk)
`LOTR_MSFF   ( CtrlPcToRegQ103H  , CtrlPcToRegQ102H  , QClk)
`LOTR_MSFF   ( CtrlRegWrQ103H    , CtrlRegWrQ102H    , QClk)
`LOTR_MSFF   ( PcQ103H           , NextPcQ102H       , QClk) //FIXME - need to review nad understand - why not use PcQ102H?
`LOTR_MSFF   ( CtrlSignExtQ103H  , CtrlSignExtQ102H  , QClk) //FIXME - need to review nad understand - why not use PcQ102H?

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
// Outputs to memory
// the address from ALU assign to the output signal MemAdrsQ103H that goes right into the D_MEM module
assign  MemAdrsQ103H = AluOutQ103H;
//Byte Enable acording to Funct3 of the Opcode.
logic [3:0]  PreMemByteEnQ103H;
assign PreMemByteEnQ103H   = (Funct3Q103H[1:0] == 2'b00 ) ? 4'b0001 : // LB/SB
                             (Funct3Q103H[1:0] == 2'b01 ) ? 4'b0011 : // LH/SH
                             (Funct3Q103H[1:0] == 2'b10 ) ? 4'b1111 : // LW/SW
                                                            4'b0000 ; // 2'b11 is an illegal Funct3 //FIXME - ADD assetion 
// incase of of non-aligned word write access, need to shift left the Byte Enable & the write data.
//FIXME - perhaps this shift should be in the mem_wrap
assign MemByteEnQ103H = (MemAdrsQ103H[1:0] == 2'b01 ) ? { PreMemByteEnQ103H[2:0],1'b0 } :
                        (MemAdrsQ103H[1:0] == 2'b10 ) ? { PreMemByteEnQ103H[1:0],2'b0 } :
                        (MemAdrsQ103H[1:0] == 2'b11 ) ? { PreMemByteEnQ103H[0]  ,3'b0 } :
                                                          PreMemByteEnQ103H;
// The value read from register assign to the output signal MemWrDataQ103H that goes right into the D_MEM module
assign MemWrDataQ103H = (MemAdrsQ103H[1:0] == 2'b01 ) ? { RegRdData2Q103H[23:0],8'b0  } :
                        (MemAdrsQ103H[1:0] == 2'b10 ) ? { RegRdData2Q103H[15:0],16'b0 } :
                        (MemAdrsQ103H[1:0] == 2'b11 ) ? { RegRdData2Q103H[7:0] ,24'b0 } :
                                                          RegRdData2Q103H;



`LOTR_MSFF   ( PcPlus4Q104H      , PcPlus4Q103H      , QClk) 
`LOTR_MSFF   ( AluOutQ104H       , AluOutQ103H       , QClk)
`LOTR_MSFF   ( CtrlMemToRegQ104H , CtrlMemToRegQ103H , QClk)
`LOTR_MSFF   ( CtrlPcToRegQ104H  , CtrlPcToRegQ103H  , QClk)
`LOTR_MSFF   ( CtrlRegWrQ104H    , CtrlRegWrQ103H    , QClk)
`LOTR_MSFF   ( PreRegWrPtrQ104H  , RegWrPtrQ103H     , QClk)
`LOTR_MSFF   ( MemByteEnQ104H    , PreMemByteEnQ103H , QClk)
`LOTR_MSFF   ( CtrlSignExtQ104H  , CtrlSignExtQ103H  , QClk)
`LOTR_MSFF   ( SampT0RcAccess    , T0RcAccess        , QClk) 
`LOTR_MSFF   ( SampT1RcAccess    , T1RcAccess        , QClk) 
`LOTR_MSFF   ( SampT2RcAccess    , T2RcAccess        , QClk) 
`LOTR_MSFF   ( SampT3RcAccess    , T3RcAccess        , QClk) 

//This logic is used to remember the WrPtr when the LOAD request is not Local (Latecy is unknown)
// RcAccess -> Ring Controller Access
always_comb begin
if( (ThreadQ104H[0] && (!SampT0RcAccess)) || 
    (ThreadQ104H[1] && (!SampT1RcAccess)) || 
    (ThreadQ104H[2] && (!SampT2RcAccess)) || 
    (ThreadQ104H[3] && (!SampT3RcAccess)) ) begin
        //This is the common case
        RegWrPtrQ104H  = PreRegWrPtrQ104H;  
    end else begin
        //Only in the case of LOAD from non-local Memory
        RegWrPtrQ104H = ThreadQ104H[0] ? T0RegWrPtrQnnnH :
                        ThreadQ104H[1] ? T1RegWrPtrQnnnH :
                        ThreadQ104H[2] ? T2RegWrPtrQnnnH :
                      /*ThreadQ104H[3]*/ T3RegWrPtrQnnnH ;
    end
end
//////////////////////////////////////////////////////////////////////////////////////////////////
//    ____  __     __   _____   _        ______          ____    __    ___    _  _     _    _ 
//  / ____| \ \   / /  / ____| | |      |  ____|        / __ \  /_ |  / _ \  | || |   | |  | |
// | |       \ \_/ /  | |      | |      | |__          | |  | |  | | | | | | | || |_  | |__| |
// | |        \   /   | |      | |      |  __|         | |  | |  | | | | | | |__   _| |  __  |
// | |____     | |    | |____  | |____  | |____        | |__| |  | | | |_| |    | |   | |  | |
//  \_____|    |_|     \_____| |______| |______|        \___\_\  |_|  \___/     |_|   |_|  |_|
//
//////////////////////////////////////////////////////////////////////////////////////////////////
 
logic [31:0] PostBeMemRdData104H;
logic [31:0] PostShiftMemRdDataQ104H;
logic [1:0]  ByteOffsetQ104H;
assign ByteOffsetQ104H = AluOutQ104H[1:0]; 

// incase of of non-aligned read access, need to shift right the data.
//FIXME - perhaps this shift should be in the mem_wrap
assign PostShiftMemRdDataQ104H = (ByteOffsetQ104H == 2'b01) ? { 8'b0,MemRdDataQ104H[31:8]}  :
                                 (ByteOffsetQ104H == 2'b10) ? {16'b0,MemRdDataQ104H[31:16]} :
                                 (ByteOffsetQ104H == 2'b11) ? {24'b0,MemRdDataQ104H[31:24]} :
                                                                     MemRdDataQ104H         ;

// taking care of Sign extend  & Byte Enable
assign PostBeMemRdData104H[7:0]   =  MemByteEnQ104H[0] ? PostShiftMemRdDataQ104H[7:0]    : 8'b0;
assign PostBeMemRdData104H[15:8]  =  MemByteEnQ104H[1] ? PostShiftMemRdDataQ104H[15:8]   :
                                     CtrlSignExtQ104H  ? {8{PostBeMemRdData104H[7]}}     : 8'b0;
assign PostBeMemRdData104H[23:16] =  MemByteEnQ104H[2] ? PostShiftMemRdDataQ104H[23:16]  :
                                     CtrlSignExtQ104H  ? {8{PostBeMemRdData104H[15]}}    : 8'b0;
assign PostBeMemRdData104H[31:24] =  MemByteEnQ104H[3] ? PostShiftMemRdDataQ104H[31:24]  :
                                     CtrlSignExtQ104H  ? {8{PostBeMemRdData104H[23]}}    : 8'b0;

always_comb begin : candidates_for_register_write_data
    unique casez ({CtrlMemToRegQ104H , CtrlPcToRegQ104H , C2F_RspMatchQ104H}) 
        3'b010   : RegWrDataQ104H = PcPlus4Q104H   ; //Data from PC - for JAL?
        3'b100   : RegWrDataQ104H = PostBeMemRdData104H ; //Data from Memory
        3'b001   : RegWrDataQ104H = PostBeMemRdData104H ; //Data from Memory- C2F Response 
        default  : RegWrDataQ104H = AluOutQ104H    ; //Data from ALU (Common case)
    endcase         
end // always_comb
            
//--------------------------------------------------------

always_comb begin : write_register_file  //ADLV : Ask ABD about this comb
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
 //Register[0] will always be tied to '0;
    NextRegister0Q104H[0] = 32'b0;  
    NextRegister1Q104H[0] = 32'b0;  
    NextRegister2Q104H[0] = 32'b0;  
    NextRegister3Q104H[0] = 32'b0;  
end // always_comb
//This will freeze the WrPtr (RegDst) when waiting for RD_RSP from Fabric.
assign T0EnRegWrPtrQnnnH =(ThreadQ103H[0] && (!SampT0RcAccess));
assign T1EnRegWrPtrQnnnH =(ThreadQ103H[1] && (!SampT1RcAccess));
assign T2EnRegWrPtrQnnnH =(ThreadQ103H[2] && (!SampT2RcAccess));
assign T3EnRegWrPtrQnnnH =(ThreadQ103H[3] && (!SampT3RcAccess));
`LOTR_EN_MSFF( T0RegWrPtrQnnnH   , RegWrPtrQ103H  , QClk , T0EnRegWrPtrQnnnH)
`LOTR_EN_MSFF( T1RegWrPtrQnnnH   , RegWrPtrQ103H  , QClk , T1EnRegWrPtrQnnnH)
`LOTR_EN_MSFF( T2RegWrPtrQnnnH   , RegWrPtrQ103H  , QClk , T2EnRegWrPtrQnnnH)
`LOTR_EN_MSFF( T3RegWrPtrQnnnH   , RegWrPtrQ103H  , QClk , T3EnRegWrPtrQnnnH)

`ifdef SIMULATION_ON
////////////////////////////////////////////////////////////////////////////////////////
//          assertions
////////////////////////////////////////////////////////////////////////////////////////
logic [7:0] core_id_strap;
assign core_id_strap = 8'b0; //FIXME
logic               AssertBadMemR_W; 
logic               AssertIllegalRegister; 
logic               AssertBadMemAccessReg;
logic               AssertBadMemAccessCore;
logic               AssertIllegalPC;
always_comb begin : assertion
    AssertBadMemR_W = CtrlMemRdQ103H && CtrlMemWrQ103H;
    AssertBadMemAccessReg  = 1'b0;// ((CtrlMemRdQ103H || CtrlMemWrQ103H) && (MemAdrsQ103H[MSB_REGION:LSB_REGION]   != D_MEM_REGION)); //FIXME - this is not a assertion in the commen case
    AssertBadMemAccessCore = ((CtrlMemRdQ103H || CtrlMemWrQ103H) && (MemAdrsQ103H[MSB_CORE_ID:LSB_CORE_ID] != core_id_strap));
    AssertIllegalRegister  = 1'b0;//(CtrlRegWrQ104H && (RegWrPtrQ104H > 16 )); //currently using the RV32I with 32 registers
    AssertIllegalPC = (PcQ100H > 32'hfff);
end
`endif // SIMULATION_ON
endmodule
