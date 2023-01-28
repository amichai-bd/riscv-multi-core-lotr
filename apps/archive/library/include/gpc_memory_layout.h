#ifndef _GPC_MEMORY_LAYOUT_H_
#define _GPC_MEMORY_LAYOUT_H_

/**
 * Default values for memory layout constants. Actual values can be overridden by build configuration
 * Used to generate LD script and may be included by entry point, so it must contain preprocessor
 * directives only
 */

#include "gpc_defs.h"

/**
 * Number of agent ID bits in GPC memory address
 */
#ifndef GPC_MEM_AGENT_ID_BITS
    #define GPC_MEM_AGENT_ID_BITS (8)
#endif

// Base of CR space address (CR region at the right place, other bits zero)
#define GPC_MEM_REGION_OFFSET (32 - 2 - GPC_MEM_AGENT_ID_BITS)
#define GPC_MEM_REGION_BASE(region) ((region) << GPC_MEM_REGION_OFFSET)

/**
 * I_MEM size
 */
#ifndef GPC_MEM_I_MEM_SIZE
#define GPC_MEM_I_MEM_SIZE 0x800
#endif

/**
 * D_MEM size
 */
#ifndef GPC_MEM_D_MEM_SIZE
#define GPC_MEM_D_MEM_SIZE 0x800
#endif

/**
 * Base address of D_MEM
 */
#define GPC_MEM_D_MEM_BASE GPC_MEM_REGION_BASE(GPC_MEM_REGION_D_MEM)

/**
 * Base address of I_MEM
 */
#define GPC_MEM_I_MEM_BASE GPC_MEM_REGION_BASE(GPC_MEM_REGION_I_MEM)

/**
 * Base address of CR space
 */
#define GPC_MEM_CR_BASE GPC_MEM_REGION_BASE(GPC_MEM_REGION_CR)

/**
 * Default D_MEM layout (sizes for 2k, see relative size for division)
 *
 * +========+======+===============+===============+
 * | Offset | Size |    Region     | Relative size |
 * +========+======+===============+===============+
 * |   1936 |  112 | Stack[3]      | 7/128         |
 * +--------+------+---------------+---------------+
 * |   1824 |  112 | Stack[2]      | 7/128         |
 * +--------+------+---------------+---------------+
 * |   1712 |  112 | Stack[1]      | 7/128         |
 * +--------+------+---------------+---------------+
 * |   1600 |  112 | Stack[0]      | 7/128         |
 * +--------+------+---------------+---------------+
 * |   1264 |  336 | Local data[3] | 21/128        |
 * +--------+------+---------------+---------------+
 * |    928 |  336 | Local data[2] | 21/128        |
 * +--------+------+---------------+---------------+
 * |    592 |  336 | Local data[1] | 21/128        |
 * +--------+------+---------------+---------------+
 * |    256 |  336 | Local data[0] | 21/128        |
 * +--------+------+---------------+---------------+
 * |    128 |  256 | Global data   | 1/8 - 128B    |
 * +--------+------+---------------+---------------+
 * |     96 |   32 | GPC params[3] |               |
 * +--------+------+---------------+---------------+
 * |     64 |   32 | GPC params[2] |               |
 * +--------+------+---------------+---------------+
 * |     32 |   32 | GPC params[1] |               |
 * +--------+------+---------------+---------------+
 * |      0 |   32 | GPC params[0] |               |
 * +--------+------+---------------+---------------+
 */

#define GPC_MEM_GPC_PARAMS_BASE GPC_MEM_D_MEM_BASE
#define GPC_MEM_GPC_PARAMS_SIZE 32

/**
 * Global data base (base of D_MEM)
 */
#ifndef GPC_MEM_GLOBAL_DATA_BASE
#define GPC_MEM_GLOBAL_DATA_BASE GPC_MEM_D_MEM_BASE
#endif

/**
 * Global data size
 * Note: GPC params will be stolen from here
 */
#ifndef GPC_MEM_GLOBAL_DATA_SIZE
#define GPC_MEM_GLOBAL_DATA_SIZE (GPC_MEM_D_MEM_SIZE>>3)
#endif

#ifndef GPC_MEM_LOCAL_DATA_BASE
#define GPC_MEM_LOCAL_DATA_BASE (GPC_MEM_GLOBAL_DATA_BASE + GPC_MEM_GLOBAL_DATA_SIZE)
#endif

/**
 * Size of single thread's local data size
 */
#ifndef GPC_MEM_LOCAL_DATA_SIZE
#define GPC_MEM_LOCAL_DATA_SIZE ((GPC_MEM_D_MEM_SIZE >> 7) * 21)
#endif

#ifndef GPC_MEM_STACK_BASE
#define GPC_MEM_STACK_BASE GPC_MEM_LOCAL_DATA_BASE + GPC_CORE_N_THREADS * GPC_MEM_LOCAL_DATA_SIZE
#endif

#ifndef GPC_MEM_STACK_SIZE
#define GPC_MEM_STACK_SIZE ((GPC_MEM_D_MEM_SIZE >> 7) * 7)
#endif

// TODO: add sanity checks to break build on failure
#define GPC_MEM_D_MEM_TOP (GPC_MEM_STACK_BASE + GPC_CORE_N_THREADS * GPC_MEM_STACK_SIZE)

#if GPC_MEM_D_MEM_TOP > GPC_MEM_D_MEM_BASE + GPC_MEM_D_MEM_SIZE
#error "Memory layout exceeds D_MEM size"
#elif GPC_MEM_D_MEM_TOP < GPC_MEM_D_MEM_BASE + GPC_MEM_D_MEM_SIZE
#warn "D_MEM is not fully utilized"
#endif

#if GPC_CORE_N_THREADS * GPC_MEM_GPC_PARAMS_SIZE > GPC_MEM_GLOBAL_DATA_SIZE
#error "Not enough space for GPC params"
#endif

#endif
