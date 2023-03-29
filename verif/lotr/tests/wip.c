#include "LOTR_defines.h"
#include "graphic.h"

int hex7seg(int number){
    int hex7seg;
    switch (number){
        case 0: hex7seg = 0b11000000; break;
        case 1: hex7seg = 0b11111001; break;
        case 2: hex7seg = 0b10100100; break;
        case 3: hex7seg = 0b10110000; break;
        case 4: hex7seg = 0b10011001; break;
        case 5: hex7seg = 0b10010010; break;
        case 6: hex7seg = 0b10000010; break;
        case 7: hex7seg = 0b11111000; break;
        case 8: hex7seg = 0b10000000; break;
        case 9: hex7seg = 0b10010000; break;
        case 10: hex7seg = 0b10001000; break;
        case 11: hex7seg = 0b10000011; break;
        case 12: hex7seg = 0b11000110; break;
        case 13: hex7seg = 0b10100001; break;
        case 14: hex7seg = 0b10000110; break;
        default: hex7seg = 0b10000000; break;
    }
    return hex7seg;
}

void fpga_7seg_print(int number){
    WRITE_REG(SEG0_FGPA, hex7seg(number%10));
    WRITE_REG(SEG1_FGPA, hex7seg((number/10)%10));
    WRITE_REG(SEG2_FGPA, hex7seg((number/100)%10));
    WRITE_REG(SEG3_FGPA, hex7seg((number/1000)%10));
    WRITE_REG(SEG4_FGPA, hex7seg((number/10000)%10));
    WRITE_REG(SEG5_FGPA, hex7seg((number/100000)%10));
}

int run_t0(){
    int sw;
    while(1){
        set_cursor(30,0);
        rvc_printf("HELLO FROM CORE 1 THREAD POC ADI 0\n");
        for (int i=0; i<100000; i++){
            set_cursor(30, 40);
            rvc_print_int(i);
            // write to LED_FGPA the value of i
            WRITE_REG(LED_FGPA, i);
            READ_REG(sw, SWITCH_FGPA);
            //  write to display the value of sw
            set_cursor(30, 50);
            rvc_printf("    ");
            set_cursor(30, 50);
            rvc_print_int(sw);
            fpga_7seg_print(i);
            for (int j=0; j<10000; j++){
            //wait
            }
        }
    }
}
int run_t1(){
    while(1){
        set_cursor(40,0);
        rvc_printf("HELLO FROM CORE 1 THREAD 1\n");
    }
}

void matrix_calc(){
    set_cursor(70, 0);
    int matrix_1 [3][3] = {{1,2,3},{4,5,6},{7,8,9}};
    int matrix_2 [3][3] = {{1,2,3},{4,5,6},{7,8,9}};
    int matrix_3 [3][3] = {{0,0,0},{0,0,0},{0,0,0}};

    rvc_printf("MATRIX 1\n");
    for (int i=0; i<3; i++){
        for (int j=0; j<3; j++){
            rvc_print_int(matrix_1[i][j]);
            rvc_printf(" ");
        }
        rvc_printf("\n");
    }
    rvc_printf("\nMATRIX 2\n");
    for (int i=0; i<3; i++){
        for (int j=0; j<3; j++){
            rvc_print_int(matrix_2[i][j]);
            rvc_printf(" ");
        }
        rvc_printf("\n");
    }
    //calculate matrix_3 = matrix_1 * matrix_2
    for (int i=0; i<3; i++){
        for (int j=0; j<3; j++){
            for (int k=0; k<3; k++){
                matrix_3[i][j] += matrix_1[i][k] * matrix_2[k][j];
            }
        }
    }
    rvc_printf("\nMATRIX 3\n");
    for (int i=0; i<3; i++){
        for (int j=0; j<3; j++){
            rvc_print_int(matrix_3[i][j]);
            rvc_printf(" ");
        }
        rvc_printf("\n");
    }
}
void run_count(int thread){
    for(int i =0; i<1000000000; i++){
        set_cursor(thread*4, 40);
        rvc_print_int(i);
        for (int j=0; j<10000; j++){
            //wait
        }
    }
    while(1); 
}
int main()
{
    int UniqeId  = CR_WHO_AM_I[0];
    int button_1;
    int button_2;
    int sw;
    clear_screen();
    //run_count(UniqeId);
    switch (UniqeId) //the CR Address
    {
        case 0x4 : run_t0(); // Core 1 Thread 0
        break;
        case 0x5 : run_t1(); // Core 1 Thread 1
        break;
        case  0x6   :     while(1){matrix_calc();}; // Core 1 Thread 0

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