/*
 
 

 */
`timescale 1ns/1ns

`include "./uart/uart_defines.v"
`include "../../common/lotr_defines.sv"

module uart_io
  import lotr_pkg::*;
  (
   input  logic 	      clk,
   input  logic 	      rstn,
   input  logic [7:0]   core_id,
   //RC <---> Core C2F
   // Request
   output logic         C2F_ReqValidQ500H      ,
   output t_opcode      C2F_ReqOpcodeQ500H     ,
   output logic  [31:0] C2F_ReqAddressQ500H    ,
   output logic  [31:0] C2F_ReqDataQ500H       ,
   output logic  [1:0]  C2F_ReqThreadIDQ500H   ,
   // Response
   input  logic         C2F_RspValidQ502H      ,
   input  t_opcode      C2F_RspOpcodeQ502H     ,
   input  logic  [31:0] C2F_RspDataQ502H       ,
   input  logic         C2F_RspStall           ,
   input  logic  [1:0]  C2F_RspThreadIDQ502H   ,     
   // uart RX/TX signals
   input   logic 	      uart_master_tx, 
   output  logic        uart_master_rx,
   output  logic        interrupt
   );
   
  logic uart_interrupt;
  logic write_resp_valid;
  logic read_resp_valid;
  logic write_transfer_valid;
  logic read_transfer_valid;

  assign interrupt            = uart_interrupt;
  assign C2F_ReqValidQ500H    = (write_transfer_valid | read_transfer_valid);
  assign C2F_ReqOpcodeQ500H   = ((write_transfer_valid) ? WR : RD);
  assign write_resp_valid     = (C2F_RspValidQ502H & (C2F_RspOpcodeQ502H==WR));
  assign read_resp_valid      = (C2F_RspValidQ502H & (C2F_RspOpcodeQ502H==RD_RSP));
  assign C2F_ReqThreadIDQ500H = '0;

   // wishbone interface
   wishbone 
     #(
       .ADDR_W   (`UART_ADDR_WIDTH),
       .DATA_W   (`UART_DATA_WIDTH),
       .SELECT_W (4)
       ) wb_if();
   
   // UART wrapper inst
   uart_wrapper
     uart_wrapper_inst
       (
        .clk            (clk),
        .rstn           (rstn),
        .wb_slave       (wb_if),
        .uart_master_tx (uart_master_tx),
        .uart_master_rx (uart_master_rx),
        .interrupt      (uart_interrupt)
        );
   
   // Gateway
   gateway
     gateway_inst
       (
        .wb_master            (wb_if),
        .clk                  (clk),
        .rstn                 (rstn),
        .interrupt            (uart_interrupt),
        .address              (C2F_ReqAddressQ500H),
        .data_out             (C2F_ReqDataQ500H),
        .data_in              (C2F_RspDataQ502H),
        .write_transfer_valid (write_transfer_valid), // once address and data are ready, pulse for one cycle.
        .write_resp_valid     (write_resp_valid),     // is pulsed to indicate write_data is valid from RC.
        .read_transfer_valid  (read_transfer_valid),  // once address and data are ready, pulse for one cycle.
        .read_resp_valid      (read_resp_valid)      // is pulsed to indicate read_data is valid from RC.
        );

endmodule // uart_io