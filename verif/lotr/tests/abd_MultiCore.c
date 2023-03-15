/*MultiThread.c
calculate 4 different arithmatic calculations one on each thread
test owner: Saar Kadosh
Created : 22/08/2021
*/
// 4KB of D_MEM
// 0x400800 - 0x400fff - Shared
// 0x400600 - 0x400800 - Thread 3
// 0x400400 - 0x400600 - Thread 2
// 0x400200 - 0x400400 - Thread 1
// 0x400000 - 0x400200 - Thread 0

// REGION == 2'b01;
//#define SCRATCHPAD0_CORE_1  ((volatile int *) (0x01C00200))
//#define SCRATCHPAD0_CORE_2  ((volatile int *) (0x02C00200))
//#define SCRATCHPAD0_CORE    ((volatile int *) (0x00C00200))
//#define SHARED_SPACE        ((volatile int *) (0x00400f00))
//#define CR_THREAD           ((volatile int *) (0x00C00004))
//#define CR_PC_EN     ((volatile int *) (0x00C00150))
//#define CR_CORE_ID          ((volatile int *) (0x00C00008))
#include "LOTR_defines.h"
#include "graphic.h"

int main() {
    int ThreadId = CR_THREAD[0];
    int CoreId   = CR_CORE_ID[0];
    switch (ThreadId) //the CR Address
    {
        case 0x0 : //expect each thread to get from the MEM_WRAP the correct Thread.
            if(CR_CORE_ID[0] == 1) {
                SCRATCHPAD0_CORE_2[0] = 0x50;               //Writing to Core2
                SCRATCHPAD0_CORE_2[1] = 0x60;          
                SCRATCHPAD0_CORE_1[2] = 0x30;          
                SCRATCHPAD0_CORE_1[3] = 0x40;          
                while(SCRATCHPAD0_CORE[3] == 0){};          // busy wait until data arrived from Core2
                SHARED_SPACE[0] = SCRATCHPAD0_CORE_1[0];    //Reading from local core
                SHARED_SPACE[1] = SCRATCHPAD0_CORE_1[1];
                SHARED_SPACE[2] = SCRATCHPAD0_CORE_1[2];
                SHARED_SPACE[3] = SCRATCHPAD0_CORE_1[3];
                SHARED_SPACE[4] = SCRATCHPAD0_CORE_2[0];    //Reading from Core2(!!)
                SHARED_SPACE[5] = SCRATCHPAD0_CORE_2[1];
                SHARED_SPACE[6] = SCRATCHPAD0_CORE_2[2];
                SHARED_SPACE[7] = SCRATCHPAD0_CORE_2[3];
                set_cursor(10,0);
                for(int i=0;i<8;i++){
                    rvc_print_int(SHARED_SPACE[i]);
                    rvc_printf(" ");
                }
            }
            else if(CR_CORE_ID[0] == 2) {
                SCRATCHPAD0_CORE_1[0] = 0x10;               //Writing to Core1
                SCRATCHPAD0_CORE_1[1] = 0x20;          
                SCRATCHPAD0_CORE_2[2] = 0x70;          
                SCRATCHPAD0_CORE_2[3] = 0x80;          
                while(SCRATCHPAD0_CORE[3] == 0){};          // busy wait until data arrived from Core2
                SHARED_SPACE[0] = SCRATCHPAD0_CORE_2[0];    //Reading from local core
                SHARED_SPACE[1] = SCRATCHPAD0_CORE_2[1];
                SHARED_SPACE[2] = SCRATCHPAD0_CORE_2[2];
                SHARED_SPACE[3] = SCRATCHPAD0_CORE_2[3];
                SHARED_SPACE[4] = SCRATCHPAD0_CORE_1[0];    //Reading from Core1(!!)
                SHARED_SPACE[5] = SCRATCHPAD0_CORE_1[1];
                SHARED_SPACE[6] = SCRATCHPAD0_CORE_1[2];
                SHARED_SPACE[7] = SCRATCHPAD0_CORE_1[3];
                set_cursor(20,0);
                for(int i=0;i<8;i++){
                    rvc_print_int(SHARED_SPACE[i]);
                    rvc_printf(" ");
                }
                while(1);
            }
            //CR_SCRATCHPAD0 - Core0 Data
            //CR_SCRATCHPAD1 - Core1 Data
            //CR_SCRATCHPAD2 - Core0 Ready flag
            //CR_SCRATCHPAD3 - Core1 Ready flag            
        break;
        case 0x1 :
            // Write 0 to PC_En[1] CR
            CR_PC_EN[1] = 0;
            while(1);
        break;
        case 0x2 :
            // Write 0 to PC_En[2] CR
            CR_PC_EN[2] = 0;
            while(1);
        break;
        case 0x3 :
            // Write 0 to PC_En[3] CR
            CR_PC_EN[3] = 0;
            while(1);
        break;
    }   
    
    return 0;

}

