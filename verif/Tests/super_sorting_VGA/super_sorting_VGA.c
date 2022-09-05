/*sorting_VGA.c
graphic array sorting. comparing Quick OR Bubble sort vs. Merge or Insertion sort
test owner: Adi Levy
Created : 01/08/2022
*/

// REGION == 2'b01;
#include "LOTR_defines.h"
#define QUICK
#define BUBBLE
#define MERGE
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


int main() {
    int UniqeId = CR_WHO_AM_I[0];
    int i;
    switch (UniqeId)
    {
        case 0x4 : //quick
        {
            while(1){
                delay();                    
                int arr[18] = {11,5,9,13,18,7,1,2,12,10,4,3,14,6,15,17,8,16};
                int n = 18;
                for (int i = 0; i < n; i++){
                    draw_stick(arr[i] , i,0 , 3600);
                }
                delay();   
                bubbleSort(arr,n,0 , 3600);
                delay();
            }
                    
        }
        break;
        case 0x5 : //inse
            while(1){
                delay();
                int arr[18] = {1,2,3,4,5,6,13,14,15,16,17,18,7,8,9,10,11,12};
                int n = 18;
                for (int i = 0; i <n ; i++){
                    draw_stick(arr[i] , i ,4800 + 40 , 3600);
                }      
                delay();
                bubbleSort(arr,n,4800 + 40, 3600);
                delay();  
            } //busy wait 
        break;
        case 0x6 : //bubble
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
            while(1){
                delay();                    
                int arr[18] = {18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1};
                int n = 18;
                for (int i = 0; i < n; i++){
                    draw_stick(arr[i] , i,40 , 3600);
                }
                delay();   
                bubbleSort(arr,n,40 , 3600);
                delay();
            }

        break;
        case 0x7 :  //merge
            while(1){
                delay();
                int arr[18] = {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,1};
                int n = 18;
                for (int i = 0; i <n ; i++){
                    draw_stick(arr[i] , i ,4800, 3600 );
                }      
                delay();
                bubbleSort(arr,n,4800 , 3600);
                delay();  
            } //busy wait
        break;

        case 0x8 :  //merge
            while(1){
                delay();
                int arr[18] = {11,5,9,13,18,7,1,2,12,10,4,3,14,6,15,17,8,16};
                int n = 18;
                for (int i = 0; i <n ; i++){
                    draw_stick(arr[i] , i ,0, 1200 );
                }      
                delay();
                insertionSort(arr,n,0 , 1200);
                delay();  
            } //busy wait
        break;

        case 0x9 :  //merge
            while(1){
                delay();
                int arr[18] = {1,2,3,4,5,6,13,14,15,16,17,18,7,8,9,10,11,12};
                int n = 18;
                for (int i = 0; i <n ; i++){
                    draw_stick(arr[i] , i ,4800 + 40, 1200 );
                }      
                delay();
                insertionSort(arr,n,4800 + 40 , 1200);
                delay();  
            } //busy wait
        break;

        case 0xa :  //merge
            while(1){
                delay();
                int arr[18] = {18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1};
                int n = 18;
                for (int i = 0; i <n ; i++){
                    draw_stick(arr[i] , i ,40, 1200 );
                }      
                delay();
                insertionSort(arr,n,40 , 1200);
                delay();  
            } //busy wait
        break;

        case 0xb :  //merge
            while(1){
                delay();
                int arr[18] = {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,1};
                int n = 18;
                for (int i = 0; i <n ; i++){
                    draw_stick(arr[i] , i ,4800  , 1200 );
                }      
                delay();
                insertionSort(arr,n,4800  , 1200);
                delay();  
            } //busy wait
        break;

        default :
                while(1); 
                break;
       
    }   
    
    return 0;

}

