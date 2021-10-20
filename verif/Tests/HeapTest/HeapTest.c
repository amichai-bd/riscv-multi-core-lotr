#define MMIO_GENERAL  ((volatile int *) (0x00400f00))
int main() {
	int a[20]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20};
    MMIO_GENERAL[0] = a[16];
    
    return 0;
}