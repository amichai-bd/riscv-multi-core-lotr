//`timescale 1ns/1ps

module rc_tb() ;
import lotr_pkg::*;  
// clock and reset for tb
logic         QClk_tb                  ;
logic         RstQnnnH_tb              ; 
logic  [7:0]  CoreID_tb                ; 
//Ring ---> RC , RingReqIn
logic         RingReqInValidQ500H_tb   ; 
logic  [9:0]  RingReqInRequestorQ500H_tb ;     
t_opcode      RingReqInOpcodeQ500H_tb  ; 
logic  [31:0] RingReqInAddressQ500H_tb ; 
logic  [31:0] RingReqInDataQ500H_tb    ; 
//Ring ---> RC , RingRspIn
logic         RingRspInValidQ500H_tb   ; 
logic  [9:0]  RingRspInRequestorQ500H_tb ;     
t_opcode      RingRspInOpcodeQ500H_tb  ; 
logic  [31:0] RingRspInAddressQ500H_tb ; 
logic  [31:0] RingRspInDataQ500H_tb    ; 
//RC   ---> Ring , RingReqOut
logic         RingReqOutValidQ502H_tb     ;
logic  [9:0]  RingReqOutRequestorQ502H_tb ;    
t_opcode      RingReqOutOpcodeQ502H_tb    ;
logic  [31:0] RingReqOutAddressQ502H_tb   ;
logic  [31:0] RingReqOutDataQ502H_tb      ;
//RC   ---> Ring , RingRspOut
logic         RingRspOutValidQ502H_tb     ;
logic  [9:0]  RingRspOutRequestorQ502H_tb ;    
t_opcode      RingRspOutOpcodeQ502H_tb    ;
logic  [31:0] RingRspOutAddressQ502H_tb   ;
logic  [31:0] RingRspOutDataQ502H_tb      ; 
//RC   Req/Rsp <---> Core
logic         F2C_RspValidQ500H_tb      ;
t_opcode      F2C_RspOpcodeQ500H_tb     ; // Fixme -  not sure neccesery - the core recieve on;y read responses
logic  [31:0] F2C_RspAddressQ500H_tb    ;
logic  [31:0] F2C_RspDataQ500H_tb       ;
logic         F2C_ReqValidQ502H_tb      ;
t_opcode      F2C_ReqOpcodeQ502H_tb     ;
logic  [31:0] F2C_ReqAddressQ502H_tb    ;
logic  [31:0] F2C_ReqDataQ502H_tb       ;
//RC <---> Core C2F
logic         C2F_ReqValidQ500H_tb      ;
t_opcode      C2F_ReqOpcodeQ500H_tb     ;
logic  [31:0] C2F_ReqAddressQ500H_tb    ;
logic  [31:0] C2F_ReqDataQ500H_tb       ;
logic  [1:0]  C2F_ReqThreadIDQ500H_tb   ;
logic         C2F_RspValidQ502H_tb      ;
logic  [31:0] C2F_RspDataQ502H_tb       ;
logic         C2F_RspStall_tb           ;
logic  [1:0]  C2F_RspThreadIDQ502H_tb   ;



// clock generation
initial begin: clock_gen
	forever begin
		#5 QClk_tb = 1'b0;
		#5 QClk_tb = 1'b1;
	end
end: clock_gen

// reset generation
initial begin: reset_gen
	RstQnnnH_tb = 1'b1;
	#40 RstQnnnH_tb = 1'b0;
end: reset_gen


initial begin: first_insertion
	CoreID_tb  		         = 8'b0000_0010 ; 
    RingReqInValidQ500H_tb   = '0 ; 
    RingReqInRequestorQ500H_tb = '0 ;     
    RingReqInOpcodeQ500H_tb  = RD ; 
    RingReqInAddressQ500H_tb = '0 ; 
    RingReqInDataQ500H_tb    = '0 ; 

    RingRspInValidQ500H_tb   = '0 ; 
    RingRspInRequestorQ500H_tb = '0 ;     
    RingRspInOpcodeQ500H_tb  = RD ; 
    RingRspInAddressQ500H_tb = '0 ; 
    RingRspInDataQ500H_tb    = '0 ; 
      
    F2C_RspValidQ500H_tb    = '0  ;
    F2C_RspOpcodeQ500H_tb   = RD_RSP; 
    F2C_RspAddressQ500H_tb  = '0  ;
    F2C_RspDataQ500H_tb     = '0  ;
    
    C2F_ReqValidQ500H_tb     = '0    ;
    C2F_ReqOpcodeQ500H_tb    = RD_RSP; 
    C2F_ReqAddressQ500H_tb   = '0    ;
    C2F_ReqDataQ500H_tb      = '0    ;
    C2F_ReqThreadIDQ500H_tb  = '0    ;

