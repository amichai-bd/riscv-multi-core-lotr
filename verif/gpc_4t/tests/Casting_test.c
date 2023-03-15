/*Casting_test .c
simple test to check Casting capabilities
test owner: Adi Levy
Created : 1/07/2022
*/



#include "LOTR_defines.h"

int main() {
    int UniqeId = CR_WHO_AM_I[0];
    switch (UniqeId) //the CR Address
    {

        case 0x4 : // parameterize 
        {
            float a = 1.5;
            float b = 2.2;
            SHARED_SPACE[0] =  (int)(a + b); //3.7 ~ 3
            SHARED_SPACE[1] =  (int)(a * b); //  3.3 ~ 3
            SHARED_SPACE[2] =  (int)(b / a); //  1.46667 ~ 1
        }


        break;

        default :
            while(1);

    }   
    
    return 0;

}

