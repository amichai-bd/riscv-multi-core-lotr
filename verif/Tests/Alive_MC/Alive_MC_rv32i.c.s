	.file	"Alive_MC.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	li	a5,12582912
	addi	a5,a5,4
	lw	a5,0(a5)
	sw	a5,-24(s0)
	li	a5,12582912
	lw	a5,0(a5)
	sw	a5,-28(s0)
	sw	zero,-20(s0)
	lw	a5,-28(s0)
	addi	a5,a5,-4
	li	a4,7
	bgtu	a5,a4,.L2
	slli	a4,a5,2
	lui	a5,%hi(.L4)
	addi	a5,a5,%lo(.L4)
	add	a5,a4,a5
	lw	a5,0(a5)
	jr	a5
	.section	.rodata
	.align	2
	.align	2
.L4:
	.word	.L11
	.word	.L10
	.word	.L9
	.word	.L8
	.word	.L7
	.word	.L6
	.word	.L5
	.word	.L3
	.text
.L11:
	li	a5,37752832
	addi	a5,a5,-1792
	li	a4,81
	sw	a4,0(a5)
	nop
.L12:
	lw	a5,-20(s0)
	addi	a4,a5,1
	sw	a4,-20(s0)
	li	a4,9
	ble	a5,a4,.L12
	li	a5,37752832
	addi	a4,a5,-1792
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,0(a4)
	sw	a4,0(a5)
	j	.L2
.L10:
.L13:
	j	.L13
.L9:
.L14:
	j	.L14
.L8:
.L15:
	j	.L15
.L7:
.L16:
	j	.L16
.L6:
.L17:
	j	.L17
.L5:
.L18:
	j	.L18
.L3:
.L19:
	j	.L19
.L2:
	li	a5,0
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
