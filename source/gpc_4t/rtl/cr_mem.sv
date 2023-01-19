//-----------------------------------------------------------------------------
// Title            : cr_mem
// Project          : LOTR
//-----------------------------------------------------------------------------
// File             : cr_mem.sv
// Original Author  : Amichai Ben-David
// current Owner    : Adi
// Created          : 5/2021
//-----------------------------------------------------------------------------
// Description      :

//------------------------------------------------------------------------------
// Modification history :
//------------------------------------------------------------------------------

`include "lotr_defines.sv"
module cr_mem 
import lotr_pkg::*;  
                (input   logic             QClk,          
                 input   logic             RstQnnnH,          
                 input   logic [7:0]       CoreIdStrap,          
                 input  logic              ALL_PC_RESET,
                 //Core interface 
                 input   logic [MSB_D_MEM:0] CrAddressQ103H,
                 input   logic [3:0]         ThreadQ103H,
                 input   logic [31:0]        PcQ103H,
                 input   logic [31:0]        CrWrDataQ103H,
                 input   logic               CrRdEnQ103H,  
                 input   logic               CrWrEnQ103H,  
                 output  logic [31:0]        CrRdDataQ104H,     
                 output  t_core_cr           core_cr,
                 // reing interface 
                 input   logic [MSB_D_MEM:0] F2C_AddressQ503H,      
                 input   logic [31:0]        F2C_WrDataQ503H,       
                 input   logic               F2C_CrRdEnQ503H,       
                 input   logic               F2C_CrWrEnQ503H,       
                 output  logic [31:0]        F2C_CrRspDataQ504H    
                );

t_cr_ro             cr_ro;
t_cr_rw             cr_rw;
t_cr_en [1:0]       cr_en;
t_cr_en             CrEnQ103H;
logic [31:0]        CrRdDataQn03H[1:0];
logic [MSB_D_MEM:0] AddressQn03H[1:0];
logic               WrEnQn03H[1:0];
logic [31:0]        WrDataQ103H[1:0] ;
logic [1:0]         CrRdEnQn03H;


logic [3:0]    ThreadQ102H;   // Due to Sample in Cr + Sample Read, need to use Q102H as the CR update

logic [31:0] StkOffsetQ102H;
logic [31:0] TlsOffsetQ102H;
logic [4:0]  DfdThreadQ102H;
logic [31:0] scratch_pad_0;
logic [31:0] scratch_pad_1;
logic [31:0] scratch_pad_2;
logic [31:0] scratch_pad_3;
logic [31:0] dfd_data_0;
logic [31:0] dfd_data_1;
logic [31:0] dfd_data_2;
logic [31:0] dfd_data_3;
logic [1:0]  ThreadIdQ102H;

//=======================================================
//================CR memory write Enable ================
//=======================================================
assign AddressQn03H[0] = CrAddressQ103H;
assign AddressQn03H[1] = F2C_AddressQ503H;

always_comb begin : cr_write_en
    cr_en = '0;
    WrEnQn03H[0]    = CrWrEnQ103H;
    WrEnQn03H[1]    = F2C_CrWrEnQ503H;
    for(int IO_NUM =0; IO_NUM<2; IO_NUM++) begin : core_wr_interface_and_ring_wr_interface
        if(WrEnQn03H[IO_NUM]) begin : decode_cr_write_en
            unique case (AddressQn03H[IO_NUM])
               CR_THREAD0_PC_RST             : cr_en[IO_NUM].rst_pc_0       = 1'b1 ;
               CR_THREAD1_PC_RST             : cr_en[IO_NUM].rst_pc_1       = 1'b1 ;
               CR_THREAD2_PC_RST             : cr_en[IO_NUM].rst_pc_2       = 1'b1 ;
               CR_THREAD3_PC_RST             : cr_en[IO_NUM].rst_pc_3       = 1'b1 ;
               CR_THREAD0_PC_EN              : cr_en[IO_NUM].en_pc_0        = 1'b1 ;
               CR_THREAD1_PC_EN              : cr_en[IO_NUM].en_pc_1        = 1'b1 ;
               CR_THREAD2_PC_EN              : cr_en[IO_NUM].en_pc_2        = 1'b1 ;
               CR_THREAD3_PC_EN              : cr_en[IO_NUM].en_pc_3        = 1'b1 ;
               CR_THREAD0_DFD_REG_ID         : cr_en[IO_NUM].dfd_id_0       = 1'b1 ;
               CR_THREAD1_DFD_REG_ID         : cr_en[IO_NUM].dfd_id_1       = 1'b1 ;
               CR_THREAD2_DFD_REG_ID         : cr_en[IO_NUM].dfd_id_2       = 1'b1 ;
               CR_THREAD3_DFD_REG_ID         : cr_en[IO_NUM].dfd_id_3       = 1'b1 ;
               CR_THREAD0_STACK_BASE_OFFSET  : cr_en[IO_NUM].stk_ofst_0     = 1'b1 ;
               CR_THREAD1_STACK_BASE_OFFSET  : cr_en[IO_NUM].stk_ofst_1     = 1'b1 ;
               CR_THREAD2_STACK_BASE_OFFSET  : cr_en[IO_NUM].stk_ofst_2     = 1'b1 ;
               CR_THREAD3_STACK_BASE_OFFSET  : cr_en[IO_NUM].stk_ofst_3     = 1'b1 ;
               CR_THREAD0_TLS_BASE_OFFSET    : cr_en[IO_NUM].tls_ofst_0     = 1'b1 ;
               CR_THREAD1_TLS_BASE_OFFSET    : cr_en[IO_NUM].tls_ofst_1     = 1'b1 ;
               CR_THREAD2_TLS_BASE_OFFSET    : cr_en[IO_NUM].tls_ofst_2     = 1'b1 ;
               CR_THREAD3_TLS_BASE_OFFSET    : cr_en[IO_NUM].tls_ofst_3     = 1'b1 ;   
               CR_SCRATCHPAD0                : cr_en[IO_NUM].scratch_pad_0  = 1'b1 ;
               CR_SCRATCHPAD1                : cr_en[IO_NUM].scratch_pad_1  = 1'b1 ;
               CR_SCRATCHPAD2                : cr_en[IO_NUM].scratch_pad_2  = 1'b1 ;
               CR_SCRATCHPAD3                : cr_en[IO_NUM].scratch_pad_3  = 1'b1 ;   
               CR_CURSOR_H0                  : cr_en[IO_NUM].cursor_h_0     = 1'b1 ;   
               CR_CURSOR_H1                  : cr_en[IO_NUM].cursor_h_1     = 1'b1 ;   
               CR_CURSOR_H2                  : cr_en[IO_NUM].cursor_h_2     = 1'b1 ;   
               CR_CURSOR_H3                  : cr_en[IO_NUM].cursor_h_3     = 1'b1 ;   
               CR_CURSOR_V0                  : cr_en[IO_NUM].cursor_v_0     = 1'b1 ;   
               CR_CURSOR_V1                  : cr_en[IO_NUM].cursor_v_1     = 1'b1 ;   
               CR_CURSOR_V2                  : cr_en[IO_NUM].cursor_v_2     = 1'b1 ;   
               CR_CURSOR_V3                  : cr_en[IO_NUM].cursor_v_3     = 1'b1 ;   
               CR_SHARED_BASE_OFFSET         : cr_en[IO_NUM].shrd_ofst      = 1'b1 ;
               default                       : /*do nothing - TODO add assertion*/;
            endcase
            if(AddressQn03H[IO_NUM] == CR_CURSOR_H) begin
                if(ThreadQ103H == 4'b0001) cr_en[IO_NUM].cursor_h_0 = 1'b1;
                if(ThreadQ103H == 4'b0010) cr_en[IO_NUM].cursor_h_1 = 1'b1;
                if(ThreadQ103H == 4'b0100) cr_en[IO_NUM].cursor_h_2 = 1'b1;
                if(ThreadQ103H == 4'b1000) cr_en[IO_NUM].cursor_h_3 = 1'b1;
            end
            if(AddressQn03H[IO_NUM] == CR_CURSOR_V) begin
                if(ThreadQ103H == 4'b0001) cr_en[IO_NUM].cursor_v_0 = 1'b1;
                if(ThreadQ103H == 4'b0010) cr_en[IO_NUM].cursor_v_1 = 1'b1;
                if(ThreadQ103H == 4'b0100) cr_en[IO_NUM].cursor_v_2 = 1'b1;
                if(ThreadQ103H == 4'b1000) cr_en[IO_NUM].cursor_v_3 = 1'b1;
            end
        end //if (WrEnQn03H[IO_NUM])
        cr_en[IO_NUM].thread     = 1'b1;//always update the thread id register (changes every cycle)
        cr_en[IO_NUM].core       = 1'b1;//this will always expose the coreID strap
        cr_en[IO_NUM].stk_ofst   = 1'b1;//always update the Stack offset  (changes every cycle)
        cr_en[IO_NUM].tls_ofst   = 1'b1;//always update the Stack offset  (changes every cycle)
        cr_en[IO_NUM].cursor_h   = 1'b1;
        cr_en[IO_NUM].cursor_v   = 1'b1;
        cr_en[IO_NUM].i_mem_msb  = 1'b1;//Static input
        cr_en[IO_NUM].d_mem_msb  = 1'b1;//Static input
        cr_en[IO_NUM].sts_0      = 1'b1;//always update the thread Status
        cr_en[IO_NUM].sts_1      = 1'b1;//always update the thread Status
        cr_en[IO_NUM].sts_2      = 1'b1;//always update the thread Status
        cr_en[IO_NUM].sts_3      = 1'b1;//always update the thread Status
        cr_en[IO_NUM].expt_0     = 1'b1;//FIXME - assign exception triger
        cr_en[IO_NUM].expt_1     = 1'b1;//FIXME - assign exception triger
        cr_en[IO_NUM].expt_2     = 1'b1;//FIXME - assign exception triger
        cr_en[IO_NUM].expt_3     = 1'b1;//FIXME - assign exception triger
        cr_en[IO_NUM].pc_0       = (ThreadIdQ102H == 2'b00);//update the pc_0 fron thread 0 every 4 cycles
        cr_en[IO_NUM].pc_1       = (ThreadIdQ102H == 2'b01);//update the pc_1 fron thread 1 every 4 cycles
        cr_en[IO_NUM].pc_2       = (ThreadIdQ102H == 2'b10);//update the pc_2 fron thread 2 every 4 cycles
        cr_en[IO_NUM].pc_3       = (ThreadIdQ102H == 2'b11);//update the pc_3 fron thread 3 every 4 cycles
        cr_en[IO_NUM].dfd_data_0 = 1'b1;//always expose the register value
        cr_en[IO_NUM].dfd_data_1 = 1'b1;//always expose the register value
        cr_en[IO_NUM].dfd_data_2 = 1'b1;//always expose the register value
        cr_en[IO_NUM].dfd_data_3 = 1'b1;//always expose the register value
    end // for IO_NUM
end // always_comb

//=======================================================
//================CR Acording to ThreadID ===============
//=======================================================
assign ThreadQ102H = {ThreadQ103H[2:0],ThreadQ103H[3]};
assign ThreadIdQ102H =  (ThreadQ102H == 4'b0001) ? 2'b00 :
                        (ThreadQ102H == 4'b0010) ? 2'b01 :
                        (ThreadQ102H == 4'b0100) ? 2'b10 :
                                                   2'b11 ;
                                                   
assign StkOffsetQ102H = (ThreadQ102H == 4'b0001) ? cr_rw.stk_ofst_0 :
                        (ThreadQ102H == 4'b0010) ? cr_rw.stk_ofst_1 :
                        (ThreadQ102H == 4'b0100) ? cr_rw.stk_ofst_2 :
                                                   cr_rw.stk_ofst_3 ;
                                                   
assign TlsOffsetQ102H = (ThreadQ102H == 4'b0001) ? cr_rw.tls_ofst_0 :
                        (ThreadQ102H == 4'b0010) ? cr_rw.tls_ofst_1 :
                        (ThreadQ102H == 4'b0100) ? cr_rw.tls_ofst_2 :
                                                   cr_rw.tls_ofst_3 ;

logic [31:0] CursorHQ102H;
logic [31:0] CursorVQ102H;
assign CursorHQ102H   = (ThreadQ102H == 4'b0001) ? cr_rw.cursor_h_0 :
                        (ThreadQ102H == 4'b0010) ? cr_rw.cursor_h_1 :
                        (ThreadQ102H == 4'b0100) ? cr_rw.cursor_h_2 :
                                                   cr_rw.cursor_h_3 ;                                                 

assign CursorVQ102H   = (ThreadQ102H == 4'b0001) ? cr_rw.cursor_v_0 :
                        (ThreadQ102H == 4'b0010) ? cr_rw.cursor_v_1 :
                        (ThreadQ102H == 4'b0100) ? cr_rw.cursor_v_2 :
                                                   cr_rw.cursor_v_3 ;   
//=======================================================
//================CR memory flops======================
//=======================================================
assign CrEnQ103H   = cr_en[0] | cr_en[1]; //bit wise operation
assign WrDataQ103H[0] = CrWrDataQ103H;
assign WrDataQ103H[1] = F2C_WrDataQ503H;

t_cr_en SelWrDataQ103H;

assign SelWrDataQ103H = cr_en[1];
//===========================================
//              CRs - Write from core/ring write request
//===========================================
logic pre_rst_pc_0;
logic pre_rst_pc_1;
logic pre_rst_pc_2;
logic pre_rst_pc_3;
`LOTR_EN_RST_VAL_MSFF(pre_rst_pc_0, WrDataQ103H[SelWrDataQ103H.rst_pc_0][0]             , QClk  ,  CrEnQ103H.rst_pc_0      , RstQnnnH  ,  1'b0)//FIXME - defualt value should be 1'b1 - reset thread.
`LOTR_EN_RST_VAL_MSFF(pre_rst_pc_1, WrDataQ103H[SelWrDataQ103H.rst_pc_1][0]             , QClk  ,  CrEnQ103H.rst_pc_1      , RstQnnnH  ,  1'b0)//FIXME - defualt value should be 1'b1 - reset thread.
`LOTR_EN_RST_VAL_MSFF(pre_rst_pc_2, WrDataQ103H[SelWrDataQ103H.rst_pc_2][0]             , QClk  ,  CrEnQ103H.rst_pc_2      , RstQnnnH  ,  1'b0)//FIXME - defualt value should be 1'b1 - reset thread.
`LOTR_EN_RST_VAL_MSFF(pre_rst_pc_3, WrDataQ103H[SelWrDataQ103H.rst_pc_3][0]             , QClk  ,  CrEnQ103H.rst_pc_3      , RstQnnnH  ,  1'b0)//FIXME - defualt value should be 1'b1 - reset thread.
assign core_cr.rst_pc_0 = pre_rst_pc_0 || ALL_PC_RESET;
assign core_cr.rst_pc_1 = pre_rst_pc_1 || ALL_PC_RESET;
assign core_cr.rst_pc_2 = pre_rst_pc_2 || ALL_PC_RESET;
assign core_cr.rst_pc_3 = pre_rst_pc_3 || ALL_PC_RESET;
`LOTR_EN_RST_VAL_MSFF(core_cr.en_pc_0 , WrDataQ103H[SelWrDataQ103H.en_pc_0][0]           , QClk  ,  CrEnQ103H.en_pc_0      , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - desable thread.
`LOTR_EN_RST_VAL_MSFF(core_cr.en_pc_1 , WrDataQ103H[SelWrDataQ103H.en_pc_1][0]           , QClk  ,  CrEnQ103H.en_pc_1      , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - desable thread.
`LOTR_EN_RST_VAL_MSFF(core_cr.en_pc_2 , WrDataQ103H[SelWrDataQ103H.en_pc_2][0]           , QClk  ,  CrEnQ103H.en_pc_2      , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - desable thread.
`LOTR_EN_RST_VAL_MSFF(core_cr.en_pc_3 , WrDataQ103H[SelWrDataQ103H.en_pc_3][0]           , QClk  ,  CrEnQ103H.en_pc_3      , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - desable thread.
`LOTR_EN_RST_VAL_MSFF(cr_rw.dfd_id_0  , WrDataQ103H[SelWrDataQ103H.dfd_id_0][4:0]        , QClk  ,  CrEnQ103H.dfd_id_0     , RstQnnnH  ,  5'b0)
`LOTR_EN_RST_VAL_MSFF(cr_rw.dfd_id_1  , WrDataQ103H[SelWrDataQ103H.dfd_id_1][4:0]        , QClk  ,  CrEnQ103H.dfd_id_1     , RstQnnnH  ,  5'b0)
`LOTR_EN_RST_VAL_MSFF(cr_rw.dfd_id_2  , WrDataQ103H[SelWrDataQ103H.dfd_id_2][4:0]        , QClk  ,  CrEnQ103H.dfd_id_2     , RstQnnnH  ,  5'b0)
`LOTR_EN_RST_VAL_MSFF(cr_rw.dfd_id_3  , WrDataQ103H[SelWrDataQ103H.dfd_id_3][4:0]        , QClk  ,  CrEnQ103H.dfd_id_3     , RstQnnnH  ,  5'b0)
`LOTR_EN_RST_VAL_MSFF(cr_rw.stk_ofst_0, WrDataQ103H[SelWrDataQ103H.stk_ofst_0][31:0]     , QClk  ,  CrEnQ103H.stk_ofst_0   , RstQnnnH  , T0_STK_OFFSET )
`LOTR_EN_RST_VAL_MSFF(cr_rw.stk_ofst_1, WrDataQ103H[SelWrDataQ103H.stk_ofst_1][31:0]     , QClk  ,  CrEnQ103H.stk_ofst_1   , RstQnnnH  , T1_STK_OFFSET )
`LOTR_EN_RST_VAL_MSFF(cr_rw.stk_ofst_2, WrDataQ103H[SelWrDataQ103H.stk_ofst_2][31:0]     , QClk  ,  CrEnQ103H.stk_ofst_2   , RstQnnnH  , T2_STK_OFFSET )
`LOTR_EN_RST_VAL_MSFF(cr_rw.stk_ofst_3, WrDataQ103H[SelWrDataQ103H.stk_ofst_3][31:0]     , QClk  ,  CrEnQ103H.stk_ofst_3   , RstQnnnH  , T3_STK_OFFSET )
`LOTR_EN_RST_VAL_MSFF(cr_rw.tls_ofst_0, WrDataQ103H[SelWrDataQ103H.tls_ofst_0][31:0]     , QClk  ,  CrEnQ103H.tls_ofst_0   , RstQnnnH  , T0_STK_OFFSET )
`LOTR_EN_RST_VAL_MSFF(cr_rw.tls_ofst_1, WrDataQ103H[SelWrDataQ103H.tls_ofst_1][31:0]     , QClk  ,  CrEnQ103H.tls_ofst_1   , RstQnnnH  , T1_STK_OFFSET )
`LOTR_EN_RST_VAL_MSFF(cr_rw.tls_ofst_2, WrDataQ103H[SelWrDataQ103H.tls_ofst_2][31:0]     , QClk  ,  CrEnQ103H.tls_ofst_2   , RstQnnnH  , T2_STK_OFFSET )
`LOTR_EN_RST_VAL_MSFF(cr_rw.tls_ofst_3, WrDataQ103H[SelWrDataQ103H.tls_ofst_3][31:0]     , QClk  ,  CrEnQ103H.tls_ofst_3   , RstQnnnH  , T3_STK_OFFSET )
`LOTR_EN_RST_VAL_MSFF(cr_rw.cursor_v_0, WrDataQ103H[SelWrDataQ103H.cursor_v_0][31:0]     , QClk  ,  CrEnQ103H.cursor_v_0   , RstQnnnH  , '0 )
`LOTR_EN_RST_VAL_MSFF(cr_rw.cursor_v_1, WrDataQ103H[SelWrDataQ103H.cursor_v_1][31:0]     , QClk  ,  CrEnQ103H.cursor_v_1   , RstQnnnH  , '0 )
`LOTR_EN_RST_VAL_MSFF(cr_rw.cursor_v_2, WrDataQ103H[SelWrDataQ103H.cursor_v_2][31:0]     , QClk  ,  CrEnQ103H.cursor_v_2   , RstQnnnH  , '0 )
`LOTR_EN_RST_VAL_MSFF(cr_rw.cursor_v_3, WrDataQ103H[SelWrDataQ103H.cursor_v_3][31:0]     , QClk  ,  CrEnQ103H.cursor_v_3   , RstQnnnH  , '0 )
`LOTR_EN_RST_VAL_MSFF(cr_rw.cursor_h_0, WrDataQ103H[SelWrDataQ103H.cursor_h_0][31:0]     , QClk  ,  CrEnQ103H.cursor_h_0   , RstQnnnH  , '0 )
`LOTR_EN_RST_VAL_MSFF(cr_rw.cursor_h_1, WrDataQ103H[SelWrDataQ103H.cursor_h_1][31:0]     , QClk  ,  CrEnQ103H.cursor_h_1   , RstQnnnH  , '0 )
`LOTR_EN_RST_VAL_MSFF(cr_rw.cursor_h_2, WrDataQ103H[SelWrDataQ103H.cursor_h_2][31:0]     , QClk  ,  CrEnQ103H.cursor_h_2   , RstQnnnH  , '0 )
`LOTR_EN_RST_VAL_MSFF(cr_rw.cursor_h_3, WrDataQ103H[SelWrDataQ103H.cursor_h_3][31:0]     , QClk  ,  CrEnQ103H.cursor_h_3   , RstQnnnH  , '0 )
`LOTR_EN_RST_VAL_MSFF(cr_rw.shrd_ofst , WrDataQ103H[SelWrDataQ103H.shrd_ofst][31:0]      , QClk  ,  CrEnQ103H.shrd_ofst    , RstQnnnH  , MEM_SHARD_OFFSET )
`LOTR_EN_RST_MSFF    (scratch_pad_0   , WrDataQ103H[SelWrDataQ103H.scratch_pad_0][31:0]  , QClk  ,  CrEnQ103H.scratch_pad_0, RstQnnnH )//Note: Reset Value is '0
`LOTR_EN_RST_MSFF    (scratch_pad_1   , WrDataQ103H[SelWrDataQ103H.scratch_pad_1][31:0]  , QClk  ,  CrEnQ103H.scratch_pad_1, RstQnnnH )//Note: Reset Value is '0
`LOTR_EN_RST_MSFF    (scratch_pad_2   , WrDataQ103H[SelWrDataQ103H.scratch_pad_2][31:0]  , QClk  ,  CrEnQ103H.scratch_pad_2, RstQnnnH )//Note: Reset Value is '0
`LOTR_EN_RST_MSFF    (scratch_pad_3   , WrDataQ103H[SelWrDataQ103H.scratch_pad_3][31:0]  , QClk  ,  CrEnQ103H.scratch_pad_3, RstQnnnH )//Note: Reset Value is '0
//===========================================
//              RO CRs - Read Only - the write is from HW and not core/ring write request
//===========================================
`LOTR_EN_RST_MSFF    (cr_ro.thread    , ThreadIdQ102H,       QClk  ,  CrEnQ103H.thread     , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.stk_ofst  , StkOffsetQ102H,      QClk  ,  CrEnQ103H.stk_ofst   , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.tls_ofst  , TlsOffsetQ102H,      QClk  ,  CrEnQ103H.tls_ofst   , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.cursor_h  , CursorHQ102H,        QClk  ,  CrEnQ103H.cursor_h   , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.cursor_v  , CursorVQ102H,        QClk  ,  CrEnQ103H.cursor_v   , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.pc_0      , PcQ103H,             QClk  ,  CrEnQ103H.pc_0       , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.pc_1      , PcQ103H,             QClk  ,  CrEnQ103H.pc_1       , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.pc_2      , PcQ103H,             QClk  ,  CrEnQ103H.pc_2       , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.pc_3      , PcQ103H,             QClk  ,  CrEnQ103H.pc_3       , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.sts_0     , 8'b0,                QClk  ,  CrEnQ103H.sts_0      , RstQnnnH )//FIXME assign logic that will indicate the Threads Status. (Freeze,Running,Reset,Exception,Stall(LoadFromFarMem))
`LOTR_EN_RST_MSFF    (cr_ro.sts_1     , 8'b0,                QClk  ,  CrEnQ103H.sts_1      , RstQnnnH )//FIXME assign logic that will indicate the Threads Status. (Freeze,Running,Reset,Exception,Stall(LoadFromFarMem))
`LOTR_EN_RST_MSFF    (cr_ro.sts_2     , 8'b0,                QClk  ,  CrEnQ103H.sts_2      , RstQnnnH )//FIXME assign logic that will indicate the Threads Status. (Freeze,Running,Reset,Exception,Stall(LoadFromFarMem))
`LOTR_EN_RST_MSFF    (cr_ro.sts_3     , 8'b0,                QClk  ,  CrEnQ103H.sts_3      , RstQnnnH )//FIXME assign logic that will indicate the Threads Status. (Freeze,Running,Reset,Exception,Stall(LoadFromFarMem))
`LOTR_EN_RST_MSFF    (cr_ro.expt_0    , 32'b0,               QClk  ,  CrEnQ103H.expt_0     , RstQnnnH )//FIXME assign exception code logic.
`LOTR_EN_RST_MSFF    (cr_ro.expt_1    , 32'b0,               QClk  ,  CrEnQ103H.expt_1     , RstQnnnH )//FIXME assign exception code logic.
`LOTR_EN_RST_MSFF    (cr_ro.expt_2    , 32'b0,               QClk  ,  CrEnQ103H.expt_2     , RstQnnnH )//FIXME assign exception code logic.
`LOTR_EN_RST_MSFF    (cr_ro.expt_3    , 32'b0,               QClk  ,  CrEnQ103H.expt_3     , RstQnnnH )//FIXME assign exception code logic.
`LOTR_EN_RST_MSFF    (dfd_data_0      , '0,                  QClk  ,  CrEnQ103H.dfd_data_0 , RstQnnnH )//FIXME connect to the register file read port
`LOTR_EN_RST_MSFF    (dfd_data_1      , '0,                  QClk  ,  CrEnQ103H.dfd_data_1 , RstQnnnH )//FIXME connect to the register file read port
`LOTR_EN_RST_MSFF    (dfd_data_2      , '0,                  QClk  ,  CrEnQ103H.dfd_data_2 , RstQnnnH )//FIXME connect to the register file read port
`LOTR_EN_RST_MSFF    (dfd_data_3      , '0,                  QClk  ,  CrEnQ103H.dfd_data_3 , RstQnnnH )//FIXME connect to the register file read port
`LOTR_EN_MSFF        (cr_ro.i_mem_msb , MSB_I_MEM[7:0],      QClk  ,  CrEnQ103H.i_mem_msb)
`LOTR_EN_MSFF        (cr_ro.d_mem_msb , MSB_D_MEM[7:0],      QClk  ,  CrEnQ103H.d_mem_msb)
`LOTR_EN_MSFF        (cr_ro.core      , CoreIdStrap,         QClk  ,  CrEnQ103H.core     )

//=======================================================
//================CR memory read======================
//=======================================================
                                               
always_comb begin
    CrRdEnQn03H[0] = CrRdEnQ103H;
    CrRdEnQn03H[1] = F2C_CrRdEnQ503H;
    for(int IO_NUM =0; IO_NUM<2; IO_NUM++) begin : core_rd_interface_and_ring_rd_interface
        CrRdDataQn03H[IO_NUM] =32'b0;
        if(CrRdEnQn03H[IO_NUM]) begin
            unique case (AddressQn03H[IO_NUM])
                 CR_WHO_AM_I                : CrRdDataQn03H[IO_NUM]  = {22'b0, cr_ro.core, cr_ro.thread}; 
                 CR_THREAD_ID               : CrRdDataQn03H[IO_NUM]  = {30'b0,cr_ro.thread}; 
                 CR_CORE_ID                 : CrRdDataQn03H[IO_NUM]  = {24'b0,cr_ro.core};
                 CR_STACK_BASE_OFFSET       : CrRdDataQn03H[IO_NUM]  = cr_ro.stk_ofst ;
                 CR_TLS_BASE_OFFSET         : CrRdDataQn03H[IO_NUM]  = cr_ro.tls_ofst ;
                 CR_CURSOR_H                : CrRdDataQn03H[IO_NUM]  = cr_ro.cursor_h ;
                 CR_CURSOR_V                : CrRdDataQn03H[IO_NUM]  = cr_ro.cursor_v ;
                 CR_SHARED_BASE_OFFSET      : CrRdDataQn03H[IO_NUM]  = cr_rw.shrd_ofst;
                 CR_I_MEM_MSB               : CrRdDataQn03H[IO_NUM]  = {18'b0,cr_ro.i_mem_msb};
                 CR_D_MEM_MSB               : CrRdDataQn03H[IO_NUM]  = {18'b0,cr_ro.d_mem_msb};
                 CR_THREAD0_STATUS          : CrRdDataQn03H[IO_NUM]  = {18'b0,cr_ro.sts_0};
                 CR_THREAD1_STATUS          : CrRdDataQn03H[IO_NUM]  = {18'b0,cr_ro.sts_1};
                 CR_THREAD2_STATUS          : CrRdDataQn03H[IO_NUM]  = {18'b0,cr_ro.sts_2};
                 CR_THREAD3_STATUS          : CrRdDataQn03H[IO_NUM]  = {18'b0,cr_ro.sts_3};
                 CR_THREAD0_EXCEPTION_CODE  : CrRdDataQn03H[IO_NUM]  = cr_ro.expt_0;
                 CR_THREAD1_EXCEPTION_CODE  : CrRdDataQn03H[IO_NUM]  = cr_ro.expt_1;
                 CR_THREAD2_EXCEPTION_CODE  : CrRdDataQn03H[IO_NUM]  = cr_ro.expt_2;
                 CR_THREAD3_EXCEPTION_CODE  : CrRdDataQn03H[IO_NUM]  = cr_ro.expt_3;
                 CR_THREAD0_PC_RST          : CrRdDataQn03H[IO_NUM]  = {31'b0,core_cr.rst_pc_0};
                 CR_THREAD1_PC_RST          : CrRdDataQn03H[IO_NUM]  = {31'b0,core_cr.rst_pc_1};
                 CR_THREAD2_PC_RST          : CrRdDataQn03H[IO_NUM]  = {31'b0,core_cr.rst_pc_2};
                 CR_THREAD3_PC_RST          : CrRdDataQn03H[IO_NUM]  = {31'b0,core_cr.rst_pc_3};
                 CR_THREAD0_PC_EN           : CrRdDataQn03H[IO_NUM]  = {31'b0,core_cr.en_pc_0};
                 CR_THREAD1_PC_EN           : CrRdDataQn03H[IO_NUM]  = {31'b0,core_cr.en_pc_1};
                 CR_THREAD2_PC_EN           : CrRdDataQn03H[IO_NUM]  = {31'b0,core_cr.en_pc_2};
                 CR_THREAD3_PC_EN           : CrRdDataQn03H[IO_NUM]  = {31'b0,core_cr.en_pc_3};
                 CR_THREAD0_DFD_REG_ID      : CrRdDataQn03H[IO_NUM]  = {27'b0,cr_rw.dfd_id_0};
                 CR_THREAD1_DFD_REG_ID      : CrRdDataQn03H[IO_NUM]  = {27'b0,cr_rw.dfd_id_1};
                 CR_THREAD2_DFD_REG_ID      : CrRdDataQn03H[IO_NUM]  = {27'b0,cr_rw.dfd_id_2};
                 CR_THREAD3_DFD_REG_ID      : CrRdDataQn03H[IO_NUM]  = {27'b0,cr_rw.dfd_id_3};
                 CR_THREAD0_PC              : CrRdDataQn03H[IO_NUM]  = cr_ro.pc_0;
                 CR_THREAD1_PC              : CrRdDataQn03H[IO_NUM]  = cr_ro.pc_1;
                 CR_THREAD2_PC              : CrRdDataQn03H[IO_NUM]  = cr_ro.pc_2;
                 CR_THREAD3_PC              : CrRdDataQn03H[IO_NUM]  = cr_ro.pc_3;
                 CR_THREAD0_DFD_REG_DATA    : CrRdDataQn03H[IO_NUM]  = dfd_data_0;
                 CR_THREAD1_DFD_REG_DATA    : CrRdDataQn03H[IO_NUM]  = dfd_data_1;
                 CR_THREAD2_DFD_REG_DATA    : CrRdDataQn03H[IO_NUM]  = dfd_data_2;
                 CR_THREAD3_DFD_REG_DATA    : CrRdDataQn03H[IO_NUM]  = dfd_data_3;
                 CR_SCRATCHPAD0             : CrRdDataQn03H[IO_NUM]  = scratch_pad_0;
                 CR_SCRATCHPAD1             : CrRdDataQn03H[IO_NUM]  = scratch_pad_1;
                 CR_SCRATCHPAD2             : CrRdDataQn03H[IO_NUM]  = scratch_pad_2;
                 CR_SCRATCHPAD3             : CrRdDataQn03H[IO_NUM]  = scratch_pad_3;
                 default                    : CrRdDataQn03H[IO_NUM]  = 32'b0;
            endcase 
        end // if (CrRdEnQ103H[IO_NUM])
    end // for IO_NUM
end

//sample the read (synchornic read)
`LOTR_MSFF(CrRdDataQ104H,      CrRdDataQn03H[0], QClk)
`LOTR_MSFF(F2C_CrRspDataQ504H, CrRdDataQn03H[1], QClk)

endmodule
