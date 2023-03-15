/*MultiThread.c
calculate 4 different arithmatic calculations one on each thread
test owner: Saar Kadosh
Created : 22/08/2021
*/
// 4KB of D_MEM
// 0x400800 - 0x400fff - Shared
//
// 0x400600 - 0x400800 - Thread 3
// 0x400400 - 0x400600 - Thread 2
// 0x400200 - 0x400400 - Thread 1
// 0x400000 - 0x400200 - Thread 0

#include "LOTR_defines.h"
#include "graphic.h"
int main() {
    int ThreadId = CR_THREAD[0];
    int UniqeId = CR_WHO_AM_I[0];
    int counter = 0 ;
    switch (UniqeId) //the CR Address
    {
        case 0x4 : // parameterize 
         
                SCRATCHPAD0_CORE_2[0] = 0x51;               //Writing to Core1

                while(counter++ < 10){};          // busy wait until data arrived from Core1

                SHARED_SPACE[0] = SCRATCHPAD0_CORE_2[0];    //Reading from local core 
                //while(1);    
        break;
        
        case 0x5 :
            while(1); 
        break;
        
        case 0x6 :
            while(1); 
        break;
        
        case 0x7 :
            while(1); 
        break;
        
        case 0x8 : 
              //  SCRATCHPAD0_CORE_2[2] = 0x70;          
              //  SCRATCHPAD0_CORE_2[3] = 0x80; 
              //  SCRATCHPAD0_CORE_1[0] = 0x10;               //Writing to Core1
              //  SCRATCHPAD0_CORE_1[1] = 0x20;          
              // // res = 1;
              // // res = 1;
              // // res = 1;
              // // res = 1;
              //  //while(SCRATCHPAD0_CORE[10] == 0){};          // busy wait until data arrived from Core2
              //  SHARED_SPACE[0] = SCRATCHPAD0_CORE_2[0];    //Reading from local core
              //  SHARED_SPACE[1] = SCRATCHPAD0_CORE_2[1];
              //  SHARED_SPACE[2] = SCRATCHPAD0_CORE_2[2];
              //  SHARED_SPACE[3] = SCRATCHPAD0_CORE_2[3];
              //  SHARED_SPACE[4] = SCRATCHPAD0_CORE_1[0];    //Reading from Core1(!!)
              //  //SHARED_SPACE[5] = SCRATCHPAD0_CORE_1[1];
              //  //SHARED_SPACE[6] = SCRATCHPAD0_CORE_1[2];
              //  //SHARED_SPACE[7] = SCRATCHPAD0_CORE_1[3];
                while(1);
        break;
        
        case 0x9 :
            while(1); 
        break;
        
        case 0xa :
            while(1); 
        break;
        
        case 0xb :
            while(1); 
        break;
    }   
    
    return 0;

}

