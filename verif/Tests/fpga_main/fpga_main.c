/*sorting_VGA.c
graphic array sorting. comparing Quick OR Bubble sort vs. Merge or Insertion sort
test owner: Adi Levy
Created : 01/08/2022
*/

// REGION == 2'b01;
#include "LOTR_defines.h"
#include "graphic.h"
#define BUBBLE
#define INSERTION

#define CR_ID10_PC_EN  ((volatile int *)  (0x01C00150))
#define CR_ID11_PC_EN  ((volatile int *)  (0x01C00154))
#define CR_ID12_PC_EN  ((volatile int *)  (0x01C00158))
#define CR_ID13_PC_EN  ((volatile int *)  (0x01C0015c))

#define CR_ID20_PC_EN  ((volatile int *)  (0x02C00150))
#define CR_ID21_PC_EN  ((volatile int *)  (0x02C00154))
#define CR_ID22_PC_EN  ((volatile int *)  (0x02C00158))
#define CR_ID23_PC_EN  ((volatile int *)  (0x02C0015c))   

void delay(){
    int timer = 0;       
    while(timer < 80000){
        timer++;
    }      
}

void draw_stick (int num, int x , int bias , int offset) {
    int l = (x * 2) + 642 + bias;
    //int offset = 1200;
    //int offset = 3600;
    int h = num*80 + 1;
    //clears the rectangle area
    for (int i = 0; i < (20*80 + 1); i+=80){
        VGA_FPGA[l - i + offset] = 0x0;
    }    
    for (int i = 0; i < h; i+=80){
        VGA_FPGA[l - i + offset] = 0xffffffff;

    }
}


void swap(int *xp, int *yp)
{
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}

#ifdef BUBBLE
void bubbleSort(int arr[], int n, int offset1, int offset2)
{

    int i, j;
    for (i = 0; i < n-1; i++)    
        for (j = 0; j < n-i-1; j++)
            if (arr[j] > arr[j+1]){
                swap(&arr[j], &arr[j+1]);
                draw_stick(arr[j] , j , offset1, offset2 );
                draw_stick(arr[j+1] , j+1 , offset1, offset2 );                
                delay();
            }
}



#endif


#ifdef INSERTION
void insertionSort(int arr[], int n , int offset1, int offset2)
{
    int i, key, j;
    for (i = 1; i < n; i++) {
        key = arr[i];
        j = i - 1;
  
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            draw_stick(arr[j + 1], j+1 ,offset1, offset2);
            delay(); 
            j = j - 1;
        }
        arr[j + 1] = key;
        draw_stick(arr[j + 1], j+1 ,offset1, offset2);
        delay(); 
    }
}


#endif

void show_menu(){

    set_cursor(1,1);
    rvc_printf("WELCOME TO THE LOTR FPGA\n");
    set_cursor(10,1);
    rvc_printf("A DUAL CORE 8 THREAD FABRIC .\n"); 
    set_cursor(20,20);
    rvc_printf("PLEASE USE SWITCH TO SELECT:\n");    
    set_cursor(40,20);
    rvc_printf("001 : SYSTEM INFORMATION\n");      
    set_cursor(50,20);
    rvc_printf("010 : LED SHOW\n");     
    set_cursor(60,20);
    rvc_printf("100 : GRAPHIC SORTING\n"); 
}

void led_blinky(){

    int counter = 1 , timer = 0, counter2 = 1023;
    int allLed = 0;
    int skipLed = 1;
    int skipLedDown = 512;
    int i = 0;
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
    set_cursor(20,10);
    rvc_printf("WELCOME TO THE LED SHOW.\n");
    set_cursor(30,15);
    rvc_printf("SET THE FPGA SWITCHES TO SELECT THE LED FUNCTION\n");
    set_cursor(40,20);
    rvc_printf("000 : ALL LED BLINK\n");    
    set_cursor(45,20);
    rvc_printf("001 : BINARY COUNTER \n");      
    set_cursor(50,20);
    rvc_printf("010 : ONE LED MOVING LEFT\n"); 
    set_cursor(55,20);
    rvc_printf("011 : DECREASE BINARY COUNTER\n");     
    set_cursor(60,20);
    rvc_printf("100 : ONE LED MOVING RIGHT\n");    
    set_cursor(65,20);
    rvc_printf("101 : 7 SEG COUNTER \n");      

    while (1){
        if (*SWITCH_FGPA == 0){
            counter = 1; counter2 = 1023; skipLed = 1; skipLedDown = 512;
            delay();
            *LED_FGPA = allLed;
            if (allLed == 1023)
                allLed = 0;
            else 
                allLed = 1023;
        }

        else if (*SWITCH_FGPA == 1){
            counter2 = 1023; allLed = 0; skipLed = 1; skipLedDown = 512;
            delay();
            *LED_FGPA = counter;
            counter ++;
            if ( counter == 1023)
                counter = 1;
        }

        else if (*SWITCH_FGPA == 2){
            counter = 1; counter2 = 1023; allLed = 0; skipLedDown = 512;
            delay();
            *LED_FGPA = skipLed;
            skipLed = skipLed * 2 ;
            if (skipLed > 512)
                skipLed = 1;
        }

        else if (*SWITCH_FGPA == 3){
            counter = 1;  allLed = 0; skipLed = 1; skipLedDown = 512;
            delay();
            *LED_FGPA = counter2;
            counter2 --;
            if (counter2 == 0)
                counter2 = 1023;
        }

        else if (*SWITCH_FGPA == 4){
            counter = 1; counter2 = 1023; allLed = 0; skipLed = 1;
            delay();
            *LED_FGPA = skipLedDown;
            skipLedDown = skipLedDown / 2 ;
            if (skipLedDown == 0)
                skipLedDown = 512;
        }

        else if (*SWITCH_FGPA == 5){
            counter = 1; counter2 = 1023;  allLed = 0; skipLed = 1; skipLedDown = 512;
            delay();      
            *SEG0_FGPA = *SEG1_FGPA = *SEG2_FGPA = *SEG3_FGPA = *SEG4_FGPA = *SEG5_FGPA = segCounter[i++];
            if (i > 16)
                i = 0;
        }

        else{
        }
    }
}

