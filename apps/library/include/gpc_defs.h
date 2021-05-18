#ifndef __GPC_DEFS_H_
#define __GPC_DEFS_H_

#define NULL ((void *) 0)

typedef unsigned int uint32_t;
_Static_assert(sizeof(uint32_t) == 4, "uint32_t not 32-bit");

typedef uint32_t size_t;

#endif
