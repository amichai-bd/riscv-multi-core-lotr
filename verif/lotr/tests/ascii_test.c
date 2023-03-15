#include "LOTR_defines.h"
#include "graphic.h"
int main() {
    int UniqeId = CR_WHO_AM_I[0];
    switch (UniqeId) //the CR Address
    {
        case 0x4 : //  
        rvc_printf("WE ARE THE PEOPLE THAT RULE THE WORLD.\n");
        rvc_printf("A FORCE RUNNING IN EVERY BOY AND GIRL.\n");
        rvc_printf("ALL REJOICING IN THE WORLD, TAKE ME NOW WE CAN TRY.\n");
        rvc_printf("0123456789\n");
        break;
        default :
            while(1); 
        break;
       
    }// case

return 0;

}