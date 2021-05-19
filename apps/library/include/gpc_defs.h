#ifndef __GPC_DEFS_H_
#define __GPC_DEFS_H_

/** GPC core memory region types */
#define GPC_ADDR_REGION_I_MEM (0x0U) /** Core instruction memory */
#define GPC_ADDR_REGION_D_MEM (0x1U) /** Core data memory */
#define GPC_ADDR_REGION_CR (0x3U) /** Core CR space */

/** Default values for build-configurable knobs */

// Hardware params

/**
 * Number of agent ID bits in GPC memory address
 */
#ifndef GPC_ADDR_AGENT_ID_BITS
    #define GPC_ADDR_AGENT_ID_BITS (8U)
#endif

#endif
