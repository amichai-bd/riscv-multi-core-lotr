#ifndef __GPC_ENTRY_H_
#define __GPC_ENTRY_H_

#include "gpc_defs.h"

/**
 * Setup entry point: executed once on load
 *
 * @param tid thread ID
 * @param tls pointer to thread-local storage
 * @param tls_size size of thread-local storage
 * @param core_global pointer to core-global storage
 * @param core_global_size size of core-global storage
 * @param cr_space pointer to CR space
 */
extern void gpc_setup(uint32_t tid,
    void *tls, size_t tls_size,
    void *core_global, size_t core_global_size,
    void *cr_space);

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
extern void gpc_loop(uint32_t tid,
    void *tls, size_t tls_size,
    void *core_global, size_t core_global_size,
    void *cr_space);

#endif
