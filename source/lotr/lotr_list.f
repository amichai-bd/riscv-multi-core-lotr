//====================================
//====== includes ====================
//====================================
+incdir+../source/common/

//====================================
//====== PARAM PACAKGE ===============
//====================================
../source/common/lotr_pkg.sv

//====================================
//======    RTL     ==================
//====================================
//===========
// gpc_4t
//===========
../source/gpc_4t/rtl/gpc_4t.sv
../source/gpc_4t/rtl/core_4t.sv
../source/gpc_4t/rtl/d_mem.sv
../source/gpc_4t/rtl/cr_mem.sv
../source/gpc_4t/rtl/d_mem_wrap.sv
../source/gpc_4t/rtl/i_mem.sv
../source/gpc_4t/rtl/i_mem_wrap.sv

//===========
// rc
//===========
../source/rc/rtl/f2c.sv
../source/rc/rtl/c2f.sv
../source/rc/rtl/rc.sv
../source/rc/rtl/mro.sv

//===========
// LOTR - Fabric
//===========
../source/lotr/rtl/gpc_4t_tile.sv
../source/lotr/rtl/lotr.sv
../source/lotr/rtl/fpga_tile.sv
../source/lotr/rtl/DE10Lite_MMIO.sv
../source/lotr/rtl/vga_ctrl.sv
../source/lotr/rtl/vga_mem.sv
../source/lotr/rtl/vga_sync_gen.sv

//====================================
//==  Simulation - Test Bench ========
//====================================
../verif/tb/gpc_4t_tile_tb.sv
../verif/tb/lotr_tb.sv
../verif/tb/lotr_fpga_tb.sv

