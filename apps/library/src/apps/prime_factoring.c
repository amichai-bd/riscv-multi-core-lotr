#include "gpc_entry.h"
#include "gpc_defs.h"
#include "gpc_basic_types.h"
#include "gpc_utils.h"

_Static_assert(GPC_CORE_BOOTSTRAP_THREAD_ID == 0, "Bootstreap thread ID != 0");
#define MANAGER_TID GPC_CORE_BOOTSTRAP_THREAD_ID

typedef enum thread_state_e {
    STATE_NOT_STARTED = 0,
    STATE_START,
    STATE_RUNNING,
    STATE_FINISHED
} thread_state;

typedef struct global_s {
    uint32_t n; // number to factorize (input)
    // thread state:
    // bit 0: is_finished (0 - not finished, 1 - finished)
    // bit 1: has_divisors (0 - no divisors found, 1 - divisors found)
    // workers done when bit 0 is set for all
    // prime if bit 1 is 0 for all
    uint32_t state[GPC_CORE_N_THREADS];
} global_t;

typedef struct local_s {
    uint32_t current; // current iteration value
    uint32_t step; // step size
} local_t;

// TODO: use a more efficient implementation
static inline uint32_t mod(uint32_t a, uint32_t b) {
    while(a > b) {
        a -= b;
    }
    return a;
}

void gpc_global_setup(
    void *core_global, size_t core_global_size,
    volatile void *cr_space) {
    global_t *g = (global_t *) core_global;
    gpc_memset(g, sizeof(*g), 0);
    // TODO: an ugly hack to pass input. real world code will need a better mechanism
    // input was generated in a fair dice roll. guaranteed to be random
    g->n = 4286436431;

}

static void manager_local_setup(global_t *g, local_t *l) {
}

static void worker_local_setup(uint32_t tid, global_t *g, local_t *l) {
    l->current = (g->n >> 1) + 1;
    l->current -= tid;
    l->step = GPC_CORE_N_THREADS - 1;
}

void gpc_local_setup(uint32_t tid,
    void *tls, size_t tls_size,
    void *core_global, size_t core_global_size,
    volatile void *cr_space) {
    global_t *g = (global_t *) core_global;
    local_t *l = (local_t *) tls;

    gpc_memset(l, sizeof(*l), 0);

    if(tid == MANAGER_TID) {
        manager_local_setup(g, l);
    }
    else {
        worker_local_setup(tid, g, l);
    }
}

static void manager_loop(global_t *g, local_t *l) {
    uint32_t state = 1;
    for(uint32_t i=0;i<GPC_CORE_N_THREADS;i++) {
        if(i == MANAGER_TID) {
            continue;
        }
        state &= ~(g->state[i] & 1);
        state |= (g->state[i] & 2);
    }
    // bit 0 is 1 => someone is still running
    // bit 1 is 0 => prime, 1 => composite
    g->state[MANAGER_TID] |= (~state) & 1;
    g->state[MANAGER_TID] |= state & 2;
}

static void worker_loop(uint32_t tid, global_t *g, local_t *l) {
    if(l->current < 2) {
        g->state[tid] |= 1;
    }
    if(g->state[tid] & 1) {
        return;
    }
    // TODO: implement modulus
    if(mod(g->n, l->current) != 0) {
        g->state[tid] |= 3; // no need to go further - set as done and composite
    }

    if(l->current < l->step) {
        l->current = 0;
    } else {
        l->current -= l->step;
    }
}

void gpc_loop(uint32_t tid,
    void *tls, size_t tls_size,
    void *core_global, size_t core_global_size,
    volatile void *cr_space) {
    global_t *g = (global_t *) core_global;
    local_t *l = (local_t *) tls;
    if(tid == MANAGER_TID) {
        manager_loop(g, l);
    } else {
        worker_loop(tid, g, l);
    }
}
