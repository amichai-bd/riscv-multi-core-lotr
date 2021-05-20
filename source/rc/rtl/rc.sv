//-----------------------------------------------------------------------------
// Title            : RC - Ring Controller 
// Project          : LOTR: Lord-Of-The-Ring
//-----------------------------------------------------------------------------
// File             : rc.sv 
// Original Author  : Tzahi Peretz, Shimi Haleluya 
// Created          : 5/2021
//-----------------------------------------------------------------------------
// Description :
// 
//
// 
//------------------------------------------------------------------------------
// Modification history :
//
//
//------------------------------------------------------------------------------

`include "lotr_defines.sv"
define ThreadNum 4
import lotr_pkg::*;
module rc
(
	//General Interface
	input   logic         QClk                   ,
	input   logic         RstQnnnH               ,
	//Ring ---> RC
	input   logic         RingInputValidQ500H    ,
	input   logic  [1:0]  RingInputOpcodeQ500H   ,
	input   logic  [31:0] RingInputAddressQ500H  ,
	input   logic  [31:0] RingInputDataQ500H     ,
	//RC   ---> Ring
	output  logic         RingOutputValidQ502H   ,
	output  logic  [1:0]  RingOutputOpcodeQ502H  ,
	output  logic  [31:0] RingOutputAddressQ502H ,
	output  logic  [31:0] RingOutputDataQ502H    ,
	
	//Core Req/Rsp <---> RC
	input   logic         C2F_ReqValidQ500H      ,
	input   logic  [1:0]  C2F_ReqOpcodeQ500H     ,
	input   logic  [1:0]  C2F_ReqThreadIDQ500H   ,
	input   logic  [31:0] C2F_ReqAddressQ500H    ,
	input   logic  [31:0] C2F_ReqDataQ500H       ,
	
	output   logic        C2F_RspValidQ502H      ,
	//output   logic [1:0]  C2F_RspOpcodeQ502H     ,// Fixme -  not sure neccesety - the core recieve on;y read responses
	output   logic [1:0]  C2F_RspThreadIDQ502H   ,
	output   logic [31:0] C2F_RspDataQ502H       ,
	output   logic        C2F_RspStall           ,
	
	// output  logic [31:0] C2F_RspAddressQ502H    ,is not necessery , because the thread already knows the read address .
	
	
	//RC   Req/Rsp <---> Core
	input   logic         F2C_RspValidQ500H      ,
	input   logic  [1:0]  F2C_RspOpcodeQ500H     , // Fixme -  not sure neccesety - the core recieve on;y read responses
	input   logic  [31:0] F2C_RspAddressQ500H    ,
	input   logic  [31:0] F2C_RspDataQ500H       ,
	
	output  logic         F2C_ReqValidQ502H      ,
	output  logic  [1:0]  F2C_ReqOpcodeQ502H     ,
	output  logic  [31:0] F2C_ReqAddressQ502H    ,
	output  logic  [31:0] F2C_ReqDataQ502H
);

//=========================================
//=====    Data Path Signals    ===========
//=========================================
// Ring Interface
logic     				RingInputValidQ501H;
logic [1:0]				RingInputOpcodeQ501H;
logic [31:0]            RingInputAddressQ501H;
logic [31:0]            RingInputDataQ501H;

logic         			RingOutputValidQ501H   ;
logic [1:0]   			RingOutputOpcodeQ501H  ;
logic [31:0]            RingOutputAddressQ501H;
logic [31:0]            RingOutputDataQ501H;


// C2F BUFFER
// States : FREE '000' , WRITE '001' , READ '010' , READ_PRGRS '011' , READ_RDY '100'
//          WRITE_BCAST '101' , WRITE_BCAST_PRGRS '110'
// Opcodes : Command type - RD=00 , RD_RSP=01 ,WR=10 , WR_BCAST=11
logic [C2F_MSB:0]      	C2F_BufferValidQnnnH       ;
logic [C2F_MSB:0][1:0]  C2F_BufferOpcodeQnnnH       ;
logic [C2F_MSB:0][1:0]  C2F_BufferThreadIDQnnnH    ;
logic [C2F_MSB:0][31:0] C2F_BufferAddressQnnnH  ;
logic [C2F_MSB:0][31:0] C2F_BufferDataQnnnH     ;
logic [C2F_MSB:0][2:0]  C2F_BufferStateQnnnH      ;

logic [C2F_MSB:0]      	C2F_NextBufferValidQnnnH       ;
logic [C2F_MSB:0][1:0]  C2F_NextBufferOpcodeQnnnH       ;
logic [C2F_MSB:0][1:0]  C2F_NextBufferThreadIDQnnnH    ;
logic [C2F_MSB:0][31:0] C2F_NextBufferAddressQnnnH;
logic [C2F_MSB:0][31:0] C2F_NextBufferDataQnnnH ;
logic [C2F_MSB:0][2:0]  C2F_NextBufferStateQnnnH      ;


logic       			C2F_ReqValidQ501H      ;
logic [1:0]  			C2F_ReqOpcodeQ501H    ;
logic [31:0] 			C2F_ReqAddressQ501H;
logic [31:0] 			C2F_ReqDataQ501H;


// F2C BUFFER
logic [F2C_MSB:0]      	F2C_BufferValidQnnnH       ;
logic [F2C_MSB:0][1:0]  F2C_BufferOpcodeQnnnH       ;
logic [F2C_MSB:0][31:0] F2C_BufferAddressQnnnH;
logic [F2C_MSB:0][31:0] F2C_BufferDataQnnnH;
logic [F2C_MSB:0][2:0]  F2C_BufferStateQnnnH      ;

logic [F2C_MSB:0]      	F2C_NextBufferValidQnnnH       ;
logic [F2C_MSB:0][1:0]  F2C_NextBufferOpcodeQnnnH       ;
logic [F2C_MSB:0][31:0] F2C_NextBufferAddressQnnnH;
logic [F2C_MSB:0][31:0] F2C_NextBufferDataQnnnH;
logic [F2C_MSB:0][2:0]  F2C_NextBufferStateQnnnH      ;

logic       			F2C_RspValidQ501H    ;
logic [1:0]  			F2C_RspOpcodeQ501H   ;
logic [31:0] 			F2C_RspAddressQ501H  ;
logic [31:0] 			F2C_RspDataQ501H     ;

//=========================================
//=====    Control Bits Signals   =========
//=========================================
// === General ===
logic [1:0]       SelRingOutQ501H;

// === C2F ===
logic [C2F_ENC_MSB:0] C2F_SelRdRingQ501H;
logic [C2F_ENC_MSB:0] C2F_SelRdCoreQ502H;
logic [C2F_MSB:0]     C2F_EnRingWrQ501H;// FIXME -
logic [C2F_MSB:0]     C2F_EnCoreWrQ500H; //FIXME
logic [C2F_MSB:0]     C2F_EnWrQnnnH;
logic [C2F_MSB:0]     C2F_SelWrQnnnH;

// === F2C ===
logic [C2F_ENC_MSB:0] F2C_SelRdRingQ501H;
logic [C2F_ENC_MSB:0] F2C_SelRdCoreQ502H;
logic [C2F_MSB:0]     F2C_EnRingWrQ501H;
logic [C2F_MSB:0]     F2C_EnCoreWrQ500H;
logic [C2F_MSB:0]     F2C_EnWrQnnnH;
logic [C2F_MSB:0]     F2C_SelWrQnnnH;


//======================================================================================
//=========================     Module Content      ====================================
//======================================================================================
//  TODO - add discription of this module structure and blockes
//
//======================================================================================

//=========================================
// Ring input Interface
//=========================================

`LOTR_MSFF( RingInputValidQ501H   , RingInputValidQ500H  , QClk )
`LOTR_MSFF( RingInputOpcodeQ501H ,  RingInputOpcodeQ500H , QClk )
`LOTR_MSFF( RingInputAddressQ501H,  RingInputAddressQ500H, QClk )
`LOTR_MSFF( RingInputDataQ501H   ,  RingInputDataQ500H   , QClk )


//==================================================================================
//              The C2F Buffer - Core 2 Fabric
//==================================================================================
//  TODO - add description of this block
//  only read responses aredont coming from the ring input, therefore if read response arrives from the
//   rinrg ,we  need to update the next buffer data only .
// but if command (read/write) comes from the core , we need to update all
// the next buffers(data,adress, thredid ...)
//==================================================================================
always_comb begin : set_c2f_wr_en
	C2F_EnCoreWrQ500H = '0; // FIXME - set the condition for this EN
	C2F_EnRingWrQ501H = '0; // FIXME - set the condition for this EN
end //always_comb


// States : FREE '000' , WRITE '001' , READ '010' , READ_PRGRS '011' , READ_RDY '100'
//          WRITE_BCAST '101' , WRITE_BCAST_PRGRS '110'
// Opcodes : Command type - RD=00 , RD_RSP=01 ,WR=10 , WR_BCAST=11

// ===== C2F Buffer Input =========
always_comb begin : next_c2f_buffer_per_buffer_entry
	C2F_EnWrQnnnH   = C2F_EnCoreWrQ500H | C2F_EnRingWrQ501H;
	C2F_SelWrQnnnH  = C2F_EnCoreWrQ500H;
	for(int i =0; i < C2F_BUFFER_SIZE; i++) begin
		C2F_NextBufferValidQnnnH[i]    = C2F_SelWrQnnnH[i] ? C2F_ReqValidQ500H    : RingInputValidQ501H ;
		C2F_NextBufferOpcodeQnnnH[i]   = C2F_SelWrQnnnH[i] ? C2F_ReqOpcodeQ500H   : RingInputOpcodeQ501H
				C2F_NextBufferThreadIDQnnnH[i] = C2F_SelWrQnnnH[i] ? C2F_ReqThreadIDQ500H : C2F_BufferThreadIDQnnnH[i] ;
		C2F_NextBufferAddressQnnnH[i]  = C2F_SelWrQnnnH[i] ? C2F_ReqAddressQ500H  : RingInputAddressQ501H ;
		C2F_NextBufferDataQnnnH[i]     = C2F_SelWrQnnnH[i] ? C2F_ReqDataQ500H     : RingInputDataQ501H   ;
		case(C2F_BufferStateQnnnH[i])
			//Slot is FREE
			3'b000 : // given Opcode is Read
					if (C2F_NextBufferOpcodeQnnnH[i] == 2'b00)
						C2F_NextBufferStateQnnnH[i] =  3'b010 ;
					// given Opcode is Write
					else if (C2F_NextBufferOpcodeQnnnH[i] == 2'b10)
						C2F_NextBufferStateQnnnH[i] =  3'b001 ;
					// given Opcode is Write Bcast
					else if (C2F_NextBufferOpcodeQnnnH[i] == 2'b11)
						C2F_NextBufferStateQnnnH[i] =  3'b101 ;
					// not suppose to happen ! from free cannot recieve read rsp
					// 3'b111 indicates Error
					else if (C2F_NextBufferOpcodeQnnnH[i] == 2'b01)
						C2F_NextBufferStateQnnnH[i] =  3'b111 ;
			//Slot is WRITE
			3'b001 : // FIXME  if there is enable for the mux buffer exit .add it to the if .
					// if the C2F out mux choose this entry , and out mux passing C2F_req
					if (C2F_SelRdRingQ501H == i && SelRingOutQ501H == 3 )
						C2F_NextBufferStateQnnnH[i] =  3'b000 ;
					else
						C2F_NextBufferStateQnnnH[i] = 3'b001 ;
			//Slot is READ
			3'b010 :// FIXME  if there is enable for the mux buffer exit .add it to the if .
					// if the C2F out mux choose this entry , and out mux passing C2F_req
					if (C2F_SelRdRingQ501H == i && SelRingOutQ501H == 3 )
						C2F_NextBufferStateQnnnH[i] =  3'b011 ;
					else
						C2F_NextBufferStateQnnnH[i] = 3'b010 ;
			//Slot is READ PRGRS
			3'b011 :// FIXME  if there is enable from the core , indicates for new command from it.
					if ( C2F_NextBufferOpcodeQnnnH[i] == 2'b01 && C2F_NextBufferAddressQnnnH[i] == C2F_BufferAddressQnnnH[i] )
						C2F_NextBufferStateQnnnH[i] =  3'b100 ;
					else
						C2F_NextBufferStateQnnnH[i] = 3'b011 ;
			
			//Slot is READ_RDY
			3'b100 :// FIXME  if there is enable for the mux buffer exit towared the core
					if ( C2F_SelRdCoreQ502H == i )
						C2F_NextBufferStateQnnnH[i] =  3'b000 ;
					else
						C2F_NextBufferStateQnnnH[i] = 3'b100 ;
			//Slot is WRITE BCAST
			3'b101 :// FIXME  if there is enable for the mux buffer exit
					if (C2F_SelRdRingQ501H == i && SelRingOutQ501H == 3 )
						C2F_NextBufferStateQnnnH[i] =  3'b110 ;
					else
						C2F_NextBufferStateQnnnH[i] = 3'b101 ;
			//Slot is WRITE BCAST PRGRS
			3'b110 :// FIXME  if there is enable for the mux buffer exit
					if ( RingInputOpcodeQ501H == 2'b11 &&   C2F_BufferAddressQnnnH[i] == RingInputAddressQ501H )
						C2F_NextBufferStateQnnnH[i] =  3'b000 ;
					else
						C2F_NextBufferStateQnnnH[i] = 3'b110 ;
		endcase
	end //for C2F_BUFFER_SIZE
end //always_comb

// ==== C2F Buffer =================
genvar C2F_ENTRY;
generate for ( C2F_ENTRY =0 ; C2F_entry < C2F_BUFFER_SIZE ; C2F_ENTRY++) begin : the_c2f_buffer_array
	`LOTR_EN_MSFF( C2F_BufferValidQnnnH[C2F_ENTRY]   , C2F_NextBufferValidQnnnH[C2F_ENTRY] ,  QClk, C2F_EnWrQnnnH[C2F_ENTRY])
	`LOTR_EN_MSFF( C2F_BufferOpcodeQnnnH[C2F_ENTRY]  , C2F_NextBufferOpcodeQnnnH[C2F_ENTRY],  QClk, C2F_EnWrQnnnH[C2F_ENTRY])
	`LOTR_EN_MSFF( C2F_BufferThreadIDQnnnH[C2F_ENTRY], C2F_NextBufferThreadIDQnnnH[C2F_ENTRY],QClk, C2F_EnWrQnnnH[C2F_ENTRY])
	`LOTR_EN_MSFF( C2F_BufferAddressQnnnH[C2F_ENTRY] , C2F_NextBufferAddressQnnnH[C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY])
	`LOTR_EN_MSFF( C2F_BufferDataQnnnH   [C2F_ENTRY] , C2F_NextBufferDataQnnnH   [C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY])
	`LOTR_EN_MSFF( C2F_BufferStateQnnnH   [C2F_ENTRY] ,C2F_NextBufferStateQnnnH  [C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY])
	
end endgenerate // for , generate

// ==== C2F Buffer Output ==========
always_comb begin : set_c2f_sel_rd_buffer
	C2F_SelRdRingQ501H = '0; // FIXME - set the condition for this Selector
	C2F_SelRdCoreQ502H = '0; // FIXME - set the condition for this Selector
end //always_comb

always_comb begin : select_C2F_from_buffer
	// C2F_buferr -> Ring (Requist)
	C2F_ReqValidQ501H   = C2F_BufferValidQnnnH[C2F_SelRdRingQ501H] ;
	C2F_ReqOpcodeQ501H  = C2F_BufferOpcodeQnnnH[C2F_SelRdRingQ501H];
	C2F_ReqAddressQ501H = C2F_BufferAddressQnnnH[C2F_SelRdRingQ501H]; // NOTE: The 501 Cycle is due to the origin of the Request (CoreReqQ500H)
	C2F_ReqDataQ501H    = C2F_BufferDataQnnnH   [C2F_SelRdRingQ501H];
	// C2F_buffer -> Core (Response)
	// C2F_RspAddressQ502H = C2F_BufferAddressQnnnH[C2F_SelRdCoreQ502H]; // Note: The 502 Cycle is due to the origin of the Response (RingInputQ500H->RingInputQ501H)
	C2F_RspDataQ502H    = C2F_BufferDataQnnnH[C2F_SelRdCoreQ502H];
	C2F_RspThreadIDQ502H =  C2F_BufferThreadIDQnnnH[C2F_SelRdCoreQ502H];
	
end //always_comb
	// C2F_buferr -> Ring (Requist)
always_comb begin : raise_stall_signal
	for ( C2F_ENTRY =0 ; C2F_entry < C2F_BUFFER_SIZE ; C2F_ENTRY++) begin :
		if ( C2F_BufferStateQnnnH[C2F_ENTRY] == 3'b000 ) begin :
			C2F_RspStall = 1'b0 ;
			break
		end
		if (C2F_ENTRY == C2F_BUFFER_SIZE -1 ) begin :
			C2F_RspStall = 1'b1 ;
		end
	end
end //always_comb


//==================================================================================
//              The F2C Buffer - Fabric 2 Core
//==================================================================================
//  TODO - add discription of this block
//
//==================================================================================
always_comb begin : set_f2c_wr_en
	F2C_EnCoreWrQ500H = '0; // FIXME - set the condition for this EN
	F2C_EnRingWrQ501H = '0; // FIXME - set the condition for this EN
end //always_comb

//
// ===== F2C Buffer Input =========
always_comb begin : next_f2c_buffer_per_buffer_entry
	F2C_EnWrQnnnH   = F2C_EnCoreWrQ500H | F2C_EnRingWrQ501H;
	F2C_SelWrQnnnH  = F2C_EnCoreWrQ500H;
	for(int i =0; i < F2C_BUFFER_SIZE; i++) begin
		F2C_NextBufferValidQnnnH[i]   = F2C_SelWrQnnnH[i] ? F2C_RspValidQ500H   : RingInputValidQ501H   ;
		F2C_NextBufferOpcodeQnnnH[i]  = F2C_SelWrQnnnH[i] ? F2C_RspOpcodeQ500H  : RingInputOpcodeQ501H  ;
		F2C_NextBufferAddressQnnnH[i] = F2C_SelWrQnnnH[i] ? F2C_RspAddressQ500H : RingInputAddressQ501H ;
		F2C_NextBufferDataQnnnH[i]    = F2C_SelWrQnnnH[i] ? F2C_RspDataQ500H    : RingInputDataQ501H    ;
		
		// States : FREE '000' , WRITE '001' , READ '010' , READ_PRGRS '011' , READ_RDY '100'
		// Opcodes : Command type - RD=00 , RD_RSP=01 ,WR=10 , WR_BCAST=11
		case(F2C_BufferStateQnnnH[i])
		//Slot is FREE
		3'b000 : // given Opcode is Read
				if (F2C_NextBufferOpcodeQnnnH[i] == 2'b00)
					F2C_NextBufferStateQnnnH[i] =  3'b010 ;
				// given Opcode is Write
				else if (F2C_NextBufferOpcodeQnnnH[i] == 2'b10)
					F2C_NextBufferStateQnnnH[i] =  3'b001 ;
				// given Opcode is Write Bcast
				else if (F2C_NextBufferOpcodeQnnnH[i] == 2'b11)
					F2C_NextBufferStateQnnnH[i] =  3'b001 ;
				// not suppose to happen ! from free cannot recieve read rsp
				// 3'b111 indicates Error
				else if (F2C_NextBufferOpcodeQnnnH[i] == 2'b01)
					F2C_NextBufferStateQnnnH[i] =  3'b111 ;
		//Slot is WRITE
		3'b001 : // FIXME  if there is enable for the mux buffer exit .add it to the if .
				if (F2C_SelRdCoreQ502H == i  )
					F2C_NextBufferStateQnnnH[i] =  3'b000 ;
				else
					F2C_NextBufferStateQnnnH[i] = 3'b001 ;
		//Slot is READ
		3'b010 :// FIXME  if there is enable for the mux buffer exit .add it to the if .
				// if the C2F out mux choose this entry , and out mux passing C2F_req
				if (F2C_SelRdCoreQ502H == i )
					F2C_NextBufferStateQnnnH[i] =  3'b011 ;
				else
					F2C_NextBufferStateQnnnH[i] = 3'b010 ;
		//Slot is READ PRGRS
		3'b011 :// FIXME  if there is enable from the core , indicates for new command from it.
				if ( F2C_NextBufferOpcodeQnnnH[i] == 2'b01 && F2C_NextBufferAddressQnnnH[i] == F2C_BufferAddressQnnnH[i] )
					F2C_NextBufferStateQnnnH[i] =  3'b100 ;
				else
					F2C_NextBufferStateQnnnH[i] = 3'b011 ;
		
		//Slot is READ_RDY
		3'b100 :// FIXME  if there is enable for the mux buffer exit towared the core
				if ( F2C_SelRdRingQ501H == i && SelRingOutQ501H == 2 )
					F2C_NextBufferStateQnnnH[i] =  3'b000 ;
				else
					F2C_NextBufferStateQnnnH[i] = 3'b100 ;
	end //for F2C_BUFFER_SIZE
end //always_comb

// ==== F2C Buffer =================
genvar F2C_ENTRY;
generate for ( F2C_ENTRY =0 ; F2C_entry < F2C_BUFFER_SIZE ; F2C_ENTRY++) begin : the_f2c_buffer_array
	`LOTR_EN_MSFF( F2C_BufferValidQnnnH[F2C_ENTRY], F2C_NextBufferValidQnnnH[F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY])
	`LOTR_EN_MSFF( F2C_BufferOpcodeQnnnH[F2C_ENTRY], F2C_NextBufferOpcodeQnnnH[F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY])
	`LOTR_EN_MSFF( F2C_BufferStateQnnnH[F2C_ENTRY], F2C_NextBufferStateQnnnH[F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY])
	`LOTR_EN_MSFF( F2C_BufferAddressQnnnH[F2C_ENTRY], F2C_NextBufferAddressQnnnH[F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY])
	`LOTR_EN_MSFF( F2C_BufferDataQnnnH   [F2C_ENTRY], F2C_NextBufferDataQnnnH   [F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY])
