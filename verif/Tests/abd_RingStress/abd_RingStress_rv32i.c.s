	.file	"abd_RingStress.c"
	.option nopic
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
	.section	.rodata
	.align	2
.LC0:
	.word	3
	.word	2
	.word	1
	.word	4
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	li	a5,12582912
	addi	a5,a5,4
	lw	a5,0(a5)
	sw	a5,-28(s0)
	li	a5,12582912
	addi	a5,a5,8
	lw	a5,0(a5)
	sw	a5,-32(s0)
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a2,0(a5)
	lw	a3,4(a5)
	lw	a4,8(a5)
	lw	a5,12(a5)
	sw	a2,-48(s0)
	sw	a3,-44(s0)
	sw	a4,-40(s0)
	sw	a5,-36(s0)
	lw	a5,-28(s0)
	bne	a5,zero,.L9
	li	a5,12582912
	addi	a5,a5,8
	lw	a4,0(a5)
	li	a5,1
	bne	a4,a5,.L10
	sw	zero,-20(s0)
	j	.L11
.L12:
	lw	a5,-20(s0)
	slli	a4,a5,2
	li	a5,46137344
	addi	a5,a5,512
	add	a4,a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-32(a5)
	sw	a5,0(a4)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L11:
	lw	a4,-20(s0)
	li	a5,3
	ble	a4,a5,.L12
	li	a1,4
	li	a5,46137344
	addi	a0,a5,512
	call	bubbleSort
	sw	zero,-24(s0)
	j	.L13
.L14:
	lw	a5,-24(s0)
	slli	a4,a5,2
	li	a5,37752832
	addi	a5,a5,-256
	add	a4,a4,a5
	lw	a5,-24(s0)
	slli	a3,a5,2
	li	a5,29360128
	addi	a5,a5,512
	add	a5,a3,a5
	lw	a4,0(a4)
	sw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L13:
	lw	a4,-24(s0)
	li	a5,3
	ble	a4,a5,.L14
.L15:
	j	.L15
.L10:
	li	a5,12582912
	addi	a5,a5,8
	lw	a4,0(a5)
	li	a5,2
	bne	a4,a5,.L9
	li	a5,12582912
	addi	a5,a5,340
	sw	zero,0(a5)
.L16:
	j	.L16
.L9:
	lw	a5,-28(s0)
	slli	a4,a5,2
	li	a5,12582912
	addi	a5,a5,336
	add	a5,a4,a5
	sw	zero,0(a5)
.L17:
	j	.L17
	.size	main, .-main
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC, 64-bit) 10.1.0"
