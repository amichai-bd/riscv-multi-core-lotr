#ifndef __GPC_ENTRY_H_
#define __GPC_ENTRY_H_

#include "gpc_basic_types.h"
#include "gpc_types.h"

/**
 * Global setup entry point
 *
 * Invoked by a single thread on reset. Other threads are asleep
 *
 * @param gpc_params GPC parameters
 */
extern void gpc_global_setup(const gpc_params_t *gpc_params);

/**
 * Local setup entry point
 *
 * Executed once per thread after global setup
 *
 * @param gpc_params GPC parameters
 */
extern void gpc_local_setup(const gpc_params_t *gpc_params);

/**
 * Loop entry point: executed in an infinite loop after setup
 *
 * @param gpc_params GPC parameters
 */
extern void gpc_loop(const gpc_params_t *gpc_params);

#endif
