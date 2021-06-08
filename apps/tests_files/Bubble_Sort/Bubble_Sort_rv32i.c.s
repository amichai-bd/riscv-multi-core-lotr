	.file	"Bubble_Sort.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	2
.LC0:
	.word	1
	.word	49
	.word	36
	.word	50
	.word	66
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-64
	sw	s0,60(sp)
	addi	s0,sp,64
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a1,0(a5)
	lw	a2,4(a5)
	lw	a3,8(a5)
	lw	a4,12(a5)
	lw	a5,16(a5)
	sw	a1,-52(s0)
	sw	a2,-48(s0)
	sw	a3,-44(s0)
	sw	a4,-40(s0)
	sw	a5,-36(s0)
	sw	zero,-20(s0)
	sw	zero,-24(s0)
	li	a5,5
	sw	a5,-28(s0)
	sw	zero,-20(s0)
	j	.L2
.L6:
	sw	zero,-24(s0)
	j	.L3
.L5:
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-36(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-36(a5)
	ble	a4,a5,.L4
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-36(a5)
	sw	a5,-32(s0)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-36(a5)
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-36(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-32(s0)
	sw	a4,-36(a5)
.L4:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L3:
	lw	a4,-28(s0)
	lw	a5,-20(s0)
	sub	a5,a4,a5
	addi	a5,a5,-1
	lw	a4,-24(s0)
	blt	a4,a5,.L5
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a4,-20(s0)
	lw	a5,-28(s0)
	blt	a4,a5,.L6
	li	a5,4198400
	lw	a4,-52(s0)
	sw	a4,0(a5)
	li	a5,4198400
	lw	a4,-48(s0)
	sw	a4,4(a5)
	li	a5,4198400
	lw	a4,-44(s0)
	sw	a4,8(a5)
	li	a5,4198400
	lw	a4,-40(s0)
	sw	a4,12(a5)
	li	a5,4198400
	lw	a4,-36(s0)
	sw	a4,16(a5)
	nop
	mv	a0,a5
	lw	s0,60(sp)
	addi	sp,sp,64
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
