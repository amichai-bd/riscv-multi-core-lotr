#ifndef __GPC_TYPES_H_
#define __GPC_TYPES_H_

#include "gpc_defs.h"
#include "gpc_basic_types.h"

/**
 * Layout of core CR space
 **/
typedef struct gpc_core_cr_s {
    uint32_t address_bits;
    uint32_t my_thread_id;
    uint32_t my_agent_id;
    uint32_t supported_arch;
} core_cr_t;

#endif
