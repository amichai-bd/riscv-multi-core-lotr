#ifndef __GPC_DEFS_H_
#define __GPC_DEFS_H_

/** GPC core memory region types */
#define GPC_MEM_REGION_I_MEM (0x0) /** Core instruction memory */
#define GPC_MEM_REGION_D_MEM (0x1) /** Core data memory */
#define GPC_MEM_REGION_CR (0x3) /** Core CR space */

/** Default values for build-configurable knobs */

// Hardware params

/**
 * Number of threads per core
 */
#ifndef GPC_CORE_N_THREADS
    #define GPC_CORE_N_THREADS (4)
#endif

/**
 * Bootstrap thread ID
 */
#ifndef GPC_CORE_BOOTSTRAP_THREAD_ID
    #define GPC_CORE_BOOTSTRAP_THREAD_ID (0)
#endif

// Sanity check: thread ID must be valid
#if (GPC_CORE_BOOTSTRAP_TREAD_ID < 0) || (GPC_CORE_BOOTSTRAP_THREAD_ID >= GPC_CORE_N_THREADS)
    #error "Bootstrap thread ID must be [0, N_THREADS)"
#endif

#endif
