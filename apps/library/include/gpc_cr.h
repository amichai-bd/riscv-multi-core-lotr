#ifndef _GPC_CR_H_
#define _GPC_CR_H_

#define GPC_CR_ADDRESS_BITS                 0x0
#define GPC_CR_MY_THREAD_ID                 0x4
#define GPC_CR_MY_AGENT_ID                  0x8
#define GPC_CR_SUPPORTED_ARCH               0xc

#define GPC_CR_THREAD0_STATUS              0x10
#define GPC_CR_THREAD1_STATUS              0x14
#define GPC_CR_THREAD2_STATUS              0x18
#define GPC_CR_THREAD3_STATUS              0x1c

#define GPC_CR_THREAD0_EXCEPTION_CODE      0x20
#define GPC_CR_THREAD1_EXCEPTION_CODE      0x24
#define GPC_CR_THREAD2_EXCEPTION_CODE      0x28
#define GPC_CR_THREAD3_EXCEPTION_CODE      0x2c

#define GPC_CR_THREAD0_PC                  0x30
#define GPC_CR_THREAD1_PC                  0x34
#define GPC_CR_THREAD2_PC                  0x38
#define GPC_CR_THREAD3_PC                  0x3c

#define GPC_CR_THREAD0_PC_RST              0x40
#define GPC_CR_THREAD1_PC_RST              0x44
#define GPC_CR_THREAD2_PC_RST              0x48
#define GPC_CR_THREAD3_PC_RST              0x4c

#define GPC_CR_THREAD0_PC_EN               0x50
#define GPC_CR_THREAD1_PC_EN               0x54
#define GPC_CR_THREAD2_PC_EN               0x58
#define GPC_CR_THREAD3_PC_RN               0x5c

#define GPC_CR_THREAD0_DFD_REG_ID          0x60
#define GPC_CR_THREAD1_DFD_REG_ID          0x64
#define GPC_CR_THREAD2_DFD_REG_ID          0x68
#define GPC_CR_THREAD3_DFD_REG_ID          0x6c

#define GPC_CR_THREAD0_DFD_REG_DATA        0x70
#define GPC_CR_THREAD1_DFD_REG_DATA        0x74
#define GPC_CR_THREAD2_DFD_REG_DATA        0x78
#define GPC_CR_THREAD3_DFD_REG_DATA        0x7c

#endif
