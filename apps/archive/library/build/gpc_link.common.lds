#include "gpc_memory_layout.h"

SEARCH_DIR(.)
__DYNAMIC  =  0;

MEMORY
{
    i_mem          : ORIGIN = GPC_MEM_I_MEM_BASE, LENGTH = GPC_MEM_I_MEM_SIZE
    global_data    : ORIGIN = GPC_MEM_GLOBAL_DATA_BASE, LENGTH = GPC_MEM_GLOBAL_DATA_SIZE
}

SECTIONS
{
    .text : {
        . = ALIGN(4);
        *(.start);
        *(.text);
        . = ORIGIN(i_mem) + LENGTH(i_mem) - 1;
        BYTE(0);
    }  > i_mem

    .data : {
        . = ALIGN(4);
        . = GPC_MEM_GLOBAL_DATA_BASE - GPC_MEM_D_MEM_BASE;
        . += GPC_MEM_GPC_PARAMS_SIZE * GPC_CORE_N_THREADS;
        *(.rodata);
        *(.sdata);
        *(.sbss);
    } > global_data
    .bss : {} > global_data
}

