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
//  D_MEM          0x40_0000    4KB     1024
//  CR             0xC0_0000 
//---------------------------------------------------

// agent_id [31:24] | region [23:22] | reserved[21:12] | offset [11:0]

// Instruction Memory 4KB 
parameter LSB_I_MEM        = 0 ;
parameter MSB_I_MEM        = 11;
parameter SIZE_I_MEM       = 2**(MSB_I_MEM + 1);

// Data Memory 4KB 
parameter LSB_D_MEM        = 0 ;
parameter MSB_D_MEM        = 11;
parameter SIZE_D_MEM       = 2**(MSB_D_MEM + 1);
parameter SIZE_SHRD_MEM    = 2**(MSB_D_MEM );

parameter MSB_CR                      = 7;
// CR Address Offsets
parameter CR_WHO_AM_I                 = 12'h0  ;
parameter CR_THREAD_ID                = 12'h4  ;
parameter CR_CORE_ID                  = 12'h8  ;
parameter CR_STACK_BASE_OFFSET        = 12'hc  ;
parameter CR_TLS_BASE_OFFSET          = 12'h10 ;
parameter CR_SHARED_BASE_OFFSET       = 12'h14 ;
parameter CR_I_MEM_MSB                = 12'h18 ;
parameter CR_D_MEM_MSB                = 12'h20 ;
parameter CR_SUPPORTED_ARCH           = 12'h24 ;
parameter CR_THREAD0_STATUS           = 12'h110;
parameter CR_THREAD1_STATUS           = 12'h114;
parameter CR_THREAD2_STATUS           = 12'h118;
parameter CR_THREAD3_STATUS           = 12'h11c;
parameter CR_THREAD0_EXCEPTION_CODE   = 12'h120;
parameter CR_THREAD1_EXCEPTION_CODE   = 12'h124;
parameter CR_THREAD2_EXCEPTION_CODE   = 12'h128;
parameter CR_THREAD3_EXCEPTION_CODE   = 12'h12c;
parameter CR_THREAD0_PC               = 12'h130;
parameter CR_THREAD1_PC               = 12'h134;
parameter CR_THREAD2_PC               = 12'h138;
parameter CR_THREAD3_PC               = 12'h13c;
parameter CR_THREAD0_PC_RST           = 12'h140;
parameter CR_THREAD1_PC_RST           = 12'h144;
parameter CR_THREAD2_PC_RST           = 12'h148;
parameter CR_THREAD3_PC_RST           = 12'h14c;
parameter CR_THREAD0_PC_EN            = 12'h150;
parameter CR_THREAD1_PC_EN            = 12'h154;
parameter CR_THREAD2_PC_EN            = 12'h158;
parameter CR_THREAD3_PC_EN            = 12'h15c;
parameter CR_THREAD0_DFD_REG_ID       = 12'h160;
parameter CR_THREAD1_DFD_REG_ID       = 12'h164;
parameter CR_THREAD2_DFD_REG_ID       = 12'h168;
parameter CR_THREAD3_DFD_REG_ID       = 12'h16c;
parameter CR_THREAD0_DFD_REG_DATA     = 12'h170;
parameter CR_THREAD1_DFD_REG_DATA     = 12'h174;
parameter CR_THREAD2_DFD_REG_DATA     = 12'h178;
parameter CR_THREAD3_DFD_REG_DATA     = 12'h17c;
parameter CR_THREAD0_STACK_BASE_OFFSET= 12'h180;
parameter CR_THREAD1_STACK_BASE_OFFSET= 12'h184;
parameter CR_THREAD2_STACK_BASE_OFFSET= 12'h188;
parameter CR_THREAD3_STACK_BASE_OFFSET= 12'h18c;
parameter CR_THREAD0_TLS_BASE_OFFSET  = 12'h190;
parameter CR_THREAD1_TLS_BASE_OFFSET  = 12'h194;
parameter CR_THREAD2_TLS_BASE_OFFSET  = 12'h198;
parameter CR_THREAD3_TLS_BASE_OFFSET  = 12'h19c;
parameter CR_SCRATCHPAD0              = 12'h200;
parameter CR_SCRATCHPAD1              = 12'h204;
parameter CR_SCRATCHPAD2              = 12'h208;
parameter CR_SCRATCHPAD3              = 12'h20C;

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


typedef struct packed { // RO\V
    logic [9:0]  who_am_i;
    logic [1:0]  thread;
    logic [7:0]  core;
    logic [31:0] stk_ofst;
    logic [31:0] tls_ofst;
    logic [7:0]  i_mem_msb;
    logic [7:0]  d_mem_msb;
    logic [7:0]  sts_0;
    logic [7:0]  sts_1;
    logic [7:0]  sts_2;
    logic [7:0]  sts_3;
    logic [31:0] expt_0;
    logic [31:0] expt_1;
    logic [31:0] expt_2;
    logic [31:0] expt_3;
    logic [31:0] pc_0;
    logic [31:0] pc_1;
    logic [31:0] pc_2;
    logic [31:0] pc_3;
        
} t_cr_ro;

typedef struct packed { //RW
    logic [4:0]  dfd_id_0;
    logic [4:0]  dfd_id_1;
    logic [4:0]  dfd_id_2;
    logic [4:0]  dfd_id_3;  
    logic [31:0] stk_ofst_0;
    logic [31:0] stk_ofst_1;
    logic [31:0] stk_ofst_2;
    logic [31:0] stk_ofst_3; 
    logic [31:0] tls_ofst_0;
    logic [31:0] tls_ofst_1;
    logic [31:0] tls_ofst_2;
    logic [31:0] tls_ofst_3;    
    logic [31:0] shrd_ofst;
} t_cr_rw;

typedef struct packed { //RW
    logic        en_pc_0;
    logic        en_pc_1;
    logic        en_pc_2;
    logic        en_pc_3;
    logic        rst_pc_0;
    logic        rst_pc_1;
    logic        rst_pc_2;
    logic        rst_pc_3;
} t_core_cr;

typedef struct packed { 
    logic who_am_i;
    logic en_pc_0;
    logic en_pc_1;
    logic en_pc_2;
    logic en_pc_3;
    logic rst_pc_0;
    logic rst_pc_1;
    logic rst_pc_2;
    logic rst_pc_3;
    logic dfd_id_0;
    logic dfd_id_1;
    logic dfd_id_2;
    logic dfd_id_3;  
    logic stk_ofst_0;
    logic stk_ofst_1;
    logic stk_ofst_2;
    logic stk_ofst_3; 
    logic tls_ofst_0;
    logic tls_ofst_1;
    logic tls_ofst_2;
    logic tls_ofst_3; 
    logic thread;
    logic core;
    logic stk_ofst;
    logic tls_ofst;
    logic shrd_ofst;
    logic i_mem_msb;
    logic d_mem_msb;
    logic sts_0;
    logic sts_1;
    logic sts_2;
    logic sts_3;
    logic expt_0;
    logic expt_1;
    logic expt_2;
    logic expt_3;
    logic pc_0;
    logic pc_1;
    logic pc_2;
    logic pc_3;
    logic dfd_data_0;
    logic dfd_data_1;
    logic dfd_data_2;
    logic dfd_data_3;
    logic scratch_pad_0;
    logic scratch_pad_1;
    logic scratch_pad_2;
    logic scratch_pad_3;
} t_cr_en;



endpackage // gpc_pkg

