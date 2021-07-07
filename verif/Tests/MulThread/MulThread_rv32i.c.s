	.file	"MulThread.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	__mulsi3
	.align	2
	.globl	Thread0
	.type	Thread0, @function
Thread0:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,20
	sw	a5,-20(s0)
	li	a5,5
	sw	a5,-24(s0)
	lw	a1,-24(s0)
	lw	a0,-20(s0)
	call	__mulsi3
	mv	a5,a0
	sw	a5,-28(s0)
	lw	a5,-28(s0)
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	Thread0, .-Thread0
	.align	2
	.globl	Thread1
	.type	Thread1, @function
Thread1:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,8
	sw	a5,-20(s0)
	li	a5,25
	sw	a5,-24(s0)
	lw	a1,-24(s0)
	lw	a0,-20(s0)
	call	__mulsi3
	mv	a5,a0
	sw	a5,-28(s0)
	lw	a5,-28(s0)
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	Thread1, .-Thread1
	.align	2
	.globl	Thread2
	.type	Thread2, @function
Thread2:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,10
	sw	a5,-20(s0)
	li	a5,30
	sw	a5,-24(s0)
	lw	a1,-24(s0)
	lw	a0,-20(s0)
	call	__mulsi3
	mv	a5,a0
	sw	a5,-28(s0)
	lw	a5,-28(s0)
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	Thread2, .-Thread2
	.align	2
	.globl	Thread3
	.type	Thread3, @function
Thread3:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,100
	sw	a5,-20(s0)
	li	a5,4
	sw	a5,-24(s0)
	lw	a1,-24(s0)
	lw	a0,-20(s0)
	call	__mulsi3
	mv	a5,a0
	sw	a5,-28(s0)
	lw	a5,-28(s0)
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	Thread3, .-Thread3
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
	addi	a5,a5,4
	lw	a5,0(a5)
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,3
	beq	a4,a5,.L10
	lw	a4,-20(s0)
	li	a5,3
	bgt	a4,a5,.L11
	lw	a4,-20(s0)
	li	a5,2
	beq	a4,a5,.L12
	lw	a4,-20(s0)
	li	a5,2
	bgt	a4,a5,.L11
	lw	a5,-20(s0)
	beq	a5,zero,.L13
	lw	a4,-20(s0)
	li	a5,1
	beq	a4,a5,.L14
	j	.L11
.L13:
	li	a5,4198400
	addi	s1,a5,-256
	call	Thread0
	mv	a5,a0
	sw	a5,0(s1)
	j	.L11
.L14:
	li	a5,4198400
	addi	s1,a5,-252
	call	Thread1
	mv	a5,a0
	sw	a5,0(s1)
	j	.L11
.L12:
	li	a5,4198400
	addi	s1,a5,-248
	call	Thread2
	mv	a5,a0
	sw	a5,0(s1)
	j	.L11
.L10:
	li	a5,4198400
	addi	s1,a5,-244
	call	Thread3
	mv	a5,a0
	sw	a5,0(s1)
	nop
.L11:
	nop
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
