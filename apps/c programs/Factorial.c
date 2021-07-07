/*Factorial.c
factorial with addition
test owner: Saar Kadosh
Created : 05/2021
*/
// 4KB of D_MEM
// 0x400800 - 0x400fff - Shared
//
// 0x400600 - 0x400800 - Thread 3
// 0x400400 - 0x400600 - Thread 2
// 0x400200 - 0x400400 - Thread 1
// 0x400000 - 0x400200 - Thread 0

// REGION == 2'b01;

#define D_MEM_SHARED (*(volatile int (*)[1])(0x00400f00))

int factorial(int a){
    if(a==1)
        return 1;
    int b = a+factorial(a-1);
    return b;
}

int main()
{
    int fact=factorial(4);
	D_MEM_SHARED[0]=fact;
}
