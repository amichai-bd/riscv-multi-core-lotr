	.file	"fpga_main.c"
	.option nopic
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
	.globl	ANIME_TOP
	.align	2
	.type	ANIME_TOP, @object
	.size	ANIME_TOP, 24
ANIME_TOP:
	.word	2084048944
	.word	943198256
	.word	943198256
	.word	2084048944
	.word	943198256
	.word	0
	.globl	ANIME_BOTTOM
	.align	2
	.type	ANIME_BOTTOM, @object
	.size	ANIME_BOTTOM, 24
ANIME_BOTTOM:
	.word	-2105259846
	.word	1145613432
	.word	271067256
	.word	672151738
	.word	1212692604
	.word	0
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
	addi	a5,a5,544
	lw	a5,0(a5)
	sw	a5,-28(s0)
	li	a5,12582912
	addi	a5,a5,564
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
	addi	a5,a5,544
	lw	a4,-28(s0)
	sw	a4,0(a5)
	li	a5,12582912
	addi	a5,a5,564
	lw	a4,-24(s0)
	sw	a4,0(a5)
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	rvc_printf, .-rvc_printf
	.align	2
	.globl	draw_symbol
	.type	draw_symbol, @function
draw_symbol:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
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
	lui	a5,%hi(ANIME_TOP)
	addi	a4,a5,%lo(ANIME_TOP)
	lw	a5,-36(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a5,0(a5)
	mv	a4,a5
	lw	a5,-28(s0)
	sw	a4,0(a5)
	lui	a5,%hi(ANIME_BOTTOM)
	addi	a4,a5,%lo(ANIME_BOTTOM)
	lw	a5,-36(s0)
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
	.size	draw_symbol, .-draw_symbol
	.align	2
	.globl	set_cursor
	.type	set_cursor, @function
set_cursor:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	li	a5,12582912
	addi	a5,a5,544
	lw	a4,-24(s0)
	sw	a4,0(a5)
	li	a5,12582912
	addi	a5,a5,564
	lw	a4,-20(s0)
	sw	a4,0(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	set_cursor, .-set_cursor
	.align	2
	.globl	clear_screen
	.type	clear_screen, @function
clear_screen:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	zero,-20(s0)
	li	a5,54525952
	sw	a5,-24(s0)
	sw	zero,-20(s0)
	j	.L11
.L12:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-24(s0)
	add	a5,a4,a5
	sw	zero,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L11:
	lw	a4,-20(s0)
	li	a5,8192
	addi	a5,a5,1407
	ble	a4,a5,.L12
	nop
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	clear_screen, .-clear_screen
	.align	2
	.globl	delay
	.type	delay, @function
delay:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	zero,-20(s0)
	j	.L14
.L15:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L14:
	lw	a4,-20(s0)
	li	a5,81920
	addi	a5,a5,-1921
	ble	a4,a5,.L15
	nop
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	delay, .-delay
	.align	2
	.globl	draw_stick
	.type	draw_stick, @function
draw_stick:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	lw	a5,-40(s0)
	addi	a5,a5,321
	slli	a5,a5,1
	lw	a4,-44(s0)
	add	a5,a4,a5
	sw	a5,-28(s0)
	lw	a4,-36(s0)
	mv	a5,a4
	slli	a5,a5,2
	add	a5,a5,a4
	slli	a5,a5,4
	addi	a5,a5,1
	sw	a5,-32(s0)
	sw	zero,-20(s0)
	j	.L17
.L18:
	lw	a4,-28(s0)
	lw	a5,-20(s0)
	sub	a4,a4,a5
	lw	a5,-48(s0)
	add	a5,a4,a5
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	sw	zero,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,80
	sw	a5,-20(s0)
.L17:
	lw	a4,-20(s0)
	li	a5,1600
	ble	a4,a5,.L18
	sw	zero,-24(s0)
	j	.L19
.L20:
	lw	a4,-28(s0)
	lw	a5,-24(s0)
	sub	a4,a4,a5
	lw	a5,-48(s0)
	add	a5,a4,a5
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,80
	sw	a5,-24(s0)
.L19:
	lw	a4,-24(s0)
	lw	a5,-32(s0)
	blt	a4,a5,.L20
	nop
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	draw_stick, .-draw_stick
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
	lw	a5,-40(s0)
	lw	a4,-20(s0)
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
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	sw	zero,-20(s0)
	j	.L23
.L27:
	sw	zero,-24(s0)
	j	.L24
.L26:
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
	ble	a4,a5,.L25
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
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	lw	a3,-48(s0)
	lw	a2,-44(s0)
	lw	a1,-24(s0)
	mv	a0,a5
	call	draw_stick
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	lw	a3,-48(s0)
	lw	a2,-44(s0)
	mv	a1,a5
	mv	a0,a4
	call	draw_stick
	call	delay
.L25:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L24:
	lw	a4,-40(s0)
	lw	a5,-20(s0)
	sub	a5,a4,a5
	addi	a5,a5,-1
	lw	a4,-24(s0)
	blt	a4,a5,.L26
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L23:
	lw	a5,-40(s0)
	addi	a5,a5,-1
	lw	a4,-20(s0)
	blt	a4,a5,.L27
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	bubbleSort, .-bubbleSort
	.align	2
	.globl	insertionSort
	.type	insertionSort, @function
insertionSort:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	li	a5,1
	sw	a5,-20(s0)
	j	.L29
.L33:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	sw	a5,-28(s0)
	lw	a5,-20(s0)
	addi	a5,a5,-1
	sw	a5,-24(s0)
	j	.L30
.L32:
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a4,a4,a5
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a3,-36(s0)
	add	a5,a3,a5
	lw	a4,0(a4)
	sw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	lw	a3,-48(s0)
	lw	a2,-44(s0)
	mv	a1,a5
	mv	a0,a4
	call	draw_stick
	call	delay
	lw	a5,-24(s0)
	addi	a5,a5,-1
	sw	a5,-24(s0)
.L30:
	lw	a5,-24(s0)
	blt	a5,zero,.L31
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	lw	a4,-28(s0)
	blt	a4,a5,.L32
.L31:
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,-28(s0)
	sw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	lw	a3,-48(s0)
	lw	a2,-44(s0)
	mv	a1,a5
	mv	a0,a4
	call	draw_stick
	call	delay
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L29:
	lw	a4,-20(s0)
	lw	a5,-40(s0)
	blt	a4,a5,.L33
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	insertionSort, .-insertionSort
	.section	.rodata
	.align	2
.LC4:
	.string	"WELCOME TO THE LOTR FPGA\n"
	.align	2
.LC5:
	.string	"A DUAL CORE 8 THREAD FABRIC .\n"
	.align	2
.LC6:
	.string	"PLEASE USE SWITCHES TO SELECT\n"
	.align	2
.LC7:
	.string	"001 : SYSTEM INFORMATION\n"
	.align	2
.LC8:
	.string	"010 : LED SHOW\n"
	.align	2
.LC9:
	.string	"100 : GRAPHIC SORTING\n"
	.align	2
.LC10:
	.string	"101 : SNAKE GAME\n"
	.text
	.align	2
	.globl	show_menu
	.type	show_menu, @function
show_menu:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a1,1
	li	a0,1
	call	set_cursor
	lui	a5,%hi(.LC4)
	addi	a0,a5,%lo(.LC4)
	call	rvc_printf
	li	a1,1
	li	a0,10
	call	set_cursor
	lui	a5,%hi(.LC5)
	addi	a0,a5,%lo(.LC5)
	call	rvc_printf
	li	a1,20
	li	a0,20
	call	set_cursor
	lui	a5,%hi(.LC6)
	addi	a0,a5,%lo(.LC6)
	call	rvc_printf
	li	a1,20
	li	a0,40
	call	set_cursor
	lui	a5,%hi(.LC7)
	addi	a0,a5,%lo(.LC7)
	call	rvc_printf
	li	a1,20
	li	a0,50
	call	set_cursor
	lui	a5,%hi(.LC8)
	addi	a0,a5,%lo(.LC8)
	call	rvc_printf
	li	a1,20
	li	a0,60
	call	set_cursor
	lui	a5,%hi(.LC9)
	addi	a0,a5,%lo(.LC9)
	call	rvc_printf
	li	a1,20
	li	a0,70
	call	set_cursor
	lui	a5,%hi(.LC10)
	addi	a0,a5,%lo(.LC10)
	call	rvc_printf
	nop
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	show_menu, .-show_menu
	.section	.rodata
	.align	2
.LC11:
	.string	"WELCOME TO THE LED SHOW.\n"
	.align	2
.LC12:
	.string	"SET THE FPGA SWITCHES TO SELECT THE LED FUNCTION\n"
	.align	2
.LC13:
	.string	"000 : ALL LED BLINK\n"
	.align	2
.LC14:
	.string	"001 : BINARY COUNTER \n"
	.align	2
.LC15:
	.string	"010 : ONE LED MOVING LEFT\n"
	.align	2
.LC16:
	.string	"011 : DECREASE BINARY COUNTER\n"
	.text
	.align	2
	.globl	led_blinky
	.type	led_blinky, @function
led_blinky:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	li	a5,1
	sw	a5,-20(s0)
	li	a5,1023
	sw	a5,-24(s0)
	sw	zero,-28(s0)
	li	a5,1
	sw	a5,-32(s0)
	li	a5,512
	sw	a5,-36(s0)
	li	a1,10
	li	a0,20
	call	set_cursor
	lui	a5,%hi(.LC11)
	addi	a0,a5,%lo(.LC11)
	call	rvc_printf
	li	a1,15
	li	a0,30
	call	set_cursor
	lui	a5,%hi(.LC12)
	addi	a0,a5,%lo(.LC12)
	call	rvc_printf
	li	a1,20
	li	a0,40
	call	set_cursor
	lui	a5,%hi(.LC13)
	addi	a0,a5,%lo(.LC13)
	call	rvc_printf
	li	a1,20
	li	a0,45
	call	set_cursor
	lui	a5,%hi(.LC14)
	addi	a0,a5,%lo(.LC14)
	call	rvc_printf
	li	a1,20
	li	a0,50
	call	set_cursor
	lui	a5,%hi(.LC15)
	addi	a0,a5,%lo(.LC15)
	call	rvc_printf
	li	a1,20
	li	a0,55
	call	set_cursor
	lui	a5,%hi(.LC16)
	addi	a0,a5,%lo(.LC16)
	call	rvc_printf
.L41:
	li	a5,62922752
	addi	a5,a5,36
	lw	a5,0(a5)
	bne	a5,zero,.L36
	li	a5,1
	sw	a5,-20(s0)
	li	a5,1023
	sw	a5,-24(s0)
	li	a5,1
	sw	a5,-32(s0)
	li	a5,512
	sw	a5,-36(s0)
	call	delay
	li	a5,62922752
	addi	a5,a5,24
	lw	a4,-28(s0)
	sw	a4,0(a5)
	lw	a4,-28(s0)
	li	a5,1023
	bne	a4,a5,.L37
	sw	zero,-28(s0)
	j	.L41
.L37:
	li	a5,1023
	sw	a5,-28(s0)
	j	.L41
.L36:
	li	a5,62922752
	addi	a5,a5,36
	lw	a4,0(a5)
	li	a5,1
	bne	a4,a5,.L39
	li	a5,1023
	sw	a5,-24(s0)
	sw	zero,-28(s0)
	li	a5,1
	sw	a5,-32(s0)
	li	a5,512
	sw	a5,-36(s0)
	call	delay
	li	a5,62922752
	addi	a5,a5,24
	lw	a4,-20(s0)
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,1023
	bne	a4,a5,.L41
	li	a5,1
	sw	a5,-20(s0)
	j	.L41
.L39:
	li	a5,62922752
	addi	a5,a5,36
	lw	a4,0(a5)
	li	a5,2
	bne	a4,a5,.L40
	li	a5,1
	sw	a5,-20(s0)
	li	a5,1023
	sw	a5,-24(s0)
	sw	zero,-28(s0)
	li	a5,512
	sw	a5,-36(s0)
	call	delay
	li	a5,62922752
	addi	a5,a5,24
	lw	a4,-32(s0)
	sw	a4,0(a5)
	lw	a5,-32(s0)
	slli	a5,a5,1
	sw	a5,-32(s0)
	lw	a4,-32(s0)
	li	a5,512
	ble	a4,a5,.L41
	li	a5,1
	sw	a5,-32(s0)
	j	.L41
.L40:
	li	a5,62922752
	addi	a5,a5,36
	lw	a4,0(a5)
	li	a5,3
	bne	a4,a5,.L41
	li	a5,1
	sw	a5,-20(s0)
	sw	zero,-28(s0)
	li	a5,1
	sw	a5,-32(s0)
	li	a5,512
	sw	a5,-36(s0)
	call	delay
	li	a5,62922752
	addi	a5,a5,24
	lw	a4,-24(s0)
	sw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,-1
	sw	a5,-24(s0)
	lw	a5,-24(s0)
	bne	a5,zero,.L41
	li	a5,1023
	sw	a5,-24(s0)
	j	.L41
	.size	led_blinky, .-led_blinky
	.section	.rodata
	.align	2
.LC17:
	.string	"LOTR FABRIC\n"
	.align	2
.LC18:
	.string	"FPGA .\n"
	.align	2
.LC19:
	.string	"HW SYSTEM PROPERTIES:\n"
	.align	2
.LC20:
	.string	"NUMBER OF CORES: 2\n"
	.align	2
.LC21:
	.string	"NUMBER OF THREAD EACH CORE: 4\n"
	.align	2
.LC22:
	.string	"FPGA MODEL : DE10LIGHT\n"
	.align	2
.LC23:
	.string	"INSTRUCTION MEMORY SIZE FOR EACH CORE : 8 KB\n"
	.align	2
.LC24:
	.string	"DATA MEMORY SIZE FOR EACH CORE : 8 KB\n"
	.align	2
.LC25:
	.string	"VGA MEMORY SIZE : 38 KB\n"
	.align	2
.LC26:
	.string	"SOME CR FEATURES : \n"
	.align	2
.LC27:
	.string	"FREEZE THREAD PC\n"
	.align	2
.LC28:
	.string	"RESET THREAD PC\n"
	.align	2
.LC29:
	.string	"CREATORS: \n"
	.align	2
.LC30:
	.string	"ADI LEVY \n"
	.align	2
.LC31:
	.string	"SAAR KADOSH \n"
	.align	2
.LC32:
	.string	"AMICHAI BEN DAVID \n"
	.text
	.align	2
	.globl	sys_info
	.type	sys_info, @function
sys_info:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a1,1
	li	a0,1
	call	set_cursor
	lui	a5,%hi(.LC17)
	addi	a0,a5,%lo(.LC17)
	call	rvc_printf
	li	a1,1
	li	a0,5
	call	set_cursor
	lui	a5,%hi(.LC18)
	addi	a0,a5,%lo(.LC18)
	call	rvc_printf
	li	a1,20
	li	a0,10
	call	set_cursor
	lui	a5,%hi(.LC19)
	addi	a0,a5,%lo(.LC19)
	call	rvc_printf
	li	a1,20
	li	a0,20
	call	set_cursor
	lui	a5,%hi(.LC20)
	addi	a0,a5,%lo(.LC20)
	call	rvc_printf
	li	a1,20
	li	a0,25
	call	set_cursor
	lui	a5,%hi(.LC21)
	addi	a0,a5,%lo(.LC21)
	call	rvc_printf
	li	a1,20
	li	a0,30
	call	set_cursor
	lui	a5,%hi(.LC22)
	addi	a0,a5,%lo(.LC22)
	call	rvc_printf
	li	a1,20
	li	a0,35
	call	set_cursor
	lui	a5,%hi(.LC23)
	addi	a0,a5,%lo(.LC23)
	call	rvc_printf
	li	a1,20
	li	a0,40
	call	set_cursor
	lui	a5,%hi(.LC24)
	addi	a0,a5,%lo(.LC24)
	call	rvc_printf
	li	a1,20
	li	a0,45
	call	set_cursor
	lui	a5,%hi(.LC25)
	addi	a0,a5,%lo(.LC25)
	call	rvc_printf
	li	a1,20
	li	a0,50
	call	set_cursor
	lui	a5,%hi(.LC26)
	addi	a0,a5,%lo(.LC26)
	call	rvc_printf
	li	a1,25
	li	a0,55
	call	set_cursor
	lui	a5,%hi(.LC27)
	addi	a0,a5,%lo(.LC27)
	call	rvc_printf
	li	a1,25
	li	a0,60
	call	set_cursor
	lui	a5,%hi(.LC28)
	addi	a0,a5,%lo(.LC28)
	call	rvc_printf
	li	a1,20
	li	a0,65
	call	set_cursor
	lui	a5,%hi(.LC29)
	addi	a0,a5,%lo(.LC29)
	call	rvc_printf
	li	a1,25
	li	a0,70
	call	set_cursor
	lui	a5,%hi(.LC30)
	addi	a0,a5,%lo(.LC30)
	call	rvc_printf
	li	a1,25
	li	a0,75
	call	set_cursor
	lui	a5,%hi(.LC31)
	addi	a0,a5,%lo(.LC31)
	call	rvc_printf
	li	a1,25
	li	a0,80
	call	set_cursor
	lui	a5,%hi(.LC32)
	addi	a0,a5,%lo(.LC32)
	call	rvc_printf
	nop
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	sys_info, .-sys_info
	.align	2
	.globl	new_direction
	.type	new_direction, @function
new_direction:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	mv	a5,a0
	sb	a5,-33(s0)
	li	a5,62922752
	addi	a5,a5,36
	lw	a5,0(a5)
	sb	a5,-17(s0)
	lbu	a5,-17(s0)
	beq	a5,zero,.L44
	lbu	a4,-17(s0)
	li	a5,2
	beq	a4,a5,.L44
	lbu	a4,-17(s0)
	li	a5,4
	beq	a4,a5,.L44
	lbu	a4,-17(s0)
	li	a5,1
	bne	a4,a5,.L45
.L44:
	lbu	a5,-33(s0)
	bne	a5,zero,.L46
	lbu	a4,-17(s0)
	li	a5,4
	beq	a4,a5,.L45
.L46:
	lbu	a4,-33(s0)
	li	a5,4
	bne	a4,a5,.L47
	lbu	a5,-17(s0)
	beq	a5,zero,.L45
.L47:
	lbu	a4,-33(s0)
	li	a5,2
	bne	a4,a5,.L48
	lbu	a4,-17(s0)
	li	a5,1
	beq	a4,a5,.L45
.L48:
	lbu	a4,-33(s0)
	li	a5,1
	bne	a4,a5,.L49
	lbu	a4,-17(s0)
	li	a5,2
	bne	a4,a5,.L49
.L45:
	lbu	a5,-33(s0)
	sb	a5,-17(s0)
.L49:
	lbu	a5,-17(s0)
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	new_direction, .-new_direction
	.align	2
	.globl	snk_move
	.type	snk_move, @function
snk_move:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	mv	a5,a0
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	mv	a4,a3
	sb	a5,-33(s0)
	mv	a5,a4
	sb	a5,-34(s0)
	lbu	a5,-34(s0)
	addi	a5,a5,-1
	sw	a5,-20(s0)
	j	.L52
.L53:
	lw	a5,-20(s0)
	addi	a5,a5,-1
	lw	a4,-40(s0)
	add	a4,a4,a5
	lw	a5,-20(s0)
	lw	a3,-40(s0)
	add	a5,a3,a5
	lbu	a4,0(a4)
	sb	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,-1
	lw	a4,-44(s0)
	add	a4,a4,a5
	lw	a5,-20(s0)
	lw	a3,-44(s0)
	add	a5,a3,a5
	lbu	a4,0(a4)
	sb	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,-1
	sw	a5,-20(s0)
.L52:
	lw	a5,-20(s0)
	bgt	a5,zero,.L53
	lbu	a4,-33(s0)
	li	a5,2
	bne	a4,a5,.L54
	lw	a5,-40(s0)
	lbu	a4,1(a5)
	lw	a5,-40(s0)
	sb	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,1
	lbu	a5,0(a5)
	addi	a5,a5,-1
	andi	a4,a5,0xff
	lw	a5,-44(s0)
	sb	a4,0(a5)
.L54:
	lbu	a4,-33(s0)
	li	a5,1
	bne	a4,a5,.L55
	lw	a5,-40(s0)
	lbu	a4,1(a5)
	lw	a5,-40(s0)
	sb	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,1
	lbu	a5,0(a5)
	addi	a5,a5,1
	andi	a4,a5,0xff
	lw	a5,-44(s0)
	sb	a4,0(a5)
.L55:
	lbu	a4,-33(s0)
	li	a5,4
	bne	a4,a5,.L56
	lw	a5,-40(s0)
	addi	a5,a5,1
	lbu	a5,0(a5)
	addi	a5,a5,-1
	andi	a4,a5,0xff
	lw	a5,-40(s0)
	sb	a4,0(a5)
	lw	a5,-44(s0)
	lbu	a4,1(a5)
	lw	a5,-44(s0)
	sb	a4,0(a5)
.L56:
	lbu	a5,-33(s0)
	bne	a5,zero,.L57
	lw	a5,-40(s0)
	addi	a5,a5,1
	lbu	a5,0(a5)
	addi	a5,a5,1
	andi	a4,a5,0xff
	lw	a5,-40(s0)
	sb	a4,0(a5)
	lw	a5,-44(s0)
	lbu	a4,1(a5)
	lw	a5,-44(s0)
	sb	a4,0(a5)
.L57:
	lbu	a5,-33(s0)
	bne	a5,zero,.L59
	lw	a5,-40(s0)
	addi	a5,a5,1
	lbu	a5,0(a5)
	addi	a5,a5,1
	andi	a4,a5,0xff
	lw	a5,-40(s0)
	sb	a4,0(a5)
	lw	a5,-44(s0)
	lbu	a4,1(a5)
	lw	a5,-44(s0)
	sb	a4,0(a5)
.L59:
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	snk_move, .-snk_move
	.align	2
	.globl	print_snake
	.type	print_snake, @function
print_snake:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	mv	a5,a0
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	sb	a5,-33(s0)
	mv	a5,a4
	sb	a5,-34(s0)
	sw	zero,-20(s0)
	j	.L61
.L64:
	lw	a5,-20(s0)
	lw	a4,-40(s0)
	add	a5,a4,a5
	lbu	a5,0(a5)
	beq	a5,zero,.L62
	lw	a5,-20(s0)
	lw	a4,-48(s0)
	add	a5,a4,a5
	lbu	a5,0(a5)
	slli	a3,a5,1
	lw	a5,-20(s0)
	lw	a4,-44(s0)
	add	a5,a4,a5
	lbu	a5,0(a5)
	mv	a2,a5
	mv	a1,a3
	li	a0,88
	call	draw_char
	lw	a5,-20(s0)
	addi	a5,a5,1
	lw	a4,-40(s0)
	add	a5,a4,a5
	lbu	a5,0(a5)
	bne	a5,zero,.L62
	lbu	a5,-33(s0)
	beq	a5,zero,.L63
	lw	a5,-20(s0)
	addi	a5,a5,1
	lw	a4,-40(s0)
	add	a5,a4,a5
	li	a4,1
	sb	a4,0(a5)
	sb	zero,-33(s0)
	j	.L62
.L63:
	lw	a5,-20(s0)
	addi	a5,a5,1
	lw	a4,-48(s0)
	add	a5,a4,a5
	lbu	a5,0(a5)
	slli	a3,a5,1
	lw	a5,-20(s0)
	addi	a5,a5,1
	lw	a4,-44(s0)
	add	a5,a4,a5
	lbu	a5,0(a5)
	mv	a2,a5
	mv	a1,a3
	li	a0,32
	call	draw_char
.L62:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L61:
	lbu	a5,-34(s0)
	lw	a4,-20(s0)
	blt	a4,a5,.L64
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	print_snake, .-print_snake
	.align	2
	.globl	eat
	.type	eat, @function
eat:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a5,-44(s0)
	mv	a5,a1
	sb	a5,-37(s0)
	mv	a5,a2
	sb	a5,-38(s0)
	mv	a5,a3
	sb	a5,-39(s0)
	mv	a5,a4
	sb	a5,-40(s0)
	lbu	a4,-37(s0)
	lbu	a5,-39(s0)
	bne	a4,a5,.L66
	lbu	a4,-38(s0)
	lbu	a5,-40(s0)
	bne	a4,a5,.L66
	li	a5,1
	j	.L67
.L66:
	li	a5,0
.L67:
	sb	a5,-17(s0)
	lbu	a5,-17(s0)
	beq	a5,zero,.L68
	lw	a5,-44(s0)
	lbu	a5,0(a5)
	addi	a5,a5,1
	andi	a4,a5,0xff
	lw	a5,-44(s0)
	sb	a4,0(a5)
.L68:
	lbu	a5,-17(s0)
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	eat, .-eat
	.section	.rodata
	.align	2
.LC33:
	.string	"GAME SCORE\n"
	.text
	.align	2
	.globl	snake_game
	.type	snake_game, @function
snake_game:
	addi	sp,sp,-96
	sw	ra,92(sp)
	sw	s0,88(sp)
	addi	s0,sp,96
	sb	zero,-17(s0)
	li	a5,5
	sb	a5,-18(s0)
	li	a5,5
	sb	a5,-19(s0)
	sb	zero,-85(s0)
	sb	zero,-20(s0)
	sb	zero,-21(s0)
	sb	zero,-22(s0)
.L85:
	li	a5,62922752
	addi	a5,a5,36
	lw	a5,0(a5)
	sb	a5,-34(s0)
	lb	a5,-34(s0)
	bge	a5,zero,.L71
	call	clear_screen
	li	a5,5
	sb	a5,-18(s0)
	li	a5,5
	sb	a5,-19(s0)
	sb	zero,-85(s0)
	sb	zero,-20(s0)
	sb	zero,-21(s0)
	sb	zero,-22(s0)
	sw	zero,-28(s0)
	j	.L72
.L73:
	lw	a2,-28(s0)
	li	a1,0
	li	a0,65
	call	draw_char
	lw	a2,-28(s0)
	li	a1,118
	li	a0,65
	call	draw_char
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L72:
	lw	a4,-28(s0)
	li	a5,79
	ble	a4,a5,.L73
	sw	zero,-32(s0)
	j	.L74
.L75:
	lw	a5,-32(s0)
	slli	a5,a5,1
	li	a2,0
	mv	a1,a5
	li	a0,65
	call	draw_char
	lw	a5,-32(s0)
	slli	a5,a5,1
	li	a2,79
	mv	a1,a5
	li	a0,65
	call	draw_char
	lw	a5,-32(s0)
	addi	a5,a5,1
	sw	a5,-32(s0)
.L74:
	lw	a4,-32(s0)
	li	a5,59
	ble	a4,a5,.L75
	sb	zero,-33(s0)
	j	.L76
.L77:
	lbu	a5,-33(s0)
	lbu	a4,-33(s0)
	addi	a4,a4,20
	andi	a4,a4,0xff
	addi	a3,s0,-16
	add	a5,a3,a5
	sb	a4,-36(a5)
	lbu	a5,-33(s0)
	addi	a4,s0,-16
	add	a5,a4,a5
	li	a4,20
	sb	a4,-52(a5)
	lbu	a5,-33(s0)
	sltiu	a5,a5,5
	andi	a4,a5,0xff
	lbu	a5,-33(s0)
	addi	a3,s0,-16
	add	a5,a3,a5
	sb	a4,-68(a5)
	lbu	a5,-33(s0)
	addi	a5,a5,1
	sb	a5,-33(s0)
.L76:
	lbu	a4,-33(s0)
	li	a5,14
	bleu	a4,a5,.L77
.L71:
	lbu	a5,-17(s0)
	mv	a0,a5
	call	new_direction
	mv	a5,a0
	sb	a5,-17(s0)
	lbu	a5,-21(s0)
	bne	a5,zero,.L78
	addi	a2,s0,-68
	addi	a4,s0,-52
	lbu	a5,-17(s0)
	li	a3,15
	mv	a1,a4
	mv	a0,a5
	call	snk_move
.L78:
	lbu	a1,-52(s0)
	lbu	a2,-68(s0)
	addi	a5,s0,-85
	lbu	a4,-19(s0)
	lbu	a3,-18(s0)
	addi	a0,s0,-84
	call	eat
	mv	a5,a0
	sb	a5,-35(s0)
	lbu	a4,-35(s0)
	li	a5,1
	bne	a4,a5,.L79
	lbu	a5,-22(s0)
	bne	a5,zero,.L80
	li	a5,9
	sb	a5,-18(s0)
	li	a5,9
	sb	a5,-19(s0)
	li	a5,1
	sb	a5,-22(s0)
	j	.L81
.L80:
	li	a5,29
	sb	a5,-18(s0)
	li	a5,29
	sb	a5,-19(s0)
	sb	zero,-22(s0)
.L81:
	lbu	a5,-20(s0)
	addi	a5,a5,1
	sb	a5,-20(s0)
.L79:
	li	a1,20
	li	a0,3
	call	set_cursor
	lui	a5,%hi(.LC33)
	addi	a0,a5,%lo(.LC33)
	call	rvc_printf
	lbu	a5,-19(s0)
	slli	a5,a5,1
	lbu	a4,-18(s0)
	mv	a2,a4
	mv	a1,a5
	li	a0,79
	call	draw_char
	addi	a3,s0,-68
	addi	a2,s0,-52
	addi	a1,s0,-84
	lbu	a5,-35(s0)
	li	a4,15
	mv	a0,a5
	call	print_snake
	lbu	a5,-20(s0)
	addi	a5,a5,48
	andi	a5,a5,0xff
	li	a2,39
	li	a1,3
	mv	a0,a5
	call	draw_char
	lbu	a5,-52(s0)
	beq	a5,zero,.L82
	lbu	a4,-52(s0)
	li	a5,79
	beq	a4,a5,.L82
	lbu	a5,-68(s0)
	beq	a5,zero,.L82
	lbu	a4,-68(s0)
	li	a5,59
	bne	a4,a5,.L83
.L82:
	li	a5,1
	j	.L84
.L83:
	li	a5,0
.L84:
	sb	a5,-21(s0)
	sb	zero,-35(s0)
	call	delay
	j	.L85
	.size	snake_game, .-snake_game
	.section	.rodata
	.align	2
.LC34:
	.string	"C1 T0, BUBBLE SORT RANDOM\n"
	.align	2
.LC35:
	.string	"C1 T1, BUBBLE SORT 3 UNIQUE\n"
	.align	2
.LC36:
	.string	"C1 T2, BUBBLE SORT REVERSE\n"
	.align	2
.LC37:
	.string	"C1 T3, BUBBLE SORT ALMOST SORTED\n"
	.align	2
.LC38:
	.string	"C2 T0 ,INSERTION SORT RANDOM\n"
	.align	2
.LC39:
	.string	"C2 T1, INSERTION SORT 3 UNIQUE\n"
	.align	2
.LC40:
	.string	"C2 T2, INSERTION SORT REVERSE\n"
	.align	2
.LC41:
	.string	"C2 T3, INSERTION SORT ALMOST SORTED.\n"
	.align	2
.LC0:
	.word	11
	.word	5
	.word	9
	.word	13
	.word	18
	.word	7
	.word	1
	.word	2
	.word	12
	.word	10
	.word	4
	.word	3
	.word	14
	.word	6
	.word	15
	.word	17
	.word	8
	.word	16
	.align	2
.LC1:
	.word	6
	.word	18
	.word	12
	.word	12
	.word	6
	.word	18
	.word	18
	.word	6
	.word	6
	.word	12
	.word	12
	.word	18
	.word	6
	.word	18
	.word	6
	.word	12
	.word	18
	.word	12
	.align	2
.LC2:
	.word	18
	.word	17
	.word	16
	.word	15
	.word	14
	.word	13
	.word	12
	.word	11
	.word	10
	.word	9
	.word	8
	.word	7
	.word	6
	.word	5
	.word	4
	.word	3
	.word	2
	.word	1
	.align	2
.LC3:
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
	.word	17
	.word	18
	.word	1
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-144
	sw	ra,140(sp)
	sw	s0,136(sp)
	addi	s0,sp,144
	call	clear_screen
	li	a5,12582912
	lw	a5,0(a5)
	sw	a5,-56(s0)
	li	a5,18
	sw	a5,-60(s0)
	lw	a5,-56(s0)
	addi	a5,a5,-4
	li	a4,7
	bgtu	a5,a4,.L87
	slli	a4,a5,2
	lui	a5,%hi(.L89)
	addi	a5,a5,%lo(.L89)
	add	a5,a4,a5
	lw	a5,0(a5)
	jr	a5
	.section	.rodata
	.align	2
	.align	2
.L89:
	.word	.L96
	.word	.L95
	.word	.L94
	.word	.L93
	.word	.L92
	.word	.L91
	.word	.L90
	.word	.L88
	.text
.L96:
	li	a5,29360128
	addi	a5,a5,336
	sw	zero,0(a5)
	call	delay
	li	a1,1
	li	a0,30
	call	set_cursor
	lui	a5,%hi(.LC34)
	addi	a0,a5,%lo(.LC34)
	call	rvc_printf
	lui	a5,%hi(.LC0)
	addi	a4,a5,%lo(.LC0)
	addi	a5,s0,-136
	mv	a3,a4
	li	a4,72
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	sw	zero,-24(s0)
	j	.L97
.L98:
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-120(a5)
	li	a5,4096
	addi	a3,a5,-496
	li	a2,0
	lw	a1,-24(s0)
	mv	a0,a4
	call	draw_stick
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L97:
	lw	a4,-24(s0)
	lw	a5,-60(s0)
	blt	a4,a5,.L98
	call	delay
	addi	a4,s0,-136
	li	a5,4096
	addi	a3,a5,-496
	li	a2,0
	lw	a1,-60(s0)
	mv	a0,a4
	call	bubbleSort
	call	delay
.L99:
	j	.L99
.L95:
	call	show_menu
	sw	zero,-64(s0)
.L106:
	li	a5,62922752
	addi	a5,a5,36
	lw	a5,0(a5)
	sw	a5,-64(s0)
	lw	a4,-64(s0)
	li	a5,1
	bne	a4,a5,.L100
	li	a2,18
	li	a1,40
	li	a0,1
	call	draw_symbol
	li	a2,18
	li	a1,50
	li	a0,5
	call	draw_symbol
	li	a2,18
	li	a1,60
	li	a0,5
	call	draw_symbol
	li	a2,18
	li	a1,70
	li	a0,5
	call	draw_symbol
	j	.L106
.L100:
	lw	a4,-64(s0)
	li	a5,2
	bne	a4,a5,.L102
	li	a2,18
	li	a1,50
	li	a0,1
	call	draw_symbol
	li	a2,18
	li	a1,40
	li	a0,5
	call	draw_symbol
	li	a2,18
	li	a1,60
	li	a0,5
	call	draw_symbol
	li	a2,18
	li	a1,70
	li	a0,5
	call	draw_symbol
	j	.L106
.L102:
	lw	a4,-64(s0)
	li	a5,4
	bne	a4,a5,.L103
	li	a2,18
	li	a1,60
	li	a0,1
	call	draw_symbol
	li	a2,18
	li	a1,40
	li	a0,5
	call	draw_symbol
	li	a2,18
	li	a1,50
	li	a0,5
	call	draw_symbol
	li	a2,18
	li	a1,70
	li	a0,5
	call	draw_symbol
	j	.L106
.L103:
	lw	a4,-64(s0)
	li	a5,5
	bne	a4,a5,.L104
	li	a2,18
	li	a1,70
	li	a0,1
	call	draw_symbol
	li	a2,18
	li	a1,40
	li	a0,5
	call	draw_symbol
	li	a2,18
	li	a1,50
	li	a0,5
	call	draw_symbol
	li	a2,18
	li	a1,60
	li	a0,5
	call	draw_symbol
	j	.L106
.L104:
	lw	a4,-64(s0)
	li	a5,129
	beq	a4,a5,.L105
	lw	a4,-64(s0)
	li	a5,130
	beq	a4,a5,.L105
	lw	a4,-64(s0)
	li	a5,132
	beq	a4,a5,.L105
	lw	a4,-64(s0)
	li	a5,133
	beq	a4,a5,.L105
	li	a2,18
	li	a1,40
	li	a0,5
	call	draw_symbol
	li	a2,18
	li	a1,50
	li	a0,5
	call	draw_symbol
	li	a2,18
	li	a1,60
	li	a0,5
	call	draw_symbol
	li	a2,18
	li	a1,70
	li	a0,5
	call	draw_symbol
	j	.L106
.L105:
	lw	a4,-64(s0)
	li	a5,129
	bne	a4,a5,.L107
	call	clear_screen
	call	sys_info
.L108:
	j	.L108
.L107:
	lw	a4,-64(s0)
	li	a5,130
	bne	a4,a5,.L109
	call	clear_screen
	call	led_blinky
.L110:
	j	.L110
.L109:
	lw	a4,-64(s0)
	li	a5,133
	bne	a4,a5,.L111
	call	clear_screen
	call	snake_game
.L112:
	j	.L112
.L111:
	lw	a4,-64(s0)
	li	a5,132
	bne	a4,a5,.L142
	call	clear_screen
	li	a5,46137344
	addi	a4,a5,348
	li	a5,1
	sw	a5,0(a4)
	li	a4,46137344
	addi	a4,a4,344
	sw	a5,0(a4)
	li	a4,46137344
	addi	a4,a4,340
	sw	a5,0(a4)
	li	a4,46137344
	addi	a4,a4,336
	sw	a5,0(a4)
	li	a4,29360128
	addi	a4,a4,348
	sw	a5,0(a4)
	li	a4,29360128
	addi	a4,a4,344
	sw	a5,0(a4)
	li	a4,29360128
	addi	a4,a4,336
	sw	a5,0(a4)
	call	delay
	li	a1,40
	li	a0,90
	call	set_cursor
	lui	a5,%hi(.LC35)
	addi	a0,a5,%lo(.LC35)
	call	rvc_printf
	lui	a5,%hi(.LC1)
	addi	a4,a5,%lo(.LC1)
	addi	a5,s0,-136
	mv	a3,a4
	li	a4,72
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	sw	zero,-28(s0)
	j	.L114
.L115:
	lw	a5,-28(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-120(a5)
	li	a5,4096
	addi	a3,a5,-496
	li	a5,4096
	addi	a2,a5,744
	lw	a1,-28(s0)
	mv	a0,a4
	call	draw_stick
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L114:
	lw	a4,-28(s0)
	lw	a5,-60(s0)
	blt	a4,a5,.L115
	call	delay
	addi	a4,s0,-136
	li	a5,4096
	addi	a3,a5,-496
	li	a5,4096
	addi	a2,a5,744
	lw	a1,-60(s0)
	mv	a0,a4
	call	bubbleSort
	call	delay
.L116:
	j	.L116
.L94:
	li	a5,29360128
	addi	a5,a5,344
	sw	zero,0(a5)
	sw	zero,-20(s0)
	j	.L118
.L119:
	lw	a5,-20(s0)
	slli	a4,a5,2
	li	a5,54525952
	add	a5,a4,a5
	li	a4,-1
	sw	a4,0(a5)
	lw	a4,-20(s0)
	li	a5,4096
	addi	a5,a5,-1696
	add	a5,a4,a5
	slli	a4,a5,2
	li	a5,54525952
	addi	a5,a5,-320
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
	lw	a4,-20(s0)
	li	a5,8192
	addi	a5,a5,-992
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
.L118:
	lw	a4,-20(s0)
	li	a5,79
	ble	a4,a5,.L119
	sw	zero,-20(s0)
	j	.L120
.L121:
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
.L120:
	lw	a4,-20(s0)
	li	a5,119
	ble	a4,a5,.L121
	call	delay
	li	a1,40
	li	a0,30
	call	set_cursor
	lui	a5,%hi(.LC36)
	addi	a0,a5,%lo(.LC36)
	call	rvc_printf
	lui	a5,%hi(.LC2)
	addi	a4,a5,%lo(.LC2)
	addi	a5,s0,-136
	mv	a3,a4
	li	a4,72
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	sw	zero,-32(s0)
	j	.L122
.L123:
	lw	a5,-32(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-120(a5)
	li	a5,4096
	addi	a3,a5,-496
	li	a2,40
	lw	a1,-32(s0)
	mv	a0,a4
	call	draw_stick
	lw	a5,-32(s0)
	addi	a5,a5,1
	sw	a5,-32(s0)
.L122:
	lw	a4,-32(s0)
	lw	a5,-60(s0)
	blt	a4,a5,.L123
	call	delay
	addi	a4,s0,-136
	li	a5,4096
	addi	a3,a5,-496
	li	a2,40
	lw	a1,-60(s0)
	mv	a0,a4
	call	bubbleSort
	call	delay
.L124:
	j	.L124
.L93:
	li	a5,29360128
	addi	a5,a5,348
	sw	zero,0(a5)
	call	delay
	li	a1,1
	li	a0,90
	call	set_cursor
	lui	a5,%hi(.LC37)
	addi	a0,a5,%lo(.LC37)
	call	rvc_printf
	lui	a5,%hi(.LC3)
	addi	a4,a5,%lo(.LC3)
	addi	a5,s0,-136
	mv	a3,a4
	li	a4,72
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	sw	zero,-36(s0)
	j	.L125
.L126:
	lw	a5,-36(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-120(a5)
	li	a5,4096
	addi	a3,a5,-496
	li	a5,4096
	addi	a2,a5,704
	lw	a1,-36(s0)
	mv	a0,a4
	call	draw_stick
	lw	a5,-36(s0)
	addi	a5,a5,1
	sw	a5,-36(s0)
.L125:
	lw	a4,-36(s0)
	lw	a5,-60(s0)
	blt	a4,a5,.L126
	call	delay
	addi	a4,s0,-136
	li	a5,4096
	addi	a3,a5,-496
	li	a5,4096
	addi	a2,a5,704
	lw	a1,-60(s0)
	mv	a0,a4
	call	bubbleSort
	call	delay
.L127:
	j	.L127
.L92:
	li	a5,46137344
	addi	a5,a5,336
	sw	zero,0(a5)
	call	delay
	li	a1,1
	li	a0,1
	call	set_cursor
	lui	a5,%hi(.LC38)
	addi	a0,a5,%lo(.LC38)
	call	rvc_printf
	lui	a5,%hi(.LC0)
	addi	a4,a5,%lo(.LC0)
	addi	a5,s0,-136
	mv	a3,a4
	li	a4,72
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	sw	zero,-40(s0)
	j	.L128
.L129:
	lw	a5,-40(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-120(a5)
	li	a3,1200
	li	a2,0
	lw	a1,-40(s0)
	mv	a0,a5
	call	draw_stick
	lw	a5,-40(s0)
	addi	a5,a5,1
	sw	a5,-40(s0)
.L128:
	lw	a4,-40(s0)
	lw	a5,-60(s0)
	blt	a4,a5,.L129
	call	delay
	addi	a5,s0,-136
	li	a3,1200
	li	a2,0
	lw	a1,-60(s0)
	mv	a0,a5
	call	insertionSort
	call	delay
.L130:
	j	.L130
.L91:
	li	a5,46137344
	addi	a5,a5,340
	sw	zero,0(a5)
	call	delay
	li	a1,40
	li	a0,60
	call	set_cursor
	lui	a5,%hi(.LC39)
	addi	a0,a5,%lo(.LC39)
	call	rvc_printf
	lui	a5,%hi(.LC1)
	addi	a4,a5,%lo(.LC1)
	addi	a5,s0,-136
	mv	a3,a4
	li	a4,72
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	sw	zero,-44(s0)
	j	.L131
.L132:
	lw	a5,-44(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-120(a5)
	li	a3,1200
	li	a5,4096
	addi	a2,a5,744
	lw	a1,-44(s0)
	mv	a0,a4
	call	draw_stick
	lw	a5,-44(s0)
	addi	a5,a5,1
	sw	a5,-44(s0)
.L131:
	lw	a4,-44(s0)
	lw	a5,-60(s0)
	blt	a4,a5,.L132
	call	delay
	addi	a4,s0,-136
	li	a3,1200
	li	a5,4096
	addi	a2,a5,744
	lw	a1,-60(s0)
	mv	a0,a4
	call	insertionSort
	call	delay
.L133:
	j	.L133
.L90:
	li	a5,46137344
	addi	a5,a5,344
	sw	zero,0(a5)
	call	delay
	li	a1,40
	li	a0,1
	call	set_cursor
	lui	a5,%hi(.LC40)
	addi	a0,a5,%lo(.LC40)
	call	rvc_printf
	lui	a5,%hi(.LC2)
	addi	a4,a5,%lo(.LC2)
	addi	a5,s0,-136
	mv	a3,a4
	li	a4,72
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	sw	zero,-48(s0)
	j	.L134
.L135:
	lw	a5,-48(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-120(a5)
	li	a3,1200
	li	a2,40
	lw	a1,-48(s0)
	mv	a0,a5
	call	draw_stick
	lw	a5,-48(s0)
	addi	a5,a5,1
	sw	a5,-48(s0)
.L134:
	lw	a4,-48(s0)
	lw	a5,-60(s0)
	blt	a4,a5,.L135
	call	delay
	addi	a5,s0,-136
	li	a3,1200
	li	a2,40
	lw	a1,-60(s0)
	mv	a0,a5
	call	insertionSort
	call	delay
.L136:
	j	.L136
.L88:
	li	a5,46137344
	addi	a5,a5,348
	sw	zero,0(a5)
	call	delay
	li	a1,1
	li	a0,60
	call	set_cursor
	lui	a5,%hi(.LC41)
	addi	a0,a5,%lo(.LC41)
	call	rvc_printf
	lui	a5,%hi(.LC3)
	addi	a4,a5,%lo(.LC3)
	addi	a5,s0,-136
	mv	a3,a4
	li	a4,72
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	sw	zero,-52(s0)
	j	.L137
.L138:
	lw	a5,-52(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-120(a5)
	li	a3,1200
	li	a5,4096
	addi	a2,a5,704
	lw	a1,-52(s0)
	mv	a0,a4
	call	draw_stick
	lw	a5,-52(s0)
	addi	a5,a5,1
	sw	a5,-52(s0)
.L137:
	lw	a4,-52(s0)
	lw	a5,-60(s0)
	blt	a4,a5,.L138
	call	delay
	addi	a4,s0,-136
	li	a3,1200
	li	a5,4096
	addi	a2,a5,704
	lw	a1,-60(s0)
	mv	a0,a4
	call	insertionSort
	call	delay
.L139:
	j	.L139
.L87:
.L140:
	j	.L140
.L142:
	nop
	li	a5,0
	mv	a0,a5
	lw	ra,140(sp)
	lw	s0,136(sp)
	addi	sp,sp,144
	jr	ra
	.size	main, .-main
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC x86_64) 10.2.0"
