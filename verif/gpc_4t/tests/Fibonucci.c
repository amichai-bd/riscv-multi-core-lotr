/*Fibonucci.c
Calculate the n'th number of the Fibbonucci series
test owner: Adi Levy
Created : 06/06/2021
*/
// 4KB of D_MEM
// 0x400800 - 0x400fff - Shared
//
// 0x400600 - 0x400800 - Thread 3
// 0x400400 - 0x400600 - Thread 2
// 0x400200 - 0x400400 - Thread 1
// 0x400000 - 0x400200 - Thread 0

// REGION == 2'b01;

int fib(unsigned n)
{
    if (n == 0)
        return 1;
    if (n == 1)
        return 1;
    return fib(n-1) + fib(n-2);
}
 
#define MMIO_GENERAL  ((volatile int *) (0x00400f00))

int main() {
    unsigned x = fib(9);
    MMIO_GENERAL[62] = x;
    return 0;
}
