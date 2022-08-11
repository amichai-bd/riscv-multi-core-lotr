	.file	"McBubble.c"
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
	lw	a4,-20(s0)
	lw	a5,-40(s0)
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
	.word	12
	.word	2
	.word	0
	.word	6
	.word	10
	.word	18
	.word	100
	.word	4
	.align	2
.LC1:
	.word	6
	.word	1
	.word	0
	.word	3
	.word	5
	.word	9
	.word	50
	.word	2
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-80
	sw	ra,76(sp)
	sw	s0,72(sp)
	addi	s0,sp,80
	li	a5,12582912
	lw	a5,0(a5)
	sw	a5,-32(s0)
	sw	zero,-20(s0)
	lw	a5,-32(s0)
	addi	a5,a5,-4
	li	a4,7
	bgtu	a5,a4,.L9
	slli	a4,a5,2
	lui	a5,%hi(.L11)
	addi	a5,a5,%lo(.L11)
	add	a5,a4,a5
	lw	a5,0(a5)
	jr	a5
	.section	.rodata
	.align	2
	.align	2
.L11:
	.word	.L34
	.word	.L17
	.word	.L16
	.word	.L15
	.word	.L14
	.word	.L35
	.word	.L12
	.word	.L10
	.text
.L34:
	nop
.L19:
	lw	a5,-20(s0)
	addi	a4,a5,1
	sw	a4,-20(s0)
	li	a4,49
	ble	a5,a4,.L19
	li	a5,37752832
	addi	a5,a5,-1792
	sw	a5,-40(s0)
	li	a1,8
	lw	a0,-40(s0)
	call	bubbleSort
	nop
.L20:
	lw	a5,-20(s0)
	addi	a4,a5,1
	sw	a4,-20(s0)
	li	a4,49
	ble	a5,a4,.L20
	j	.L9
.L17:
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a7,0(a5)
	lw	a6,4(a5)
	lw	a0,8(a5)
	lw	a1,12(a5)
	lw	a2,16(a5)
	lw	a3,20(a5)
	lw	a4,24(a5)
	lw	a5,28(a5)
	sw	a7,-72(s0)
	sw	a6,-68(s0)
	sw	a0,-64(s0)
	sw	a1,-60(s0)
	sw	a2,-56(s0)
	sw	a3,-52(s0)
	sw	a4,-48(s0)
	sw	a5,-44(s0)
	sw	zero,-24(s0)
	j	.L21
.L22:
	lw	a5,-24(s0)
	slli	a4,a5,2
	li	a5,4198400
	addi	a5,a5,-1792
	add	a4,a4,a5
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a5,a5,-16
	add	a5,a5,s0
	lw	a5,-56(a5)
	sw	a5,0(a4)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L21:
	lw	a4,-24(s0)
	li	a5,7
	ble	a4,a5,.L22
.L23:
	j	.L23
.L16:
.L24:
	j	.L24
.L15:
.L25:
	j	.L25
.L14:
	lui	a5,%hi(.LC1)
	addi	a5,a5,%lo(.LC1)
	lw	a7,0(a5)
	lw	a6,4(a5)
	lw	a0,8(a5)
	lw	a1,12(a5)
	lw	a2,16(a5)
	lw	a3,20(a5)
	lw	a4,24(a5)
	lw	a5,28(a5)
	sw	a7,-72(s0)
	sw	a6,-68(s0)
	sw	a0,-64(s0)
	sw	a1,-60(s0)
	sw	a2,-56(s0)
	sw	a3,-52(s0)
	sw	a4,-48(s0)
	sw	a5,-44(s0)
	sw	zero,-28(s0)
	j	.L26
.L27:
	lw	a5,-28(s0)
	slli	a4,a5,2
	li	a5,4198400
	addi	a5,a5,-1792
	add	a4,a4,a5
	lw	a5,-28(s0)
	slli	a5,a5,2
	addi	a5,a5,-16
	add	a5,a5,s0
	lw	a5,-56(a5)
	sw	a5,0(a4)
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L26:
	lw	a4,-28(s0)
	li	a5,7
	ble	a4,a5,.L27
.L28:
	j	.L28
.L35:
	nop
.L29:
	lw	a5,-20(s0)
	addi	a4,a5,1
	sw	a4,-20(s0)
	li	a4,49
	ble	a5,a4,.L29
	li	a5,20975616
	addi	a5,a5,-1792
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	bubbleSort
.L30:
	j	.L30
.L12:
.L31:
	j	.L31
.L10:
.L32:
	j	.L32
.L9:
	li	a5,0
	mv	a0,a5
	lw	ra,76(sp)
	lw	s0,72(sp)
	addi	sp,sp,80
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
