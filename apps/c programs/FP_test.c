/*FP_test.c
simple test to check floating point capabilities
test owner: Adi Levy
Created : 1/07/2022
*/



#include "LOTR_defines.h"


#define SHARED_MEM ((volatile float *) (0x00400f00))

int main() {
    int UniqeId = CR_WHO_AM_I[0];
    switch (UniqeId) //the CR Address
    {

        case 0x4 : // parameterize 
        {
            float a = 1.5;
            float b = 2.2;
            SHARED_MEM[0] =  a + b; // 0x406ccccd = 3.7
            SHARED_MEM[1] =  a * b; // 0x40533334 = 3.3
            SHARED_MEM[2] =  b / a; // 0x3fbbbbbc = 1.46667
        }


        break;

        default :
            while(1);

    }   
    
    return 0;

}

