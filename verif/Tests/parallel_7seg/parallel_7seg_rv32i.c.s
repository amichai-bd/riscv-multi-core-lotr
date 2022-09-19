	.file	"parallel_7seg.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	delay
	.type	delay, @function
delay:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	zero,-20(s0)
	j	.L2
.L3:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a4,-20(s0)
	li	a5,200704
	addi	a5,a5,-705
	ble	a4,a5,.L3
	nop
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	delay, .-delay
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-112
	sw	ra,108(sp)
	sw	s0,104(sp)
	addi	s0,sp,112
	li	a5,12582912
	lw	a5,0(a5)
	sw	a5,-24(s0)
	sw	zero,-28(s0)
	li	a5,1
	sw	a5,-32(s0)
	sw	zero,-20(s0)
	sw	zero,-36(s0)
	sw	zero,-40(s0)
	sw	zero,-44(s0)
	sw	zero,-48(s0)
	li	a5,64
	sw	a5,-112(s0)
	li	a5,121
	sw	a5,-108(s0)
	li	a5,36
	sw	a5,-104(s0)
	li	a5,48
	sw	a5,-100(s0)
	li	a5,25
	sw	a5,-96(s0)
	li	a5,18
	sw	a5,-92(s0)
	li	a5,2
	sw	a5,-88(s0)
	li	a5,120
	sw	a5,-84(s0)
	sw	zero,-80(s0)
	li	a5,24
	sw	a5,-76(s0)
	li	a5,8
	sw	a5,-72(s0)
	li	a5,3
	sw	a5,-68(s0)
	li	a5,70
	sw	a5,-64(s0)
	li	a5,33
	sw	a5,-60(s0)
	li	a5,6
	sw	a5,-56(s0)
	li	a5,14
	sw	a5,-52(s0)
	li	a5,127
	sw	a5,-48(s0)
	lw	a4,-24(s0)
	li	a5,5
	bne	a4,a5,.L5
.L7:
	call	delay
	lw	a5,-20(s0)
	addi	a4,a5,1
	sw	a4,-20(s0)
	li	a4,62922752
	addi	a4,a4,16
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-96(a5)
	sw	a5,0(a4)
	lw	a4,-20(s0)
	li	a5,16
	ble	a4,a5,.L7
	sw	zero,-20(s0)
	j	.L7
.L5:
	j	.L5
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
