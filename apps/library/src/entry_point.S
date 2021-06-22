#include "gpc_defs.h"
#include "gpc_memory_layout.h"
#include "gpc_cr.h"
#include "gpc_params.h"

.section .start

.global _start
_start:
    /* clear pipeline */
    nop
    nop
    nop
    nop
    nop

    /* set all registers to zero */
    mv  x1, x0
    mv  x2, x0
    mv  x3, x0
    mv  x4, x0
    mv  x5, x0
    mv  x6, x0
    mv  x7, x0
    mv  x8, x0
    mv  x9, x0
    mv x10, x0
    mv x11, x0
    mv x12, x0
    mv x13, x0
    mv x14, x0
    mv x15, x0
#if !defined(USE_RV32E) || !USE_RV32E
    mv x16, x0
    mv x17, x0
    mv x18, x0
    mv x19, x0
    mv x20, x0
    mv x21, x0
    mv x22, x0
    mv x23, x0
    mv x24, x0
    mv x25, x0
    mv x26, x0
    mv x27, x0
    mv x28, x0
    mv x29, x0
    mv x30, x0
    mv x31, x0
#endif

read_tid:
      li t0, GPC_MEM_CR_BASE
      lw t0, GPC_CR_MY_THREAD_ID(t0)

init_stack:
      li a1, GPC_MEM_STACK_SIZE
      mv a2, t0
      call init_multiply
      addi sp, a0, GPC_MEM_STACK_SIZE
      mv fp, sp

init_gpc_params:
      li a1, PARAMS_SIZE
      mv a2, t0
      call init_multiply
      li a3, GPC_MEM_GLOBAL_DATA_BASE
      add a3, a3, a0
      // From this point a3 must be GPC params base
      
      // Thread ID (read earlier to t0)
      sw t0, PARAMS_OFFSET_TID(a3)

      // Global data base: need to add GPC params region size
      li t1, GPC_MEM_GLOBAL_DATA_BASE + GPC_MEM_GPC_PARAMS_SIZE * GPC_CORE_N_THREADS
      sw t1, PARAMS_OFFSET_GLOBAL_DATA(a3)

      // Global data size: need to subtract GPC params region size
      li t1, GPC_MEM_GLOBAL_DATA_SIZE - GPC_MEM_GPC_PARAMS_SIZE * GPC_CORE_N_THREADS
      sw t1, PARAMS_OFFSET_GLOBAL_DATA_SIZE(a3)
      
      // Local data base: base + tid*size
      li a1, GPC_MEM_LOCAL_DATA_SIZE
      mv a2, t0
      call init_multiply
      li t1, GPC_MEM_LOCAL_DATA_BASE
      add t1, t1, a0
      sw t1, PARAMS_OFFSET_LOCAL_DATA(a3)

      // Local data size: constant
      li t1, GPC_MEM_LOCAL_DATA_SIZE
      sw t1, PARAMS_OFFSET_LOCAL_DATA_SIZE(a3)

      // Reserved: zero everything
      li t1, PARAMS_OFFSET_RESERVED_START
      li t2, PARAMS_SIZE
reserved_init_loop:
      add a0, a3, t1
      sw zero, 0(a0)
      addi t1, t1, 4
      blt t1, t2, reserved_init_loop

init_gp:
      lw gp, PARAMS_OFFSET_GLOBAL_DATA(a3)

init_tp:
      lw tp, PARAMS_OFFSET_LOCAL_DATA(a3)

is_bootstrap_thread:
    li t2, GPC_CORE_BOOTSTRAP_THREAD_ID
    beq t0, t2, bootstrap_thread
non_bootstrap_thread:
    # TODO: wait/poll until bootstrap thread is done
    ebreak
    j global_setup_done
bootstrap_thread:
    mv a0, a3
    call gpc_global_setup
    ebreak
    # TODO: wake up other threads
global_setup_done:

local_setup:
    mv a0, a3
    call gpc_local_setup

exec_loop:
    mv a0, a3
    call gpc_loop
    j exec_loop

unreachable:
    // Must not reach here
    ebreak

/**
 * multiplies a1 and a2 (unsigned) and stores result in a0
 *
 * NOTE: must not use memory or other registers!
 * result will be in a0
 */
init_multiply:
    // TODO: replace with more efficient algorithm?
    li a0, 0
    beq a2, x0, init_multiply_end
init_multiply_loop:
    add a0, a0, a1
    addi a2, a2, -1
    bne a2, x0, init_multiply_loop
init_multiply_end:
    ret
