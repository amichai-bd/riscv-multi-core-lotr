	.file	"AliveTest.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	ADDI
	.type	ADDI, @function
ADDI:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	li	a5,4198400
	addi	a5,a5,-256
	lw	a4,-20(s0)
	addi	a4,a4,1
	sw	a4,0(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	ADDI, .-ADDI
	.align	2
	.globl	SLTI
	.type	SLTI, @function
SLTI:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	slti	a5,a5,5
	andi	a4,a5,0xff
	li	a5,4198400
	addi	a5,a5,-252
	sw	a4,0(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	SLTI, .-SLTI
	.align	2
	.globl	ANDI
	.type	ANDI, @function
ANDI:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	li	a5,4198400
	addi	a5,a5,-248
	lw	a4,-20(s0)
	andi	a4,a4,6
	sw	a4,0(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	ANDI, .-ANDI
	.align	2
	.globl	ORI
	.type	ORI, @function
ORI:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	ori	a5,a5,26
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,30
	bne	a4,a5,.L6
	li	a5,4198400
	addi	a5,a5,-244
	li	a4,1
	sw	a4,0(a5)
.L6:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	ORI, .-ORI
	.align	2
	.globl	XORI
	.type	XORI, @function
XORI:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	li	a5,4198400
	addi	a5,a5,-240
	lw	a4,-20(s0)
	xori	a4,a4,42
	sw	a4,0(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	XORI, .-XORI
	.align	2
	.globl	SLLI
	.type	SLLI, @function
SLLI:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	slli	a5,a5,3
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,64
	bne	a4,a5,.L10
	li	a5,4198400
	addi	a5,a5,-236
	li	a4,1
	sw	a4,0(a5)
.L10:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	SLLI, .-SLLI
	.align	2
	.globl	SRLI
	.type	SRLI, @function
SRLI:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
 #APP
# 37 "AliveTest.c" 1
	lui a5,0x41;addi a5,a5,-512;lw a4,-20(s0);srli a4,a4,0xc;sw	a4,24(a5)
# 0 "" 2
 #NO_APP
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	SRLI, .-SRLI
	.align	2
	.globl	SRAI
	.type	SRAI, @function
SRAI:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	srai	a5,a5,3
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,-1024
	bne	a4,a5,.L14
	li	a5,4198400
	addi	a5,a5,-228
	li	a4,1
	sw	a4,0(a5)
.L14:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	SRAI, .-SRAI
	.align	2
	.globl	ADD
	.type	ADD, @function
ADD:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,579
	bne	a4,a5,.L17
	li	a5,4198400
	addi	a5,a5,-224
	li	a4,1
	sw	a4,0(a5)
.L17:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	ADD, .-ADD
	.align	2
	.globl	SLT
	.type	SLT, @function
SLT:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	slt	a5,a4,a5
	andi	a4,a5,0xff
	li	a5,4198400
	addi	a5,a5,-220
	sw	a4,0(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	SLT, .-SLT
	.align	2
	.globl	SLTU
	.type	SLTU, @function
SLTU:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	snez	a5,a5
	andi	a4,a5,0xff
	li	a5,4198400
	addi	a5,a5,-216
	sw	a4,0(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	SLTU, .-SLTU
	.align	2
	.globl	AND
	.type	AND, @function
AND:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	li	a5,4198400
	addi	a5,a5,-212
	lw	a3,-20(s0)
	lw	a4,-24(s0)
	and	a4,a3,a4
	sw	a4,0(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	AND, .-AND
	.align	2
	.globl	OR
	.type	OR, @function
OR:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	or	a5,a4,a5
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,4096
	addi	a5,a5,-298
	bne	a4,a5,.L23
	li	a5,4198400
	addi	a5,a5,-208
	li	a4,1
	sw	a4,0(a5)
.L23:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	OR, .-OR
	.align	2
	.globl	XOR
	.type	XOR, @function
XOR:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	li	a5,4198400
	addi	a5,a5,-204
	lw	a3,-20(s0)
	lw	a4,-24(s0)
	xor	a4,a3,a4
	sw	a4,0(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	XOR, .-XOR
	.align	2
	.globl	SLL
	.type	SLL, @function
SLL:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a5,-24(s0)
	lw	a4,-20(s0)
	sll	a5,a4,a5
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,32768
	bne	a4,a5,.L27
	li	a5,4198400
	addi	a5,a5,-200
	li	a4,1
	sw	a4,0(a5)
.L27:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	SLL, .-SLL
	.align	2
	.globl	SRL
	.type	SRL, @function
SRL:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
 #APP
# 85 "AliveTest.c" 1
	lui a5,0x41;addi a5,a5,-512;lw  a4,-24(s0);lw  a3,-20(s0);srl a4,a3,a4;sw  a4,60(a5);
# 0 "" 2
 #NO_APP
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	SRL, .-SRL
	.align	2
	.globl	SUB
	.type	SUB, @function
SUB:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	li	a5,4198400
	addi	a5,a5,-192
	lw	a3,-24(s0)
	lw	a4,-20(s0)
	sub	a4,a3,a4
	sw	a4,0(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	SUB, .-SUB
	.align	2
	.globl	SRA
	.type	SRA, @function
SRA:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a5,-24(s0)
	lw	a4,-20(s0)
	sra	a5,a4,a5
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,-1024
	bne	a4,a5,.L32
	li	a5,4198400
	addi	a5,a5,-188
	li	a4,1
	sw	a4,0(a5)
.L32:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	SRA, .-SRA
	.align	2
	.globl	BEQ
	.type	BEQ, @function
BEQ:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	beq	a4,a5,.L35
	li	a5,4198400
	addi	a5,a5,-184
	li	a4,1
	sw	a4,0(a5)
.L35:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	BEQ, .-BEQ
	.align	2
	.globl	BNE
	.type	BNE, @function
BNE:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	bne	a4,a5,.L38
	li	a5,4198400
	addi	a5,a5,-180
	li	a4,1
	sw	a4,0(a5)
.L38:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	BNE, .-BNE
	.align	2
	.globl	BLT
	.type	BLT, @function
BLT:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	blt	a4,a5,.L41
	li	a5,4198400
	addi	a5,a5,-176
	li	a4,1
	sw	a4,0(a5)
.L41:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	BLT, .-BLT
	.align	2
	.globl	BGE
	.type	BGE, @function
BGE:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	bge	a4,a5,.L44
	li	a5,4198400
	addi	a5,a5,-172
	li	a4,1
	sw	a4,0(a5)
.L44:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	BGE, .-BGE
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a0,0
	call	ADDI
	li	a0,1
	call	SLTI
	li	a0,1
	call	ANDI
	li	a0,12
	call	ORI
	li	a0,41
	call	XORI
	li	a0,8
	call	SLLI
	li	a0,4096
	call	SRLI
	li	a0,-4096
	call	SRAI
	li	a1,456
	li	a0,123
	call	ADD
	li	a1,171
	li	a0,85
	call	AND
	li	a5,4096
	addi	a1,a5,-442
	li	a0,1234
	call	OR
	li	a1,41
	li	a0,42
	call	XOR
	li	a1,3
	li	a0,4096
	call	SLL
	li	a1,12
	li	a0,4096
	call	SRL
	li	a1,122
	li	a0,123
	call	SUB
	li	a1,3
	li	a0,-4096
	call	SRA
	li	a1,9
	li	a0,5
	call	BEQ
	li	a1,42
	li	a0,42
	call	BNE
	li	a1,4
	li	a0,9
	call	BLT
	li	a1,7
	li	a0,1
	call	BGE
	nop
	mv	a0,a5
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
