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
// 2) Q101H Instruction Decode + Excecute
// 3) Q102H Sent Address+Data to Data Memory 
// 4) Q103H Writeback data from Memory/ALU to Registerfile
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
    input  logic [31:0] InstFetchQ101H,
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
logic [31:0]        InstructionQ101H;
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


// ========= Thread Logic ==============
// Shift register to move the "valid" thread for each Cycle.
assign NextThreadQ100H = {ThreadQ100H[2:0], ThreadQ100H[3]};
`GPC_RST_VAL_MSFF(ThreadQ100H, NextThreadQ100H, QClk, RstQnnnH, 4'b0001)
assign ThreadQ101H = {ThreadQ100H[0] , ThreadQ100H[3:1]} ; //`GPC_MSFF(ThreadQ101H, ThreadQ100H, QClk)
assign ThreadQ102H = {ThreadQ101H[0] , ThreadQ101H[3:1]} ; //`GPC_MSFF(ThreadQ102H, ThreadQ101H, QClk)
assign ThreadQ103H = {ThreadQ102H[0] , ThreadQ102H[3:1]} ; //`GPC_MSFF(ThreadQ103H, ThreadQ102H, QClk) 
// TODO - Please add documentation comment on this logic - explain the assign and the GPC_MSFF are equvelent 
//-----------------------------------------
//          |  Q100H  Q101H  Q102H  Q103H
//-----------------------------------------
// cycle 0  |  0001   1000   0100   0010
// cycle 1  |  0010   0001   1000   0100   
// cycle 2  |  0100   0010   0001   1000
// cycle 3  |  1000   0100   0010   0001
// cycle 4  |  0001   1000   0100   0010
// cycle 5  |  0010   0001   1000   0100   
// cycle 6  |  0100   0010   0001   1000
// cycle 7  |  1000   0100   0010   0001


