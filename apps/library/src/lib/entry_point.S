#include "gpc_defs.h"

// Base of CR space address (CR region at the right place, other bits zero)
#define REGION_OFFSET (32 - 2 - GPC_ADDR_AGENT_ID_BITS)
#define REGION_BASE(region) (region) << REGION_OFFSET
#define CR_SPACE_ADDR REGION_BASE(GPC_ADDR_REGION_CR)
#define D_MEM_ADDR REGION_BASE(GPC_ADDR_REGION_D_MEM)

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
  // TODO: don't do that in rv32e (build/run time parameter?)
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

  /*
  GP_BASE 0x800
  GP_SIZE 0x100
  DS_BASE 0x900
  DS_SIZE 0x540 => 0x150
  SS_BASE 0xe40
  SS_SIZE 0x1c0 => 0x70
  TOP 0x1000
  */

  li t1, CR_SPACE_ADDR
  li t2, D_MEM_ADDR
read_tid:
  lw t3, 0(t1) // TODO: set proper offset for thread id

read_mem_size:
  lw t4, 0(t1) // TODO: set proper offset for address bits
  li t5, 1
  sll t4, t5, t4
  // TODO: fix addresses to use D_MEM region
  // TODO: calculate all offsets below based on base and size of D_MEM

  // sp initialization: thread stack
init_sp:
  mv sp, t2
  li t5, 0xe40
  or sp, sp, t5
  // tid * (SS_SIZE/4)
  li a1, 0x70
  mv a2, t3
  call init_multiply
  addi a0, a0, 0x6c // first stack element offset SS_SIZE/4 - 4
  add sp, sp, a0
  mv fp, sp
  sw x0, 0(sp)

  // gp initialization: base of D_MEM
init_gp:
  mv gp, t2

  // tp initialization: thread local storage
init_tp:
  add tp, gp, 0x100
  // tid * (DS_SIZE/4)
  li a1, 0x150
  mv a2, t3
  call init_multiply
  add tp, tp, a0

  li t5, GPC_CORE_BOOTSTRAP_THREAD_ID
  beq t3, t5, bootstrap_thread
non_bootstrap_thread:
  # TODO: wait/poll until bootstrap thread is done
  ebreak
  j global_setup_done
bootstrap_thread:
  mv a0, gp
  li a1, 0x100
  mv a2, t1
  call gpc_global_setup
  ebreak
  # TODO: wake up other threads
global_setup_done:

local_setup:
  mv a0, t3
  mv a1, tp
  li a2, 0x150
  mv a3, gp
  li a4, 0x100
  mv a5, t1
  call gpc_local_setup

exec_loop:
  mv a0, t1
  mv a1, tp
  li a2, 0x150
  mv a3, gp
  li a4, 0x100
  mv a5, t1
  call gpc_loop
  j exec_loop

  // must not reach here
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
