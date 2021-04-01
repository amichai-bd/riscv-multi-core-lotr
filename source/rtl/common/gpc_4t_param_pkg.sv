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

parameter NOP          = 32'b0000000000_00000_000_00000_0010011; //add x0 , x0 , 0

//---------------------MEMORY------------------------
//                 start   size    end     # of words
//  Inst memory    0x000  0x800  0x7FF    512
//  Data memory    0x800  0x600  0xDFF    384
//  Stack          0xE00  0x100  0xEFF    64 
//  MMIO_general   0xF00  0xA0   0xF9F    40 
//  MMIO_CSR       0xFA0  0x20   0xFBF    8  
//  MMIO_drct_out  0xFC0  0x10   0xFCF    4  
//  MMIO_ER        0xFD0  0x20   0xFEF    8  
//  MMIO_drct_in   0xFF0  0x10   0xFFF    4  
//---------------------------------------------------
parameter SIZE_INST            = 'h800                                     ;
parameter SIZE_DATA            = 'h600                                     ;
parameter SIZE_STACK           = 'h100                                     ;
parameter SIZE_MMIO_GENERAL    = 'hA0                                      ;
parameter SIZE_MMIO_CSR        = 'h20                                      ;
parameter SIZE_MMIO_DRCT_OUT   = 'h4                                       ;
parameter SIZE_MMIO_ER         = 'h8                                       ;
parameter SIZE_MMIO_DRCT_IN    = 'h4                                       ;

parameter OFFSET_INST          = 'h0                                       ;
parameter OFFSET_DATA          = OFFSET_INST+SIZE_INST                     ;
parameter OFFSET_STACK         = OFFSET_DATA+SIZE_DATA                     ;
parameter OFFSET_MMIO_GENERAL  = OFFSET_STACK+SIZE_STACK                   ;
parameter OFFSET_MMIO_CSR      = OFFSET_MMIO_GENERAL+SIZE_MMIO_GENERAL     ;
parameter OFFSET_MMIO_DRCT_OUT = OFFSET_MMIO_CSR+SIZE_MMIO_CSR             ;
parameter OFFSET_MMIO_ER       = OFFSET_MMIO_DRCT_OUT+SIZE_MMIO_DRCT_OUT   ;
parameter OFFSET_MMIO_DRCT_IN  = OFFSET_MMIO_ER+SIZE_MMIO_ER               ;

parameter LSB_INST_MEM         = OFFSET_INST                               ;
parameter MSB_INST_MEM         = OFFSET_INST + SIZE_INST - 1               ;
parameter LSB_DATA_MEM         = OFFSET_DATA                               ;
parameter MSB_DATA_MEM         = OFFSET_DATA+SIZE_DATA+SIZE_STACK+SIZE_MMIO_GENERAL-1;
parameter LSB_MMIO_GENRAL      = OFFSET_MMIO_GENERAL                       ;
parameter MSB_MMIO_GENRAL      = OFFSET_MMIO_GENERAL+SIZE_MMIO_GENERAL-1   ;
parameter LSB_CSR              = OFFSET_MMIO_CSR                           ;
parameter MSB_CSR              = OFFSET_MMIO_CSR+SIZE_MMIO_CSR-1           ;
parameter LSB_DRCT_OUT         = OFFSET_MMIO_DRCT_OUT                      ;
parameter MSB_DRCT_OUT         = OFFSET_MMIO_DRCT_OUT+SIZE_MMIO_DRCT_OUT-1 ;
parameter LSB_ER               = OFFSET_MMIO_ER                            ;
parameter MSB_ER               = OFFSET_MMIO_ER+SIZE_MMIO_ER-1             ;
parameter LSB_DRCT_IN          = OFFSET_MMIO_DRCT_IN                       ;
parameter MSB_DRCT_IN          = OFFSET_MMIO_DRCT_IN+SIZE_MMIO_DRCT_IN-1   ;
parameter LSB_MMIO_MEM         = OFFSET_MMIO_CSR                           ;
parameter MSB_MMIO_MEM         = OFFSET_MMIO_DRCT_IN + SIZE_MMIO_DRCT_IN-1 ;


typedef struct packed {
    logic       en_pc;
    logic       rst_pc;
    logic [4:0] rd_ptr;
    logic       start;
    logic       done;
} t_cr;


typedef struct packed {
    logic [(SIZE_MMIO_DRCT_OUT/4)-1:0][31:0] out ;
} t_drct_out;

typedef struct packed {
    logic [31:0] pc;
    logic [31:0] register;
} t_dfd_reg;

typedef struct packed {
    logic [(SIZE_MMIO_DRCT_IN/4)-1:0][31:0] in;
} t_drct_in;

typedef struct packed {
    t_cr         cr       ;
    t_drct_out   drct_out  ;
    t_drct_in    drct_in   ;
} t_mmio;



endpackage // gpc_pkg

