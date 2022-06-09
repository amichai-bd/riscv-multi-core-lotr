//-----------------------------------------------------------------------------
// Title         : lort parameter package
// Project       : lotr_pkg
//-----------------------------------------------------------------------------
// File          : lotr_pkg.sv
// Author        : Amichai Ben-David
// Created       : 1/2020
//-----------------------------------------------------------------------------
// Description :
// parameters and struct used in gpc_4t
//-----------------------------------------------------------------------------

`timescale 1ps/1ps

package lotr_pkg;
//=================================================================================
//============                  RC - ring controller              =================
//=================================================================================
//=========================================
// t_opcodes : Command type - RD=00 , RD_RSP=01 ,WR=10 , WR_BCAST=11
//=========================================
typedef enum logic [1:0] {
    RD                = 2'b00 , 
    RD_RSP            = 2'b01 ,
    WR                = 2'b10 , 
    WR_BCAST          = 2'b11 
    } t_opcode ;
//=========================================
// t_states : FREE '000' , WRITE '001' , READ '010' , READ_PRGRS '011' , READ_RDY '100'
//          WRITE_BCAST '101' , WRITE_BCAST_PRGRS '110'
//=========================================
typedef enum logic [2:0] {
    FREE              = 3'b000 ,
    WRITE             = 3'b001 ,
    READ              = 3'b010 ,
    READ_PRGRS        = 3'b011 ,
    READ_RDY          = 3'b100 ,
    WRITE_BCAST       = 3'b101 ,
    WRITE_BCAST_PRGRS = 3'b110 ,
    ERROR             = 3'b111
    } t_state; 
//=========================================
// t_winner  : which signal to drive to the ring output - NOP=0 , RingInput=1 ,F2CResponse=2 , C2FRequest=3
//=========================================
typedef enum logic [1:0] {
    BUBBLE_OUT         = 2'd0 ,
    RING_INPUT         = 2'd1 ,
    F2C_RESPONSE       = 2'd2 ,
    C2F_REQUEST        = 2'd3 
    } t_winner ;
//=========================================
//=========    Parameters    ==============
//=========================================
parameter C2F_ENTRIESNUM = 4                      ; 
parameter C2F_MSB = C2F_ENTRIESNUM -1             ;
parameter C2F_ENC_MSB = $clog2(C2F_ENTRIESNUM)-1  ; 

parameter F2C_ENTRIESNUM = 4                      ; 
parameter F2C_MSB = F2C_ENTRIESNUM -1             ;
parameter F2C_ENC_MSB = $clog2(F2C_ENTRIESNUM)-1  ;

//=================================================================================
//============               END of RC - ring controller          =================
//=================================================================================
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
parameter I_MEM_OFFSET     = 'h0000_0000;   // See I_MEM_REGION
parameter LSB_I_MEM        = 0 ;
parameter MSB_I_MEM        = 11;
parameter SIZE_I_MEM       = 2**(MSB_I_MEM + 1);

// Data Memory 4KB 
parameter D_MEM_OFFSET     = 'h0040_0000;   // See D_MEM_REGION
parameter LSB_D_MEM        = 0 ;
parameter MSB_D_MEM        = 11;
parameter SIZE_D_MEM       = 2**(MSB_D_MEM + 1);
parameter SIZE_SHRD_MEM    = 2**(MSB_D_MEM );

// For test bench use
parameter SIZE_MEM         = D_MEM_OFFSET + SIZE_D_MEM ;
parameter MSB_CR                      = 11;

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

// region offset in 32 bit

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

parameter CR_SEG7_0    = 20'h2000 ; // RW 7 bit
parameter CR_SEG7_1    = 20'h2004 ; // RW 7 bit
parameter CR_SEG7_2    = 20'h2008 ; // RW 7 bit
parameter CR_SEG7_3    = 20'h200c ; // RW 7 bit
parameter CR_SEG7_4    = 20'h2010 ; // RW 7 bit
parameter CR_SEG7_5    = 20'h2014 ; // RW 7 bit
parameter CR_LED       = 20'h2018 ; // RW 7 bit
parameter CR_Button_0  = 20'h201c ; // RO 1 bit
parameter CR_Button_1  = 20'h2020 ; // RO 1 bit
parameter CR_Switch    = 20'h2024 ; // RO 10 bit

typedef struct packed { // RO
    logic       Button_0;
    logic       Button_1;
    logic [9:0] Switch;
} t_cr_ro_fpga ;

typedef struct packed { // RW
    logic [6:0] SEG7_0;
    logic [6:0] SEG7_1;
    logic [6:0] SEG7_2;
    logic [6:0] SEG7_3;
    logic [6:0] SEG7_4;
    logic [6:0] SEG7_5;
    logic [6:0] LED;
} t_cr_rw_fpga ;

endpackage // lotr_pkg

