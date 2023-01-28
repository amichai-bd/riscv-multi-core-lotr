#include "gpc_utils.h"

void gpc_memset(void *p, size_t s, uint32_t value) {
    while(s > 0) {
        *((uint32_t *)p) = value;
        p += 4;
        s -= 4;
    }
}

uint32_t gpc_wait_for_non_zero(uint32_t *p) {
    while(*((volatile uint32_t *) p) == 0) {
        // TODO: add some pause?
    }
    return *p;
}
