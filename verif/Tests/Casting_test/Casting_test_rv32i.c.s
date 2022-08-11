	.file	"Casting_test.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	__addsf3
	.globl	__fixsfsi
	.globl	__mulsf3
	.globl	__divsf3
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	sw	s1,20(sp)
	addi	s0,sp,32
	li	a5,12582912
	lw	a5,0(a5)
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,4
	bne	a4,a5,.L2
	lui	a5,%hi(.LC0)
	lw	a5,%lo(.LC0)(a5)
	sw	a5,-24(s0)
	lui	a5,%hi(.LC1)
	lw	a5,%lo(.LC1)(a5)
	sw	a5,-28(s0)
	lw	a1,-28(s0)
	lw	a0,-24(s0)
	call	__addsf3
	mv	a5,a0
	mv	a4,a5
	li	a5,4198400
	addi	s1,a5,-256
	mv	a0,a4
	call	__fixsfsi
	mv	a5,a0
	sw	a5,0(s1)
	lw	a1,-28(s0)
	lw	a0,-24(s0)
	call	__mulsf3
	mv	a5,a0
	mv	a4,a5
	li	a5,4198400
	addi	s1,a5,-252
	mv	a0,a4
	call	__fixsfsi
	mv	a5,a0
	sw	a5,0(s1)
	lw	a1,-24(s0)
	lw	a0,-28(s0)
	call	__divsf3
	mv	a5,a0
	mv	a4,a5
	li	a5,4198400
	addi	s1,a5,-248
	mv	a0,a4
	call	__fixsfsi
	mv	a5,a0
	sw	a5,0(s1)
	j	.L5
.L2:
	j	.L2
.L5:
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.section	.rodata
	.align	2
.LC0:
	.word	1069547520
	.align	2
.LC1:
	.word	1074580685
	.ident	"GCC: (GNU) 11.1.0"
