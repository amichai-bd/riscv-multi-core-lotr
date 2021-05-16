  .section .text

reset_handler:
  /* set all registers to zero */
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

  /* TODO: read thread id from CR and initialize stack accordingly */
  /* read tid from CR */
  /* mv x2, tid */
  /* mul x2, x2, stack_size */
  //addi x2, x2, _stack_start

  /* stack initilization */
  la   x2, _stack_start


_start:
  .global _start


setup_entry:
  // TODO: call setup entry point



main_entry:
  /* jump to main program entry point (argc = argv = 0) */
  addi x10, x0, 0
  addi x11, x0, 0
  jal x1, main


/* This section has to be down here, since we have to disable rvc for it  */

  .section .vectors, "ax"
  .option norvc;

  // external interrupts are handled by the same callback
  // until compiler supports IRQ routines
  .org 0x00
  .rept 32
  nop                       // unused
  .endr


  // reset vector
  .org 0x80
  jal x0, reset_handler
  
  .global _init
  .global _fini
_init:
_fini:
  # These don't have to do anything since we use init_array/fini_array.
  ret
  

