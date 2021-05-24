#ifndef __GPC_UTILS_H_
#define __GPC_UTILS_H_

#include "gpc_basic_types.h"

/**
 * Sets value into a given memory range
 * 
 * @note Currently region (base and size) must be 32-bit aligned
 * @note May be optimized out, not for security purposes
 *
 * @param p pointer to memory
 * @param s size of the region
 * @param value 32-bit value to write into memory
 */
void gpc_memset(void *p, size_t s, uint32_t value);

/**
 * Waits until the value of the given memory word is non-zero
 *
 * @note use with caution: this may cause deadlock
 * @param p address to poll
 * @return value after wait is over
 */
uint32_t gpc_wait_for_non_zero(uint32_t *p);

#endif