end endgenerate // for , generate

// ==== F2C Buffer Output ==========
always_comb begin : set_f2c_sel_rd_buffer
	F2C_SelRdRingQ501H = '0; // FIXME - set the condition for this Selector
	F2C_SelRdCoreQ502H = '0; // FIXME - set the condition for this Selector
end //always_comb

always_comb begin : select_f2c_from_buffer
	// F2C_buferr -> Ring (Response)
	F2C_RspValidQ501H   = F2C_BufferValidQnnnH[F2C_SelRdRingQ501H]  ; 
	F2C_RspOpcodeQ501H  = F2C_BufferOpcodeQnnnH[F2C_SelRdRingQ501H] ; 
	F2C_RspAddressQ501H = F2C_BufferAddressQnnnH[F2C_SelRdRingQ501H]; // NOTE: The 501 Cycle is due to the origin of the Request (CoreReqQ500H)
	F2C_RspDataQ501H    = F2C_BufferDataQnnnH   [F2C_SelRdRingQ501H];

	// F2C_buffer -> Core (Request)
	F2C_ReqValidQ502H  =  F2C_BufferValidQnnnH  [F2C_SelRdCoreQ502H];
	F2C_ReqOpcodeQ502H =  F2C_BufferOpcodeQnnnH [F2C_SelRdCoreQ502H];
	F2C_ReqAddressQ502H = F2C_BufferAddressQnnnH[F2C_SelRdCoreQ502H]; // Note: The 502 Cycle is due to the origin of the Response (RingInputQ500H->RingInputQ501H)
	F2C_ReqDataQ502H    = F2C_BufferDataQnnnH   [F2C_SelRdCoreQ502H];
	
