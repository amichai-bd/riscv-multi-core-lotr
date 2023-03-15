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

void draw_stick (int num, int x , int bias) {
    int l = (x * 2) + 642 + bias;
    int offset = 3600;
    int h = num*80 + 1;
    //clears the rectangle area
    for (int i = 0; i < (30*80 + 1); i+=80){
        VGA_FPGA[l - i + offset] = 0x0;
    }    
    for (int i = 0; i < h; i+=80){
        VGA_FPGA[l - i + offset] = 0xffffffff;

    }
}


void swap(char *xp, char *yp)
{
    char temp = *xp;
    *xp = *yp;
    *yp = temp;
}

#ifdef BUBBLE
void bubbleSort(char arr[], int n)
{

    int i, j;
    for (i = 0; i < n-1; i++)    
        for (j = 0; j < n-i-1; j++)
            if (arr[j] > arr[j+1]){
                swap(&arr[j], &arr[j+1]);
                draw_stick(arr[j] , j , 40 );
                draw_stick(arr[j+1] , j+1 , 40 );                
                delay();
            }
}



#endif

#ifdef QUICK
int partition(char arr[], char l, char h)
{
    char x = arr[h];
    char i = (l - 1);
 
    for (int j = l; j <= h - 1; j++) {
        if (arr[j] <= x) {
            i++;

            swap(&arr[i], &arr[j]);
            draw_stick(arr[i],i,0);
            draw_stick(arr[j],j,0);
            if(arr[i]!=arr[j]){
                delay();

            }
     
        }
    }

    swap(&arr[i + 1], &arr[h]);
    draw_stick(arr[i +1 ],i+1,0);
    draw_stick(arr[h],h,0);  
    if(arr[i + 1]!=arr[h]){
        delay();

    }    


    return (i + 1);
}
 

void quickSortIterative(char arr[], char l, char h)
{
    char stack[h - l + 1];
 
    int top = -1;
 
    stack[++top] = l;
    stack[++top] = h;
 
    while (top >= 0) {
        h = stack[top--];
        l = stack[top--];
 
        char p = partition(arr, l, h);

        if (p - 1 > l) {
            stack[++top] = l;
            stack[++top] = p - 1;
        }
 
        if (p + 1 < h) {
            stack[++top] = p + 1;
            stack[++top] = h;
        }
    }
}


#endif

#ifdef MERGE
void merge(char arr[], char l, char m, char r);
  
int min(int x, int y) { return (x<y)? x :y; }
  
  
void mergeSort(char arr[], int n)
{
   int curr_size;  
   int left_start; 

   for (curr_size=1; curr_size<=n-1; curr_size = 2*curr_size)
   {
       for (left_start=0; left_start<n-1; left_start += 2*curr_size)
       {

           int mid = min(left_start + curr_size - 1, n-1);
  
           int right_end = min(left_start + 2*curr_size - 1, n-1);
  
           merge(arr, left_start, mid, right_end);
       }
   }
}
  
void merge(char arr[], char l, char m, char r)
{
    char i, j, k;
    char n1 = m - l + 1;
    char n2 =  r - m;
  
    char L[n1], R[n2];
  
    for (i = 0; i < n1; i++)
        L[i] = arr[l + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[m + 1+ j];
  
    i = 0;
    j = 0;
    k = l;
    while (i < n1 && j < n2)
    {
        if (L[i] <= R[j])
        {
            arr[k] = L[i];
            draw_stick(arr[k],k,4800 + 0);
            delay();
            i++;
        }
        else
        {
            arr[k] = R[j];
            draw_stick(arr[k],k,4800 + 0);
            delay();
            j++;
        }
        k++;
    }
  
    while (i < n1)
    {
        arr[k] = L[i];
        draw_stick(arr[k],k,4800 + 0);
        delay();        
        i++;
        k++;
    }
  
    while (j < n2)
    {
        arr[k] = R[j];
        draw_stick(arr[k],k,4800 + 0);
        delay();         
        j++;
        k++;
    }
}

#endif


#ifdef INSERTION
void insertionSort(int arr[], int n)
{
    int i, key, j;
    for (i = 1; i < n; i++) {
        key = arr[i];
        j = i - 1;
  
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            draw_stick(arr[j + 1], j+1 ,4800 + 40);
            delay(); 
            j = j - 1;
        }
        arr[j + 1] = key;
        draw_stick(arr[j + 1], j+1 ,4800 + 40);
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
                char arr[18] = {11,5,9,13,18,7,1,2,12,10,4,3,14,6,15,17,8,16};
                int n = 18;
                for (int i = 0; i < n; i++){
                    draw_stick(arr[i] , i,0);
                }
                delay();   
                quickSortIterative(arr, 0, n - 1);
                delay();
            }
                    
        }
        break;
        case 0x5 : //inse
            while(1){
                delay();
                int arr[18] = {11,5,9,13,18,7,1,2,12,10,4,3,14,6,15,17,8,16};
                int n = 18;
                for (int i = 0; i <n ; i++){
                    draw_stick(arr[i] , i ,4800 + 40);
                }      
                delay();
                insertionSort(arr,n);
                delay();  
            } //busy wait 
        break;
        case 0x6 : //bubble
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
            while(1){
                delay();                    
                char arr[18] = {11,5,9,13,18,7,1,2,12,10,4,3,14,6,15,17,8,16};
                int n = 18;
                for (int i = 0; i < n; i++){
                    draw_stick(arr[i] , i,40);
                }
                delay();   
                bubbleSort(arr,n);
                delay();
            }

        break;
        case 0x7 :  //merge
            while(1){
                delay();
                char arr[18] = {11,5,9,13,18,7,1,2,12,10,4,3,14,6,15,17,8,16};
                int n = 18;
                for (int i = 0; i <n ; i++){
                    draw_stick(arr[i] , i ,4800 );
                }      
                delay();
                mergeSort(arr,n);
                delay();  
            } //busy wait
        break;
        default :
                while(1); 
                break;
       
    }   
    
    return 0;

}

