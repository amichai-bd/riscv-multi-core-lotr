//====================================
//====== includes ====================
//====================================
+incdir+../../../source/common/

//====================================
//====== PARAM PACAKGE ===============
//====================================
../../../source/common/lotr_pkg.sv

//====================================
//======    RTL     ==================
//====================================

//=============
// UART_tile
//=============
// WISHBONE
../../../source/uart_io/rtl/wishbone/wishbone.sv
../../../source/uart_io/rtl/wishbone/wishbone_mux3to1.sv
// UART design      
../../../source/uart_io/rtl/uart/uart_defines.v
../../../source/uart_io/rtl/uart/timescale.v
../../../source/uart_io/rtl/uart/raminfr.v
../../../source/uart_io/rtl/uart/uart_sync_flops.v
../../../source/uart_io/rtl/uart/uart_rfifo.v
../../../source/uart_io/rtl/uart/uart_tfifo.v
../../../source/uart_io/rtl/uart/uart_receiver.v
../../../source/uart_io/rtl/uart/uart_transmitter.v
../../../source/uart_io/rtl/uart/uart_regs.v
../../../source/uart_io/rtl/uart/uart_wb.v
../../../source/uart_io/rtl/uart/uart_top.v
../../../source/uart_io/rtl/uart/uart_wrapper.sv
// GATEWAY
../../../source/uart_io/rtl/gateway/uart_config/uart_config.sv
../../../source/uart_io/rtl/gateway/transfer_handler_engine/Counter.sv
../../../source/uart_io/rtl/gateway/transfer_handler_engine/wishbone_transfer_fsm.sv
../../../source/uart_io/rtl/gateway/transfer_handler_engine/transfer_handler_engine.sv
../../../source/uart_io/rtl/gateway/gateway.sv
// UART_IO
../../../source/uart_io/rtl/uart_io.sv


//===========
// gpc_4t
//===========
../../../source/gpc_4t/rtl/gpc_4t.sv
../../../source/gpc_4t/rtl/core_4t.sv
../../../source/gpc_4t/rtl/d_mem.sv
../../../source/gpc_4t/rtl/cr_mem.sv
../../../source/gpc_4t/rtl/d_mem_wrap.sv
../../../source/gpc_4t/rtl/i_mem.sv
../../../source/gpc_4t/rtl/i_mem_wrap.sv

//===========
// rc
//===========
../../../source/rc/rtl/f2c.sv
../../../source/rc/rtl/c2f.sv
../../../source/rc/rtl/rc.sv
../../../source/rc/rtl/mro.sv

//===========
// LOTR - Fabric
//===========
../../../source/lotr/rtl/uart_tile.sv
../../../source/lotr/rtl/gpc_4t_tile.sv
../../../source/lotr/rtl/lotr.sv
../../../source/lotr/rtl/fpga_tile.sv
../../../source/lotr/rtl/DE10Lite_MMIO.sv
../../../source/lotr/rtl/vga_ctrl.sv
../../../source/lotr/rtl/vga_mem.sv
../../../source/lotr/rtl/vga_sync_gen.sv

