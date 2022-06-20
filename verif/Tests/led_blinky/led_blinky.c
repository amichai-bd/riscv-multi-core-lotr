/*MultiThread.c
calculate 4 different arithmatic calculations one on each thread
test owner: Saar Kadosh
Created : 22/08/2021
*/
// 4KB of D_MEM
// 0x400800 - 0x400fff - Shared
//
// 0x400600 - 0x400800 - Thread 3
// 0x400400 - 0x400600 - Thread 2
// 0x400200 - 0x400400 - Thread 1
// 0x400000 - 0x400200 - Thread 0

// REGION == 2'b01;
#define LED_FGPA  ((volatile int *) (0x03002018))
#define SEG0_FGPA  ((volatile int *) (0x03002000))
#define SEG1_FGPA  ((volatile int *) (0x03002004))
#define SEG2_FGPA  ((volatile int *) (0x03002008))
#define SEG3_FGPA  ((volatile int *) (0x0300200C))
#define SWITCH_FGPA  ((volatile int *) (0x03002024))
#define SCRATCHPAD0_CORE_2  ((volatile int *) (0x02400900))
#define SCRATCHPAD0_CORE    ((volatile int *) (0x00400900))
#define SHARED_SPACE ((volatile int *) (0x00400f00))
#define CR_THREAD  ((volatile int *) (0x00C00004))
#define CR_THREAD_PC_EN  ((volatile int *)  (0x00C00150))
#define CR_CORE_ID ((volatile int *) (0x00C00008))
#define CR_WHO_AM_I ((volatile int *) (0x00C00000))

int main() {
    int UniqeId = CR_WHO_AM_I[0];
    int counter = 1 , timer = 0, counter2 = 1023, counter3 = 0;
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
    // int segCounter [6] =
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
                    counter = 1; counter2 = 1023; counter3 = 0; skipLed = 1; skipLedDown = 512;
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
                    counter2 = 1023; counter3 = 0; allLed = 0; skipLed = 1; skipLedDown = 512;
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
                    counter = 1; counter2 = 1023; counter3 = 0; allLed = 0; skipLedDown = 512;
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
                    counter = 1;  counter3 = 0; allLed = 0; skipLed = 1; skipLedDown = 512;
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
                    counter = 1; counter2 = 1023; counter3 = 0; allLed = 0; skipLed = 1;
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
        case 0x8 : 
            while (1){
                
                     while(timer < 250){
                        timer++;
                    }                   
                    *SEG1_FGPA = segCounter[i];
                    *SEG2_FGPA = segCounter[i];
                    *SEG3_FGPA = segCounter[i];
                    i++;
                    if (i > 5)
                        i = 0;
                    timer = 0;
                


            }
        break;
        default :
                while(1); 
                break;
       
    }   
    
    return 0;

}

