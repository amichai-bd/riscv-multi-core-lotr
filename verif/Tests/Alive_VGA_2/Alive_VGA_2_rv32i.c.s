	.file	"Alive_VGA_2.c"
	.option nopic
	.text
	.align	2
	.globl	draw_hi
	.type	draw_hi, @function
draw_hi:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	addi	a5,a5,162
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,242
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,322
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,402
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,482
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,562
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,642
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,164
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,244
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,324
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,404
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,484
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,564
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,644
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,403
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,166
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,167
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,168
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,247
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,327
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,407
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,487
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,567
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,646
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,647
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,648
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,409
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,410
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	li	a5,0
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	draw_hi, .-draw_hi
	.align	2
	.globl	draw_i
	.type	draw_i, @function
draw_i:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	addi	a5,a5,166
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,167
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,168
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,247
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,327
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,407
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,487
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,567
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,646
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,647
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,648
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	li	a5,0
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	draw_i, .-draw_i
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
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
	li	a5,7
	beq	a4,a5,.L6
	lw	a4,-28(s0)
	li	a5,7
	bgt	a4,a5,.L7
	lw	a4,-28(s0)
	li	a5,6
	beq	a4,a5,.L8
	lw	a4,-28(s0)
	li	a5,6
	bgt	a4,a5,.L7
	lw	a4,-28(s0)
	li	a5,4
	beq	a4,a5,.L9
	lw	a4,-28(s0)
	li	a5,5
	beq	a4,a5,.L10
	j	.L7
.L9:
	sw	zero,-20(s0)
	j	.L11
.L12:
	lw	a5,-20(s0)
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a4,-20(s0)
	li	a5,4096
	addi	a5,a5,704
	add	a5,a4,a5
	slli	a4,a5,2
	li	a5,54525952
	addi	a5,a5,-320
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	slli	a4,a5,2
	li	a5,54562816
	addi	a5,a5,1216
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L11:
	lw	a4,-20(s0)
	li	a5,79
	ble	a4,a5,.L12
	sw	zero,-20(s0)
	j	.L13
.L14:
	lw	a4,-20(s0)
	mv	a5,a4
	slli	a5,a5,2
	add	a5,a5,a4
	slli	a5,a5,6
	mv	a4,a5
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a4,-20(s0)
	mv	a5,a4
	slli	a5,a5,2
	add	a5,a5,a4
	slli	a5,a5,6
	mv	a4,a5
	li	a5,54525952
	addi	a5,a5,156
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a4,-20(s0)
	mv	a5,a4
	slli	a5,a5,2
	add	a5,a5,a4
	slli	a5,a5,6
	mv	a4,a5
	li	a5,54525952
	addi	a5,a5,316
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L13:
	lw	a4,-20(s0)
	li	a5,119
	ble	a4,a5,.L14
	li	a0,0
	call	draw_hi
	li	a0,6
	call	draw_i
	li	a5,54525952
	addi	a4,a5,324
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,0(a4)
	sw	a4,0(a5)
	j	.L21
.L10:
	li	a0,40
	call	draw_hi
	li	a0,46
	call	draw_i
	li	a0,48
	call	draw_i
.L16:
	j	.L16
.L8:
	li	a5,4096
	addi	a0,a5,704
	call	draw_hi
	li	a5,4096
	addi	a0,a5,710
	call	draw_i
	li	a5,4096
	addi	a0,a5,712
	call	draw_i
	li	a5,4096
	addi	a0,a5,714
	call	draw_i
.L17:
	j	.L17
.L6:
	li	a5,4096
	addi	a0,a5,744
	call	draw_hi
	li	a5,4096
	addi	a0,a5,750
	call	draw_i
	li	a5,4096
	addi	a0,a5,752
	call	draw_i
	li	a5,4096
	addi	a0,a5,754
	call	draw_i
	li	a5,4096
	addi	a0,a5,756
	call	draw_i
.L18:
	j	.L18
.L7:
.L19:
	j	.L19
.L21:
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC x86_64) 10.2.0"