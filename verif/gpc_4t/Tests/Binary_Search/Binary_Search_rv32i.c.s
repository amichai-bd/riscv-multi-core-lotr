	.file	"Binary_Search.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	binarySearch
	.type	binarySearch, @function
binarySearch:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	j	.L2
.L6:
	lw	a4,-44(s0)
	lw	a5,-40(s0)
	sub	a5,a4,a5
	srli	a4,a5,31
	add	a5,a4,a5
	srai	a5,a5,1
	mv	a4,a5
	lw	a5,-40(s0)
	add	a5,a5,a4
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	lw	a4,-48(s0)
	bne	a4,a5,.L3
	lw	a5,-20(s0)
	j	.L4
.L3:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	lw	a4,-48(s0)
	ble	a4,a5,.L5
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-40(s0)
	j	.L2
.L5:
	lw	a5,-20(s0)
	addi	a5,a5,-1
	sw	a5,-44(s0)
.L2:
	lw	a4,-40(s0)
	lw	a5,-44(s0)
	ble	a4,a5,.L6
	li	a5,-1
.L4:
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	binarySearch, .-binarySearch
	.section	.rodata
	.align	2
.LC0:
	.word	2
	.word	3
	.word	4
	.word	10
	.word	40
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a1,0(a5)
	lw	a2,4(a5)
	lw	a3,8(a5)
	lw	a4,12(a5)
	lw	a5,16(a5)
	sw	a1,-48(s0)
	sw	a2,-44(s0)
	sw	a3,-40(s0)
	sw	a4,-36(s0)
	sw	a5,-32(s0)
	li	a5,6
	sw	a5,-20(s0)
	li	a5,10
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	addi	a4,a5,-1
	addi	a5,s0,-48
	lw	a3,-24(s0)
	mv	a2,a4
	li	a1,0
	mv	a0,a5
	call	binarySearch
	sw	a0,-28(s0)
	lw	a4,-28(s0)
	li	a5,-1
	bne	a4,a5,.L8
	li	a5,4198400
	addi	a5,a5,-256
	sw	zero,0(a5)
	j	.L9
.L8:
	li	a5,4198400
	addi	a5,a5,-256
	li	a4,1
	sw	a4,0(a5)
.L9:
	li	a5,0
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
