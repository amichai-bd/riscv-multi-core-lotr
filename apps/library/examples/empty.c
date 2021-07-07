#include "gpc_entry.h"
#include "gpc_defs.h"
#include "gpc_basic_types.h"
#include "gpc_cr.h"

void gpc_global_setup(const gpc_params_t *gpc_params) {
	volatile uint32_t *cr_base = (volatile uint32_t *) GPC_MEM_CR_BASE;
	uint32_t tid = cr_base[GPC_CR_MY_THREAD_ID>>2];
	for(uint32_t i=0;i<50;i++) {
		tid = cr_base[GPC_CR_MY_THREAD_ID>>2];
	}
}

void gpc_local_setup(const gpc_params_t *gpc_params) {
	volatile uint32_t *cr_base = (volatile uint32_t *) GPC_MEM_CR_BASE;
	uint32_t tid = cr_base[GPC_CR_MY_THREAD_ID>>2];
	cr_base[(GPC_CR_SCRATCHPAD0>>2) + tid] = (tid << 30);
}

void gpc_loop(const gpc_params_t *gpc_params) {
	volatile uint32_t *cr_base = (volatile uint32_t *) GPC_MEM_CR_BASE;
	uint32_t tid = cr_base[GPC_CR_MY_THREAD_ID>>2];
	cr_base[(GPC_CR_SCRATCHPAD0>>2) + tid] += (1 << tid);
}
