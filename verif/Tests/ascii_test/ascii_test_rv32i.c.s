	.file	"ascii_test.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	ASCII_TOP
	.data
	.align	2
	.type	ASCII_TOP, @object
	.size	ASCII_TOP, 388
ASCII_TOP:
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	1382169600
	.word	438048768
	.word	1078082560
	.word	1078082560
	.word	606613504
	.word	1040350720
	.word	37895168
	.word	809532928
	.word	1111636992
	.word	1111636992
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	1715214336
	.word	1042423296
	.word	37633024
	.word	574496256
	.word	101088768
	.word	101088768
	.word	37633024
	.word	1717986816
	.word	404258304
	.word	1616928768
	.word	1046889984
	.word	101058048
	.word	1516651008
	.word	1852203520
	.word	1717976064
	.word	1717976576
	.word	1111636992
	.word	1717976576
	.word	503741440
	.word	404258304
	.word	1717986816
	.word	1717986816
	.word	1111638528
	.word	1013343744
	.word	1013343744
	.word	270564864
	.zero	24
	.globl	ASCII_BOTTOM
	.align	2
	.type	ASCII_BOTTOM, @object
	.size	ASCII_BOTTOM, 388
ASCII_BOTTOM:
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	102635544
	.word	0
	.word	1579008
	.word	0
	.word	3950154
	.word	8263704
	.word	8258108
	.word	3949112
	.word	2105470
	.word	3949120
	.word	3949118
	.word	526344
	.word	3949116
	.word	4079740
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	6717030
	.word	1974846
	.word	3948034
	.word	1981986
	.word	8259198
	.word	394878
	.word	3940922
	.word	6710910
	.word	8263704
	.word	8152678
	.word	4613694
	.word	8259078
	.word	4342362
	.word	4613750
	.word	3958374
	.word	394814
	.word	8151634
	.word	6710846
	.word	4087928
	.word	1579032
	.word	3964518
	.word	1588326
	.word	4357722
	.word	6710844
	.word	1579032
	.word	8258568
	.zero	24
	.text
	.align	2
	.globl	draw_char
	.type	draw_char, @function
draw_char:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	mv	a5,a0
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sb	a5,-33(s0)
	lw	a4,-40(s0)
	mv	a5,a4
	slli	a5,a5,2
	add	a5,a5,a4
	slli	a5,a5,6
	sw	a5,-20(s0)
	lw	a5,-44(s0)
	slli	a5,a5,2
	sw	a5,-24(s0)
	lw	a4,-24(s0)
	lw	a5,-20(s0)
	add	a4,a4,a5
	li	a5,54525952
	add	a5,a4,a5
	sw	a5,-28(s0)
	lw	a4,-24(s0)
	lw	a5,-20(s0)
	add	a4,a4,a5
	li	a5,54525952
	addi	a5,a5,320
	add	a5,a4,a5
	sw	a5,-32(s0)
	lbu	a5,-33(s0)
	lui	a4,%hi(ASCII_TOP)
	addi	a4,a4,%lo(ASCII_TOP)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a5,0(a5)
	mv	a4,a5
	lw	a5,-28(s0)
	sw	a4,0(a5)
	lbu	a5,-33(s0)
	lui	a4,%hi(ASCII_BOTTOM)
	addi	a4,a4,%lo(ASCII_BOTTOM)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a5,0(a5)
	mv	a4,a5
	lw	a5,-32(s0)
	sw	a4,0(a5)
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	draw_char, .-draw_char
	.align	2
	.globl	rvc_printf
	.type	rvc_printf, @function
rvc_printf:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	zero,-20(s0)
	sw	zero,-24(s0)
	sw	zero,-28(s0)
	li	a5,12582912
	addi	a5,a5,512
	lw	a5,0(a5)
	sw	a5,-28(s0)
	li	a5,12582912
	addi	a5,a5,516
	lw	a5,0(a5)
	sw	a5,-24(s0)
	j	.L3
.L7:
	lw	a5,-20(s0)
	lw	a4,-36(s0)
	add	a5,a4,a5
	lbu	a4,0(a5)
	li	a5,10
	bne	a4,a5,.L4
	sw	zero,-28(s0)
	lw	a5,-24(s0)
	addi	a5,a5,2
	sw	a5,-24(s0)
	lw	a4,-24(s0)
	li	a5,120
	bne	a4,a5,.L5
	sw	zero,-24(s0)
.L5:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
	j	.L3
.L4:
	lw	a5,-20(s0)
	lw	a4,-36(s0)
	add	a5,a4,a5
	lbu	a5,0(a5)
	lw	a4,-24(s0)
	lw	a3,-28(s0)
	mv	a2,a3
	mv	a1,a4
	mv	a0,a5
	call	draw_char
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
	lw	a4,-28(s0)
	li	a5,80
	bne	a4,a5,.L6
	sw	zero,-28(s0)
	lw	a5,-24(s0)
	addi	a5,a5,2
	sw	a5,-24(s0)
	lw	a4,-24(s0)
	li	a5,120
	bne	a4,a5,.L6
	sw	zero,-24(s0)
.L6:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L3:
	lw	a5,-20(s0)
	lw	a4,-36(s0)
	add	a5,a4,a5
	lbu	a5,0(a5)
	bne	a5,zero,.L7
	li	a5,12582912
	addi	a5,a5,512
	lw	a4,-28(s0)
	sw	a4,0(a5)
	li	a5,12582912
	addi	a5,a5,516
	lw	a4,-24(s0)
	sw	a4,0(a5)
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	rvc_printf, .-rvc_printf
	.section	.rodata
	.align	2
.LC0:
	.string	"WE ARE THE PEOPLE THAT RULE THE WORLD.\n"
	.align	2
.LC1:
	.string	"A FORCE RUNNING IN EVERY BOY AND GIRL.\n"
	.align	2
.LC2:
	.string	"ALL REJOICING IN THE WORLD, TAKE ME NOW WE CAN TRY.\n"
	.align	2
.LC3:
	.string	"0123456789\n"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,12582912
	lw	a5,0(a5)
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,4
	bne	a4,a5,.L9
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	rvc_printf
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	rvc_printf
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	rvc_printf
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	rvc_printf
.L9:
.L10:
	j	.L10
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
