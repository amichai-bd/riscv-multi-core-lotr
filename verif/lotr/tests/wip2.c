#include "LOTR_defines.h"
#include "graphic.h"

void print_fixed_point(int value, int precision) {
    int intPart = value / precision;
    int fractionalPart = value % precision;
    rvc_print_int(intPart);
    rvc_printf(".");
    rvc_print_int(fractionalPart);
}

int calculate_pi(int iterations) {
  int pi = 0;
  int precision = 1000000;
  int i;
  for (i = 0; i < iterations; ++i) {
    int term = (i % 2 == 0 ? 1 : -1) * precision / (2 * i + 1);
    pi += term;
    rvc_printf("ITER ");
    rvc_print_int(i + 1);
    rvc_printf(". ");
    print_fixed_point(pi * 4, precision);
    rvc_printf("\n");
  }
  return pi * 4;
}

int run_t0() {
  int iterations = 1000000; // Increase for a more accurate result
  rvc_printf("CALC \n");
  calculate_pi(iterations);
  return 0;
}

int main()
{
    int UniqeId  = CR_WHO_AM_I[0];
    switch (UniqeId) //the CR Address
    {
        case 0x4 : run_t0(); // Core 1 Thread 0
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