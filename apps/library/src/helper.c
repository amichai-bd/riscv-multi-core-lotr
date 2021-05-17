#include "gpc_types.h"

uint32_t multiply(uint32_t a, uint32_t b) {
    uint32_t ret = 0;
    while(b > 0) {
        ret += a;
        b--;
    }
    return ret;
}

uint32_t fib(uint32_t a) {
    if(a <= 1) return a;
    return fib(a-1) + fib(a-2);
}
