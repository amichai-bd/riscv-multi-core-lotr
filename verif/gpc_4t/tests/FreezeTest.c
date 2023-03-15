#define SHARED_SPACE  ((volatile int *) (0x00400f00))
#define CR_THREAD0_PC_EN ((volatile int *) (0x00C00150))
#define CR_THREAD1_PC_EN ((volatile int *) (0x00C00154))
#define CR_THREAD2_PC_EN ((volatile int *) (0x00C00158))
#define CR_THREAD3_PC_EN ((volatile int *) (0x00C0015c))
#define CR_THREAD  ((volatile int *) (0x00C00004))
#define CR_SCRATCHPAD  ((volatile int *) (0x00C00200))


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


int main() {

    switch (CR_THREAD[0]) //the CR Address
    {
        case 0x0 : //expect each thread to get from the MEM_WRAP the correct Thread.
            SHARED_SPACE[0] =  Thread0();
            CR_THREAD1_PC_EN[0]=1;
            CR_THREAD2_PC_EN[0]=1;
            CR_THREAD3_PC_EN[0]=1;
            while( !CR_SCRATCHPAD[1] || !CR_SCRATCHPAD[2] || !CR_SCRATCHPAD[3] ){} //busy wait             
        break;
        case 0x1 :
            CR_THREAD1_PC_EN[0]=0;
            SHARED_SPACE[1] =  Thread1();
            CR_SCRATCHPAD[1] = 1 ;  
            while(1){} //busy wait          
        break;
        case 0x2 :
            CR_THREAD2_PC_EN[0]=0;
            SHARED_SPACE[2] =  Thread2();
            CR_SCRATCHPAD[2] = 1 ;  
            while(1){} //busy wait
        break;
        case 0x3 :
            CR_THREAD3_PC_EN[0]=0;
            SHARED_SPACE[3] =  Thread3();
            CR_SCRATCHPAD[3] = 1 ;  
            while(1){} //busy wait
        break;
    }   
    return 0;
}