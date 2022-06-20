	.file	"led_blinky.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-80
	sw	s0,76(sp)
	addi	s0,sp,80
	li	a5,12582912
	lw	a5,0(a5)
	sw	a5,-48(s0)
	li	a5,1
	sw	a5,-20(s0)
	sw	zero,-24(s0)
	li	a5,1023
	sw	a5,-28(s0)
	sw	zero,-52(s0)
	sw	zero,-32(s0)
	li	a5,1
	sw	a5,-36(s0)
	li	a5,512
	sw	a5,-40(s0)
	sw	zero,-44(s0)
	li	a5,126
	sw	a5,-76(s0)
	li	a5,125
	sw	a5,-72(s0)
	li	a5,123
	sw	a5,-68(s0)
	li	a5,119
	sw	a5,-64(s0)
	li	a5,111
	sw	a5,-60(s0)
	li	a5,95
	sw	a5,-56(s0)
	lw	a4,-48(s0)
	li	a5,4
	beq	a4,a5,.L2
	lw	a4,-48(s0)
	li	a5,8
	beq	a4,a5,.L30
	j	.L4
.L2:
	li	a5,50339840
	addi	a5,a5,36
	lw	a5,0(a5)
	bne	a5,zero,.L5
	li	a5,1
	sw	a5,-20(s0)
	li	a5,1023
	sw	a5,-28(s0)
	sw	zero,-52(s0)
	li	a5,1
	sw	a5,-36(s0)
	li	a5,512
	sw	a5,-40(s0)
	j	.L6
.L7:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L6:
	lw	a4,-24(s0)
	li	a5,1665
	ble	a4,a5,.L7
	li	a5,50339840
	addi	a5,a5,24
	lw	a4,-32(s0)
	sw	a4,0(a5)
	lw	a4,-32(s0)
	li	a5,1023
	bne	a4,a5,.L8
	sw	zero,-32(s0)
	j	.L9
.L8:
	li	a5,1023
	sw	a5,-32(s0)
.L9:
	sw	zero,-24(s0)
	j	.L2
.L5:
	li	a5,50339840
	addi	a5,a5,36
	lw	a4,0(a5)
	li	a5,1
	bne	a4,a5,.L11
	li	a5,1023
	sw	a5,-28(s0)
	sw	zero,-52(s0)
	sw	zero,-32(s0)
	li	a5,1
	sw	a5,-36(s0)
	li	a5,512
	sw	a5,-40(s0)
	j	.L12
.L13:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L12:
	lw	a4,-24(s0)
	li	a5,1665
	ble	a4,a5,.L13
	li	a5,50339840
	addi	a5,a5,24
	lw	a4,-20(s0)
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,1023
	bne	a4,a5,.L14
	li	a5,1
	sw	a5,-20(s0)
.L14:
	sw	zero,-24(s0)
	j	.L2
.L11:
	li	a5,50339840
	addi	a5,a5,36
	lw	a4,0(a5)
	li	a5,2
	bne	a4,a5,.L15
	li	a5,1
	sw	a5,-20(s0)
	li	a5,1023
	sw	a5,-28(s0)
	sw	zero,-52(s0)
	sw	zero,-32(s0)
	li	a5,512
	sw	a5,-40(s0)
	j	.L16
.L17:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L16:
	lw	a4,-24(s0)
	li	a5,1665
	ble	a4,a5,.L17
	li	a5,50339840
	addi	a5,a5,24
	lw	a4,-36(s0)
	sw	a4,0(a5)
	lw	a5,-36(s0)
	slli	a5,a5,1
	sw	a5,-36(s0)
	lw	a4,-36(s0)
	li	a5,512
	ble	a4,a5,.L18
	li	a5,1
	sw	a5,-36(s0)
.L18:
	sw	zero,-24(s0)
	j	.L2
.L15:
	li	a5,50339840
	addi	a5,a5,36
	lw	a4,0(a5)
	li	a5,3
	bne	a4,a5,.L19
	li	a5,1
	sw	a5,-20(s0)
	sw	zero,-52(s0)
	sw	zero,-32(s0)
	li	a5,1
	sw	a5,-36(s0)
	li	a5,512
	sw	a5,-40(s0)
	j	.L20
.L21:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L20:
	lw	a4,-24(s0)
	li	a5,1665
	ble	a4,a5,.L21
	li	a5,50339840
	addi	a5,a5,24
	lw	a4,-28(s0)
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,-1
	sw	a5,-28(s0)
	lw	a5,-28(s0)
	bne	a5,zero,.L22
	li	a5,1023
	sw	a5,-28(s0)
.L22:
	sw	zero,-24(s0)
	j	.L2
.L19:
	li	a5,50339840
	addi	a5,a5,36
	lw	a4,0(a5)
	li	a5,4
	bne	a4,a5,.L23
	li	a5,1
	sw	a5,-20(s0)
	li	a5,1023
	sw	a5,-28(s0)
	sw	zero,-52(s0)
	sw	zero,-32(s0)
	li	a5,1
	sw	a5,-36(s0)
	j	.L24
.L25:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L24:
	lw	a4,-24(s0)
	li	a5,1665
	ble	a4,a5,.L25
	li	a5,50339840
	addi	a5,a5,24
	lw	a4,-40(s0)
	sw	a4,0(a5)
	lw	a5,-40(s0)
	srli	a4,a5,31
	add	a5,a4,a5
	srai	a5,a5,1
	sw	a5,-40(s0)
	lw	a5,-40(s0)
	bne	a5,zero,.L26
	li	a5,512
	sw	a5,-40(s0)
.L26:
	sw	zero,-24(s0)
	j	.L2
.L23:
	li	a5,50339840
	addi	a5,a5,36
	lw	a4,0(a5)
	li	a5,5
	bne	a4,a5,.L2
	li	a5,1
	sw	a5,-20(s0)
	li	a5,1023
	sw	a5,-28(s0)
	sw	zero,-32(s0)
	li	a5,1
	sw	a5,-36(s0)
	li	a5,512
	sw	a5,-40(s0)
	j	.L27
.L28:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L27:
	lw	a4,-24(s0)
	li	a5,499
	ble	a4,a5,.L28
	lw	a5,-44(s0)
	addi	a4,a5,1
	sw	a4,-44(s0)
	li	a4,50339840
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-60(a5)
	sw	a5,0(a4)
	lw	a4,-44(s0)
	li	a5,5
	ble	a4,a5,.L29
	sw	zero,-44(s0)
.L29:
	sw	zero,-24(s0)
	j	.L2
.L31:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L30:
	lw	a4,-24(s0)
	li	a5,249
	ble	a4,a5,.L31
	li	a5,50339840
	addi	a4,a5,4
	lw	a5,-44(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-60(a5)
	sw	a5,0(a4)
	li	a5,50339840
	addi	a4,a5,8
	lw	a5,-44(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-60(a5)
	sw	a5,0(a4)
	li	a5,50339840
	addi	a4,a5,12
	lw	a5,-44(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-60(a5)
	sw	a5,0(a4)
	lw	a5,-44(s0)
	addi	a5,a5,1
	sw	a5,-44(s0)
	lw	a4,-44(s0)
	li	a5,5
	ble	a4,a5,.L32
	sw	zero,-44(s0)
.L32:
	sw	zero,-24(s0)
	j	.L30
.L4:
	j	.L4
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
