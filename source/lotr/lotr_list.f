//====================================
//====== includes ====================
//====================================
+incdir+../source/common/

//====================================
//====== PARAM PACAKGE ===============
//====================================
../source/gpc_4t/rtl/gpc_4t_param_pkg.sv
../source/rc/rtl/rc_param_pkg.sv

//====================================
//======    RTL     ==================
//====================================
// gpc_4t
//====================================
../source/gpc_4t/rtl/gpc_4t.sv
../source/gpc_4t/rtl/core_4t.sv
../source/gpc_4t/rtl/d_mem.sv
../source/gpc_4t/rtl/d_mem_wrap.sv
../source/gpc_4t/rtl/i_mem.sv
../source/gpc_4t/rtl/i_mem_wrap.sv
//====================================
// rc
//====================================
../source/rc/rtl/rc.sv
../source/rc/rtl/mro.sv
//====================================
// LOTR - Fabric
//====================================
../source/lotr/rtl/gpc_4t_tile.sv

//====================================
//==  Simulation - Test Bench ========
//====================================
../verif/tb/gpc_4t_tile_tb.sv

