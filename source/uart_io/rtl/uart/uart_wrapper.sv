/*
 this module wrapps the UART IP 
 design and compacts the use of 
 uart via interface connection
 */

`timescale 1ns/1ns

module uart_wrapper
  (
   // wishbone slave interface
   input logic clk,
   input logic rstn,
   wishbone.slave wb_slave,
   // uart RX/TX signals
   input logic  uart_master_tx, 
   output logic uart_master_rx,
   // interrupt
   output logic interrupt
   );   

   logic 	uart_rts_n;
   logic 	uart_dtr_n;
   
   // UART DUT instance
   uart_top uart_top_DUT
     (
      // Wishbone signals
      .wb_clk_i   (clk),
      .wb_rst_i   (~rstn),
      .wb_adr_i   (wb_slave.address),
      .wb_dat_i   (wb_slave.data_out),
      .wb_dat_o   (wb_slave.data_in),
      .wb_we_i    (wb_slave.we),
      .wb_stb_i   (wb_slave.stb),
      .wb_cyc_i   (wb_slave.cyc),
      .wb_ack_o   (wb_slave.ack),
      .wb_sel_i   (wb_slave.sel),
      // interrupt request
      .int_o      (interrupt), 
      // uart serial input/output
      .stx_pad_o  (uart_master_rx),
      .srx_pad_i  (uart_master_tx),
      // modem signals
      .rts_pad_o  (uart_rts_n),
      .cts_pad_i  (uart_rts_n),
      .dtr_pad_o  (uart_dtr_n),
      .dsr_pad_i  (uart_dtr_n),
      .ri_pad_i   ('1),
      .dcd_pad_i  ('1)
`ifdef UART_HAS_BAUDRATE_OUTPUT
      ,.baud_o    ()
`endif
      );   
   
endmodule // uart_wrapper
