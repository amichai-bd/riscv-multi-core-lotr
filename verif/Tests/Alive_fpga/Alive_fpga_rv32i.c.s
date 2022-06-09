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
	li	a5,50339840
	li	a4,1
	sw	a4,0(a5)
	nop
.L3:
	lw	a5,-20(s0)
	addi	a4,a5,1
	sw	a4,-20(s0)
	li	a4,9
	ble	a5,a4,.L3
	li	a4,50339840
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,0(a4)
	sw	a4,0(a5)
	j	.L6
.L2:
	j	.L2
.L6:
	li	a5,0
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
