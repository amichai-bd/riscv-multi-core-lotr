#include "gpc_core.h"
#include "gpc_defs.h"

volatile gpc_core_cr_t *gpc_get_agent_cr_space(uint32_t agent_id) {
    gpc_addr_t ret;
    ret.raw = 0;
    // TODO: check agent_id validity. how to fail?
    ret.agent_id = agent_id;
    ret.region = GPC_MEM_REGION_CR;
    return (volatile gpc_core_cr_t *) ret.raw;
}
