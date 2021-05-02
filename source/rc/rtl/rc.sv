//-----------------------------------------------------------------------------
// Title            : RC - Ring Controller 
// Project          : LOTR: Lord-Of-The-Ring
//-----------------------------------------------------------------------------
// File             : rc.sv 
// Original Author  : 
// Created          : 5/2021
//-----------------------------------------------------------------------------
// Description :
// 
//
// 
//------------------------------------------------------------------------------
// Modification history :
//
//
//------------------------------------------------------------------------------

`include "lotr_defines.sv"
module rc 
    import lotr_pkg::*;  
    (
    //General Interface
    input   logic        QClk                   ,
    input   logic        RstQnnnH               ,
    //Ring ---> RC 
    input   logic [31:0] RingInputAddressQ500H  ,
    input   logic [31:0] RingInputDataQ500H     ,
    //RC   ---> Ring 
    output  logic [31:0] RingOutputAddressQ502H ,
    output  logic [31:0] RingOutputDataQ502H    ,
    //Core Req/Rsp <---> RC
    input   logic [31:0] C2F_ReqAddressQ500H    ,
    input   logic [31:0] C2F_ReqDataQ500H       ,
    output  logic [31:0] C2F_RspAddressQ502H    ,
    output  logic [31:0] C2F_RspDataQ502H       ,
    //RC   Req/Rsp <---> Core
    input   logic [31:0] F2C_RspAddressQ500H    ,
    input   logic [31:0] F2C_RspDataQ500H       ,
    output  logic [31:0] F2C_ReqAddressQ502H    ,
    output  logic [31:0] F2C_ReqDataQ502H
    );

//=========================================
//=====    Data Path Signals    ===========
//=========================================
// Ring Interface 
logic [31:0]            RingInputAddressQ501H;
logic [31:0]            RingInputDataQ501H;
logic [31:0]            RingOutputAddressQ501H;
logic [31:0]            RingOutputDataQ501H;

// C2F BUFFER
logic [C2F_MSB:0][31:0] C2F_BufferAddressQnnnH;
logic [C2F_MSB:0][31:0] C2F_BufferDataQnnnH;
logic [C2F_MSB:0][31:0] C2F_NextBufferAddressQnnnH;
logic [C2F_MSB:0][31:0] C2F_NextBufferDataQnnnH;
logic            [31:0] C2F_ReqAddressQ501H;
logic            [31:0] C2F_ReqDataQ501H;

// F2C BUFFER
logic [F2C_MSB:0][31:0] F2C_BufferAddressQnnnH;
logic [F2C_MSB:0][31:0] F2C_BufferDataQnnnH;
logic [F2C_MSB:0][31:0] F2C_NextBufferAddressQnnnH;
logic [F2C_MSB:0][31:0] F2C_NextBufferDataQnnnH;
logic            [31:0] F2C_RspAddressQ501H;
logic            [31:0] F2C_RspDataQ501H;

//=========================================
//=====    Control Bits Signals   =========
//=========================================
// === General ===
logic [1:0]       SelRingOutQ501H;

// === C2F ===
logic [C2F_ENC_MSB:0] C2F_SelRdRingQ501H;
logic [C2F_ENC_MSB:0] C2F_SelRdCoreQ502H;
logic [C2F_MSB:0]     C2F_EnRingWrQ501H;
logic [C2F_MSB:0]     C2F_EnCoreWrQ500H;
logic [C2F_MSB:0]     C2F_EnWrQnnnH;
logic [C2F_MSB:0]     C2F_SelWrQnnnH;

// === F2C ===
logic [C2F_ENC_MSB:0] F2C_SelRdRingQ501H;
logic [C2F_ENC_MSB:0] F2C_SelRdCoreQ502H;
logic [C2F_MSB:0]     F2C_EnRingWrQ501H;
logic [C2F_MSB:0]     F2C_EnCoreWrQ500H;
logic [C2F_MSB:0]     F2C_EnWrQnnnH;
logic [C2F_MSB:0]     F2C_SelWrQnnnH;


//======================================================================================
//=========================     Module Content      ====================================
//======================================================================================
//  TODO - add discription of this module structure and blockes
//
//======================================================================================

//=========================================
// Ring input Interface
//=========================================
`LOTR_MSFF( RingInputAddressQ501H   ,RingInputAddressQ500H, QClk )
`LOTR_MSFF( RingInputDataQ501H      ,RingInputDataQ500H   , QClk )

//==================================================================================
//              The C2F Buffer - Ring 2 Fabric
//==================================================================================
//  TODO - add discription of this block
//  
//==================================================================================
always_comb begin : set_c2f_wr_en
    C2F_EnCoreWrQ500H = '0; // FIXME - set the condition for this EN
    C2F_EnRingWrQ501H = '0; // FIXME - set the condition for this EN
end //always_comb


// ===== C2F Buffer Input =========
always_comb begin : next_c2f_buffer_per_buffer_entry
    C2F_EnWrQnnnH   = C2F_EnCoreWrQ500H | C2F_EnRingWrQ501H;
    C2F_SelWrQnnnH  = C2F_EnCoreWrQ500H;
    for(int i =0; i < C2F_BUFFER_SIZE; i++) begin
        C2F_NextBufferAddressQnnnH[i] = C2F_SelWrQnnnH[i] ? C2F_ReqAddressQ500H : RingInputAddressQ501H ; 
        C2F_NextBufferDataQnnnH[i]    = C2F_SelWrQnnnH[i] ? C2F_ReqDataQ500H    : RingInputDataQ501H    ; 
    end //for C2F_BUFFER_SIZE
end //always_comb

// ==== C2F Buffer =================
genvar C2F_ENTRY;
generate for ( C2F_ENTRY =0 ; C2F_entry < C2F_BUFFER_SIZE ; C2F_ENTRY++) begin : the_c2f_buffer_array
    `LOTR_EN_MSFF( C2F_BufferAddressQnnnH[C2F_ENTRY], C2F_NextBufferAddressQnnnH[C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY])
    `LOTR_EN_MSFF( C2F_BufferDataQnnnH   [C2F_ENTRY], C2F_NextBufferDataQnnnH   [C2F_ENTRY], QClk, C2F_EnWrQnnnH[C2F_ENTRY])
end endgenerate // for , generate

// ==== C2F Buffer Output ==========
always_comb begin : set_c2f_sel_rd_buffer
    C2F_SelRdRingQ501H = '0; // FIXME - set the condition for this Selector
    C2F_SelRdCoreQ502H = '0; // FIXME - set the condition for this Selector
end //always_comb

always_comb begin : select_C2F_from_buffer
    // C2F_buferr -> Ring (Requist)
    C2F_ReqAddressQ501H = C2F_BufferAddressQnnnH[C2F_SelRdRingQ501H]; // NOTE: The 501 Cycle is due to the origin of the Request (CoreReqQ500H)
    C2F_ReqDataQ501H    = C2F_BufferDataQnnnH   [C2F_SelRdRingQ501H]; 
    // C2F_buffer -> Core (Response)
    C2F_RspAddressQ502H = C2F_BufferAddressQnnnH[C2F_SelRdCoreQ502H]; // Note: The 502 Cycle is due to the origin of the Response (RingInputQ500H->RingInputQ501H)
    C2F_RspDataQ502H    = C2F_BufferDataQnnnH   [C2F_SelRdCoreQ502H];
end //always_comb

//==================================================================================
//              The F2C Buffer - Fabric 2 Core
//==================================================================================
//  TODO - add discription of this block
//  
//==================================================================================
always_comb begin : set_f2c_wr_en
    F2C_EnCoreWrQ500H = '0; // FIXME - set the condition for this EN
    F2C_EnRingWrQ501H = '0; // FIXME - set the condition for this EN
end //always_comb


// ===== F2C Buffer Input =========
always_comb begin : next_f2c_buffer_per_buffer_entry
    F2C_EnWrQnnnH   = F2C_EnCoreWrQ500H | F2C_EnRingWrQ501H;
    F2C_SelWrQnnnH  = F2C_EnCoreWrQ500H;
    for(int i =0; i < F2C_BUFFER_SIZE; i++) begin
        F2C_NextBufferAddressQnnnH[i] = F2C_SelWrQnnnH[i] ? F2C_RspAddressQ500H : RingInputAddressQ501H ; 
        F2C_NextBufferDataQnnnH[i]    = F2C_SelWrQnnnH[i] ? F2C_RspDataQ500H    : RingInputDataQ501H    ; 
    end //for F2C_BUFFER_SIZE
end //always_comb

// ==== F2C Buffer =================
genvar F2C_ENTRY;
generate for ( F2C_ENTRY =0 ; F2C_entry < F2C_BUFFER_SIZE ; F2C_ENTRY++) begin : the_f2c_buffer_array
    `LOTR_EN_MSFF( F2C_BufferAddressQnnnH[F2C_ENTRY], F2C_NextBufferAddressQnnnH[F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY])
    `LOTR_EN_MSFF( F2C_BufferDataQnnnH   [F2C_ENTRY], F2C_NextBufferDataQnnnH   [F2C_ENTRY], QClk, F2C_EnWrQnnnH[F2C_ENTRY])
end endgenerate // for , generate

// ==== F2C Buffer Output ==========
always_comb begin : set_f2c_sel_rd_buffer
    F2C_SelRdRingQ501H = '0; // FIXME - set the condition for this Selector
    F2C_SelRdCoreQ502H = '0; // FIXME - set the condition for this Selector
end //always_comb

always_comb begin : select_f2c_from_buffer
    // F2C_buferr -> Ring (Response)
    F2C_RspAddressQ501H = F2C_BufferAddressQnnnH[F2C_SelRdRingQ501H]; // NOTE: The 501 Cycle is due to the origin of the Request (CoreReqQ500H)
    F2C_RspDataQ501H    = F2C_BufferDataQnnnH   [F2C_SelRdRingQ501H]; 
    // F2C_buffer -> Core (Request)
    F2C_ReqAddressQ502H = F2C_BufferAddressQnnnH[F2C_SelRdCoreQ502H]; // Note: The 502 Cycle is due to the origin of the Response (RingInputQ500H->RingInputQ501H)
    F2C_ReqDataQ502H    = F2C_BufferDataQnnnH   [F2C_SelRdCoreQ502H];
end //always_comb


//==================================================================================
//                  Ring output Interface
//==================================================================================
//  TODO - add more detailed discription of this block
//  Select the Ring Output.
//  C2F_Req / F2C_Rsp / RingInput
//==================================================================================

always_comb begin : set_the_select_next_ring_output_logic
    SelRingOutQ501H = '0;  // FIXME - set the condition for this Selector
end //always_comb

always_comb begin : select_next_ring_output
    //mux 4:1
    unique casez (SelRingOutQ501H) 
        2'b00   : begin // Insert Invalid Cycle
                    RingOutputAddressQ501H  = 32'b0; 
                    RingOutputDataQ501H     = 32'b0; 
                  end 
        2'b01   : begin // Send the C2F Req
                    RingOutputAddressQ501H  = C2F_ReqAddressQ501H  ; 
                    RingOutputDataQ501H     = C2F_ReqDataQ501H     ; 
                  end 
        2'b10   : begin // Send the F2C Rsp
                    RingOutputAddressQ501H  = F2C_RspAddressQ501H  ;
                    RingOutputDataQ501H     = F2C_RspDataQ501H     ;
                  end 
        2'b11   : begin // Foword the Ring Input 
                    RingOutputAddressQ501H  = RingInputAddressQ501H; 
                    RingOutputDataQ501H     = RingInputDataQ501H   ; 
                  end 
    endcase
end

//The Sample before Ring Output 
`LOTR_MSFF( RingOutputAddressQ502H, RingOutputAddressQ501H, QClk )
`LOTR_MSFF( RingOutputDataQ502H   , RingOutputDataQ501H   , QClk )



endmodule // module rc
