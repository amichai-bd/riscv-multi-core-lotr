	.file	"Binary_Search.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	li	a5,1
	sw	a5,-48(s0)
	li	a5,5
	sw	a5,-44(s0)
	li	a5,7
	sw	a5,-40(s0)
	li	a5,1
	sw	a5,-32(s0)
	sw	zero,-20(s0)
	li	a5,2
	sw	a5,-24(s0)
	sw	zero,-28(s0)
	li	a5,4198400
	addi	a5,a5,-256
	sw	zero,0(a5)
	j	.L2
.L6:
	lw	a4,-24(s0)
	lw	a5,-20(s0)
	sub	a5,a4,a5
	srli	a4,a5,31
	add	a5,a4,a5
	srai	a5,a5,1
	mv	a4,a5
	lw	a5,-20(s0)
	add	a5,a5,a4
	sw	a5,-36(s0)
	lw	a5,-36(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-32(a5)
	lw	a4,-32(s0)
	bne	a4,a5,.L3
	li	a5,1
	sw	a5,-28(s0)
	li	a5,4198400
	addi	a5,a5,-256
	li	a4,1
	sw	a4,0(a5)
.L3:
	lw	a5,-36(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-32(a5)
	lw	a4,-32(s0)
	ble	a4,a5,.L4
	lw	a5,-36(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
	j	.L2
.L4:
	lw	a5,-36(s0)
	addi	a5,a5,-1
	sw	a5,-24(s0)
.L2:
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	bgt	a4,a5,.L5
	lw	a5,-28(s0)
	beq	a5,zero,.L6
.L5:
	nop
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
