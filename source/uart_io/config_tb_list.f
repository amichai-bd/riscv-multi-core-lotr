// Includes
+incdir+../../source/common/
+incdir+../../verif/tb/
+incdir+../../source/uart_io/rtl/uart/

// PARAM PACAKGE
../../source/common/lotr_pkg.sv

// WISHBONE
../../source/uart_io/rtl/wishbone/wishbone.sv
../../source/uart_io/rtl/wishbone/wishbone_mux3to1.sv
      
// UART design      
../../source/uart_io/rtl/uart/uart_defines.v
../../source/uart_io/rtl/uart/timescale.v
../../source/uart_io/rtl/uart/raminfr.v
../../source/uart_io/rtl/uart/uart_sync_flops.v
../../source/uart_io/rtl/uart/uart_rfifo.v
../../source/uart_io/rtl/uart/uart_tfifo.v
../../source/uart_io/rtl/uart/uart_receiver.v
../../source/uart_io/rtl/uart/uart_transmitter.v
../../source/uart_io/rtl/uart/uart_regs.v
../../source/uart_io/rtl/uart/uart_wb.v
../../source/uart_io/rtl/uart/uart_top.v
../../source/uart_io/rtl/uart/uart_wrapper.sv

// GATEWAY
../../source/uart_io/rtl/gateway/uart_config/uart_config.sv
../../source/uart_io/rtl/gateway/handshake/handshake.sv
../../source/uart_io/rtl/gateway/xmodem/xmodem_pkg.sv
../../source/uart_io/rtl/gateway/xmodem/xmodem.sv
../../source/uart_io/rtl/gateway/gateway.sv

// UART_IO
../../source/uart_io/rtl/uart_io.sv
      
// Simulation - testbench
../../verif/tb/uart_config_tb.sv
      
