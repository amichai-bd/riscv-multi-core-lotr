	.file	"MC_Multitask.c"
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
	.align	2
	.globl	multiply
	.type	multiply, @function
multiply:
	addi	sp,sp,-64
	sw	s0,60(sp)
	addi	s0,sp,64
	sw	a0,-52(s0)
	sw	a1,-56(s0)
	sw	a2,-60(s0)
	lw	a5,-60(s0)
	li	a4,15
	sw	a4,0(a5)
	sw	zero,-20(s0)
	j	.L9
.L14:
	lw	a5,-60(s0)
	li	a4,14
	sw	a4,0(a5)
	sw	zero,-24(s0)
	j	.L10
.L13:
	lw	a5,-60(s0)
	li	a4,13
	sw	a4,0(a5)
	sw	zero,-32(s0)
	sw	zero,-28(s0)
	j	.L11
.L12:
	lw	a5,-60(s0)
	li	a4,12
	sw	a4,0(a5)
	lw	a5,-20(s0)
	slli	a4,a5,2
	lw	a5,-28(s0)
	add	a5,a4,a5
	slli	a5,a5,2
	lw	a4,-52(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	sw	a5,-36(s0)
	lw	a5,-60(s0)
	addi	a5,a5,4
	lw	a4,-36(s0)
	sw	a4,0(a5)
	lw	a5,-28(s0)
	slli	a4,a5,2
	lw	a5,-24(s0)
	add	a5,a4,a5
	slli	a5,a5,2
	lw	a4,-56(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	sw	a5,-40(s0)
	lw	a5,-60(s0)
	addi	a5,a5,8
	lw	a4,-40(s0)
	sw	a4,0(a5)
	lw	a4,-32(s0)
	lw	a5,-36(s0)
	add	a5,a4,a5
	lw	a4,-40(s0)
	add	a5,a4,a5
	sw	a5,-32(s0)
	lw	a5,-60(s0)
	li	a4,11
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L11:
	lw	a4,-28(s0)
	li	a5,3
	ble	a4,a5,.L12
	lw	a5,-60(s0)
	li	a4,10
	sw	a4,0(a5)
	lw	a5,-20(s0)
	slli	a4,a5,2
	lw	a5,-24(s0)
	add	a5,a4,a5
	slli	a5,a5,2
	lw	a4,-60(s0)
	add	a5,a4,a5
	lw	a4,-32(s0)
	sw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L10:
	lw	a4,-24(s0)
	li	a5,3
	ble	a4,a5,.L13
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L9:
	lw	a4,-20(s0)
	li	a5,3
	ble	a4,a5,.L14
	nop
	nop
	lw	s0,60(sp)
	addi	sp,sp,64
	jr	ra
	.size	multiply, .-multiply
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
	.align	2
.LC2:
	.word	13
	.word	14
	.word	15
	.word	16
	.word	9
	.word	10
	.word	11
	.word	12
	.word	5
	.word	6
	.word	7
	.word	8
	.word	1
	.word	2
	.word	3
	.word	4
	.align	2
.LC3:
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
	addi	sp,sp,-192
	sw	ra,188(sp)
	sw	s0,184(sp)
	addi	s0,sp,192
	li	a5,12582912
	lw	a5,0(a5)
	sw	a5,-36(s0)
	sw	zero,-20(s0)
	lw	a5,-36(s0)
	addi	a5,a5,-4
	li	a4,7
	bgtu	a5,a4,.L16
	slli	a4,a5,2
	lui	a5,%hi(.L18)
	addi	a5,a5,%lo(.L18)
	add	a5,a4,a5
	lw	a5,0(a5)
	jr	a5
	.section	.rodata
	.align	2
	.align	2
.L18:
	.word	.L43
	.word	.L24
	.word	.L23
	.word	.L22
	.word	.L21
	.word	.L44
	.word	.L45
	.word	.L17
	.text
.L43:
	nop
.L26:
	lw	a5,-20(s0)
	addi	a4,a5,1
	sw	a4,-20(s0)
	li	a4,49
	ble	a5,a4,.L26
	li	a5,37752832
	addi	a5,a5,-1792
	sw	a5,-60(s0)
	li	a1,8
	lw	a0,-60(s0)
	call	bubbleSort
.L27:
	j	.L27
.L24:
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
	sw	a7,-124(s0)
	sw	a6,-120(s0)
	sw	a0,-116(s0)
	sw	a1,-112(s0)
	sw	a2,-108(s0)
	sw	a3,-104(s0)
	sw	a4,-100(s0)
	sw	a5,-96(s0)
	sw	zero,-24(s0)
	j	.L28
.L29:
	lw	a5,-24(s0)
	slli	a4,a5,2
	li	a5,4198400
	addi	a5,a5,-1792
	add	a4,a4,a5
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-108(a5)
	sw	a5,0(a4)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L28:
	lw	a4,-24(s0)
	li	a5,7
	ble	a4,a5,.L29
.L30:
	j	.L30
.L23:
	sw	zero,-56(s0)
	lui	a5,%hi(.LC1)
	addi	a4,a5,%lo(.LC1)
	addi	a5,s0,-188
	mv	a3,a4
	li	a4,64
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	lui	a5,%hi(.LC2)
	addi	a4,a5,%lo(.LC2)
	addi	a5,s0,-124
	mv	a3,a4
	li	a4,64
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	sw	zero,-28(s0)
	j	.L31
.L32:
	lw	a5,-28(s0)
	slli	a4,a5,2
	li	a5,4198400
	addi	a5,a5,-1536
	add	a4,a4,a5
	lw	a5,-28(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-172(a5)
	sw	a5,0(a4)
	lw	a5,-28(s0)
	slli	a4,a5,2
	li	a5,4198400
	addi	a5,a5,-1280
	add	a4,a4,a5
	lw	a5,-28(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-108(a5)
	sw	a5,0(a4)
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L31:
	lw	a4,-28(s0)
	li	a5,15
	ble	a4,a5,.L32
.L33:
	j	.L33
.L22:
.L34:
	j	.L34
.L21:
	lui	a5,%hi(.LC3)
	addi	a5,a5,%lo(.LC3)
	lw	a7,0(a5)
	lw	a6,4(a5)
	lw	a0,8(a5)
	lw	a1,12(a5)
	lw	a2,16(a5)
	lw	a3,20(a5)
	lw	a4,24(a5)
	lw	a5,28(a5)
	sw	a7,-124(s0)
	sw	a6,-120(s0)
	sw	a0,-116(s0)
	sw	a1,-112(s0)
	sw	a2,-108(s0)
	sw	a3,-104(s0)
	sw	a4,-100(s0)
	sw	a5,-96(s0)
	sw	zero,-32(s0)
	j	.L35
.L36:
	lw	a5,-32(s0)
	slli	a4,a5,2
	li	a5,4198400
	addi	a5,a5,-1792
	add	a4,a4,a5
	lw	a5,-32(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-108(a5)
	sw	a5,0(a4)
	lw	a5,-32(s0)
	addi	a5,a5,1
	sw	a5,-32(s0)
.L35:
	lw	a4,-32(s0)
	li	a5,7
	ble	a4,a5,.L36
.L37:
	j	.L37
.L44:
	nop
.L38:
	lw	a5,-20(s0)
	addi	a4,a5,1
	sw	a4,-20(s0)
	li	a4,49
	ble	a5,a4,.L38
	li	a5,20975616
	addi	a5,a5,-1792
	sw	a5,-52(s0)
	li	a1,8
	lw	a0,-52(s0)
	call	bubbleSort
.L39:
	j	.L39
.L45:
	nop
.L40:
	lw	a5,-20(s0)
	addi	a4,a5,1
	sw	a4,-20(s0)
	li	a4,199
	ble	a5,a4,.L40
	li	a5,20975616
	addi	a5,a5,-1536
	sw	a5,-40(s0)
	li	a5,20975616
	addi	a5,a5,-1280
	sw	a5,-44(s0)
	li	a5,4198400
	addi	a5,a5,-1024
	sw	a5,-48(s0)
	lw	a2,-48(s0)
	lw	a1,-44(s0)
	lw	a0,-40(s0)
	call	multiply
	j	.L16
.L17:
.L41:
	j	.L41
.L16:
	li	a5,0
	mv	a0,a5
	lw	ra,188(sp)
	lw	s0,184(sp)
	addi	sp,sp,192
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