end: first_insertion


initial begin: main_testing

// ================= writes ========================
		#95
// [1]  valid write_req_1(500)

        RingReqInValidQ500H_tb   = 1'b1 ;
        RingReqInRequestorQ500H_tb = 10'b0000000001 ;
        RingReqInOpcodeQ500H_tb  = WR ; //write     
        RingReqInAddressQ500H_tb = 32'h0200_1111 ; // MSB 0x02 matches current RC 
        RingReqInDataQ500H_tb    = 32'h1111_1111 ; 

		#10
        RingReqInValidQ500H_tb   = 1'b0 ;
		#10
// expected : write[1] will get inserted to one of F2C entries (501) 
//            this request will be candidate from F2C to core 

// [2]  valid write_req_2(500)

        RingReqInValidQ500H_tb   = 1'b1 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = WR ; //write     
        RingReqInAddressQ500H_tb = 32'h0200_2222 ; // MSB 0x02 matches current RC 
        RingReqInDataQ500H_tb    = 32'h2222_2222 ;  
		#10
// expected : write[2] will get inserted to one of F2C entries (501) 
//            this request will be candidate from F2C to core 
//            write[1] will disptached to the core(502) .


// [3]  invalid_write_1 (500)       

        RingReqInValidQ500H_tb   = 1'b0 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = WR ; //write     
        RingReqInAddressQ500H_tb = 32'h0200_0000 ; // MSB 0x02 matches current RC 
        RingReqInDataQ500H_tb    = 32'h3333_3333 ;  
		#10                 
// expected : write[2] will disptached to the core(502) .
//            write[3] will get sampled (move to 501) . 

// [4]  invalid_write_2 (500)   - doesnt match RC id ,          

        RingReqInValidQ500H_tb   = 1'b1 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = WR ; //write     
        RingReqInAddressQ500H_tb = 32'hAA00_0000 ; // MSB 0xAA not matches current RC 
        RingReqInDataQ500H_tb    = 32'h4444_4444 ; 
		#10                 
// expected : write[4] will get sampled (move to 501) . 
//            write[3] will get eliminated

// [5]  invalid_write_3 (500)          
        RingReqInValidQ500H_tb   = 1'b0 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = WR ; //write     
        RingReqInAddressQ500H_tb = 32'h0200_0000 ; // MSB 0x20 matches current RC 
        RingReqInDataQ500H_tb    = 32'h5555_5555 ; 
		#10                 
// expected : write[5] will get sampled (move to 501) . 
//            write[4] will get eliminated


// dummy - inserting invalid request for 3 cycles - 
        RingReqInValidQ500H_tb   = 1'b0 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = WR ; //write     
        RingReqInAddressQ500H_tb = 32'h0200_0000 ; // MSB 0x20 matches current RC 
        RingReqInDataQ500H_tb    = 32'h5555_5555 ;
		#10
// expeteced to see the reqests in C2F+F2C buffer getting out throguh RingMuxOut in the following order : 9(F2C) -> 10(C2F old) -> 11 (C2F new) .

// [6]  valid write_broadcast from ring (500)  
        RingReqInValidQ500H_tb   = 1'b1 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = WR_BCAST ; //write     
        RingReqInAddressQ500H_tb = 32'hFF00_0000 ; // MSB 0xFF indicates for BCAST req .
        RingReqInDataQ500H_tb    = 32'h6666_6666 ;
        #10
// expected : write[6] will inserted to F2C buffer (move to 501)

        RingReqInValidQ500H_tb   = 1'b0 ;
		#10
