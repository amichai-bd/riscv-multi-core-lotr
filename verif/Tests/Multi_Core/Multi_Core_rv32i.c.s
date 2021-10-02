	.file	"Multi_Core.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	li	a5,12582912
	addi	a5,a5,4
	lw	a5,0(a5)
	sw	a5,-20(s0)
	li	a5,9
	sw	a5,-24(s0)
	li	a5,8
	sw	a5,-28(s0)
	li	a5,7
	sw	a5,-32(s0)
	li	a5,19
	sw	a5,-36(s0)
	lw	a4,-20(s0)
	li	a5,3
	beq	a4,a5,.L2
	lw	a4,-20(s0)
	li	a5,3
	bgt	a4,a5,.L3
	lw	a4,-20(s0)
	li	a5,2
	beq	a4,a5,.L4
	lw	a4,-20(s0)
	li	a5,2
	bgt	a4,a5,.L3
	lw	a5,-20(s0)
	beq	a5,zero,.L5
	lw	a4,-20(s0)
	li	a5,1
	beq	a4,a5,.L6
	j	.L3
.L5:
	li	a5,12582912
	addi	a5,a5,8
	lw	a4,0(a5)
	li	a5,1
	bne	a4,a5,.L7
	lw	a4,-24(s0)
	lw	a5,-28(s0)
	add	a5,a4,a5
	sw	a5,-40(s0)
	li	a5,33554432
	addi	a5,a5,512
	lw	a4,-40(s0)
	sw	a4,0(a5)
	nop
.L8:
	li	a5,16777216
	addi	a5,a5,512
	lw	a5,0(a5)
	beq	a5,zero,.L8
	li	a5,16777216
	addi	a5,a5,512
	lw	a3,0(a5)
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-40(s0)
	add	a4,a3,a4
	sw	a4,0(a5)
	nop
.L9:
	li	a5,33554432
	addi	a5,a5,516
	lw	a4,0(a5)
	li	a5,1
	bne	a4,a5,.L9
	j	.L3
.L7:
	li	a5,12582912
	addi	a5,a5,8
	lw	a4,0(a5)
	li	a5,2
	bne	a4,a5,.L6
	lw	a4,-32(s0)
	lw	a5,-36(s0)
	add	a5,a4,a5
	sw	a5,-40(s0)
	li	a5,16777216
	addi	a5,a5,512
	lw	a4,-40(s0)
	sw	a4,0(a5)
	nop
.L10:
	li	a5,33554432
	addi	a5,a5,512
	lw	a5,0(a5)
	beq	a5,zero,.L10
	li	a5,33554432
	addi	a5,a5,512
	lw	a3,0(a5)
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-40(s0)
	add	a4,a3,a4
	sw	a4,0(a5)
	li	a5,16777216
	addi	a5,a5,516
	li	a4,1
	sw	a4,0(a5)
.L11:
	j	.L11
.L6:
	li	a5,12582912
	addi	a5,a5,340
	sw	zero,0(a5)
 #APP
# 65 "Multi_Core.c" 1
	nop;nop;
# 0 "" 2
 #NO_APP
	sw	a5,-40(s0)
	j	.L3
.L4:
	li	a5,12582912
	addi	a5,a5,344
	sw	zero,0(a5)
 #APP
# 70 "Multi_Core.c" 1
	nop;nop;
# 0 "" 2
 #NO_APP
	sw	a5,-40(s0)
	j	.L3
.L2:
	li	a5,12582912
	addi	a5,a5,348
	sw	zero,0(a5)
 #APP
# 75 "Multi_Core.c" 1
	nop;nop;
# 0 "" 2
 #NO_APP
	sw	a5,-40(s0)
	nop
.L3:
	nop
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
