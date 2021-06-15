int fib(int n)
{
    if (n == 0)
        return 1;
    if (n == 1)
        return 1;
    return fib(n-1) + fib(n-2);
}
 
#define MMIO_GENERAL  (*(volatile int (*)[64])(0x00400F00))//

int main() {
    MMIO_GENERAL[63]=fib(6);
    return 0;
}