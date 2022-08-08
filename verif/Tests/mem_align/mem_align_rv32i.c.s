clear:
    nop
    nop
    nop 
    nop
    addi x1, x0, 0
    addi x2, x0, 0
    addi x3, x0, 0
    addi x4, x0, 0
    addi x5, x0, 0
    addi x6, x0, 0
    addi x7, x0, 0
    addi x8, x0, 0
    addi x9, x0, 0
    addi x10, x0, 0
    addi x11, x0, 0
    addi x12, x0, 0
    addi x13, x0, 0
    addi x14, x0, 0
    addi x15, x0, 0
    addi x16, x1, 0
    addi x17, x0, 0
    addi x18, x0, 0
    addi x19, x0, 0
    addi x20, x0, 0
    addi x21, x0, 0
    addi x22, x0, 0
    addi x23, x0, 0
    addi x24, x0, 0
    addi x25, x0, 0
    addi x26, x0, 0
    addi x27, x0, 0
    addi x28, x0, 0
    addi x29, x0, 0
    addi x30, x0, 0
    addi x31, x0, 0
main:
    li x1, 0x400000
    li x2, 0x04030201
    li x3, 0xf0E0D0B0
    li x4, 0x400004 # Results

    sw x2   , 0x0(x1) # 0x1000 04030201 
    lw x10  , 0x0(x1) # 04030201
    lh x11  , 0x0(x1) # 00000201
    lb x12  , 0x0(x1) # 00000001
    lhu x13 , 0x0(x1) # 00000201
    lbu x14 , 0x0(x1) # 00000001

    sw x10 , 0x0(x4)  # 0x1004 04030201
    sw x11 , 0x4(x4)  # 0x1008 00000201
    sw x12 , 0x8(x4)  # 0x100c 00000001
    sw x13 , 0xc(x4)  # 0x1010 00000201
    sw x14 , 0x10(x4) # 0x1014 00000001

    lh x11  , 0x1(x1) # 00000302
    lb x12  , 0x1(x1) # 00000002
    lhu x13 , 0x1(x1) # 00000302
    lbu x14 , 0x1(x1) # 00000002

    sw x11 , 0x14(x4) # 0x1018 00000302
    sw x12 , 0x18(x4) # 0x101c 00000002
    sw x13 , 0x1c(x4) # 0x1020 00000302
    sw x14 , 0x20(x4) # 0x1024 00000002

    lh x11  , 0x2(x1) # 00000403
    lb x12  , 0x2(x1) # 00000003
    lhu x13 , 0x2(x1) # 00000403
    lbu x14 , 0x2(x1) # 00000003

    sw x11 , 0x24(x4) # 0x1028 00000403
    sw x12 , 0x28(x4) # 0x102c 00000003
    sw x13 , 0x2c(x4) # 0x1030 00000403
    sw x14 , 0x30(x4) # 0x1034 00000003

    lh x11  , 0x3(x1) # 00000004
    lb x12  , 0x3(x1) # 00000004
    lhu x13 , 0x3(x1) # 00000004
    lbu x14 , 0x3(x1) # 00000004

    sw x11 , 0x34(x4) # 0x1038 00000004
    sw x12 , 0x38(x4) # 0x103c 00000004
    sw x13 , 0x3c(x4) # 0x1040 00000004
    sw x14 , 0x40(x4) # 0x1044 00000004

    li x1, 0xdeadbeef
    li x2, 0x400048
    sb x1, 0x0(x2) # 0x1048 000000ef
    sb x1, 0x1(x2) # 0x1048 0000efef
    sb x1, 0x2(x2) # 0x1048 00efefef
    sb x1, 0x3(x2) # 0x1048 efefefef

    li x3, 0x40004c
    sh x1, 0x0(x3) # 0x104c 0000beef 
    sh x1, 0x2(x3) # 0x104c beefbeef

eot:
    nop
    nop
    nop
    nop
    ebreak
    nop
    nop
    nop
    nop