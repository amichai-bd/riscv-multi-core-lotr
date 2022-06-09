`include "lotr_defines.sv"

module mro 
#( 
   parameter MRO_MSB = 3 )

(
      input  logic             Clk,
      input  logic             Rst,
      input  logic             EnAlloc,
      input  logic [MRO_MSB:0] NextAlloc,
      input  logic [MRO_MSB:0] Dealloc,
      input  logic [MRO_MSB:0] Mask0, // mask 0 for read response
      input  logic [MRO_MSB:0] Mask1, // mask 1 for all other commands  
      output logic [MRO_MSB:0] Oldest0,
	  output logic [MRO_MSB:0] Oldest1
      ) ; 
// initialize the matrix reset signals by setting each cell to its row-deallocate signal . 
localparam MRO_SIZE = MRO_MSB + 1 ; 
localparam ENC_MRO_MSB = $clog2(MRO_SIZE)-1 ; 

logic [MRO_MSB:0][MRO_MSB:0] HistoryMatrix ;
logic [MRO_MSB:0][MRO_MSB:0] NextHistoryMatrix ;
logic [MRO_MSB:0][MRO_MSB:0] EnShiftCol ;
logic [MRO_MSB:0][MRO_MSB:0] RstRow ;
logic [MRO_MSB:0]            validCol ; 


always_comb begin : rst_row
	RstRow = '0 ; 
	for(int row_i =0 ; row_i < MRO_SIZE ;row_i++) begin	
		for (int col_i = 0 ;col_i < MRO_SIZE ; col_i++) begin
			RstRow[col_i][row_i] = Dealloc[row_i] ; 
		end
	end // for
end //always_comb  rst_row


// chcek for each column , if there is a request stored in it .  

always_comb begin : valid_col_set
	validCol = '0 ; 
	for(int col_i =0 ;col_i<MRO_SIZE ;col_i++) begin		
		validCol[col_i] = |(HistoryMatrix[col_i][MRO_MSB:0])  ; 
	end // for
end //always_comb  valid_col_set

// initalize enable signal for each cell in the matrix . the enable signal is determined 
// by its previous column valid bit & more previous column shifting . 

always_comb begin : enable
	EnShiftCol[0][MRO_MSB:0] = {MRO_SIZE{EnAlloc}} ; 
	for(int col_i =1 ;col_i<MRO_SIZE ;col_i++) begin	
		EnShiftCol[col_i][MRO_MSB:0] = validCol[col_i-1] && EnShiftCol[col_i-1][MRO_MSB:0] ;
	end // for
end //always_comb  enable

// prepre data for shift write the matrix .
// first column gets the next alloc vector
// each other columns recieves its previous one. 
always_comb begin : history_assign
	NextHistoryMatrix[0][MRO_MSB:0] = NextAlloc ;
	for (int col_i = 1 ; col_i < MRO_SIZE ;col_i++ )begin 
		NextHistoryMatrix[col_i][MRO_MSB:0] = HistoryMatrix[col_i-1][MRO_MSB:0] ; 
	end
end //always_comb  history_assign

genvar row ,col; 
generate 
for( row =0 ; row < MRO_SIZE; row++) begin : history_matrix_sampling
    for ( col = 0 ; col < MRO_SIZE ; col++) begin : col_for
	    `LOTR_EN_RST_MSFF(HistoryMatrix[col][row], NextHistoryMatrix[col][row] ,Clk, EnShiftCol[col][row] ,  RstRow[col][row])
	end //for
end //for
endgenerate 



//untill here we mainted the matrix , from now we use it . 
logic [MRO_MSB:0] oldestColMask0 ; 
logic [MRO_MSB:0] candiatesMask0 ; 
logic [MRO_MSB:0] oldestColMask1 ; 
logic [MRO_MSB:0] candiatesMask1 ; 
logic [ENC_MRO_MSB:0] EncOldestColMask0 ; 
logic [ENC_MRO_MSB:0] EncOldestColMask1 ; 

always_comb begin : select_oldest
	for (int i=0 ; i< MRO_SIZE ; i++) begin 
		candiatesMask0[i] = |(Mask0 & HistoryMatrix[i][MRO_MSB:0]);
		candiatesMask1[i] = |(Mask1 & HistoryMatrix[i][MRO_MSB:0]);
	end // for	
end // always_comb select_oldest


`FIND_FIRST(oldestColMask0 ,candiatesMask0)
`FIND_FIRST(oldestColMask1 ,candiatesMask1)
`ONE_HOT_TO_ENC(EncOldestColMask0 , oldestColMask0 )
`ONE_HOT_TO_ENC(EncOldestColMask1 , oldestColMask1 )
assign Oldest0 = HistoryMatrix[EncOldestColMask0][MRO_MSB:0] ;
assign Oldest1 = HistoryMatrix[EncOldestColMask1][MRO_MSB:0] ;



endmodule

