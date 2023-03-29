/*LOTR_defines.h

owner: Adi Levy
Created : 1/07/2022
*/

//Core1 Scratchpad
#define SCRATCHPAD0_CORE_1  ((volatile int *) (0x01400900))
#define SCRATCHPAD1_CORE_1  ((volatile int *) (0x01400A00))
#define SCRATCHPAD2_CORE_1  ((volatile int *) (0x01400B00))
#define SCRATCHPAD3_CORE_1  ((volatile int *) (0x01400C00))

//Core2 Scratchpad
#define SCRATCHPAD0_CORE_2  ((volatile int *) (0x02400900))
#define SCRATCHPAD1_CORE_2  ((volatile int *) (0x02400A00))
#define SCRATCHPAD2_CORE_2  ((volatile int *) (0x02400B00))
#define SCRATCHPAD3_CORE_2  ((volatile int *) (0x02400C00))

//Local Core scratchpad
#define SCRATCHPAD0_CORE    ((volatile int *) (0x00400900))
#define SCRATCHPAD1_CORE    ((volatile int *) (0x00400A00))
#define SCRATCHPAD2_CORE    ((volatile int *) (0x00400B00))
#define SCRATCHPAD3_CORE    ((volatile int *) (0x00400C00))


#define SHARED_SPACE ((volatile int *) (0x00400f00))

//CRs
#define CR_PC_EN     ((volatile int *) (0x00C00150))

#define CR_ID10_PC_EN  ((volatile int *)  (0x01C00150))
#define CR_ID11_PC_EN  ((volatile int *)  (0x01C00154))
#define CR_ID12_PC_EN  ((volatile int *)  (0x01C00158))
#define CR_ID13_PC_EN  ((volatile int *)  (0x01C0015c))

#define CR_ID20_PC_EN  ((volatile int *)  (0x02C00150))
#define CR_ID21_PC_EN  ((volatile int *)  (0x02C00154))
#define CR_ID22_PC_EN  ((volatile int *)  (0x02C00158))
#define CR_ID23_PC_EN  ((volatile int *)  (0x02C0015c))

#define CR_WHO_AM_I    ((volatile int *) (0x00C00000))
#define CR_THREAD      ((volatile int *) (0x00C00004))
#define CR_CORE_ID     ((volatile int *) (0x00C00008))
#define CR_SCRATCHPAD0 ((volatile int *) (0x00C00200))
#define CR_SCRATCHPAD1 ((volatile int *) (0x00C00204))
#define CR_SCRATCHPAD2 ((volatile int *) (0x00C00208))
#define CR_SCRATCHPAD3 ((volatile int *) (0x00C0020C))

/* Control registers addresses */
#define CR_CURSOR_H (volatile int *) (0x00C00220)
#define CR_CURSOR_V (volatile int *) (0x00C00234)

//FPGA
//CR
#define SEG0_FGPA    ((volatile int *) (0x03C02000))
#define SEG1_FGPA    ((volatile int *) (0x03C02004))
#define SEG2_FGPA    ((volatile int *) (0x03C02008))
#define SEG3_FGPA    ((volatile int *) (0x03C0200C))
#define SEG4_FGPA    ((volatile int *) (0x03C02010))
#define SEG5_FGPA    ((volatile int *) (0x03C02014))
#define LED_FGPA     ((volatile int *) (0x03C02018))
#define BUTTON1_FGPA ((volatile int *) (0x03C0201c))
#define BUTTON2_FGPA ((volatile int *) (0x03C02020))
#define SWITCH_FGPA  ((volatile int *) (0x03C02024))
#define ARDUINO_IO_FGPA  ((volatile int *) (0x03C02028))
#define ARDUINO_IO_FGPA_STICKY  ((volatile int *) (0x03C0202C))

#define VGA_FPGA     ((volatile int *) (0x03400000))
#define VGA_MEM_BASE 0x03400000

#define CR_MEM_BASE  0x00007000

#define WRITE_REG(REG,VAL) (*REG) = VAL
#define READ_REG(VAL,REG)  VAL    = (*REG)
#define MEM_SCRATCH_PAD    ((volatile int *) (D_MEM_BASE))
#define MEM_SCRATCH_PAD_FP  ((volatile float *) (FP_RESULTS))
