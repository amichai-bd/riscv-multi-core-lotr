// 4KB of D_MEM
// 2048 - 4096 - Shared
//
// 1536 -    2048 - Thread 1
// 1024 -    1536 - Thread 1
// 512  -    1024 - Thread 1
// 0    -    512  - Thread 0

// REGION == 2'b01;

#define D_MEM_SHARED (*(volatile int (*)[5])(0x00401000))

int main()
{
    int a[5] = {1,49,36,50,66};
    int i = 0, j = 0, tmp;
    int n=5;
    for (i = 0; i < n; i++) {
        for (j = 0; j < n - i - 1; j++) {
            if (a[j] > a[j + 1]) {
                tmp = a[j];
                a[j] = a[j + 1];
                a[j + 1] = tmp;
            }
        }
    }
	D_MEM_SHARED[0]=a[0];
    D_MEM_SHARED[1]=a[1];
    D_MEM_SHARED[2]=a[2];
    D_MEM_SHARED[3]=a[3];
    D_MEM_SHARED[4]=a[4];
}
