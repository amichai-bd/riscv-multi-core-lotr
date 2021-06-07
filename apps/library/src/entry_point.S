#include "gpc_defs.h"
#include "gpc_cr.h"

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

  /*
  GP_BASE 0x800
  GP_SIZE 0x100
  DS_BASE 0x900
  DS_SIZE 0x540 => 0x150
  SS_BASE 0xe40
  SS_SIZE 0x1c0 => 0x70
  TOP 0x1000
  */

read_crs:
  li t0, CR_SPACE_ADDR
  lw t1, GPC_CR_MY_THREAD_ID(t0)
  lw t0, GPC_CR_ADDRESS_BITS(t0)

calc_mem_size:
  li t2, 1
  sll t0, t2, t0

  // from this point the following must not be modified:
  // t0 - size of D_MEM
  // t1 - my tid

  // memory layout, bottom to top (fractions relative to D_MEM size):
  // global data (1/8 == 16/128)
  // local data (21/128 per thread => 84/128 total)
  // stack (7/128 per thread => 28/128 total)

init_sp:
  // stack base offset:
  // D_MEM_SIZE/128 * (100+7*tid) - 4
  li a1, 7
  mv a2, t1
  call init_multiply
  mv t2, a0 // save result on the side, we'll save it in stack soon
  addi a2, a0, 100
  srli a1, t0, 7
  call init_multiply
  addi a0, a0, -4
  li sp, D_MEM_ADDR
  or sp, sp, a0
  mv fp, sp

calculate_sizes:
  // saved sizes:
  // sp+0 - STACK_SIZE
  // sp+4 - LOCAL_SIZE
  // sp+8 - GLOBAL_SIZE
  addi sp, sp, -12
  sw t2, 0(sp)
  srli a1, t0, 7
  li a2, 21
  call init_multiply
  sw a0, 4(sp)
  srli t2, t0, 3
  sw t2, 8(sp)

init_gp:
  // global data: base of D_MEM
  li gp, D_MEM_ADDR

init_tp:
  // local data offset:
  // D_MEM_SIZE / 128 * (16 + tid*21)
  li a1, 21
  mv a2, t1
  call init_multiply
  addi a2, a0, 16
  srli a1, t0, 7
  call init_multiply
  li tp, D_MEM_ADDR
  or tp, tp, a0

is_bootstrap_thread:
  li t2, GPC_CORE_BOOTSTRAP_THREAD_ID
  beq t1, t2, bootstrap_thread
non_bootstrap_thread:
  # TODO: wait/poll until bootstrap thread is done
  ebreak
  j global_setup_done
bootstrap_thread:
  mv a0, gp
  lw a1, 8(sp)
  li a2, CR_SPACE_ADDR
  call gpc_global_setup
  ebreak
  # TODO: wake up other threads
global_setup_done:

local_setup:
  mv a0, t1
  mv a1, tp
  lw a2, 4(sp)
  mv a3, gp
  lw a4, 8(sp)
  li a5, CR_SPACE_ADDR
  call gpc_local_setup

exec_loop:
  mv a0, t1
  mv a1, tp
  lw a2, 4(sp)
  mv a3, gp
  lw a4, 8(sp)
  li a5, CR_SPACE_ADDR
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
