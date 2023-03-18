#include "LOTR_defines.h"
#include "graphic.h"

int main()
{
    int UniqeId  = CR_WHO_AM_I[0];
    int button_1;
    int button_2;
    int sw;
    switch (UniqeId) //the CR Address
    {
        case 0x4 : // Core 1 Thread 0
        clear_screen();
        set_cursor(0,0);
        //rvc_printf("WE ARE THE PEOPLE THAT RULE THE WORLD.\n");
        rvc_printf("                              \n");
        while(1){
            rvc_printf("                              \n");
            set_cursor(0,0);
            READ_REG(sw,SWITCH_FGPA);
            rvc_print_int(sw);
            set_cursor(5,5);
            READ_REG(button_1,BUTTON1_FGPA);
            rvc_print_int(button_1);
            set_cursor(6,6);
            READ_REG(button_2,BUTTON2_FGPA);
            rvc_print_int(button_2);
            //if(button_1 == 0){
            //    rvc_printf("Button_1 0\n");
            //}
            //else{
            //    rvc_printf("Button 1\n");
            //}
        //for(int i = 0; i < 20; i=i+5){
        //    draw_symbol(0, 15, 15 + i);
        //    rvc_delay(400000);
        //    draw_symbol(5, 15, 15 + i);

        //    draw_symbol(1, 15, 16 +i);
        //    rvc_delay(400000);
        //    draw_symbol(5, 15, 16 +i);

        //    draw_symbol(2, 15, 17 +i);
        //    rvc_delay(400000);
        //    draw_symbol(5, 15, 17 +i);

        //    draw_symbol(3, 15, 18 +i);
        //    rvc_delay(400000);
        //    draw_symbol(5, 15, 18 +i);

        //    draw_symbol(4, 15, 19 +i);
        //    rvc_delay(400000);
        //    draw_symbol(5, 15, 19 +i);
        //}
        }
        rvc_printf("0123456789\n");
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