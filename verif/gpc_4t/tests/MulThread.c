/*MultiThread.c
calculate 4 different arithmatic calculations one on each thread
test owner: Amichai BD
Created : 22/06/2021
*/
// 4KB of D_MEM
// 0x400800 - 0x400fff - Shared
//
// 0x400600 - 0x400800 - Thread 3
// 0x400400 - 0x400600 - Thread 2
// 0x400200 - 0x400400 - Thread 1
// 0x400000 - 0x400200 - Thread 0

// REGION == 2'b01;
int Thread0 ( ){
    int a = 20;
    int b = 5;
    int c;
    c = a * b; // c = 100
    return c;
}

int Thread1 ( ){
    int a = 8;
    int b = 25;
    int c;
    c = a * b; // c = 200
    return c;
}

int Thread2 ( ){
    int a = 10;
    int b = 30;
    int c;
    c = a * b; // c = 300
    return c;
}

int Thread3 ( ){
    int a = 100;
    int b = 4;
    int c;
    c = a * b; // c = 400
    return c;
}
 
#define SHARED_SPACE  ((volatile int *) (0x00400f00))
#define CR_THREAD  ((volatile int *) (0x00C00004))
#define CR_SCRATCHPAD  ((volatile int *) (0x00C00200))

int main() {
    int x = CR_THREAD[0];

    switch (x) //the CR Address
    {
        case 0x0 : //expect each thread to get from the MEM_WRAP the correct Thread.
            SHARED_SPACE[0] =  Thread0();
            CR_SCRATCHPAD[0] = 1 ;
            while( !CR_SCRATCHPAD[1] || !CR_SCRATCHPAD[2] || !CR_SCRATCHPAD[3] ){} //busy wait            
        break;
        case 0x1 :
            SHARED_SPACE[1] =  Thread1();
            CR_SCRATCHPAD[1] = 1 ;    
            while(1){} //busy wait            
        break;
        case 0x2 :
            SHARED_SPACE[2] =  Thread2();
            CR_SCRATCHPAD[2] = 1 ;
            while(1){} //busy wait
        break;
        case 0x3 :
            SHARED_SPACE[3] =  Thread3();
            CR_SCRATCHPAD[3] = 1 ;
            while(1){} //busy wait
        break;
    }   

}

