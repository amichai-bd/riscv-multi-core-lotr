	.file	"Factorial.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	factorial
	.type	factorial, @function
factorial:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lw	a4,-36(s0)
	li	a5,1
	bne	a4,a5,.L2
	li	a5,1
	j	.L3
.L2:
	lw	a5,-36(s0)
	addi	a5,a5,-1
	mv	a0,a5
	call	factorial
	mv	a4,a0
	lw	a5,-36(s0)
	add	a5,a5,a4
	sw	a5,-20(s0)
	lw	a5,-20(s0)
.L3:
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	factorial, .-factorial
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a0,4
	call	factorial
	sw	a0,-20(s0)
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-20(s0)
	sw	a4,0(a5)
	nop
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
