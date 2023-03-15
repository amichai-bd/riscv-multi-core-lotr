//`timescale 1ns/1ps

module rc_tb;
import lotr_pkg::*;  
// clock and reset for tb
logic         QClk_tb                  ;
logic         RstQnnnH_tb              ; 
logic  [7:0]  CoreID_tb                ; 
//Ring ---> RC , RingReqIn
logic         RingReqInValidQ500H_tb   ; 
logic  [9:0]  RingReqInRequestorQ500H_tb ;     
t_opcode      RingReqInOpcodeQ500H_tb  ; 
 
t_opcode       C2F_RspOpcodeQ502H_tb  ;
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

string test_name;
initial begin: main_testing
if ($value$plusargs ("STRING=%s", test_name))
$display("STRING value %s", test_name);
$display("================\n     START\n================\n");
RstQnnnH_tb = 1'b1;
delay(10);
RstQnnnH_tb = 1'b0;
delay(10);
$display("====== Reset Done =======\n");
if(test_name == "alive") begin
    `include "alive.sv"
end
if(test_name == "core_req") begin
    `include "core_req.sv"
end
end //initial 

rc rc(	  
    //================================================
    //        General Interface
    //================================================
    .QClk  		            (QClk_tb)                   ,//input 
    .RstQnnnH  	            (RstQnnnH_tb)               ,//input 
    .CoreID       		    (CoreID_tb)                 ,//input 
    //================================================
    //        RING Interface
    //================================================
    //Ring ---> RC , RingReqIn
    .RingReqInValidQ500H        (RingReqInValidQ500H_tb)      ,//input
    .RingReqInRequestorQ500H    (RingReqInRequestorQ500H_tb)  ,//input
    .RingReqInOpcodeQ500H       (RingReqInOpcodeQ500H_tb)     ,//input
    .RingReqInAddressQ500H      (RingReqInAddressQ500H_tb)    ,//input
    .RingReqInDataQ500H         (RingReqInDataQ500H_tb)       ,//input
    //Ring ---> RC , RingRspIn
    .RingRspInValidQ500H        (RingRspInValidQ500H_tb)      ,//input
    .RingRspInRequestorQ500H    (RingRspInRequestorQ500H_tb)  ,//input
    .RingRspInOpcodeQ500H       (RingRspInOpcodeQ500H_tb)     ,//input
    .RingRspInAddressQ500H      (RingRspInAddressQ500H_tb)    ,//input
    .RingRspInDataQ500H         (RingRspInDataQ500H_tb)       ,//input
    //RC   ---> Ring , RingReqOut
    .RingReqOutValidQ502H       (RingReqOutValidQ502H_tb)     ,//output
    .RingReqOutRequestorQ502H   (RingReqOutRequestorQ502H_tb) ,//output
    .RingReqOutOpcodeQ502H      (RingReqOutOpcodeQ502H_tb)    ,//output
    .RingReqOutAddressQ502H     (RingReqOutAddressQ502H_tb)   ,//output
    .RingReqOutDataQ502H        (RingReqOutDataQ502H_tb)      ,//output
     //RC   ---> Ring , RingRspOut
    .RingRspOutValidQ502H       (RingRspOutValidQ502H_tb)     ,//output
    .RingRspOutRequestorQ502H   (RingRspOutRequestorQ502H_tb) ,//output
    .RingRspOutOpcodeQ502H      (RingRspOutOpcodeQ502H_tb)    ,//output
    .RingRspOutAddressQ502H     (RingRspOutAddressQ502H_tb)   ,//output
    .RingRspOutDataQ502H        (RingRspOutDataQ502H_tb)      ,//output
    //================================================
    //        Core Interface
    //================================================
    // input - Req from Core
    .C2F_ReqValidQ500H      (C2F_ReqValidQ500H_tb)      ,//input
    .C2F_ReqOpcodeQ500H     (C2F_ReqOpcodeQ500H_tb)     ,//input
    .C2F_ReqThreadIDQ500H   (C2F_ReqThreadIDQ500H_tb[1:0]),//input
    .C2F_ReqAddressQ500H    (C2F_ReqAddressQ500H_tb)    ,//input
    .C2F_ReqDataQ500H       (C2F_ReqDataQ500H_tb)       ,//input
    // output - Rsp to Core
    .C2F_RspValidQ502H      (C2F_RspValidQ502H_tb)      ,//output
    .C2F_RspOpcodeQ502H     (C2F_RspOpcodeQ502H_tb)     ,//output
    .C2F_RspThreadIDQ502H   (C2F_RspThreadIDQ502H_tb[1:0]),//output
    .C2F_RspDataQ502H       (C2F_RspDataQ502H_tb)       ,//output
    .C2F_RspStall           (C2F_RspStall_tb)           ,//output
    // input - Rsp from Local Memory -> to Ring/Fabric
    .F2C_RspValidQ500H      (F2C_RspValidQ500H_tb)      ,//input
    .F2C_RspOpcodeQ500H     (F2C_RspOpcodeQ500H_tb)     ,//input
    .F2C_RspAddressQ500H    (F2C_RspAddressQ500H_tb)    ,//input
    .F2C_RspDataQ500H       (F2C_RspDataQ500H_tb)       ,//input
    // output - Req to Local Memory
    .F2C_ReqValidQ502H      (F2C_ReqValidQ502H_tb)      ,//output
    .F2C_ReqOpcodeQ502H     (F2C_ReqOpcodeQ502H_tb)     ,//output
    .F2C_ReqAddressQ502H    (F2C_ReqAddressQ502H_tb)    ,//output
    .F2C_ReqDataQ502H       (F2C_ReqDataQ502H_tb)        //output
    );

