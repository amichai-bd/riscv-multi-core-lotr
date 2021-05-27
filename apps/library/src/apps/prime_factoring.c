#include "gpc_entry.h"
#include "gpc_defs.h"
#include "gpc_basic_types.h"
#include "gpc_utils.h"

typedef struct global_s {
    // channels[i][i] - current index of tid i. for master it's the number we factorize
    // channels[i][j] - message from i to j
    uint32_t channels[GPC_CORE_N_THREADS][GPC_CORE_N_THREADS];
} global_t;

void gpc_global_setup(
    void *core_global, size_t core_global_size,
    volatile void *cr_space) {
    global_t *g = (global_t *) core_global;
    gpc_memset(g, sizeof(*g), 0);
}

void gpc_local_setup(uint32_t tid,
    void *tls, size_t tls_size,
    void *core_global, size_t core_global_size,
    volatile void *cr_space) {
    global_t *g = (global_t *) core_global;
    // TODO: an ugly hack to pass input. real world code will need a better mechanism
    // input was generated in a fair dice roll. guaranteed to be random
    if(tid == GPC_CORE_BOOTSTRAP_THREAD_ID) {
        g->channels[tid][tid] = 4286436431;
        for(uint32_t i=0;i<GPC_CORE_N_THREADS;i++) {
            if(i==tid) {
                continue;
            }
            g->channels[tid][i] = 1;
        }
    }
    else {
        uint32_t upper_bound = gpc_wait_for_non_zero(&g->channels[GPC_CORE_BOOTSTRAP_THREAD_ID][GPC_CORE_BOOTSTRAP_THREAD_ID]);
        upper_bound -= tid;
        g->channels[tid][tid] = upper_bound;
        // must wait for the master to start us
        gpc_wait_for_non_zero(&g->channels[GPC_CORE_BOOTSTRAP_THREAD_ID][tid]);
    }
}

void gpc_loop(uint32_t tid,
    void *tls, size_t tls_size,
    void *core_global, size_t core_global_size,
    volatile void *cr_space) {
    if(tid == GPC_CORE_BOOTSTRAP_THREAD_ID) {
        // TODO: poll threads
    } else {
        // TODO: do calculation
        // TODO: how do we calculate modulus without muldiv?
    }
}
