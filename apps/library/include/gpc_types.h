#ifndef __GPC_TYPES_H_
#define __GPC_TYPES_H_

#include "gpc_defs.h"
#include "gpc_basic_types.h"

/**
 * Layout of a GPC core memory address
 */
typedef struct gpc_addr_s {
    union {
        struct {
            uint32_t offset: 32 - 2 - GPC_ADDR_AGENT_ID_BITS;
            uint32_t region: 2;
            uint32_t agent_id: GPC_ADDR_AGENT_ID_BITS;
        };
        uint32_t raw;
    };
} gpc_addr_t;


/**
 * Layout of core CR space
 **/
typedef struct gpc_core_cr_s {
    uint32_t address_bits;
    uint32_t my_thread_id;
    uint32_t my_agent_id;
    uint32_t supported_arch;
} gpc_core_cr_t;

#endif
