/*led_blinky.c
calculate 4 different arithmatic calculations one on each thread
test owner: Saar Kadosh
Created : 22/08/2021
*/


#include "LOTR_defines.h"

void delay(){
    int timer = 0;       
    while(timer < 200000){
        timer++;
    }      
}

int main() {
    int UniqeId = CR_WHO_AM_I[0];
    int timer = 0;
    int skipLed = 1;
    int i = 0, j = 0 , k = 0 , l =0, m = 0;
    int segCounter [16];
    segCounter[0] = 0b1000000;
    segCounter[1] = 0b1111001;
    segCounter[2] = 0b0100100;
    segCounter[3] = 0b0110000;
    segCounter[4] = 0b0011001;
    segCounter[5] = 0b0010010;
    segCounter[6] = 0b0000010;
    segCounter[7] = 0b1111000;
    segCounter[8] = 0b0000000;
    segCounter[9] = 0b0011000;
    segCounter[10] = 0b0001000;
    segCounter[11] = 0b0000011;
    segCounter[12] = 0b1000110;
    segCounter[13] = 0b0100001;
    segCounter[14] = 0b0000110;
    segCounter[15] = 0b0001110;
    segCounter[16] = 0b1111111;
    // int segCounter [6] =
    //                     {0b1111110,
    //                     0b1111101,
    //                     0b1111011,
    //                     0b1110111,
    //                     0b1101111,
    //                     0b1011111};    
    switch (UniqeId) //the CR Address
    {
        case 0x5 : 
            while (1){

               delay();  
                *SEG4_FGPA = segCounter[i++];
                if (i > 16)
                    i = 0;
            }
            break;

        // case 0x4 : 
        //     while (1){

        //         while(timer < 250){
        //             timer++;
        //         }                   
        //         *SEG1_FGPA = segCounter[j++];
        //         if (j > 16)
        //             j = 0;
        //         timer = 0;
                

        //     }
        //     break;

        // case 0x6 : 
        //     while (1){

        //         while(timer < 250){
        //             timer++;
        //         }                   
        //         *SEG2_FGPA = segCounter[k++];
        //         if (k > 16)
        //             k = 0;
        //         timer = 0;

        //     }
        //     break;

        // case 0x7 : 
        //     while (1){

        //         while(timer < 250){
        //             timer++;
        //         }                   
        //         *SEG3_FGPA = segCounter[l++];
        //         if (l > 16)
        //             l = 0;
        //         timer = 0;
        //     }
        //     break;

        // case 0x8 : 
        //     while (1){

        //         while(timer < 250){
        //             timer++;
        //         }                   
        //         *SEG4_FGPA = segCounter[m++];
        //         if (m > 16)
        //             m = 0;
        //         timer = 0;
        //     }
        //     break;

        // case 0x9 : 
        //     while (1){

        //         while(timer < 250){
        //             timer++;
        //         }                   
        //         *SEG5_FGPA = segCounter[j++];
        //         if (j > 16)
        //             j = 0;
        //         timer = 0;
        //     }
        //     break;      

        // case 0x10 : 
        //     while (1){

        //         while(timer < 250){
        //             timer++;
        //         }                   
        //         *LED_FGPA = skipLed;
        //         skipLed = skipLed * 2 ;
        //         if (skipLed > 512)
        //             skipLed = 1;
        //         timer = 0;
        //     }
        //     break;                              


        default :
                while(1); 
                break;
       
    }   
    
    return 0;

}

