/*
 RC to wishbone gateway controller
 this module controlls the uart ip 
 via wishbone transactions and the 
 lotr project via the RC controller
 */

`timescale 1ns/1ns
`include "../uart/uart_defines.v"

module gateway
  (
   input logic 	       clk,
   input logic 	       rstn,
   // wishbone master interface
   input logic 	       interrupt,
   output logic [31:0] address,
   output logic [31:0] data_out,
   input logic [31:0]  data_in,
   output logic        write_transfer_valid,	// once address and data are ready, pulse for one cycle.
   input logic 	       write_resp_valid,	// is ppulsed to indicate write_data is valid from RC.
   output logic        read_transfer_valid,	// once address and data are ready, pulse for one cycle.
   input logic 	       read_resp_valid,		// is ppulsed to indicate read_data is valid from RC.
   wishbone.master wb_master
   );

   logic 	       config_done;
   
   // wishbone interface
   wishbone 
     #(
       .ADDR_W   (`UART_ADDR_WIDTH),
       .DATA_W   (`UART_DATA_WIDTH),
       .SELECT_W (4)
       ) wb_if[2]();
   
   wishbone_mux3to1
     wishbone_mux3to1
       (
	.slave_select (config_done),
	.wb_slave_0   (wb_if[0]),
	.wb_slave_1   (wb_if[1]),
	.wb_master    (wb_master)
	);
   
   uart_config
     uart_config_inst
       (
	.clk          (clk),
	.rstn         (rstn),
	.interrupt    (interrupt),
	.start_config (1'b1),
	.config_done  (config_done),
	.wb_master    (wb_if[0])
	);
   
   transfer_handler_engine
     transfer_handler_engine_inst
       (
	.clk                  (clk),
	.rstn                 (rstn),
	.invalid_comm         (), // floating
	.address              (address),
	.data_out             (data_out),
	.data_in              (data_in),
	.write_transfer_valid (write_transfer_valid), // once address and data are ready, pulse for one cycle.
	.write_resp_valid     (write_resp_valid),     // is pulsed to indicate write_data is valid from RC.
	.read_transfer_valid  (read_transfer_valid),  // once address and data are ready, pulse for one cycle.
	.read_resp_valid      (read_resp_valid),      // is pulsed to indicate read_data is valid from RC.
	.interrupt            (interrupt),
	.wb_master            (wb_if[1])
	);
   
endmodule // gateway
