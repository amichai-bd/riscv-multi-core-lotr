#ifndef __GPC_CORE_H_
#define __GPC_CORE_H_

#include "gpc_types.h"

/**
 * Gets a pointer to the CR space of the given agent
 *
 * @param agent_id desired agent ID (zero for current agent)
 * @return pointer to the agent's CR space
 */
volatile gpc_core_cr_t *gpc_get_agent_cr_space(uint32_t agent_id);

#endif
