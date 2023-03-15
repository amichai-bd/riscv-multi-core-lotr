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
    rvc_printf("PLEASE USE SWITCHES TO SELECT\n");      
    set_cursor(40,20);
    rvc_printf("001 : SYSTEM INFORMATION\n");      
    set_cursor(50,20);
    rvc_printf("010 : LED SHOW\n");     
    set_cursor(60,20);
    rvc_printf("100 : GRAPHIC SORTING\n"); 
    set_cursor(70,20);
    rvc_printf("101 : SNAKE GAME\n");     
}

void led_blinky(){

    int counter = 1 ,  counter2 = 1023;
    int allLed = 0;
    int skipLed = 1;
    int skipLedDown = 512;


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
    //set_cursor(60,20);
    //rvc_printf("100 : ONE LED MOVING RIGHT\n");    


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
            skipLed = skipLed << 1 ;
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

        //else if (*SWITCH_FGPA == 4){
        //    counter = 1; counter2 = 1023; allLed = 0; skipLed = 1;
        //    delay();
        //    *LED_FGPA = skipLedDown;
        //    skipLedDown = skipLedDown >> 1 ;
        //    if (skipLedDown == 0)
        //        skipLedDown = 512;
        //}



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
    rvc_printf("SAAR KADOSH \n");             
    set_cursor(80,25);
    rvc_printf("AMICHAI BEN DAVID \n"); 

}

#define SNK_RIGHT 0
#define SNK_DOWN  1
#define SNK_UP    2
#define SNK_LEFT  4
#define SNK_SIZE  15
//char new_direction(char cur_direction){
//    char new_direction;
//    new_direction = SWITCH_FGPA[0];
//
//    if((new_direction != SNK_RIGHT) && (new_direction != SNK_UP) && (new_direction != SNK_LEFT) && (new_direction != SNK_DOWN) ||
//        (cur_direction == SNK_RIGHT) && (new_direction == SNK_LEFT) || (cur_direction == SNK_LEFT) && (new_direction == SNK_RIGHT) ||
//         (cur_direction == SNK_UP) && (new_direction == SNK_DOWN) || (cur_direction == SNK_DOWN) && (new_direction == SNK_UP) ){
//        new_direction = cur_direction;
//    }
//    return new_direction;
//}
//void snk_move (char direction, char *snk_x_pos, char *snk_y_pos, char size){
//    for (int i =(size-1); i>0 ; i--){
//        snk_x_pos[i] = snk_x_pos[i-1];
//        snk_y_pos[i] = snk_y_pos[i-1];
//    } //for
//    if(direction == SNK_UP) {
//        snk_x_pos[0] = snk_x_pos[1];
//        snk_y_pos[0] = snk_y_pos[1] -1;
//    } //if SNK_UP
//    if(direction == SNK_DOWN) {
//        snk_x_pos[0] = snk_x_pos[1];
//        snk_y_pos[0] = snk_y_pos[1] + 1;
//    } //if SNK_DOWN
//    if(direction == SNK_LEFT) {
//        snk_x_pos[0] = snk_x_pos[1] - 1;
//        snk_y_pos[0] = snk_y_pos[1];
//    } //if SNK_LEFT
//    if(direction == SNK_RIGHT) {
//        snk_x_pos[0] = snk_x_pos[1] + 1;
//        snk_y_pos[0] = snk_y_pos[1];
//    } //if SNK_RIGHT
//    if(direction == 0) {
//        snk_x_pos[0] = snk_x_pos[1] + 1;
//        snk_y_pos[0] = snk_y_pos[1];
//    } //if NO direction set
//}
//void print_snake (char hit, char *snk_valid, char *snk_x_pos, char *snk_y_pos, char size) {
//    for(int i = 0; i<size; i++) {
//        if(snk_valid[i]){
//            draw_char('X', 2*snk_y_pos[i],  snk_x_pos[i]);
//            if(snk_valid[i+1] == 0) {
//                if(hit) {
//                    snk_valid[i+1] = 1;
//                    hit = 0;
//                } else {
//                    draw_char(' ', 2*snk_y_pos[i+1],  snk_x_pos[i+1]);
//                }
//            } 
//        }
//    }
//}
//char eat(char *snk_valid, char snk_x_pos, char snk_y_pos, char apple_x, char apple_y , char *apple_indx){
//    char hit = ((snk_x_pos == apple_x) && (snk_y_pos == apple_y)) ? 1 : 0;
//    if (hit) {
//         *apple_indx = *apple_indx +1;
//    }
//    return hit;
//}
//// int check_hit (int snk_x_pos, int snk_y_pos) {
////     int kill = 0;
////     if(snk_x_pos == 0 || snk_x_pos ==79 || snk_y_pos == 0 || snk_y_pos ==59)  kill = 1;
////     return kill;
//// }
//// void new_apple (int * apple_x, int *apple_y){
////     *apple_x = 9;
////     *apple_y = 9;
//// }
//
//void snake_game (){
//    char snk_x_pos [SNK_SIZE];
//    char snk_y_pos [SNK_SIZE];
//    char snk_valid [SNK_SIZE];
//    char direction = SNK_RIGHT;
//    char apple_x = 5;
//    char apple_y = 5;
//    char apple_indx = 0;
//    char score = 0;
//    char kill = 0;
//    char loc = 0;
//    char hit_apple;
//    char Switch;
//
//    
//    while (1)
//    { 
//    Switch = *SWITCH_FGPA;
//        if(Switch>127){
//            clear_screen();
//            apple_x = 5;
//            apple_y = 5;
//            apple_indx = 0;
//            score = 0;
//            kill = 0;
//            loc = 0;
//            for(int x = 0; x<80; x++) {
//                draw_char('A', 0  , x);
//                draw_char('A', 2*59, x);
//            }
//            for(int y = 0; y<60; y++) {
//                draw_char('A', y<<1,  0);
//                draw_char('A', y<<1, 79);
//            }
//            for(char i = 0; i < SNK_SIZE ; i ++) {
//                snk_x_pos[i] = i+20;
//                snk_y_pos[i] = 20;
//                snk_valid[i] = (i<5) ? 1 : 0;
//            }
//        }
//        direction = new_direction(direction);
//        if(kill == 0 ){
//            snk_move(direction, snk_x_pos, snk_y_pos, SNK_SIZE);
//        }
//        hit_apple = eat(snk_valid, snk_x_pos[0], snk_y_pos[0], apple_x, apple_y, &apple_indx);
//        if( hit_apple == 1 ) {
//            if (loc == 0){
//                apple_x = 9, apple_y = 9;
//                loc = 1;
//            }
//            else {
//                apple_x = 29, apple_y = 29;
//                loc = 0;
//            }            
//
//            score++;
//        }
//        set_cursor(3,20);
//        rvc_printf("GAME SCORE\n");    
//        //print_apple
//        draw_char('O', 2*apple_y,  apple_x);
//        print_snake(hit_apple, snk_valid, snk_x_pos, snk_y_pos, SNK_SIZE);   
//        //print_score
//        draw_char((score+'0'), 3,  39);
//        kill =  (snk_x_pos[0] == 0 || snk_x_pos[0] ==79 || snk_y_pos[0] == 0 || snk_y_pos[0] ==59);
//        hit_apple = 0;
//
//        delay();
//    }
//    
//}


