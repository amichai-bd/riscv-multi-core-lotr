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
#include "LOTR_defines.h"

int draw_hi (int offset) {
//The letter "H"
    VGA_FPGA[162 + offset] = 0xffffffff;
    VGA_FPGA[242 + offset] = 0xffffffff;
    VGA_FPGA[322 + offset] = 0xffffffff;
    VGA_FPGA[402 + offset] = 0xffffffff;
    VGA_FPGA[482 + offset] = 0xffffffff;
    VGA_FPGA[562 + offset] = 0xffffffff;
    VGA_FPGA[642 + offset] = 0xffffffff;
    VGA_FPGA[164 + offset] = 0xffffffff;
    VGA_FPGA[244 + offset] = 0xffffffff;
    VGA_FPGA[324 + offset] = 0xffffffff;
    VGA_FPGA[404 + offset] = 0xffffffff;
    VGA_FPGA[484 + offset] = 0xffffffff;
    VGA_FPGA[564 + offset] = 0xffffffff;
    VGA_FPGA[644 + offset] = 0xffffffff;
    VGA_FPGA[403 + offset] = 0xffffffff;
//The letter "I"
    VGA_FPGA[166 + offset] = 0xffffffff;
    VGA_FPGA[167 + offset] = 0xffffffff;
    VGA_FPGA[168 + offset] = 0xffffffff;
    VGA_FPGA[247 + offset] = 0xffffffff;
    VGA_FPGA[327 + offset] = 0xffffffff;
    VGA_FPGA[407 + offset] = 0xffffffff;
    VGA_FPGA[487 + offset] = 0xffffffff;
    VGA_FPGA[567 + offset] = 0xffffffff;
    VGA_FPGA[646 + offset] = 0xffffffff;
    VGA_FPGA[647 + offset] = 0xffffffff;
    VGA_FPGA[648 + offset] = 0xffffffff;
    // the "-"
    VGA_FPGA[409 + offset] = 0xffffffff;
    VGA_FPGA[410 + offset] = 0xffffffff;
    return 0;
}
int draw_i (int offset) {
//The letter I
    VGA_FPGA[166 + offset] = 0xffffffff;
    VGA_FPGA[167 + offset] = 0xffffffff;
    VGA_FPGA[168 + offset] = 0xffffffff;
    VGA_FPGA[247 + offset] = 0xffffffff;
    VGA_FPGA[327 + offset] = 0xffffffff;
    VGA_FPGA[407 + offset] = 0xffffffff;
    VGA_FPGA[487 + offset] = 0xffffffff;
    VGA_FPGA[567 + offset] = 0xffffffff;
    VGA_FPGA[646 + offset] = 0xffffffff;
    VGA_FPGA[647 + offset] = 0xffffffff;
    VGA_FPGA[648 + offset] = 0xffffffff;
    return 0;
}
int main() {
    int ThreadId = CR_THREAD[0];
    int UniqeId = CR_WHO_AM_I[0];
    int counter = 0 ;
    int i;
    switch (UniqeId) //the CR Address
    {
        case 0x4 : //    HI - I
        
            for ( i = 0 ; i < 80 ; i++) {
                VGA_FPGA[i]           = 0xffffffff; //First row
                VGA_FPGA[i + 4800 -80]= 0xffffffff; //middle row
                VGA_FPGA[i + 9520]    = 0xffffffff; //Last row
            }
            for ( i = 0 ; i < 120 ; i++) {
                VGA_FPGA[i*80]        = 0xffffffff; // first Line
                VGA_FPGA[i*80 + 39]   = 0xffffffff; // middle Line
                VGA_FPGA[i*80 + 79]   = 0xffffffff; // last  Line
            }

            draw_hi(0);
            draw_i (6);
            SHARED_SPACE[0] = VGA_FPGA[81];
        break;
        case 0x5 : //    HI - II
            draw_hi(40);
            draw_i (40 + 6);
            draw_i (40 + 8);
            while(1); 
            while(1){} //busy wait
        break;
        case 0x6 : //    HI - III
            draw_hi(4800);
            draw_i (4800 + 6);
            draw_i (4800 + 8);
            draw_i (4800 + 10);
            while(1); 
            while(1){} //busy wait
        break;
        case 0x7 : //   HI - IIII
            draw_hi(40 + 4800);
            draw_i (40 + 4800 + 6);
            draw_i (40 + 4800 + 8);
            draw_i (40 + 4800 + 10);
            draw_i (40 + 4800 + 12);
            while(1); 
            while(1){} //busy wait
        break;
        default :
                while(1); 
                break;
       
    }   
    
    return 0;

}