`include "rc_trk.sv"


task delay(input int cycles);
  for(int i =0; i< cycles; i++) begin
    @(posedge QClk_tb);
  end
endtask

task RingReqIn( input logic [9:0]  Requestor, 
                input t_opcode      Opcode   ,
                input logic [31:0]  Address  ,
                input logic [31:0]  Data     );
        RingReqInValidQ500H_tb      = 1'b1 ;
        RingReqInRequestorQ500H_tb  = Requestor;
        RingReqInOpcodeQ500H_tb     = Opcode;
        RingReqInAddressQ500H_tb    = Address;
        RingReqInDataQ500H_tb       = Data ; 
        delay(1);
        RingReqInValidQ500H_tb   = 1'b0 ;
endtask

task RingRspIn ( input logic [9:0]  Requestor, 
                 input t_opcode      Opcode   ,
                 input logic [31:0]  Address  ,
                 input logic [31:0]  Data     );
        RingRspInValidQ500H_tb      = 1'b1 ;
        RingRspInRequestorQ500H_tb  = Requestor;
        RingRspInOpcodeQ500H_tb     = Opcode;
        RingRspInAddressQ500H_tb    = Address;
        RingRspInDataQ500H_tb       = Data ; 
        delay(1);
        RingRspInValidQ500H_tb   = 1'b0 ;
endtask

task C2F_Req ( input t_opcode      Opcode   ,
               input logic [31:0]  Address  ,
               input logic [31:0]  Data     ,
               input logic [31:0]  Thread );
        C2F_ReqValidQ500H_tb      = 1'b1 ;
        C2F_ReqOpcodeQ500H_tb     = Opcode;
        C2F_ReqAddressQ500H_tb    = Address;
        C2F_ReqDataQ500H_tb       = Data ; 
        C2F_ReqThreadIDQ500H_tb   = Thread ; 
        delay(1);
        C2F_ReqValidQ500H_tb   = 1'b0 ;
endtask

task F2C_Rsp (input t_opcode      Opcode   ,
              input logic [31:0]  Address  ,
              input logic [31:0]  Data     );
        F2C_RspValidQ500H_tb      = 1'b1 ;
        F2C_RspOpcodeQ500H_tb     = Opcode;
        F2C_RspAddressQ500H_tb    = Address;
        F2C_RspDataQ500H_tb       = Data ; 
        delay(1);
        F2C_RspValidQ500H_tb   = 1'b0 ;
endtask

initial begin 
   #10000 $finish;
end
endmodule // tb_top

