#ifndef __GPC_TYPES_H_
#define __GPC_TYPES_H_

#include "gpc_defs.h"

/**
 * Defines the layout of core CR space
 **/
typedef struct core_cr_s {
    volatile uint32_t whoami;
} core_cr_t;

#endif