int main() {
    clear_screen();
    int UniqeId = CR_WHO_AM_I[0];
    int i;
    int n = 18;
    switch (UniqeId)
    {
        case 0x4 : //Bubble sort - random
        {
            CR_ID10_PC_EN[0] = 0;
            delay();
            set_cursor(30,1);
            rvc_printf("C1 T0, BUBBLE SORT RANDOM\n");                  
            int arr[18] = {11,5,9,13,18,7,1,2,12,10,4,3,14,6,15,17,8,16};
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
                    draw_symbol(5, 70, 18);                    
                }
                else if (x == 2){
                    draw_symbol(1, 50, 18);
                    draw_symbol(5, 40, 18);
                    draw_symbol(5, 60, 18);
                    draw_symbol(5, 70, 18);                       
                }       
                else if (x == 4){
                    draw_symbol(1, 60, 18);
                    draw_symbol(5, 40, 18);
                    draw_symbol(5, 50, 18);
                    draw_symbol(5, 70, 18);                       
                } 
                else if (x == 5){
                    draw_symbol(1, 70, 18);
                    draw_symbol(5, 40, 18);
                    draw_symbol(5, 50, 18);
                    draw_symbol(5, 60, 18);
                }                 
                //using switch [7] to select
                else if(x == 129 || x == 130 || x == 132 || x == 133 ){
                    break;
                }                
                else{
                    draw_symbol(5, 40, 18);
                    draw_symbol(5, 50, 18);
                    draw_symbol(5, 60, 18); 
                    draw_symbol(5, 70, 18);                                        
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
            else if( x == 133){
                clear_screen();
                //snake_game();
                rvc_printf("THE SNAKE GAME IS DISABLED DUE TO MEMORY SIZE\n");                  
                while(1);
            }            
            else if (x == 132){
                clear_screen();
                CR_ID10_PC_EN[0] = CR_ID12_PC_EN[0] = CR_ID13_PC_EN[0] = CR_ID20_PC_EN[0] = CR_ID21_PC_EN[0] = CR_ID22_PC_EN[0] = CR_ID23_PC_EN[0]  = 1;
                delay();
                set_cursor(90,40);
                rvc_printf("C1 T1, BUBBLE SORT 3 UNIQUE\n");                  
                int arr[18] = {6,18,12,12,6,18,18,6,6,12,12,18,6,18,6,12,18,12};
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
            rvc_printf("C1 T2, BUBBLE SORT REVERSE\n");                              
            int arr[18] = {18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1};
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
            rvc_printf("C1 T3, BUBBLE SORT ALMOST SORTED\n");                      
            int arr[18] = {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,1};
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
            rvc_printf("C2 T0 ,INSERTION SORT RANDOM\n");                    
            int arr[18] = {11,5,9,13,18,7,1,2,12,10,4,3,14,6,15,17,8,16};
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
            rvc_printf("C2 T1, INSERTION SORT 3 UNIQUE\n");                  
            int arr[18] = {6,18,12,12,6,18,18,6,6,12,12,18,6,18,6,12,18,12};
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
            rvc_printf("C2 T2, INSERTION SORT REVERSE\n");                        
            int arr[18] = {18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1};
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
            rvc_printf("C2 T3, INSERTION SORT ALMOST SORTED.\n");                      
            int arr[18] = {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,1};
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


