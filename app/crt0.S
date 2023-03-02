#define THREAD_STACK_ADDRESS 0xC0000C

_start:
  .global _start
  
/* PipeLine CleanUp  */

  .section .vectors, "ax"
  .option norvc;
  .org 0x00
  nop
  nop
  nop
  nop
  nop
  .org 0x14
  jal x0, reset_handler
  

/* Set all registers to zero and stack initilization*/

reset_handler:
  mv  x1, x0
  mv  x2, x1
  mv  x3, x1
  mv  x4, x1
  mv  x5, x1
  mv  x6, x1
  mv  x7, x1
  mv  x8, x1
  mv  x9, x1
  mv x10, x1
  mv x11, x1
  mv x12, x1
  mv x13, x1
  mv x14, x1
  mv x15, x1
  mv x16, x1
  mv x17, x1
  mv x18, x1
  mv x19, x1
  mv x20, x1
  mv x21, x1
  mv x22, x1
  mv x23, x1
  mv x24, x1
  mv x25, x1
  mv x26, x1
  mv x27, x1
  mv x28, x1
  mv x29, x1
  mv x30, x1
  mv x31, x1
  /* stack initilization */
  li   x5,THREAD_STACK_ADDRESS
  lw   x2, 0(x5)
  jal x1, main      //jump to main
  ebreak        //end
  
  .section .text






  


