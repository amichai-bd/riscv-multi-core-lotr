	.file	"Matrix_Mul.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	__mulsi3
	.align	2
	.globl	multiply
	.type	multiply, @function
multiply:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s1,36(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	zero,-20(s0)
	j	.L2
.L7:
	sw	zero,-24(s0)
	j	.L3
.L6:
	lw	a4,-20(s0)
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	slli	a5,a5,2
	mv	a4,a5
	lw	a5,-44(s0)
	add	a4,a5,a4
	lw	a5,-24(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	sw	zero,0(a5)
	sw	zero,-28(s0)
	j	.L4
.L5:
	lw	a4,-20(s0)
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	slli	a5,a5,2
	mv	a4,a5
	lw	a5,-44(s0)
	add	a4,a5,a4
	lw	a5,-24(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	s1,0(a5)
	lw	a4,-20(s0)
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	slli	a5,a5,2
	mv	a4,a5
	lw	a5,-36(s0)
	add	a4,a5,a4
	lw	a5,-28(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a3,0(a5)
	lw	a4,-28(s0)
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	slli	a5,a5,2
	mv	a4,a5
	lw	a5,-40(s0)
	add	a4,a5,a4
	lw	a5,-24(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a5,0(a5)
	mv	a1,a5
	mv	a0,a3
	call	__mulsi3
	mv	a5,a0
	mv	a2,a5
	lw	a4,-20(s0)
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	slli	a5,a5,2
	mv	a4,a5
	lw	a5,-44(s0)
	add	a3,a5,a4
	add	a4,s1,a2
	lw	a5,-24(s0)
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L4:
	lw	a4,-28(s0)
	li	a5,2
	ble	a4,a5,.L5
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L3:
	lw	a4,-24(s0)
	li	a5,2
	ble	a4,a5,.L6
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a4,-20(s0)
	li	a5,2
	ble	a4,a5,.L7
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	addi	sp,sp,48
	jr	ra
	.size	multiply, .-multiply
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-144
	sw	ra,140(sp)
	sw	s0,136(sp)
	addi	s0,sp,144
	sw	zero,-28(s0)
	li	a5,1
	sw	a5,-64(s0)
	li	a5,2
	sw	a5,-60(s0)
	li	a5,3
	sw	a5,-56(s0)
	li	a5,4
	sw	a5,-52(s0)
	li	a5,5
	sw	a5,-48(s0)
	li	a5,6
	sw	a5,-44(s0)
	li	a5,7
	sw	a5,-40(s0)
	li	a5,8
	sw	a5,-36(s0)
	li	a5,9
	sw	a5,-32(s0)
	li	a5,9
	sw	a5,-100(s0)
	li	a5,8
	sw	a5,-96(s0)
	li	a5,7
	sw	a5,-92(s0)
	li	a5,6
	sw	a5,-88(s0)
	li	a5,5
	sw	a5,-84(s0)
	li	a5,4
	sw	a5,-80(s0)
	li	a5,3
	sw	a5,-76(s0)
	li	a5,2
	sw	a5,-72(s0)
	li	a5,1
	sw	a5,-68(s0)
	addi	a3,s0,-136
	addi	a4,s0,-100
	addi	a5,s0,-64
	mv	a2,a3
	mv	a1,a4
	mv	a0,a5
	call	multiply
	sw	zero,-20(s0)
	j	.L9
.L12:
	sw	zero,-24(s0)
	j	.L10
.L11:
	lw	a5,-28(s0)
	addi	a4,a5,1
	sw	a4,-28(s0)
	slli	a4,a5,2
	li	a5,4198400
	addi	a5,a5,-256
	add	a3,a4,a5
	lw	a4,-20(s0)
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	lw	a4,-24(s0)
	add	a5,a5,a4
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-120(a5)
	sw	a5,0(a3)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L10:
	lw	a4,-24(s0)
	li	a5,2
	ble	a4,a5,.L11
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L9:
	lw	a4,-20(s0)
	li	a5,2
	ble	a4,a5,.L12
	li	a5,0
	mv	a0,a5
	lw	ra,140(sp)
	lw	s0,136(sp)
	addi	sp,sp,144
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
