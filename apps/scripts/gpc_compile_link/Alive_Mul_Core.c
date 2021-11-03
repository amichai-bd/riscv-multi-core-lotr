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
#define SCRATCHPAD0_CORE_1  ((volatile int *) (0x01C00200))
#define SCRATCHPAD0_CORE_2  ((volatile int *) (0x02C00200))
#define SHARED_SPACE ((volatile int *) (0x00400f00))
#define CR_THREAD  ((volatile int *) (0x00C00004))
#define CR_THREAD_PC_EN  ((volatile int *)  (0x00C00150))
#define CR_CORE_ID ((volatile int *) (0x00C00008))

int main() {
    int ThreadId = CR_THREAD[0];
    int res ;
    int num11 = 9;
    int num21 = 8;
    int num12 = 7;
    int num22 = 19;
    switch (ThreadId) //the CR Address
    {
        case 0x0 : //expect each thread to get from the MEM_WRAP the correct Thread.
            // 1.Compute some number
            // 2.Send result to 2nd Core
            // 3.Busy wait until data from 2nd core arrived
            // 4.Compute something with a new number 
            // 5.Indicate computation was done
            // 6.If this is the master core return and break; Else - Busy wait

            if(CR_CORE_ID[0] == 1) {
                res = 10*20;            //Compute some number
                SCRATCHPAD0_CORE_2[0] = res;        //Send result to 2nd Core
                SCRATCHPAD0_CORE_2[1] = 1;          
                while(SCRATCHPAD0_CORE_1[1] == 0){};    //Busy wait until data from 2nd core arrived
                SHARED_SPACE[0] = SCRATCHPAD0_CORE_1[0]; //Use Datat locally
                // return and exit to EBRAEK
            }
            else if(CR_CORE_ID[0] == 2) {
                res = 30*20;
                SCRATCHPAD0_CORE_1[0] = res;
                SCRATCHPAD0_CORE_1[1] = 1;
                while(SCRATCHPAD0_CORE_2[1] == 0){};
                SHARED_SPACE[0] = SCRATCHPAD0_CORE_2[0];
                while(1);
            }


            
            //CR_SCRATCHPAD0 - Core0 Data
            //CR_SCRATCHPAD1 - Core1 Data
            //CR_SCRATCHPAD2 - Core0 Ready flag
            //CR_SCRATCHPAD3 - Core1 Ready flag            
        case 0x1 :
            // Write 0 to PC_En[1] CR
            CR_THREAD_PC_EN[1] = 0;
            __asm("nop;nop;" : [res] "=r" (res));
        break;
        case 0x2 :
            // Write 0 to PC_En[2] CR
            CR_THREAD_PC_EN[2] = 0;
            __asm("nop;nop;" : [res] "=r" (res));       
        break;
        case 0x3 :
            // Write 0 to PC_En[3] CR
            CR_THREAD_PC_EN[3] = 0;
            __asm("nop;nop;" : [res] "=r" (res));         
        break;
    }   
    
    return 0;

}

