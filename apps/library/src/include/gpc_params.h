#ifndef __GPC_PARAMS_H_
#define __GPC_PARAMS_H_

#include "gpc_memory_layout.h"

// MUST BE CONSISTENT WITH gpc_params_t OFFSETS!!!!

#define PARAMS_OFFSET_TID               0
#define PARAMS_OFFSET_GLOBAL_DATA       4
#define PARAMS_OFFSET_GLOBAL_DATA_SIZE  8
#define PARAMS_OFFSET_LOCAL_DATA        12
#define PARAMS_OFFSET_LOCAL_DATA_SIZE   16
#define PARAMS_OFFSET_RESERVED_START    20
#define PARAMS_SIZE                     GPC_MEM_GPC_PARAMS_SIZE
#endif
