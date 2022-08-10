//-----------------------------------------------------------------------------
// Title            : instruction memory wrap
// Project          : LOTR
//-----------------------------------------------------------------------------
// File             : i_mem_wrap.sv
// Original Author  : Amichai Ben-David
// Created          : 1/2020
//-----------------------------------------------------------------------------
// Description :
// will `ifdef the SRAM memory vs behavrial memory
//------------------------------------------------------------------------------
// Modification history :
//------------------------------------------------------------------------------
`include "lotr_defines.sv"

module i_mem_wrap 
import lotr_pkg::*;
                (
                input  logic        QClk  ,
                input  logic        RstQnnnH    ,
                //============================================
                //      core interface
                //============================================
                input  logic [31:0] PcQ100H,        //curr_pc    ,
                input  logic        RdEnableQ100H,  //core_rd_en   ,
                output logic [31:0] InstFetchQ101H, //instruction,
                //============================================
                //      RC interface
                //============================================
                input  logic        F2C_ReqValidQ503H     ,
                input  t_opcode     F2C_ReqOpcodeQ503H    ,
                input  logic [31:0] F2C_ReqAddressQ503H   ,
                input  logic [31:0] F2C_ReqDataQ503H      ,
                output logic        F2C_RspIMemValidQ504H , 
                output logic [31:0] F2C_I_MemRspDataQ504H 
                );


logic  F2C_I_MemHitQ503H;
logic  F2C_RdEnQ503H;
logic  F2C_WrEnQ503H;
//===========================================
//    set F2C request 503 ( D_MEM )
//===========================================
assign F2C_I_MemHitQ503H =(F2C_ReqAddressQ503H[MSB_REGION:LSB_REGION] == I_MEM_REGION);
assign F2C_RdEnQ503H     = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == RD) && F2C_I_MemHitQ503H;
assign F2C_WrEnQ503H     = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == WR) && F2C_I_MemHitQ503H;

`LOTR_MSFF(F2C_RspIMemValidQ504H, F2C_RdEnQ503H, QClk)
`ifdef DE10_LITE
	`ifdef IMEM_8K
		i_mem_8k i_mem (
	`else
		i_mem_4k_take2 i_mem (
	`endif //IMEM_8K
`else 
i_mem    i_mem  (
`endif // DE10_LITE
   
    .clock    (QClk),
    //Core interface (instruction fitch)
    .address_a  (PcQ100H[MSB_I_MEM:2]),
    .data_a     ('0),
    .rden_a     (RdEnableQ100H),
    .wren_a     ('0),
    .q_a        (InstFetchQ101H),
    //ring interface
    .address_b  (F2C_ReqAddressQ503H[MSB_I_MEM:2]),
    .data_b     (F2C_ReqDataQ503H),              
    .rden_b     (F2C_RdEnQ503H),                
    .wren_b     (F2C_WrEnQ503H),                
    .q_b        (F2C_I_MemRspDataQ504H)              
    );

endmodule               