// Insert NOP - (back pressure, Wait for Read, ext..)
// FIXME - currently Enable only Thread0; ->Insert NOP for any other Thread
assign CtrlInsertNopQ101H = (ThreadQ101H != 4'b0001);          
assign InstructionQ101H = CtrlInsertNopQ101H ? NOP : InstFetchQ101H;
////////////////////////////////////////////////////////////////////////////////////////
//          Instruction "Decode" per Opcode Type - R/I/S/B/U/J Types
////////////////////////////////////////////////////////////////////////////////////////
assign U_ImmediateQ101H = { InstructionQ101H[31:12] , 12'b0 } ; 
assign I_ImmediateQ101H = { {20{InstructionQ101H[31]}} , InstructionQ101H[31:25] , InstructionQ101H[24:20] }; 
assign S_ImmediateQ101H = { {20{InstructionQ101H[31]}} , InstructionQ101H[31:25] , InstructionQ101H[11:7]  }; 
assign B_ImmediateQ101H = { {20{InstructionQ101H[31]}} , InstructionQ101H[7]     , InstructionQ101H[30:25] , InstructionQ101H[11:8]  , 1'b0}; 
assign J_ImmediateQ101H = { {12{InstructionQ101H[31]}} , InstructionQ101H[19:12] , InstructionQ101H[20]    , InstructionQ101H[30:21] , 1'b0}; 
assign RegRdPtr1Q101H   = InstructionQ101H[19:15];
assign RegRdPtr2Q101H   = InstructionQ101H[24:20];
assign RegWrPtrQ101H    = InstructionQ101H[11:7];
assign Funct3Q101H      = InstructionQ101H[14:12];
assign Funct7Q101H      = InstructionQ101H[31:25];
assign ShamtQ101H       = InstructionQ101H[24:20];
assign OpcodeQ101H      = InstructionQ101H[6:0];

////////////////////////////////////////////////////////////////////////////////////////
//          PC - Program Counter
////////////////////////////////////////////////////////////////////////////////////////

always_comb begin : set_next_pc
    PcBranchQ101H = PcQ101H + B_ImmediateQ101H; // ALU will set if branch condition met
    PcPlus4Q100H  = PcQ100H + 32'd4;
    unique casez ({ CtrlJalrQ101h , CtrlJalQ101H , BranchCondMetQ101H}) 
        3'b001  : NextPcQnnnH = PcBranchQ101H;     // OP_BRANCH 
        3'b010  : NextPcQnnnH = J_ImmediateQ101H;  // OP_JAL
        3'b100  : NextPcQnnnH = AluOutQ101H;       // OP_JALR ALU output I_ImmediateUQ101H + rs1
        default : NextPcQnnnH = PcPlus4Q100H;
    endcase
end



assign BrOrJmpQ102H = ( CtrlJalrQ101h || CtrlJalQ101H || BranchCondMetQ101H);


assign EnPCQnnnH   = 4'b0001; //Enable Only Thread 0 FIXME - this is Temp for Enabling the PIPE for Single Thread.
assign T0EnPcQnnnH = EnPCQnnnH[0] && (ThreadQ100H[0] || (BrOrJmpQ102H && ThreadQ102H[0]) );
assign T1EnPcQnnnH = EnPCQnnnH[1] && (ThreadQ100H[1] || (BrOrJmpQ102H && ThreadQ102H[1]) );
assign T2EnPcQnnnH = EnPCQnnnH[2] && (ThreadQ100H[2] || (BrOrJmpQ102H && ThreadQ102H[2]) );
assign T3EnPcQnnnH = EnPCQnnnH[3] && (ThreadQ100H[3] || (BrOrJmpQ102H && ThreadQ102H[3]) );


`GPC_EN_RST_MSFF( T0PcQ100H, NextPcQnnnH, QClk, T0EnPcQnnnH, RstQnnnH) 
`GPC_EN_RST_MSFF( T1PcQ100H, NextPcQnnnH, QClk, T1EnPcQnnnH, RstQnnnH) 
`GPC_EN_RST_MSFF( T2PcQ100H, NextPcQnnnH, QClk, T2EnPcQnnnH, RstQnnnH) 
`GPC_EN_RST_MSFF( T3PcQ100H, NextPcQnnnH, QClk, T3EnPcQnnnH, RstQnnnH) 

assign PcQ100H = ThreadQ100H[0] ? T0PcQ100H :
                 ThreadQ100H[1] ? T1PcQ100H :
                 ThreadQ100H[2] ? T2PcQ100H :
                                  T3PcQ100H ;

`GPC_MSFF       ( PcQ101H, PcQ100H,     QClk ) 

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
    NextRegisterQnnnH[0]         = 32'b0;           // Register[0] always '0;
	if (DervRstQnn1H) begin
		NextRegisterQnnnH[2]		 = 32'hf00;		//sp
		NextRegisterQnnnH[7] 		 = 32'hf00; 	//s0		
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
    //   fowording units
    //////////////////////
    // Q102H WrPtr == Q101H RdPtr
    if((RegRdPtr1Q101H == RegWrPtrQ102H ) && CtrlRegWrQ102H && (RegWrPtrQ102H!=5'b0)) begin
        RegRdData1Q101H = AluOutQ102H; 
    end
    if((RegRdPtr2Q101H == RegWrPtrQ102H ) && CtrlRegWrQ102H && (RegWrPtrQ102H!=5'b0)) begin
        RegRdData2Q101H = AluOutQ102H; 
    end
    // Q103H WrPtr == Q101H RdPtr
    if((RegRdPtr1Q101H == RegWrPtrQ103H ) && CtrlRegWrQ103H && (RegWrPtrQ103H!=5'b0)) begin
        RegRdData1Q101H = RegWrDataQ103H; 
    end
    if((RegRdPtr2Q101H == RegWrPtrQ103H ) && CtrlRegWrQ103H && (RegWrPtrQ103H!=5'b0)) begin
        RegRdData2Q101H = RegWrDataQ103H; 
    end
end

`GPC_MSFF(PcPlus4Q103H,      PcPlus4Q102H,      QClk)
`GPC_MSFF(CtrlMemToRegQ102H, CtrlMemToRegQ101H, QClk)
`GPC_MSFF(CtrlMemToRegQ103H, CtrlMemToRegQ102H, QClk)
`GPC_MSFF(CtrlPcToRegQ103H,  CtrlPcToRegQ102H,  QClk)
`GPC_MSFF(CtrlRegWrQ102H,    CtrlRegWrQ101H  ,  QClk) 
`GPC_MSFF(CtrlRegWrQ103H,    CtrlRegWrQ102H  ,  QClk) 

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

////////////////////////////////////////////////////////////////////////////////////////
//          DFD - Design for Debug
////////////////////////////////////////////////////////////////////////////////////////
//assign expose_reg.register  = RegRdData3Q101H; //read register acording to CRQnnnH.rd_ptr;
//assign expose_reg.pc        = PcPlus4Q101H;  //expose the pc


endmodule
//this will solve the conflict
