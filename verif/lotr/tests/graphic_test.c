#include "LOTR_defines.h"
#include "graphic.h"

int main()
{
    int UniqeId  = CR_WHO_AM_I[0];
    switch (UniqeId) //the CR Address
    {
        case 0x4 : // Core 1 Thread 0
        rvc_printf("WE ARE THE PEOPLE THAT RULE THE WORLD.\n");
        draw_symbol(0, 15, 15);
        draw_symbol(1, 15, 16);
        draw_symbol(2, 15, 17);
        draw_symbol(3, 15, 18);
        draw_symbol(4, 15, 19);
        case 0x5 : // Core 1 Thread 1
        set_cursor(10,0);
        rvc_printf("A FORCE RUNNING IN EVERY BOY AND GIRL.\n");
        case 0x6 : // Core 1 Thread 2
        set_cursor(20,0);
        rvc_printf("ALL REJOICING IN THE WORLD, TAKE ME NOW WE CAN TRY.\n");
        case 0x7 : // Core 1 Thread 3
        set_cursor(30,0);
        rvc_printf("0123456789\n");
        case 0x8 : // Core 2 Thread 0
        draw_symbol(0, 25, 15);
        draw_symbol(1, 25, 16);
        draw_symbol(2, 25, 17);
        break;
        default :
            while(1); 
        break;
    }// case

if(UniqeId != 0x4){
    while(1); 
}

    return 0;
}