end //always_comb


//==================================================================================
//                  Ring output Interface
//==================================================================================
//  TODO - add more detailed discription of this block
//  Select the Ring Output.
//  C2F_Req / F2C_Rsp / RingInput
//==================================================================================

always_comb begin : set_the_select_next_ring_output_logic
	SelRingOutQ501H = '0;  // FIXME - set the condition for this Selector
end //always_comb

always_comb begin : select_next_ring_output
	//mux 4:1
	unique casez (SelRingOutQ501H)
		2'b00   : begin // Insert Invalid Cycle
			RingOutputValidQ501H    = 1'b0; // FIXME - think and change the code to consider the valid bit 
			RingOutputOpcodeQ501H   = 2'b0;
			RingOutputAddressQ501H  = 32'b0;
			RingOutputDataQ501H     = 32'b0;
		end
		2'b01   : begin // Foword the Ring Input
			RingOutputValidQ501H    = RingInputValidQ501H  ;
			RingOutputOpcodeQ501H   = RingInputOpcodeQ501H ;
			RingOutputAddressQ501H  = RingInputAddressQ501H;
			RingOutputDataQ501H     = RingInputDataQ501H   ;
		end
		2'b10   : begin // Send the F2C Rsp
			RingOutputValidQ501H    = F2C_RspValidQ501H    ;
			RingOutputOpcodeQ501H   = F2C_RspOpcodeQ501H   ;
			RingOutputAddressQ501H  = F2C_RspAddressQ501H  ;
			RingOutputDataQ501H     = F2C_RspDataQ501H     ;
		end
		2'b11   : begin // Send the C2F Req
			RingOutputValidQ501H    = C2F_ReqValidQ501H    ;
			RingOutputOpcodeQ501H   = C2F_ReqOpcodeQ501H   ;
			RingOutputAddressQ501H  = C2F_ReqAddressQ501H  ;
			RingOutputDataQ501H     = C2F_ReqDataQ501H     ;
		end
	endcase
end

//The Sample before Ring Output
`LOTR_MSFF( RingOutputValidQ502H   , RingOutputValidQ501H  , QClk )
`LOTR_MSFF( RingOutputOpcodeQ502H  , RingOutputOpcodeQ501H , QClk )
`LOTR_MSFF( RingOutputAddressQ502H , RingOutputAddressQ501H, QClk )
`LOTR_MSFF( RingOutputDataQ502H    , RingOutputDataQ501H   , QClk )


endmodule // module rc
