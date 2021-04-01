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
//#define MMIO_CSR      (*(volatile int (*)[ 8])(0x00000FA0))//
//#define MMIO_DRCT_OUT (*(volatile int (*)[ 1])(0x00000FC0))//
//#define MMIO_ER       (*(volatile int (*)[ 2])(0x00000FC4))//
//#define MMIO_DRCT_IN  (*(volatile int (*)[ 1])(0x00000FCC))//

int main() {
int a;
int b;
int c;

a = 1;
b = 2;
c = a+b;
MMIO_GENERAL[0] = c;

return 0;
}// main
