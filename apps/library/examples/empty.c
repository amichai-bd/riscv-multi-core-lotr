#include "gpc_entry.h"
#include "gpc_defs.h"
#include "gpc_basic_types.h"

void gpc_global_setup(
    void *core_global, size_t core_global_size,
    volatile void *cr_space) {
}

void gpc_local_setup(uint32_t tid,
    void *tls, size_t tls_size,
    void *core_global, size_t core_global_size,
    volatile void *cr_space) {
}

void gpc_loop(uint32_t tid,
    void *tls, size_t tls_size,
    void *core_global, size_t core_global_size,
    volatile void *cr_space) {
}
