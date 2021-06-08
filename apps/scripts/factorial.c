// 4KB of D_MEM
// 2048 - 4096 - Shared
//
// 1536 -    2048 - Thread 1
// 1024 -    1536 - Thread 1
// 512  -    1024 - Thread 1
// 0    -    512  - Thread 0

// REGION == 2'b01;

#define D_MEM_SHARED (*(volatile int (*)[1])(0x00400f00))

int factorial(int a){
    if(a==1)
        return 1;
    int c=factorial(a-1);
    int b = a+c;
    return b;
}

int main()
{
    int fact=factorial(3);
	D_MEM_SHARED[0]=fact;
}
