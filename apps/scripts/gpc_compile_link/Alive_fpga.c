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

// REGION == 2'b01;
#define SEG0_FGPA  ((volatile int *) (0x03002000))
#define SCRATCHPAD0_CORE_2  ((volatile int *) (0x02400900))
#define SCRATCHPAD0_CORE    ((volatile int *) (0x00400900))
#define SHARED_SPACE ((volatile int *) (0x00400f00))
#define CR_THREAD  ((volatile int *) (0x00C00004))
#define CR_THREAD_PC_EN  ((volatile int *)  (0x00C00150))
#define CR_CORE_ID ((volatile int *) (0x00C00008))
#define CR_WHO_AM_I ((volatile int *) (0x00C00000))

int main() {
    int ThreadId = CR_THREAD[0];
    int UniqeId = CR_WHO_AM_I[0];
    int counter = 0 ;
    switch (UniqeId) //the CR Address
    {
        case 0x4 : // parameterize 
         
                SEG0_FGPA[0] = 0x1;               //Writing to fpga

                while(counter++ < 10){};          // busy wait until data arrived from Core1

                SHARED_SPACE[0] = SEG0_FGPA[0];    //Reading from fpga 
                //while(1);    
        break;
        default :
                while(1); 
                break;
       
    }   
    
    return 0;

}

