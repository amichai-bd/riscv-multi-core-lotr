//-----------------------------------------------------------------------------
// Title         : rc parameter package
// Project       : rc
//-----------------------------------------------------------------------------
// File          : rc_param_pkg.sv
// Author        : 
// Created       : 5/2021
//-----------------------------------------------------------------------------
// Description :
// parameters , enum and struct used in rc
//-----------------------------------------------------------------------------

package rc_pkg;
//=========================================
//============    enum    =================
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
    NOP               = 0 ,
    RingInput         = 1 ,
    F2CResponse       = 2 ,
    C2FRequest        = 3 
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




endpackage // rc_pkg

