#ifndef __GPC_ENTRY_H_
#define __GPC_ENTRY_H_

#include "gpc_basic_types.h"
#include "gpc_types.h"

/**
 * Global setup entry point
 *
 * Invoked by a single thread on reset. Other threads are asleep
 *
 * @param core_global pointer to core-global storage
 * @param core_global_size size of core-global storage
 * @param cr_space pointer to CR space
 */
extern void gpc_global_setup(const gpc_params_t *gpc_params);

/**
 * Local setup entry point
 *
 * Executed once per thread after global setup
 *
 * @param tid thread ID
 * @param tls pointer to thread-local storage
 * @param tls_size size of thread-local storage
 * @param core_global pointer to core-global storage
 * @param core_global_size size of core-global storage
 * @param cr_space pointer to CR space
 */
extern void gpc_local_setup(const gpc_params_t *gpc_params);

/**
 * Loop entry point: executed in an infinite loop after setup
 *
 * @param tid thread ID
 * @param tls pointer to thread-local storage
 * @param tls_size size of thread-local storage
 * @param core_global pointer to core-global storage
 * @param core_global_size size of core-global storage
 * @param cr_space pointer to CR space
 */
extern void gpc_loop(const gpc_params_t *gpc_params);

#endif