// [7]  valid write broadcast_2
        RingReqInValidQ500H_tb   = 1'b1 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = WR_BCAST ; //write     
        RingReqInAddressQ500H_tb = 32'hFF00_0000 ; // MSB 0xFF indicates for BCAST req .
        RingReqInDataQ500H_tb    = 32'h7777_7777 ;
        #10
// expected :   write_bcast [6] will get forworded to the Ring output (move to 502) + will move to the core . 
//              write[7] will get sampled (move to 501)

// dummy - inserting invalid request for 1 cycles - 
		RingReqInValidQ500H_tb     = 1'b0  ; 
		#100


// ================ Read  ======================
// [1]  valid read_req_1(500)
        RingReqInValidQ500H_tb   = 1'b1 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = RD ;    
        RingReqInAddressQ500H_tb = 32'h0200_0000 ; // MSB 0x02 matches current RC 
        RingReqInDataQ500H_tb    = 32'h1111_1111 ; // no real need .
		#10
// expected : read[1] will get inserted to one of F2C entries (501) 
//            this request will be candidate from F2C to core 

		RingReqInValidQ500H_tb     = 1'b0  ; 
		#10
// [2]  valid read_req_2(500)
        RingReqInValidQ500H_tb   = 1'b1 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = RD ;    
        RingReqInAddressQ500H_tb = 32'h0200_0022 ; // MSB 0x02 matches current RC 
        RingReqInDataQ500H_tb    = 32'h2222_2222 ; // no real need .
		#10
// expected : read[2] will get inserted to one of F2C entries (501) 
//            this request will be candidate from F2C to core 
//            read[1] will disptached to the core(502) .


// [3]  invalid_read_1 (500)       
        RingReqInValidQ500H_tb   = 1'b0 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = RD ;    
        RingReqInAddressQ500H_tb = 32'h0200_0000 ; // MSB 0x02 matches current RC 
        RingReqInDataQ500H_tb    = 32'h3333_3333 ; // no real need .
		#10                 
// expected : read[2] will disptached to the core(502) .
//            read[3] will get sampled (move to 501) . 

// [4]  invalid_read_2 (500)         
        RingReqInValidQ500H_tb   = 1'b1 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = RD ;    
        RingReqInAddressQ500H_tb = 32'hAA00_0000 ; // MSB 0xAA matches current RC 
        RingReqInDataQ500H_tb    = 32'h4444_4444 ; // no real need .
		#10                 
// expected :  read[3] will get eliminated 
//             read[4] will get sampled (move to 501) . 

// [5]  invalid_read_3 (500)          
        RingReqInValidQ500H_tb   = 1'b0 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = RD ;    
        RingReqInAddressQ500H_tb = 32'hAA00_0000 ; // MSB 0xAA matches current RC 
        RingReqInDataQ500H_tb    = 32'h5555_5555 ; // no real need .
		#10                 
// expected : read[5] will get sampled (move to 501) . 
//            read[4] will get eliminated . 


// [6]  receiving read response of read[1] , from the ring input .
        F2C_RspValidQ500H_tb    = 1'b1  ;
        F2C_RspOpcodeQ500H_tb   = RD_RSP  ;
        F2C_RspAddressQ500H_tb  = 32'h0200_0000 ;
        F2C_RspDataQ500H_tb     = 32'h6666_6666 ;
		#10    
// expected :  read response[6](match for read[1]) will move to 501
//             read[5] will get eliminated .
 
		F2C_RspValidQ500H_tb     = 1'b0  ; 
		#10
// [7]  receiving read response of read[1] , from the ring input .
        F2C_RspValidQ500H_tb    = 1'b1  ;
        F2C_RspOpcodeQ500H_tb   = RD_RSP  ;
        F2C_RspAddressQ500H_tb  = 32'h0200_0022 ;
        F2C_RspDataQ500H_tb     = 32'h7777_7777 ;
		#10    
		F2C_RspValidQ500H_tb     = 1'b0  ; 
		#10
// expected :  read response[7](match for read[2]) will move to 501

// dummy - inserting invalid request for 1 cycles -
        RingReqInValidQ500H_tb   = 1'b0 ;
        RingReqInRequestorQ500H_tb = 10'b0000000011 ;
        RingReqInOpcodeQ500H_tb  = RD ;    
        RingReqInAddressQ500H_tb = 32'h0200_0000 ; 
        RingReqInDataQ500H_tb    = 32'hFFFF_FFFF ; 
