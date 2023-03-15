/*led_blinky.c
a test blinking fpga leds depends on the state of the board switches
single thread single core works only
test owner: Adi Levy
Created : 16.6.2022
*/

#include "LOTR_defines.h"
#include "graphic.h"
int main() {
    int UniqeId = CR_WHO_AM_I[0];
    int counter = 1 , timer = 0, counter2 = 1023;
    int allLed = 0;
    int skipLed = 1;
    int skipLedDown = 512;
    int i = 0;
    int segCounter [6];
    segCounter[0] = 0b1111110;
    segCounter[1] = 0b1111101;
    segCounter[2] = 0b1111011;
    segCounter[3] = 0b1110111;
    segCounter[4] = 0b1101111;
    segCounter[5] = 0b1011111;
    // int segCounter [6] =     //D_MEM mif memmory not working yet
    //                     {0b1111110,
    //                     0b1111101,
    //                     0b1111011,
    //                     0b1110111,
    //                     0b1101111,
    //                     0b1011111};    
    switch (UniqeId) //the CR Address
    {
        case 0x4 : 
            while (1){

                if (*SWITCH_FGPA == 0){
                    counter = 1; counter2 = 1023; skipLed = 1; skipLedDown = 512;
                    while(timer < 1666){
                        timer++;
                    }
                    *LED_FGPA = allLed;
                    if (allLed == 1023)
                        allLed = 0;
                    else 
                        allLed = 1023;
                    timer = 0;
                }

                else if (*SWITCH_FGPA == 1){
                    counter2 = 1023; allLed = 0; skipLed = 1; skipLedDown = 512;
                    while(timer < 1666){
                        timer++;
                    }
                    *LED_FGPA = counter;
                    counter ++;
                    if ( counter == 1023)
                        counter = 1;
                    timer = 0;
                }

                else if (*SWITCH_FGPA == 2){
                    counter = 1; counter2 = 1023; allLed = 0; skipLedDown = 512;
                    while(timer < 1666){
                        timer++;
                    }
                    *LED_FGPA = skipLed;
                    skipLed = skipLed * 2 ;
                    if (skipLed > 512)
                        skipLed = 1;
                    timer = 0;
                }

                else if (*SWITCH_FGPA == 3){
                    counter = 1;  allLed = 0; skipLed = 1; skipLedDown = 512;
                    while(timer < 1666){
                        timer++;
                    }
                    *LED_FGPA = counter2;
                    counter2 --;
                    if (counter2 == 0)
                        counter2 = 1023;
                    timer = 0;                    
                }

                else if (*SWITCH_FGPA == 4){
                    counter = 1; counter2 = 1023; allLed = 0; skipLed = 1;
                    while(timer < 1666){
                        timer++;
                    }
                    *LED_FGPA = skipLedDown;
                    skipLedDown = skipLedDown / 2 ;
                    if (skipLedDown == 0)
                        skipLedDown = 512;
                    timer = 0;
                }

                else if (*SWITCH_FGPA == 5){
                    counter = 1; counter2 = 1023;  allLed = 0; skipLed = 1; skipLedDown = 512;
                     while(timer < 500){
                        timer++;
                    }                   
                    *SEG0_FGPA = segCounter[i++];
                    if (i > 5)
                        i = 0;
                    timer = 0;
                }

                else{
          
                }

            }
        break;
        default :
                while(1); 
                break;
       
    }   
    
    return 0;

}

