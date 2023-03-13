#define SCRATCHPAD0_CORE    ((volatile int *) (0x00C00200))
#define SCRATCHPAD0_CORE_1  ((volatile int *) (0x01C00200))
#define SCRATCHPAD0_CORE_2  ((volatile int *) (0x02C00200))
#define SHARED_SPACE        ((volatile int *) (0x00400f00))
#define SHARED_SPACE_CORE_1 ((volatile int *) (0x01400f00))
#define SHARED_SPACE_CORE_2 ((volatile int *) (0x02400f00))
#define CR_THREAD           ((volatile int *) (0x00C00004))
#define CR_THREAD_PC_EN     ((volatile int *) (0x00C00150))
#define CR_CORE_ID          ((volatile int *) (0x00C00008))
void swap(volatile int *xp,volatile  int *yp) {
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}
 
// A function to implement bubble sort
void bubbleSort(volatile int arr[], int n) {
    int i, j;
    for (i = 0; i < n-1; i++)    
        for (j = 0; j < n-i-1; j++)
            if (arr[j] > arr[j+1])
                swap(&arr[j], &arr[j+1]);
}
int main() {
    int ThreadId = CR_THREAD[0];
    int CoreId   = CR_CORE_ID[0];
    //int arr[8] = {3,2,1,5,4,8,6,7};
    int arr[4] = {3,2,1,4};
    switch (ThreadId) { //the CR Address
        case 0x0 :
            if(CR_CORE_ID[0] == 1) {//Core 1 will use core_2 memory space to sort the array.
                for(int i=0;i<4;i++) {
                    SCRATCHPAD0_CORE_2[i] = arr[i];
                }
                bubbleSort(SCRATCHPAD0_CORE_2, 4);
                for(int i=0;i<4;i++) {
                    SCRATCHPAD0_CORE_1[i]=SHARED_SPACE_CORE_2[i];   
                }
                while(1);
            }
            else if(CR_CORE_ID[0] == 2) {
                CR_THREAD_PC_EN[1] = 0;
                while(1);
            }
        default:
            // Write 0 to PC_En[ThreadId] CR
            CR_THREAD_PC_EN[ThreadId] = 0;
            while(1);
        break;
    }   
    return 0;
}