// expected :  
	end //initial 

rc i_rc(	  
    .QClk                     ( QClk_tb                    ),
    .RstQnnnH                 ( RstQnnnH_tb                ),
    .CoreID                   ( CoreID_tb                  ),
    .RingReqInValidQ500H      ( RingReqInValidQ500H_tb     ),
    .RingReqInRequestorQ500H  ( RingReqInRequestorQ500H_tb ),   
    .RingReqInOpcodeQ500H     ( RingReqInOpcodeQ500H_tb    ),
    .RingReqInAddressQ500H    ( RingReqInAddressQ500H_tb   ),
    .RingReqInDataQ500H       ( RingReqInDataQ500H_tb      ),
    .RingRspInValidQ500H      ( RingRspInValidQ500H_tb     ),
    .RingRspInRequestorQ500H    ( RingRspInRequestorQ500H_tb   ),    
    .RingRspInOpcodeQ500H     ( RingRspInOpcodeQ500H_tb    ),
    .RingRspInAddressQ500H    ( RingRspInAddressQ500H_tb   ),
    .RingRspInDataQ500H       ( RingRspInDataQ500H_tb      ),
    .RingReqOutValidQ502H     ( RingReqOutValidQ502H_tb    ),
    .RingReqOutRequestorQ502H ( RingReqOutRequestorQ502H_tb),    
    .RingReqOutOpcodeQ502H    ( RingReqOutOpcodeQ502H_tb   ),
    .RingReqOutAddressQ502H   ( RingReqOutAddressQ502H_tb  ),
    .RingReqOutDataQ502H      ( RingReqOutDataQ502H_tb     ),
    .RingRspOutValidQ502H     ( RingRspOutValidQ502H_tb    ),
    .RingRspOutRequestorQ502H ( RingRspOutRequestorQ502H_tb),    
    .RingRspOutOpcodeQ502H    ( RingRspOutOpcodeQ502H_tb   ),
    .RingRspOutAddressQ502H   ( RingRspOutAddressQ502H_tb  ),
    .RingRspOutDataQ502H      ( RingRspOutDataQ502H_tb     ), 
    .F2C_RspValidQ500H        ( F2C_RspValidQ500H_tb       ),
    .F2C_RspOpcodeQ500H       ( F2C_RspOpcodeQ500H_tb      ),
    .F2C_RspAddressQ500H      ( F2C_RspAddressQ500H_tb     ),
    .F2C_RspDataQ500H         ( F2C_RspDataQ500H_tb        ),
    .F2C_ReqValidQ502H        ( F2C_ReqValidQ502H_tb       ),
    .F2C_ReqOpcodeQ502H       ( F2C_ReqOpcodeQ502H_tb      ),
    .F2C_ReqAddressQ502H      ( F2C_ReqAddressQ502H_tb     ),
    .F2C_ReqDataQ502H         ( F2C_ReqDataQ502H_tb        ),
    .C2F_ReqValidQ500H        ( C2F_ReqValidQ500H_tb       ),//input   logic         
    .C2F_ReqOpcodeQ500H       ( C2F_ReqOpcodeQ500H_tb      ),//input   t_opcode      
    .C2F_ReqAddressQ500H      ( C2F_ReqAddressQ500H_tb     ),//input   logic  [31:0] 
    .C2F_ReqDataQ500H         ( C2F_ReqDataQ500H_tb        ),//input   logic  [31:0] 
    .C2F_ReqThreadIDQ500H     ( C2F_ReqThreadIDQ500H_tb    ),//input   logic  [1:0]  
    .C2F_RspValidQ502H        ( C2F_RspValidQ502H_tb       ),//output  logic         
    .C2F_RspDataQ502H         ( C2F_RspDataQ502H_tb        ),//output  logic  [31:0] 
    .C2F_RspStall             ( C2F_RspStall_tb            ),//output  logic         
    .C2F_RspThreadIDQ502H     ( C2F_RspThreadIDQ502H_tb    ) //output  logic  [1:0] 
    );

initial begin 
   #10000 $finish;
end
endmodule // tb_top

