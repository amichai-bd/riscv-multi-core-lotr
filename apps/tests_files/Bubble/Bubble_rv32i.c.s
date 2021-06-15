	.file	"Bubble.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	swap
	.type	swap, @function
swap:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-36(s0)
	lw	a5,0(a5)
	sw	a5,-20(s0)
	lw	a5,-40(s0)
	lw	a4,0(a5)
	lw	a5,-36(s0)
	sw	a4,0(a5)
	lw	a5,-40(s0)
	lw	a4,-20(s0)
	sw	a4,0(a5)
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	swap, .-swap
	.align	2
	.globl	bubbleSort
	.type	bubbleSort, @function
bubbleSort:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	zero,-20(s0)
	j	.L3
.L7:
	sw	zero,-24(s0)
	j	.L4
.L6:
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a3,-36(s0)
	add	a5,a3,a5
	lw	a5,0(a5)
	ble	a4,a5,.L5
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a3,a4,a5
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	mv	a1,a5
	mv	a0,a3
	call	swap
.L5:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L4:
	lw	a4,-40(s0)
	lw	a5,-20(s0)
	sub	a5,a4,a5
	addi	a5,a5,-1
	lw	a4,-24(s0)
	blt	a4,a5,.L6
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L3:
	lw	a5,-40(s0)
	addi	a5,a5,-1
	lw	a4,-20(s0)
	blt	a4,a5,.L7
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	bubbleSort, .-bubbleSort
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	li	a5,6
	sw	a5,-48(s0)
	li	a5,1
	sw	a5,-44(s0)
	sw	zero,-40(s0)
	li	a5,3
	sw	a5,-36(s0)
	li	a5,5
	sw	a5,-32(s0)
	li	a5,9
	sw	a5,-28(s0)
	li	a5,50
	sw	a5,-24(s0)
	li	a5,2
	sw	a5,-20(s0)
	addi	a5,s0,-48
	li	a1,8
	mv	a0,a5
	call	bubbleSort
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-48(s0)
	sw	a4,0(a5)
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-44(s0)
	sw	a4,4(a5)
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-40(s0)
	sw	a4,8(a5)
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-36(s0)
	sw	a4,12(a5)
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-32(s0)
	sw	a4,16(a5)
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-28(s0)
	sw	a4,20(a5)
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-24(s0)
	sw	a4,24(a5)
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-20(s0)
	sw	a4,28(a5)
	li	a5,4198400
	addi	a5,a5,-256
	li	a4,1
	sw	a4,252(a5)
	li	a5,0
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
