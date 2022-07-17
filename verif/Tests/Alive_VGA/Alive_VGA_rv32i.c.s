	.file	"Alive_VGA.c"
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
	sw	zero,-32(s0)
	lw	a4,-28(s0)
	li	a5,4
	bne	a4,a5,.L2
	sw	zero,-20(s0)
	j	.L3
.L4:
	lw	a4,-20(s0)
	li	a5,4096
	addi	a5,a5,-1024
	add	a3,a4,a5
	lw	a4,-20(s0)
	mv	a5,a4
	slli	a5,a5,2
	add	a5,a5,a4
	slli	a5,a5,4
	add	a5,a3,a5
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L3:
	lw	a4,-20(s0)
	li	a5,119
	ble	a4,a5,.L4
	li	a5,54525952
	addi	a4,a5,324
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,0(a4)
	sw	a4,0(a5)
	j	.L7
.L2:
	j	.L2
.L7:
	li	a5,0
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
