/*Bubble.c
Sort 8 integer-size array using bubbleSort algorithm
test owner: Adi Levy
Created : 06/06/2021
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
void swap(int *xp, int *yp)
{
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}
 
// A function to implement bubble sort
void bubbleSort(int arr[], int n)
{
    int i, j;
    for (i = 0; i < n-1; i++)    
        for (j = 0; j < n-i-1; j++)
            if (arr[j] > arr[j+1])
                swap(&arr[j], &arr[j+1]);
}
int main() {
    int i;
    int arr[] = {6, 1, 0, 3, 5, 9, 50, 2};
    bubbleSort(arr, 8);
    for(i=0;i<8;i++){
        SHARED_SPACE[i]=arr[i];   
    }
    return 0;
}