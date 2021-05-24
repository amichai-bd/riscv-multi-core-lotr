SEARCH_DIR(.)
__DYNAMIC  =  0;

MEMORY
{
    instrram    : ORIGIN = 0x00000000, LENGTH = 0x0800
    dataram     : ORIGIN = 0x00000800, LENGTH = 0x0800
}

SECTIONS
{
    .text : {
        . = ALIGN(4);
        *(.start);
        *(.text);
    }  > instrram
}

