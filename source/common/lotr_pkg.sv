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
parameter MSB_I_MEM        = 12;
parameter SIZE_I_MEM       = 2**(MSB_I_MEM + 1);

// Data Memory 4KB 
parameter D_MEM_OFFSET     = 'h0040_0000;   // See D_MEM_REGION
parameter LSB_D_MEM        = 0 ;
parameter MSB_D_MEM        = 12;
parameter SIZE_D_MEM       = 2**(MSB_D_MEM + 1);
parameter SIZE_SHRD_MEM    = 2**(MSB_D_MEM );
parameter T0_STK_OFFSET    = 32'h0040_1400;
parameter T1_STK_OFFSET    = 32'h0040_1800;
parameter T2_STK_OFFSET    = 32'h0040_1C00;
parameter T3_STK_OFFSET    = 32'h0040_2000;
parameter MEM_SHARD_OFFSET = 32'h0040_0f00;
// For test bench use
parameter SIZE_MEM         = D_MEM_OFFSET + SIZE_D_MEM ;
parameter MSB_CR           = 12;

// CR Address Offsets
parameter CR_WHO_AM_I                 = 14'h0  ;
parameter CR_THREAD_ID                = 14'h4  ;
parameter CR_CORE_ID                  = 14'h8  ;
parameter CR_STACK_BASE_OFFSET        = 14'hc  ;
parameter CR_TLS_BASE_OFFSET          = 14'h10 ;
parameter CR_SHARED_BASE_OFFSET       = 14'h14 ;
parameter CR_I_MEM_MSB                = 14'h18 ;
parameter CR_D_MEM_MSB                = 14'h20 ;
parameter CR_SUPPORTED_ARCH           = 14'h24 ;
parameter CR_THREAD0_STATUS           = 14'h110;
parameter CR_THREAD1_STATUS           = 14'h114;
parameter CR_THREAD2_STATUS           = 14'h118;
parameter CR_THREAD3_STATUS           = 14'h11c;
parameter CR_THREAD0_EXCEPTION_CODE   = 14'h120;
parameter CR_THREAD1_EXCEPTION_CODE   = 14'h124;
parameter CR_THREAD2_EXCEPTION_CODE   = 14'h128;
parameter CR_THREAD3_EXCEPTION_CODE   = 14'h12c;
parameter CR_THREAD0_PC               = 14'h130;
parameter CR_THREAD1_PC               = 14'h134;
parameter CR_THREAD2_PC               = 14'h138;
parameter CR_THREAD3_PC               = 14'h13c;
parameter CR_THREAD0_PC_RST           = 14'h140;
parameter CR_THREAD1_PC_RST           = 14'h144;
parameter CR_THREAD2_PC_RST           = 14'h148;
parameter CR_THREAD3_PC_RST           = 14'h14c;
parameter CR_THREAD0_PC_EN            = 14'h150;
parameter CR_THREAD1_PC_EN            = 14'h154;
parameter CR_THREAD2_PC_EN            = 14'h158;
parameter CR_THREAD3_PC_EN            = 14'h15c;
parameter CR_THREAD0_DFD_REG_ID       = 14'h160;
parameter CR_THREAD1_DFD_REG_ID       = 14'h164;
parameter CR_THREAD2_DFD_REG_ID       = 14'h168;
parameter CR_THREAD3_DFD_REG_ID       = 14'h16c;
parameter CR_THREAD0_DFD_REG_DATA     = 14'h170;
parameter CR_THREAD1_DFD_REG_DATA     = 14'h174;
parameter CR_THREAD2_DFD_REG_DATA     = 14'h178;
parameter CR_THREAD3_DFD_REG_DATA     = 14'h17c;
parameter CR_THREAD0_STACK_BASE_OFFSET= 14'h180;
parameter CR_THREAD1_STACK_BASE_OFFSET= 14'h184;
parameter CR_THREAD2_STACK_BASE_OFFSET= 14'h188;
parameter CR_THREAD3_STACK_BASE_OFFSET= 14'h18c;
parameter CR_THREAD0_TLS_BASE_OFFSET  = 14'h190;
parameter CR_THREAD1_TLS_BASE_OFFSET  = 14'h194;
parameter CR_THREAD2_TLS_BASE_OFFSET  = 14'h198;
parameter CR_THREAD3_TLS_BASE_OFFSET  = 14'h19c;
parameter CR_SCRATCHPAD0              = 14'h200;
parameter CR_SCRATCHPAD1              = 14'h204;
parameter CR_SCRATCHPAD2              = 14'h208;
parameter CR_SCRATCHPAD3              = 14'h20C;
parameter CR_CURSOR_H                 = 14'h220;
parameter CR_CURSOR_H0                = 14'h224;
parameter CR_CURSOR_H1                = 14'h228;
parameter CR_CURSOR_H2                = 14'h22C;
parameter CR_CURSOR_H3                = 14'h230;
parameter CR_CURSOR_V                 = 14'h234;
parameter CR_CURSOR_V0                = 14'h238;
parameter CR_CURSOR_V1                = 14'h23C;
parameter CR_CURSOR_V2                = 14'h240;
parameter CR_CURSOR_V3                = 14'h244;

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
    logic [31:0] cursor_h;
    logic [31:0] cursor_v;
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
    logic [31:0] cursor_v_0;
    logic [31:0] cursor_v_1;
    logic [31:0] cursor_v_2;
    logic [31:0] cursor_v_3;
    logic [31:0] cursor_h_0;
    logic [31:0] cursor_h_1;
    logic [31:0] cursor_h_2;
    logic [31:0] cursor_h_3;
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
    logic cursor_h;
    logic cursor_h_0;
    logic cursor_h_1;
    logic cursor_h_2;
    logic cursor_h_3;
    logic cursor_v;
    logic cursor_v_0;
    logic cursor_v_1;
    logic cursor_v_2;
    logic cursor_v_3;
} t_cr_en;

parameter CR_SEG7_0    = 20'h2000 ; // RW 7 bit
parameter CR_SEG7_1    = 20'h2004 ; // RW 7 bit
parameter CR_SEG7_2    = 20'h2008 ; // RW 7 bit
parameter CR_SEG7_3    = 20'h200c ; // RW 7 bit
parameter CR_SEG7_4    = 20'h2010 ; // RW 7 bit
parameter CR_SEG7_5    = 20'h2014 ; // RW 7 bit
parameter CR_LED       = 20'h2018 ; // RW 7 bit
parameter CR_ALL_PC_RESET= 20'h2040 ;
parameter CR_Button_0  = 20'h201c ; // RO 1 bit
parameter CR_Button_1  = 20'h2020 ; // RO 1 bit
parameter CR_Switch    = 20'h2024 ; // RO 10 bit
parameter CR_Arduino_dg_io = 20'h2028 ; // RO 16 bit
parameter CR_Sticky_Arduino_dg_io = 20'h202C ; // RO 16 bit

typedef struct packed { // RO
    logic       Button_0;
    logic       Button_1;
    logic [9:0] Switch;
    logic [15:0] Arduino_dg_io;
    logic [15:0] Sticky_Arduino_dg_io;
} t_cr_ro_fpga ;

typedef struct packed { // RW
    logic [7:0] SEG7_0;
    logic [7:0] SEG7_1;
    logic [7:0] SEG7_2;
    logic [7:0] SEG7_3;
    logic [7:0] SEG7_4;
    logic [7:0] SEG7_5;
    logic [9:0] LED;
    logic       ALL_PC_RESET;

} t_cr_rw_fpga ;


endpackage // lotr_pkg

