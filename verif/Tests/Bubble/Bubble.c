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
 
#define MMIO_GENERAL  (*(volatile int (*)[64])(0x00400F00))//

int main() {
    int x;
    int arr[8];
    arr[0]=6;
    arr[1]=1;
    arr[2]=0;
    arr[3]=3;
    arr[4]=5;
    arr[5]=9;
    arr[6]=50;
    arr[7]=2;
    bubbleSort(arr, 8);
    //to track single register in logs:
    MMIO_GENERAL[0]=arr[0];
    MMIO_GENERAL[1]=arr[1];
    MMIO_GENERAL[2]=arr[2];
    MMIO_GENERAL[3]=arr[3];
    MMIO_GENERAL[4]=arr[4];
    MMIO_GENERAL[5]=arr[5];
    MMIO_GENERAL[6]=arr[6];
    MMIO_GENERAL[7]=arr[7];
    MMIO_GENERAL[63]=1;
    return 0;
}