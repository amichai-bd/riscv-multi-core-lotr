//-----------------------------------------------------------------------------
// Title            : lotr_defines 
// Project          : lotr
//-----------------------------------------------------------------------------
// File             : lotr_defines.sv
// Original Author  : Amichai Ben-David
// Created          : 1/2021
//-----------------------------------------------------------------------------
// Description :
// lotr defines
//-----------------------------------------------------------------------------
`ifndef lotr_defines
`define lotr_defines

`define  LOTR_MSFF(q,i,clk)             \
         always_ff @(posedge clk)       \
            q<=i;

`define  LOTR_EN_MSFF(q,i,clk,en)       \
         always_ff @(posedge clk)       \
            if(en) q<=i;

`define  LOTR_RST_MSFF(q,i,clk,rst)     \
         always_ff @(posedge clk) begin \
            if (rst) q <='0;            \
            else     q <= i;            \
         end
        
`define  LOTR_RST_VAL_MSFF(q,i,clk,rst,val) \
         always_ff @(posedge clk) begin    \
            if (rst) q <= val;             \
            else     q <= i;               \
         end

`define  LOTR_EN_RST_MSFF(q,i,clk,en,rst)\
         always_ff @(posedge clk)       \
            if (rst)    q <='0;         \
            else if(en) q <= i;

`define  LOTR_EN_RST_VAL_MSFF(q,i,clk,en,rst,val)\
         always_ff @(posedge clk) begin \
            if (rst)    q <=val;        \
            else if(en) q <= i; end


`define  FIND_FIRST(first , candidates )\
	always_comb begin \
		first = '0 ;\
		for(int i = $bits(candidates)-1 ; i >= 0  ; i-- ) begin\
			if (candidates[i] == 1 ) begin\
				first = '0 ;\
				first[i] = 1'b1 ;\
			end \
		end \
	end

`define  ONE_HOT_TO_ENC(number , one_hot_vec )\
	always_comb begin\
		number = '0 ;\
		for (logic [$bits(number):0] i = 0 ; i <$bits(one_hot_vec) ;i++) begin\
			if (one_hot_vec[i])\
				number = i[$bits(number)-1:0] ;\
		end\
	end

`endif // lotr_defines

