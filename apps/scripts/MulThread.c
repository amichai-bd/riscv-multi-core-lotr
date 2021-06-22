/*MultiThread.c
calculate 4 different arithmatic calculations one on each thread
test owner: Adi Levy
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
int main() {
    int x = CR_THREAD[0];

  
            SHARED_SPACE[0] =  Thread0();

            SHARED_SPACE[1] =  Thread1();


            SHARED_SPACE[2] =  Thread2();


            SHARED_SPACE[3] =  Thread3();

}

