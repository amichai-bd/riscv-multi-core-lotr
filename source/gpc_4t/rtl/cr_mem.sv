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
module cr_mem import gpc_4t_pkg::*;  
                (input   logic             QClk,          
                 input   logic             RstQnnnH,          
                 input   logic [7:0]       CoreIdStrap,          
                 
                 input   logic [31:0]      CrAddressQ103H,
                 input   logic [3:0]       ThreadQ103H,
                 input   logic [31:0]      PcQ103H,
                 input   logic [31:0]      CrWrDataQ103H,
                 input   logic             CrRdEnQ103H,  
                 input   logic             CrWrEnQ103H,  
                 output  logic [31:0]      CrRdDataQ104H,     
                 
                 output  t_core_cr         core_cr
                );

t_cr_ro      cr_ro;
t_cr_en      cr_en;
t_cr_rw      cr_rw;

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
always_comb begin
    cr_en = '0;
    if(CrWrEnQ103H) begin : decode_cr_write_en
        unique case (CrAddressQ103H[MSB_CR:0])
           CR_THREAD0_PC_RST             : cr_en.rst_pc_0       = 1'b1 ;
           CR_THREAD1_PC_RST             : cr_en.rst_pc_1       = 1'b1 ;
           CR_THREAD2_PC_RST             : cr_en.rst_pc_2       = 1'b1 ;
           CR_THREAD3_PC_RST             : cr_en.rst_pc_3       = 1'b1 ;
           CR_THREAD0_PC_EN              : cr_en.en_pc_0        = 1'b1 ;
           CR_THREAD1_PC_EN              : cr_en.en_pc_1        = 1'b1 ;
           CR_THREAD2_PC_EN              : cr_en.en_pc_2        = 1'b1 ;
           CR_THREAD3_PC_EN              : cr_en.en_pc_3        = 1'b1 ;
           CR_THREAD0_DFD_REG_ID         : cr_en.dfd_id_0       = 1'b1 ;
           CR_THREAD1_DFD_REG_ID         : cr_en.dfd_id_1       = 1'b1 ;
           CR_THREAD2_DFD_REG_ID         : cr_en.dfd_id_2       = 1'b1 ;
           CR_THREAD3_DFD_REG_ID         : cr_en.dfd_id_3       = 1'b1 ;
           CR_THREAD0_STACK_BASE_OFFSET  : cr_en.stk_ofst_0     = 1'b1 ;
           CR_THREAD1_STACK_BASE_OFFSET  : cr_en.stk_ofst_1     = 1'b1 ;
           CR_THREAD2_STACK_BASE_OFFSET  : cr_en.stk_ofst_2     = 1'b1 ;
           CR_THREAD3_STACK_BASE_OFFSET  : cr_en.stk_ofst_3     = 1'b1 ;
           CR_THREAD0_TLS_BASE_OFFSET    : cr_en.tls_ofst_0     = 1'b1 ;
           CR_THREAD1_TLS_BASE_OFFSET    : cr_en.tls_ofst_1     = 1'b1 ;
           CR_THREAD2_TLS_BASE_OFFSET    : cr_en.tls_ofst_2     = 1'b1 ;
           CR_THREAD3_TLS_BASE_OFFSET    : cr_en.tls_ofst_3     = 1'b1 ;   
           CR_SCRATCHPAD0                : cr_en.scratch_pad_0  = 1'b1 ;
           CR_SCRATCHPAD1                : cr_en.scratch_pad_1  = 1'b1 ;
           CR_SCRATCHPAD2                : cr_en.scratch_pad_2  = 1'b1 ;
           CR_SCRATCHPAD3                : cr_en.scratch_pad_3  = 1'b1 ;   
           CR_SHARED_BASE_OFFSET         : cr_en.shrd_ofst      = 1'b1 ;
           default                       : /*do nothing - TODO add assertion*/;
        endcase
    end //if (wren)
    cr_en.thread     = 1'b1;//always update the thread id register (changes every cycle)
    cr_en.core       = 1'b1;//this will always expose the coreID strap
    cr_en.stk_ofst   = 1'b1;//always update the Stack offset  (changes every cycle)
    cr_en.tls_ofst   = 1'b1;//always update the Stack offset  (changes every cycle)
    cr_en.i_mem_msb  = 1'b1;//Static input
    cr_en.d_mem_msb  = 1'b1;//Static input
    cr_en.sts_0      = 1'b1;//always update the thread Status
    cr_en.sts_1      = 1'b1;//always update the thread Status
    cr_en.sts_2      = 1'b1;//always update the thread Status
    cr_en.sts_3      = 1'b1;//always update the thread Status
    cr_en.expt_0     = 1'b1;//FIXME - assign exception triger
    cr_en.expt_1     = 1'b1;//FIXME - assign exception triger
    cr_en.expt_2     = 1'b1;//FIXME - assign exception triger
    cr_en.expt_3     = 1'b1;//FIXME - assign exception triger
    cr_en.pc_0       = (ThreadIdQ102H == 2'b00);//update the pc_0 fron thread 0 every 4 cycles
    cr_en.pc_1       = (ThreadIdQ102H == 2'b01);//update the pc_1 fron thread 1 every 4 cycles
    cr_en.pc_2       = (ThreadIdQ102H == 2'b10);//update the pc_2 fron thread 2 every 4 cycles
    cr_en.pc_3       = (ThreadIdQ102H == 2'b11);//update the pc_3 fron thread 3 every 4 cycles
    cr_en.dfd_data_0 = 1'b1;//always expose the register value
    cr_en.dfd_data_1 = 1'b1;//always expose the register value
    cr_en.dfd_data_2 = 1'b1;//always expose the register value
    cr_en.dfd_data_3 = 1'b1;//always expose the register value
    
end 


//=======================================================
//================CR Acording to ThreadID ===============
//=======================================================
logic [3:0]  ThreadQ102H;   // Due to Sample in Cr + Sample Read, need to use Q102H as the CR update
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
                                                   
//=======================================================
//================CR memory flops======================
//=======================================================
`LOTR_EN_RST_VAL_MSFF(core_cr.rst_pc_0, CrWrDataQ103H[0]   , QClk  ,  cr_en.rst_pc_0     , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - reset thread.
`LOTR_EN_RST_VAL_MSFF(core_cr.rst_pc_1, CrWrDataQ103H[0]   , QClk  ,  cr_en.rst_pc_1     , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - reset thread.
`LOTR_EN_RST_VAL_MSFF(core_cr.rst_pc_2, CrWrDataQ103H[0]   , QClk  ,  cr_en.rst_pc_2     , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - reset thread.
`LOTR_EN_RST_VAL_MSFF(core_cr.rst_pc_3, CrWrDataQ103H[0]   , QClk  ,  cr_en.rst_pc_3     , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - reset thread.
`LOTR_EN_RST_VAL_MSFF(core_cr.en_pc_0 , CrWrDataQ103H[0]   , QClk  ,  cr_en.en_pc_0      , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - desable thread.
`LOTR_EN_RST_VAL_MSFF(core_cr.en_pc_1 , CrWrDataQ103H[0]   , QClk  ,  cr_en.en_pc_1      , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - desable thread.
`LOTR_EN_RST_VAL_MSFF(core_cr.en_pc_2 , CrWrDataQ103H[0]   , QClk  ,  cr_en.en_pc_2      , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - desable thread.
`LOTR_EN_RST_VAL_MSFF(core_cr.en_pc_3 , CrWrDataQ103H[0]   , QClk  ,  cr_en.en_pc_3      , RstQnnnH  ,  1'b1)//FIXME - defualt value should be 1'b0 - desable thread.
`LOTR_EN_RST_VAL_MSFF(cr_rw.dfd_id_0  , CrWrDataQ103H[4:0] , QClk  ,  cr_en.dfd_id_0     , RstQnnnH  ,  5'b0)
`LOTR_EN_RST_VAL_MSFF(cr_rw.dfd_id_1  , CrWrDataQ103H[4:0] , QClk  ,  cr_en.dfd_id_1     , RstQnnnH  ,  5'b0)
`LOTR_EN_RST_VAL_MSFF(cr_rw.dfd_id_2  , CrWrDataQ103H[4:0] , QClk  ,  cr_en.dfd_id_2     , RstQnnnH  ,  5'b0)
`LOTR_EN_RST_VAL_MSFF(cr_rw.dfd_id_3  , CrWrDataQ103H[4:0] , QClk  ,  cr_en.dfd_id_3     , RstQnnnH  ,  5'b0)

`LOTR_EN_RST_VAL_MSFF(cr_rw.stk_ofst_0, CrWrDataQ103H[31:0], QClk  ,  cr_en.stk_ofst_0   , RstQnnnH  ,  32'h400200)
`LOTR_EN_RST_VAL_MSFF(cr_rw.stk_ofst_1, CrWrDataQ103H[31:0], QClk  ,  cr_en.stk_ofst_1   , RstQnnnH  ,  32'h400400)
`LOTR_EN_RST_VAL_MSFF(cr_rw.stk_ofst_2, CrWrDataQ103H[31:0], QClk  ,  cr_en.stk_ofst_2   , RstQnnnH  ,  32'h400600)
`LOTR_EN_RST_VAL_MSFF(cr_rw.stk_ofst_3, CrWrDataQ103H[31:0], QClk  ,  cr_en.stk_ofst_3   , RstQnnnH  ,  32'h400800)
`LOTR_EN_RST_VAL_MSFF(cr_rw.tls_ofst_0, CrWrDataQ103H[31:0], QClk  ,  cr_en.tls_ofst_0   , RstQnnnH  ,  32'h400200)
`LOTR_EN_RST_VAL_MSFF(cr_rw.tls_ofst_1, CrWrDataQ103H[31:0], QClk  ,  cr_en.tls_ofst_1   , RstQnnnH  ,  32'h400400)
`LOTR_EN_RST_VAL_MSFF(cr_rw.tls_ofst_2, CrWrDataQ103H[31:0], QClk  ,  cr_en.tls_ofst_2   , RstQnnnH  ,  32'h400600)
`LOTR_EN_RST_VAL_MSFF(cr_rw.tls_ofst_3, CrWrDataQ103H[31:0], QClk  ,  cr_en.tls_ofst_3   , RstQnnnH  ,  32'h400800)
`LOTR_EN_RST_VAL_MSFF(cr_rw.shrd_ofst , CrWrDataQ103H[31:0], QClk  ,  cr_en.shrd_ofst    , RstQnnnH  ,  32'h400f00)

`LOTR_EN_RST_MSFF    (scratch_pad_0     , CrWrDataQ103H[31:0], QClk  ,  cr_en.scratch_pad_0, RstQnnnH )//Note: Reset Value is '0
`LOTR_EN_RST_MSFF    (scratch_pad_1     , CrWrDataQ103H[31:0], QClk  ,  cr_en.scratch_pad_1, RstQnnnH )//Note: Reset Value is '0
`LOTR_EN_RST_MSFF    (scratch_pad_2     , CrWrDataQ103H[31:0], QClk  ,  cr_en.scratch_pad_2, RstQnnnH )//Note: Reset Value is '0
`LOTR_EN_RST_MSFF    (scratch_pad_3     , CrWrDataQ103H[31:0], QClk  ,  cr_en.scratch_pad_3, RstQnnnH )//Note: Reset Value is '0
//===========================================
//              RO CRs - Read Only
//===========================================
`LOTR_EN_RST_MSFF    (cr_ro.thread      , ThreadIdQ102H,  QClk  ,  cr_en.thread     , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.stk_ofst    , StkOffsetQ102H, QClk  ,  cr_en.stk_ofst   , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.tls_ofst    , TlsOffsetQ102H, QClk  ,  cr_en.tls_ofst   , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.pc_0        , PcQ103H,        QClk  ,  cr_en.pc_0       , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.pc_1        , PcQ103H,        QClk  ,  cr_en.pc_1       , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.pc_2        , PcQ103H,        QClk  ,  cr_en.pc_2       , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.pc_3        , PcQ103H,        QClk  ,  cr_en.pc_3       , RstQnnnH )
`LOTR_EN_RST_MSFF    (cr_ro.sts_0       , 32'b0,          QClk  ,  cr_en.sts_0      , RstQnnnH )//FIXME assign logic that will indicate the Threads Status. (Freeze,Running,Reset,Exception,Stall(LoadFromFarMem))
`LOTR_EN_RST_MSFF    (cr_ro.sts_1       , 32'b0,          QClk  ,  cr_en.sts_1      , RstQnnnH )//FIXME assign logic that will indicate the Threads Status. (Freeze,Running,Reset,Exception,Stall(LoadFromFarMem))
`LOTR_EN_RST_MSFF    (cr_ro.sts_2       , 32'b0,          QClk  ,  cr_en.sts_2      , RstQnnnH )//FIXME assign logic that will indicate the Threads Status. (Freeze,Running,Reset,Exception,Stall(LoadFromFarMem))
`LOTR_EN_RST_MSFF    (cr_ro.sts_3       , 32'b0,          QClk  ,  cr_en.sts_3      , RstQnnnH )//FIXME assign logic that will indicate the Threads Status. (Freeze,Running,Reset,Exception,Stall(LoadFromFarMem))
`LOTR_EN_RST_MSFF    (cr_ro.expt_0      , 32'b0,          QClk  ,  cr_en.expt_0     , RstQnnnH )//FIXME assign exception code logic.
`LOTR_EN_RST_MSFF    (cr_ro.expt_1      , 32'b0,          QClk  ,  cr_en.expt_1     , RstQnnnH )//FIXME assign exception code logic.
`LOTR_EN_RST_MSFF    (cr_ro.expt_2      , 32'b0,          QClk  ,  cr_en.expt_2     , RstQnnnH )//FIXME assign exception code logic.
`LOTR_EN_RST_MSFF    (cr_ro.expt_3      , 32'b0,          QClk  ,  cr_en.expt_3     , RstQnnnH )//FIXME assign exception code logic.

`LOTR_EN_RST_MSFF    (dfd_data_0        , '0,             QClk  ,  cr_en.dfd_data_0 , RstQnnnH )//FIXME connect to the register file read port
`LOTR_EN_RST_MSFF    (dfd_data_1        , '0,             QClk  ,  cr_en.dfd_data_1 , RstQnnnH )//FIXME connect to the register file read port
`LOTR_EN_RST_MSFF    (dfd_data_2        , '0,             QClk  ,  cr_en.dfd_data_2 , RstQnnnH )//FIXME connect to the register file read port
`LOTR_EN_RST_MSFF    (dfd_data_3        , '0,             QClk  ,  cr_en.dfd_data_3 , RstQnnnH )//FIXME connect to the register file read port

`LOTR_EN_MSFF        (cr_ro.i_mem_msb   , MSB_I_MEM,      QClk  ,  cr_en.i_mem_msb)
`LOTR_EN_MSFF        (cr_ro.d_mem_msb   , MSB_D_MEM,      QClk  ,  cr_en.d_mem_msb)
`LOTR_EN_MSFF        (cr_ro.core        , CoreIdStrap,    QClk  ,  cr_en.core     )

//=======================================================
//================CR memory read======================
//=======================================================
                                               
logic [31:0] CrRdDataQ103H;
always_comb begin
    CrRdDataQ103H =32'b0;
    if(CrRdEnQ103H) begin
        unique case (CrAddressQ103H[MSB_CR:0])
             CR_WHO_AM_I                : CrRdDataQ103H  = {22'b0, cr_ro.core, cr_ro.thread}; 
             CR_THREAD_ID               : CrRdDataQ103H  = {30'b0,cr_ro.thread}; 
             CR_CORE_ID                 : CrRdDataQ103H  = {24'b0,cr_ro.core};
             CR_STACK_BASE_OFFSET       : CrRdDataQ103H  = cr_ro.stk_ofst ;
             CR_TLS_BASE_OFFSET         : CrRdDataQ103H  = cr_ro.tls_ofst ;
             CR_SHARED_BASE_OFFSET      : CrRdDataQ103H  = cr_rw.shrd_ofst;
             CR_I_MEM_MSB               : CrRdDataQ103H  = {24'b0,cr_ro.i_mem_msb};
             CR_D_MEM_MSB               : CrRdDataQ103H  = {24'b0,cr_ro.d_mem_msb};
             CR_THREAD0_STATUS          : CrRdDataQ103H  = {24'b0,cr_ro.sts_0};
             CR_THREAD1_STATUS          : CrRdDataQ103H  = {24'b0,cr_ro.sts_1};
             CR_THREAD2_STATUS          : CrRdDataQ103H  = {24'b0,cr_ro.sts_2};
             CR_THREAD3_STATUS          : CrRdDataQ103H  = {24'b0,cr_ro.sts_3};
             CR_THREAD0_EXCEPTION_CODE  : CrRdDataQ103H  = cr_ro.expt_0;
             CR_THREAD1_EXCEPTION_CODE  : CrRdDataQ103H  = cr_ro.expt_1;
             CR_THREAD2_EXCEPTION_CODE  : CrRdDataQ103H  = cr_ro.expt_2;
             CR_THREAD3_EXCEPTION_CODE  : CrRdDataQ103H  = cr_ro.expt_3;
             CR_THREAD0_PC_RST          : CrRdDataQ103H  = {31'b0,core_cr.rst_pc_0};
             CR_THREAD1_PC_RST          : CrRdDataQ103H  = {31'b0,core_cr.rst_pc_1};
             CR_THREAD2_PC_RST          : CrRdDataQ103H  = {31'b0,core_cr.rst_pc_2};
             CR_THREAD3_PC_RST          : CrRdDataQ103H  = {31'b0,core_cr.rst_pc_3};
             CR_THREAD0_PC_EN           : CrRdDataQ103H  = {31'b0,core_cr.en_pc_0};
             CR_THREAD1_PC_EN           : CrRdDataQ103H  = {31'b0,core_cr.en_pc_1};
             CR_THREAD2_PC_EN           : CrRdDataQ103H  = {31'b0,core_cr.en_pc_2};
             CR_THREAD3_PC_EN           : CrRdDataQ103H  = {31'b0,core_cr.en_pc_3};
             CR_THREAD0_DFD_REG_ID      : CrRdDataQ103H  = {27'b0,cr_rw.dfd_id_0};
             CR_THREAD1_DFD_REG_ID      : CrRdDataQ103H  = {27'b0,cr_rw.dfd_id_1};
             CR_THREAD2_DFD_REG_ID      : CrRdDataQ103H  = {27'b0,cr_rw.dfd_id_2};
             CR_THREAD3_DFD_REG_ID      : CrRdDataQ103H  = {27'b0,cr_rw.dfd_id_3};
             CR_THREAD0_PC              : CrRdDataQ103H  = cr_ro.pc_0;
             CR_THREAD1_PC              : CrRdDataQ103H  = cr_ro.pc_1;
             CR_THREAD2_PC              : CrRdDataQ103H  = cr_ro.pc_2;
             CR_THREAD3_PC              : CrRdDataQ103H  = cr_ro.pc_3;
             CR_THREAD0_DFD_REG_DATA    : CrRdDataQ103H  = dfd_data_0;
             CR_THREAD1_DFD_REG_DATA    : CrRdDataQ103H  = dfd_data_1;
             CR_THREAD2_DFD_REG_DATA    : CrRdDataQ103H  = dfd_data_2;
             CR_THREAD3_DFD_REG_DATA    : CrRdDataQ103H  = dfd_data_3;
             CR_SCRATCHPAD0             : CrRdDataQ103H  = scratch_pad_0;
             CR_SCRATCHPAD1             : CrRdDataQ103H  = scratch_pad_1;
             CR_SCRATCHPAD2             : CrRdDataQ103H  = scratch_pad_2;
             CR_SCRATCHPAD3             : CrRdDataQ103H  = scratch_pad_3;
             default                    : CrRdDataQ103H  = 32'b0;
        endcase
    end
end

//sample the read (synchornic read)
`LOTR_MSFF(CrRdDataQ104H, CrRdDataQ103H, QClk)

endmodule
