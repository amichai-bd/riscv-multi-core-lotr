
`timescale 1ns/1ns

module Counter
  #(
    parameter integer W_COUNTER=10
    )
   (
    input logic 		 clk,
    input logic 		 rstn,
    input logic 		 enable,
    input logic 		 inc_dec,
    input logic [W_COUNTER-1:0]  scale,
    input logic [W_COUNTER-1:0]  max_value,
    input logic [W_COUNTER-1:0]  min_value,
    input logic 		 load,
    input logic [W_COUNTER-1:0]  load_value,
    output logic [W_COUNTER-1:0] counter_value,
    output logic 		 first,
    output logic 		 last
    );

   logic 			 wrap;
   logic [W_COUNTER-1:0] 	 counter;
   logic [W_COUNTER-1:0] 	 next_counter_value;
   logic [W_COUNTER-1:0] 	 increase_value;
   
   assign first          = (counter==min_value);
   assign last           = (counter==max_value);
   assign wrap           = ((inc_dec) ? last : first);
   assign increase_value = ((inc_dec) ? scale : -scale);
   assign counter_value  = counter;
   
   always_comb begin
      next_counter_value = counter + increase_value;
      if(wrap) next_counter_value = ((inc_dec) ? min_value : max_value);
   end

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn)       counter <= '0;
      else if(load)   counter <= load_value;
      else if(enable) counter <= next_counter_value;
   end

endmodule
