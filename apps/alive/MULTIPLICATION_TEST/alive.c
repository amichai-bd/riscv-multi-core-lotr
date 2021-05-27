//---------------------------------------------------------
// MEMORY
//    INSTRRAM     : ORIGIN =       , LENGTH =       ,  #words= 
//    DATARAM      : ORIGIN =       , LENGTH =       ,  #words= 
//    STACK        : ORIGIN =       , LENGTH =       ,  #words= 
//    MMIO_GENERAL : ORIGIN =       , LENGTH =       ,  #words= 
//    MMIO_CSR     : ORIGIN =       , LENGTH =       ,  #words= 
//    MMIO_ER      : ORIGIN =       , LENGTH =       ,  #words= 
//    MMIO_DRCT_IN : ORIGIN =       , LENGTH =       ,  #words= 
//    MMIO_DRCT_OUT: ORIGIN =       , LENGTH =       ,  #words= 
//----------------------------------------------------------
#define MMIO_GENERAL  (*(volatile int (*)[40])(0x00000F00))//

int main() {
int a;
int b;
int c;
int d;

a = 5;
b = 3;
c = a*b; //
MMIO_GENERAL[0] = c;

return 0;
}// main
