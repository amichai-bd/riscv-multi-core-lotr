//-----------------------------------------------------------------------------
// Title         : gpc_4t parameter package
// Project       : gpc_4t
//-----------------------------------------------------------------------------
// File          : gpc_4t_param_pkg.sv
// Author        : Amichai Ben-David
// Created       : 1/2020
//-----------------------------------------------------------------------------
// Description :
// parameters and struct used in gpc_4t
//-----------------------------------------------------------------------------

package gpc_4t_pkg;
// number registers in register file.
parameter OP_LUI       = 7'b0110111;
parameter OP_AUIPC     = 7'b0010111;
parameter OP_JAL       = 7'b1101111;
parameter OP_JALR      = 7'b1100111;
parameter OP_BRANCH    = 7'b1100011;
parameter OP_LOAD      = 7'b0000011;
parameter OP_STORE     = 7'b0100011;
parameter OP_OPIMM     = 7'b0010011;
parameter OP_OP        = 7'b0110011;
parameter OP_FENCE     = 7'b0001111;
parameter OP_SYSTEM    = 7'b1110011;


parameter NOP          = 32'b0000000000_00000_000_00000_0010011; //addi x0 , x0 , 0

//---------------------MEMORY------------------------
//                 start        size    # of words
//  I_MEM          0x00_0000    4KB     1024
//  D_MEM          0x80_0000    4KB     1024
//  CR             0xC0_0000 
//---------------------------------------------------

// agent_id [31:24] | region [23:22] | reserved[21:12] | offset [11:0]

// Instruction Memory 2KB 
parameter LSB_I_MEM        = 0 ;
parameter MSB_I_MEM        = 11;
parameter SIZE_I_MEM       = 2**(MSB_I_MEM);

// Data Memory 2KB 
parameter LSB_D_MEM        = 0 ;
parameter MSB_D_MEM        = 11;
parameter SIZE_D_MEM       = 2**(MSB_D_MEM);

// CR Address Offsets
parameter MSB_CR           = 7;
parameter CR_EN_PC         = 8'h0;
parameter CR_RST_PC        = 8'h4;
parameter CR_CORE_ID       = 8'h8;
parameter CR_THREAD_ID     = 8'hC;

// Region Bits
parameter LSB_REGION    = 22;
parameter MSB_REGION    = 23;

// Encoded region
parameter I_MEM_REGION  = 2'b00;
parameter D_MEM_REGION  = 2'b01;
parameter CR_REGION     = 2'b11;

// CORE ID
// 8'b0000_0000 reserved - Always Hit Local Core Memory.
// 8'b1111_1111 reserved - Always Hit Local Core Memory & Brodcast to other cores.
parameter LSB_CORE_ID      = 24;
parameter MSB_CORE_ID      = 31;


typedef struct packed {
    logic       en_pc;
    logic       rst_pc;
} t_cr;

typedef struct packed {
    logic [31:0] pc;
} t_sr;

typedef struct packed {
    t_cr         cr;
    t_sr         sr;
} t_mmio;



endpackage // gpc_pkg

