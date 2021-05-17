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
//                 start   size    # of words
//  I_MEM          0x0     2KB     512
//  D_MEM          0x800   2KB     512
//  CR             0xC00   
//---------------------------------------------------
// Instruction Memory 2KB 
parameter LSB_I_MEM        = 0 ;
parameter MSB_I_MEM        = 11;
parameter SIZE_I_MEM       = 2048;

// Data Memory 2KB 
parameter LSB_D_MEM        = 0 ;
parameter MSB_D_MEM        = 11;
parameter SIZE_D_MEM       = 2048;

// CR Address Offsets
parameter MSB_CR           = 7;
parameter CR_EN_PC         = 8'b0000_0000;
parameter CR_RST_PC        = 8'b0000_0100;
parameter CR_CORE_ID       = 8'b0000_1000;
parameter CR_THREAD_ID     = 8'b0000_1100;

// Region Bits
parameter LSB_REGION    = 14;
parameter MSB_REGION    = 15;

// Encoded region
parameter I_MEM_REGION  = 2'b00;
parameter D_MEM_REGION  = 2'b00;
parameter CR_REGION     = 2'b00;

// CORE ID
// 8'b0000_0000 reserved - Always Hit Local Core Memory.
// 8'b1111_1111 reserved - Always Hit Local Core Memory & Brodcast to other cores.
parameter LSB_CORE_ID      = 16;
parameter MSB_CORE_ID      = 23;


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