void sys_info(){
    set_cursor(1,1);
    rvc_printf("LOTR FABRIC\n");
    set_cursor(5,1);
    rvc_printf("FPGA .\n"); 
    set_cursor(10,20);
    rvc_printf("HW SYSTEM PROPERTIES:\n");    
    set_cursor(20,20);
    rvc_printf("NUMBER OF CORES: 2\n");      
    set_cursor(25,20);
    rvc_printf("NUMBER OF THREAD EACH CORE: 4\n"); 
    set_cursor(30,20);
    rvc_printf("FPGA MODEL : DE10LIGHT\n");      
    set_cursor(35,20);
    rvc_printf("INSTRUCTION MEMORY SIZE FOR EACH CORE : 8 KB\n"); 
    set_cursor(40,20);
    rvc_printf("DATA MEMORY SIZE FOR EACH CORE : 8 KB\n");      
    set_cursor(45,20);
    rvc_printf("VGA MEMORY SIZE : 38 KB\n");         
    set_cursor(50,20);
    rvc_printf("SOME CR FEATURES : \n");        
    set_cursor(55,25);
    rvc_printf("FREEZE THREAD PC\n");     
    set_cursor(60,25);
    rvc_printf("RESET THREAD PC\n");                 
    set_cursor(65,20);
    rvc_printf("CREATORS: \n");   
    set_cursor(70,25);
    rvc_printf("ADI LEVY \n"); 
    set_cursor(75,25);
    rvc_printf("AMICHAI BEN DAVID \n"); 
    set_cursor(80,25);
    rvc_printf("SAAR KADOSH \n");             

}

