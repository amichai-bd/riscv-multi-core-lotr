//-----------------------------------------------------------------------------
// Title            : gpc_4t_defines 
// Project          : gpc_4t
//-----------------------------------------------------------------------------
// File             : gpc_4t_defines.sv
// Original Author  : Amichai Ben-David
// Created          : 1/2021
//-----------------------------------------------------------------------------
// Description :
// gpc_4t defines
//-----------------------------------------------------------------------------
`ifndef gpc_4t_defines
`define gpc_4t_defines

`define  GPC_MSFF(q,i,clk)              \
         always_ff @(posedge clk)       \
            q<=i;

`define  GPC_EN_MSFF(q,i,clk,en)        \
         always_ff @(posedge clk)       \
            if(en) q<=i;

`define  GPC_RST_MSFF(q,i,clk,rst)      \
         always_ff @(posedge clk) begin \
            if (rst) q <='0;            \
            else     q <= i;            \
         end
        
`define  GPC_RST_VAL_MSFF(q,i,clk,rst,val) \
         always_ff @(posedge clk) begin    \
            if (rst) q <= val;             \
            else     q <= i;               \
         end

`define  GPC_EN_RST_MSFF(q,i,clk,en,rst)\
         always_ff @(posedge clk)       \
            if (rst)    q <='0;         \
            else if(en) q <= i;

`define  GPC_EN_RST_VAL_MSFF(q,i,clk,en,rst,val)\
         always_ff @(posedge clk) begin \
            if (rst)    q <=val;        \
            else if(en) q <= i; end

`endif // gpc_defines

