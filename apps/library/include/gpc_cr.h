#ifndef _GPC_CR_H_
#define _GPC_CR_H_

#define GPC_CR_ADDRESS_BITS                 0x0
#define GPC_CR_MY_THREAD_ID                 0x4
#define GPC_CR_MY_AGENT_ID                  0x8
#define GPC_CR_SUPPORTED_ARCH               0xc

#define GPC_CR_THREAD0_STATUS              0x110
#define GPC_CR_THREAD1_STATUS              0x114
#define GPC_CR_THREAD2_STATUS              0x118
#define GPC_CR_THREAD3_STATUS              0x11c

#define GPC_CR_THREAD0_EXCEPTION_CODE      0x120
#define GPC_CR_THREAD1_EXCEPTION_CODE      0x124
#define GPC_CR_THREAD2_EXCEPTION_CODE      0x128
#define GPC_CR_THREAD3_EXCEPTION_CODE      0x12c

#define GPC_CR_THREAD0_PC                  0x130
#define GPC_CR_THREAD1_PC                  0x134
#define GPC_CR_THREAD2_PC                  0x138
#define GPC_CR_THREAD3_PC                  0x13c

#define GPC_CR_THREAD0_PC_RST              0x140
#define GPC_CR_THREAD1_PC_RST              0x144
#define GPC_CR_THREAD2_PC_RST              0x148
#define GPC_CR_THREAD3_PC_RST              0x14c

#define GPC_CR_THREAD0_PC_EN               0x150
#define GPC_CR_THREAD1_PC_EN               0x154
#define GPC_CR_THREAD2_PC_EN               0x158
#define GPC_CR_THREAD3_PC_EN               0x15c

#define GPC_CR_THREAD0_DFD_REG_ID          0x160
#define GPC_CR_THREAD1_DFD_REG_ID          0x164
#define GPC_CR_THREAD2_DFD_REG_ID          0x168
#define GPC_CR_THREAD3_DFD_REG_ID          0x16c

#define GPC_CR_THREAD0_DFD_REG_DATA        0x170
#define GPC_CR_THREAD1_DFD_REG_DATA        0x174
#define GPC_CR_THREAD2_DFD_REG_DATA        0x178
#define GPC_CR_THREAD3_DFD_REG_DATA        0x17c

#define GPC_CR_SCRATCHPAD0                 0x200
#define GPC_CR_SCRATCHPAD1                 0x204
#define GPC_CR_SCRATCHPAD2                 0x208
#define GPC_CR_SCRATCHPAD3                 0x20c

#endif