int main() {
    clear_screen();
    int UniqeId = CR_WHO_AM_I[0];
    int i;
    switch (UniqeId)
    {
        case 0x4 : //Bubble sort - random
        {
            CR_ID10_PC_EN[0] = 0;
            delay();
            set_cursor(30,1);
            rvc_printf("CORE 1 THREAD 0, BUBBLE SORT RANDOM\n");                  
            int arr[18] = {11,5,9,13,18,7,1,2,12,10,4,3,14,6,15,17,8,16};
            int n = 18;
            for (int i = 0; i < n; i++){
                draw_stick(arr[i] , i,0 , 3600);
            }
            delay();   
            bubbleSort(arr,n,0 , 3600);
            delay();
            while(1){
            }
        }
        break;
        case 0x5 : //bubble sort - 3 unique
        {
            show_menu();

            int x = 0;
            while(1)  {
                x = *SWITCH_FGPA;
                if (x == 1){
                    draw_symbol(1, 40, 18);
                    draw_symbol(5, 50, 18);
                    draw_symbol(5, 60, 18);
                }
                else if (x == 2){
                    draw_symbol(1, 50, 18);
                    draw_symbol(5, 40, 18);
                    draw_symbol(5, 60, 18);
                }       
                else if (x == 4){
                    draw_symbol(1, 60, 18);
                    draw_symbol(5, 40, 18);
                    draw_symbol(5, 50, 18);
                } 
                else if(x == 129 || x == 130 || x == 132 ){
                    break;
                }                
                else{
                    draw_symbol(5, 40, 18);
                    draw_symbol(5, 50, 18);
                    draw_symbol(5, 60, 18);                    
                }                              

            }; //Busy Wait
            if(x == 129)
            {
                clear_screen();
                sys_info();
                while(1);
            }
            else if( x == 130){
                clear_screen();
                led_blinky();
                while(1);
            }
            else if (x == 132){
                clear_screen();
                CR_ID10_PC_EN[0] = CR_ID12_PC_EN[0] = CR_ID13_PC_EN[0] = CR_ID20_PC_EN[0] = CR_ID21_PC_EN[0] = CR_ID22_PC_EN[0] = CR_ID23_PC_EN[0]  = 1;
                delay();
                set_cursor(90,40);
                rvc_printf("CORE 1 THREAD 1, BUBBLE SORT 3 UNIQUE\n");                  
                int arr[18] = {6,18,12,12,6,18,18,6,6,12,12,18,6,18,6,12,18,12};
                int n = 18;
                for (int i = 0; i <n ; i++){
                    draw_stick(arr[i] , i ,4800 + 40 , 3600);
                }      
                delay();
                bubbleSort(arr,n,4800 + 40, 3600);
                delay();  
                while(1){
                        } //busy wait 
            }
        }
        break;
        case 0x6 : //bubble sort - reverse
        {
            CR_ID12_PC_EN[0] = 0;
            for ( i = 0 ; i < 80 ; i++) {
                VGA_FPGA[i]           = 0xffffffff; //First row
                VGA_FPGA[i + 2400 - 80 ]= 0xffffffff; //middle row
                VGA_FPGA[i + 4800 - 80]= 0xffffffff; //middle row
                VGA_FPGA[i + 7200 - 80]= 0xffffffff; //middle row
                VGA_FPGA[i + 9520]    = 0xffffffff; //Last row
            }
            for ( i = 0 ; i < 120 ; i++) {
                VGA_FPGA[i*80]        = 0xffffffff; // first Line
                VGA_FPGA[i*80 + 39]   = 0xffffffff; // middle Line
                VGA_FPGA[i*80 + 79]   = 0xffffffff; // last  Line
            }
            delay();        
            set_cursor(30,40);
            rvc_printf("CORE 1 THREAD 2, BUBBLE SORT REVERSE\n");                              
            int arr[18] = {18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1};
            int n = 18;
            for (int i = 0; i < n; i++){
                draw_stick(arr[i] , i,40 , 3600);
            }
            delay();   
            bubbleSort(arr,n,40 , 3600);
            delay();
            while(1){  
            }
        }
        break;            
        case 0x7 :  //bubble sort - almost sorted
        {
            CR_ID13_PC_EN[0] = 0;
            delay();
            set_cursor(90,1);
            rvc_printf("CORE 1 THREAD 3, BUBBLE SORT ALMOST SORTED\n");                      
            int arr[18] = {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,1};
            int n = 18;
            for (int i = 0; i <n ; i++){
                draw_stick(arr[i] , i ,4800, 3600 );
            }      
            delay();
            bubbleSort(arr,n,4800 , 3600);
            delay();  
            while(1){
            } //busy wait
        }
        break;
        case 0x8 :  //insertion sort - random
        {
            CR_ID20_PC_EN[0] = 0;   
            delay();
            set_cursor(1,1);
            rvc_printf("CORE 2 THREAD 0 ,INSERTION SORT RANDOM\n");                    
            int arr[18] = {11,5,9,13,18,7,1,2,12,10,4,3,14,6,15,17,8,16};
            int n = 18;
            for (int i = 0; i <n ; i++){
                draw_stick(arr[i] , i ,0, 1200 );
            }      
            delay();
            insertionSort(arr,n,0 , 1200);
            delay();  
            while(1){
            } //busy wait
        }
        break;

        case 0x9 :  //insertion - 3 unique
        {
            CR_ID21_PC_EN[0] = 0;   
            delay();
            set_cursor(60,40);
            rvc_printf("CORE 2 THREAD 1, INSERTION SORT 3 UNIQUE\n");                  
            int arr[18] = {6,18,12,12,6,18,18,6,6,12,12,18,6,18,6,12,18,12};
            int n = 18;
            for (int i = 0; i <n ; i++){
                draw_stick(arr[i] , i ,4800 + 40, 1200 );
            }      
            delay();
            insertionSort(arr,n,4800 + 40 , 1200);
            delay();  
            while(1){
            } //busy wait
        }
        break;

        case 0xa :  //insertion reverse
        {
            CR_ID22_PC_EN[0] = 0;   
            delay();
            set_cursor(1,40);
            rvc_printf("CORE 2 THREAD 2, INSERTION SORT REVERSE\n");                        
            int arr[18] = {18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1};
            int n = 18;
            for (int i = 0; i <n ; i++){
                draw_stick(arr[i] , i ,40, 1200 );
            }      
            delay();
            insertionSort(arr,n,40 , 1200);
            delay();  
            while(1){
            } //busy wait
        }
        break;

        case 0xb :  //insertion almost sorted
        {
            CR_ID23_PC_EN[0] = 0;   
            delay();
            set_cursor(60,1);
            rvc_printf("CORE 2 THREAD 3, INSERTION SORT ALMOST SORTED.\n");                      
            int arr[18] = {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,1};
            int n = 18;
            for (int i = 0; i <n ; i++){
                draw_stick(arr[i] , i ,4800  , 1200 );
            }      
            delay();
            insertionSort(arr,n,4800  , 1200);
            delay();  
            while(1){
            } //busy wait
        }
        break;

        default :
                while(1); 
                break;
    
    }   

    
    // while(1){};
    return 0;

}


