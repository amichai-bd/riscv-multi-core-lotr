#include "LOTR_defines.h"
#include "graphic.h"
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
    int UniqeId = CR_WHO_AM_I[0];
    int i;
    int arr[] = {11, 123, 0, 3, 651, 9, 50, 2};
    switch (UniqeId) //the CR Address
    {
        case 0x4 : //  
        rvc_printf("INPUT\n");
        for(i=0;i<8;i++){
            rvc_print_int(arr[i]);
            rvc_printf(" ");
        }
        bubbleSort(arr, 8);
        rvc_printf("\nOUTPUT\n");
        for(i=0;i<8;i++){
            rvc_print_int(arr[i]);
            rvc_printf(" ");
        }
        break;
        default :
            while(1); 
        break;
       
    }// case

return 0;

}
