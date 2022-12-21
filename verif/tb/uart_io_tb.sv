/*
 This testbench simulates the uart io functionality
 uart_io master communicates with uart slave(external uart device)
 uart_io resques and responds from/to fabric side
 
                    ---------
                   |         |
 F2C_request   ->  |         |
 F2C_response  <-  |         | -> uart_master_tx
                   | uart_io | 
 C2F_request   <-  |         | -> uart_master_rx
 C2F_response  ->  |         |
                   |         |
                    --------- 
 */
`timescale 1ns/1ns

`include "lotr_defines.sv"

module uart_io_tb;
   import lotr_pkg::*;

   // CLK PARAMETERS 20MHz CLK
   localparam integer HALF_CLK=25; 
   localparam integer CLK_PERIOD=2*HALF_CLK;

   // UART PROTOCOL PARAMS
   localparam bit     LSB_FIRST=0;        //[0/1] 0: MSB first,   1: LSB first
   localparam bit     PARITY_EN=0;        //[0/1] 0: disable,     1: enable
   localparam bit     SINGLE_STOP_BIT=1;  //[0/1] 0: 2 stop bits, 1: single
   localparam integer N_DATA_BITS=8;      //[5:8] can be any number between 5 and 8
   localparam integer BUADRATE=9600;      //[] bits per sec
   localparam integer NANOSECOND=1e+9;
   localparam         UART_BIT_PERIOD=(NANOSECOND/BUADRATE);

   localparam bit     ADDR = 0;
   localparam bit     DATA = 0; 
   localparam integer N_WRITE_TRANSFERS = 1;
   logic [31:0]       Write_transfer_buffer [N_WRITE_TRANSFERS-1:0][1:0]; 
   
   // GENERAL SIGNALS
   logic          test_undone;
   logic 	      clk;
   logic 	      rstn;
   logic 	      clk_en;
   logic 	      uart_master_tx; //pc side to uart
   logic 	      uart_master_rx; //pc side to uart
   logic          interrupt;

   //===================================
   // Ring Controler <-> Core Interface
   //===================================
   //---------------------------------------
   //RC <---> Core F2C 
   //---------------------------------------
   // REQUEST
   logic 	      F2C_ReqValidQ502H;
   t_opcode       F2C_ReqOpcodeQ502H;
   logic [31:0]   F2C_ReqAddressQ502H;
   logic [31:0]   F2C_ReqDataQ502H;
   // RESPOSE
   logic 	      F2C_RspValidQ500H;
   t_opcode       F2C_RspOpcodeQ500H;
   logic [31:0]   F2C_RspAddressQ500H;
   logic [31:0]   F2C_RspDataQ500H;
   //---------------------------------------
   //RC <---> Core C2F
   //---------------------------------------
   // REQUEST
   logic 	      C2F_ReqValidQ500H;
   t_opcode       C2F_ReqOpcodeQ500H;
   logic [31:0]   C2F_ReqAddressQ500H;
   logic [31:0]   C2F_ReqDataQ500H;
   logic [1:0] 	C2F_ReqThreadIDQ500H;
   // RESPONSE
   logic 	      C2F_RspValidQ502H;
   t_opcode       C2F_RspOpcodeQ502H;
   logic [31:0]   C2F_RspDataQ502H;
   logic 	      C2F_RspStall;
   logic [1:0] 	C2F_RspThreadIDQ502H;        
   
   always #HALF_CLK
     clk = (clk_en) ? ~clk : 0;

 /*//////////////////////
    ___   _   _  _____ 
   |   \ | | | ||_   _|
   | |) || |_| |  | |  
   |___/  \___/   |_|  
                       
  *//////////////////////
   
   uart_io
     uart_io_DUT
       (
      // clk, rst
      .clk           (clk),
      .rstn          (rstn),
      .core_id       (8'hac),
      // RC interface
      // uart RX/TX signals
      .uart_master_tx(uart_master_tx), 
      .uart_master_rx(uart_master_rx),
      .interrupt (interrupt),
      // Fabric To Core(F2C)
      .C2F_RspValidQ502H(C2F_RspValidQ502H), 
      .C2F_RspOpcodeQ502H(C2F_RspOpcodeQ502H), 
      .C2F_RspThreadIDQ502H(C2F_RspThreadIDQ502H), 
      .C2F_RspDataQ502H(C2F_RspDataQ502H),
      .C2F_RspStall(C2F_RspStall),
      // ----output----
      .C2F_ReqValidQ500H(C2F_ReqValidQ500H),
      .C2F_ReqOpcodeQ500H(C2F_ReqOpcodeQ500H),
      .C2F_ReqThreadIDQ500H(C2F_ReqThreadIDQ500H),
      .C2F_ReqAddressQ500H(C2F_ReqAddressQ500H),
      .C2F_ReqDataQ500H(C2F_ReqDataQ500H)
	);

/*///////////////////////////
   _____           _       
  |_   _|__ _  ___| |__ ___
    | | / _` |(_-<| / /(_-<
    |_| \__,_|/__/|_\_\/__/
                           
 *///////////////////////////
	 
   task print(string str);
      $display("-I- time=%0t[ns]: %s",
               $time, str);   
   endtask // print

   task uart_bit_wait(int bits);
      #(bits*UART_BIT_PERIOD);
   endtask // uart_bit_wait
      
   task delay(int cycles);
      #(cycles*CLK_PERIOD);
   endtask // delay

   task init();
      print("Initializing TB signals");
      clk_en=1'b0;
      clk=1'b0;
      rstn=1'b1;
      uart_master_tx=1'b1;
   endtask // init
   
   task reset();
      print("Asserting reset");
      rstn=1'b0;
      delay(100);
      rstn=1'b1;
   endtask // reset

   task enable_clk();
      print("Enabling main TB clock");
      clk_en=1'b1;
   endtask // enable_clk

   //uart host to device transmit
   task UART_H2D_transmit;
      input logic [N_DATA_BITS-1:0] data;      
      print($sformatf("UART transmiting Host to Device, Bin:%b, Dec:%d, 0x%x", data, data, data));
      // start bit
      uart_master_tx=1'b0;
      uart_bit_wait(1);       
      // data bits
      for(int i=0; i<N_DATA_BITS; i++) begin
	 if(LSB_FIRST) uart_master_tx = data[i];
	 else 	       uart_master_tx = data[N_DATA_BITS-1-i] ; 
	 uart_bit_wait(1);
      end		     
      // parity
      if(PARITY_EN) begin 
	 uart_master_tx = ^data;
	 uart_bit_wait(1);
      end
      // end bits
      uart_master_tx = 1'b1;
      uart_bit_wait((SINGLE_STOP_BIT) ? 1 : 2);
   endtask // UART_H2D_transmit

   
   task F2C_request;
      input logic        valid;
      input 		 t_opcode opcode;
      input logic [31:0] address;
      input logic [31:0] data;
      @(negedge clk);
      F2C_ReqValidQ502H   = valid;
      F2C_ReqOpcodeQ502H  = opcode;
      F2C_ReqAddressQ502H = address;
      F2C_ReqDataQ502H    = data;
      @(negedge clk);
      F2C_ReqValidQ502H   = '0;
      F2C_ReqAddressQ502H = '0;
      F2C_ReqDataQ502H    = '0;
   endtask // F2C_request

   
   task F2C_response_monitor();
   endtask // F2C_response_monitor
   
   task C2F_response;
      input logic        valid;
      input	         t_opcode opcode;
      input logic [31:0] data;
      input logic 	 stall;
      input logic 	 tid;
      @(negedge clk);
      C2F_RspValidQ502H    = valid;
      C2F_RspOpcodeQ502H   = opcode;
      C2F_RspDataQ502H     = data;
      C2F_RspStall         = stall;
      C2F_RspThreadIDQ502H = tid;        
      @(negedge clk);
      C2F_RspValidQ502H    = '0;
      C2F_RspDataQ502H     = '0;
      C2F_RspStall         = '0;
      C2F_RspThreadIDQ502H = '0;        
   endtask // C2F_response

   task C2F_request_monitor();
   endtask // C2F_request_monitor

   
   task Terminal_Write;
      input logic [3:0][7:0] address;
      input logic [3:0][7:0] data;
      print($sformatf("Terminal transmit opcode: %d address: 0x%x, data: 0x%x", "W", address, data));
      UART_H2D_transmit(32'd87); //W in Ascci
      for(int i=4; i>0; i--)
	      UART_H2D_transmit(address[i-1]);
      for(int i=4; i>0; i--)
	      UART_H2D_transmit(data[i-1]);
   endtask // Terminal_Write

   
   task Terminal_Read;
      input logic [3:0][7:0] address;
      UART_H2D_transmit(32'd82); //R in Ascci
      for(int i=4; i>0; --i)
	      UART_H2D_transmit(address[i]);
   endtask // Terminal_Read
   //    
   
/*/////////////////////////////////
   ___  _    _              _  _ 
  / __|| |_ (_) _ __  _  _ | |(_)
  \__ \|  _|| || '  \| || || || |
  |___/ \__||_||_|_|_|\_,_||_||_|
                                 
 */////////////////////////////////
   
   initial begin
      test_undone= 1'b1;
      $display("%s", {50{"*"}});
      $display("*** UART playground testbench");    
      $display("%s", {50{"*"}});
      delay(10); init();
      delay(10); reset();
      delay(10); enable_clk();

      fork
         // PROCCESS-1
         begin
            forever begin
               @(posedge interrupt);
               print("UART interrupt caught $$$$");
            end 
         end

         // PROCCESS-2
         begin
            for(int i=0; i<N_WRITE_TRANSFERS; i++) begin
               Write_transfer_buffer[i][ADDR] = $random();
               Write_transfer_buffer[i][DATA] = $random();
            end
            for(int i=0; i<N_WRITE_TRANSFERS; i++) begin
               Terminal_Write(Write_transfer_buffer[i][ADDR], Write_transfer_buffer[i][DATA]);
            end
            test_undone = 1'b0;
         end
      join_any
      uart_bit_wait(10);
      $display("%s", {50{"*"}});
      $finish(1);
   end   
endmodule
