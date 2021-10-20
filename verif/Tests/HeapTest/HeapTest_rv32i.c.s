	.file	"HeapTest.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	2
.LC0:
	.word	1
	.word	2
	.word	3
	.word	4
	.word	5
	.word	6
	.word	7
	.word	8
	.word	9
	.word	10
	.word	11
	.word	12
	.word	13
	.word	14
	.word	15
	.word	16
	.word	17
	.word	18
	.word	19
	.word	20
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-96
	sw	ra,92(sp)
	sw	s0,88(sp)
	addi	s0,sp,96
	lui	a5,%hi(.LC0)
	addi	a4,a5,%lo(.LC0)
	addi	a5,s0,-96
	mv	a3,a4
	li	a4,80
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-32(s0)
	sw	a4,0(a5)
	li	a5,0
	mv	a0,a5
	lw	ra,92(sp)
	lw	s0,88(sp)
	addi	sp,sp,96
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
