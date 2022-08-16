	.file	"Alive_fpga.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	li	a5,12582912
	addi	a5,a5,4
	lw	a5,0(a5)
	sw	a5,-24(s0)
	li	a5,12582912
	lw	a5,0(a5)
	sw	a5,-28(s0)
	sw	zero,-20(s0)
	lw	a4,-28(s0)
	li	a5,4
	bne	a4,a5,.L2
.L3:
	li	a5,50339840
	addi	a5,a5,24
	lw	a4,-20(s0)
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
	j	.L3
.L2:
	j	.L2
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
