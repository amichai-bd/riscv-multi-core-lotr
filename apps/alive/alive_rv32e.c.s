	.file	"alive.c"
	.option nopic
	.attribute arch, "rv32e1p9"
	.attribute unaligned_access, 0
	.attribute stack_align, 4
	.text
	.globl	__mulsi3
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-24
	sw	ra,20(sp)
	sw	s0,16(sp)
	addi	s0,sp,24
	li	a5,5
	sw	a5,-16(s0)
	li	a5,3
	sw	a5,-20(s0)
	lw	a1,-20(s0)
	lw	a0,-16(s0)
	call	__mulsi3
	mv	a5,a0
	sw	a5,-24(s0)
	li	a5,4096
	addi	a5,a5,-256
	lw	a4,-24(s0)
	sw	a4,0(a5)
	li	a5,0
	mv	a0,a5
	lw	ra,20(sp)
	lw	s0,16(sp)
	addi	sp,sp,24
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
