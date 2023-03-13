/*McBubble.c
thread 0 from core 1 sorting array located on thread 0 core 2.
thread 1 from core 2 sorting array located on thread 1 core 1
test owner: Adi Levy
Created : 15/05/2025
*/
// 4KB of D_MEM
// 0x400800 - 0x400fff - Shared


// REGION == 2'b01;
#define SCRATCHPAD0_CORE_1  ((volatile int *) (0x01400900))
#define SCRATCHPAD1_CORE_1  ((volatile int *) (0x01400A00))
#define SCRATCHPAD2_CORE_1  ((volatile int *) (0x01400B00))
#define SCRATCHPAD3_CORE_1  ((volatile int *) (0x01400C00))

#define SCRATCHPAD0_CORE_2  ((volatile int *) (0x02400900))
#define SCRATCHPAD1_CORE_2  ((volatile int *) (0x02400A00))
#define SCRATCHPAD2_CORE_2  ((volatile int *) (0x02400B00))
#define SCRATCHPAD3_CORE_2  ((volatile int *) (0x02400C00))

#define SCRATCHPAD0_CORE    ((volatile int *) (0x00400900))
#define SCRATCHPAD1_CORE    ((volatile int *) (0x00400A00))
#define SCRATCHPAD2_CORE    ((volatile int *) (0x00400B00))
#define SCRATCHPAD3_CORE    ((volatile int *) (0x00400C00))

#define SHARED_SPACE ((volatile int *) (0x00400f00))
#define CR_THREAD  ((volatile int *) (0x00C00004))
#define CR_THREAD_PC_EN  ((volatile int *)  (0x00C00150))
#define CR_CORE_ID ((volatile int *) (0x00C00008))
#define CR_WHO_AM_I ((volatile int *) (0x00C00000))


void swap(volatile int *xp, volatile int *yp)
{
    volatile int temp = *xp;
    *xp = *yp;
    *yp = temp;
}



// A function to implement bubble sort
void bubbleSort(volatile int arr[], int n)
{
    int i, j;
    for (i = 0; i < n-1; i++)    
        for (j = 0; j < n-i-1; j++)
            if (arr[j] > arr[j+1])
                swap(&arr[j], &arr[j+1]);
}





int main() {
    int UniqeId = CR_WHO_AM_I[0];
    int counter = 0 ;
    switch (UniqeId) //the CR Address
    {
        case 0x4 : // parameterize 
        {
            while(counter++ < 50){};                //some busy wait
            volatile int* arr = SCRATCHPAD0_CORE_2; //pointer to array on core 2
            bubbleSort(arr, 8);
            while(counter++ < 50){};                //waiting for core 2 to finish sorting
        }


        break;
        
        case 0x5 :
        {
            int j;
            int arr[8] = {12,2,0,6,10,18,100,4};    //load array to heap
            for(j = 0 ; j < 8 ; j++){
                SCRATCHPAD0_CORE[j] = arr[j];   //load array from heap to shared mem
            }           
            while(1); 
        }
        
        break;
        
        case 0x6 :
        {
            while(1); 
        }
        break;
        
        case 0x7 :
            while(1); 
        break;
        
        case 0x8 : 
        {
            int j;
            int arr[8] = {6,1,0,3,5,9,50,2};//load array to heap
            for(j = 0 ; j < 8 ; j++){
                SCRATCHPAD0_CORE[j] = arr[j];   //load array from heap to shared mem
            }           
            while(1);
        }
        break;
        
        case 0x9 :
        {
            while(counter++ < 50){};                //some busy wait
            volatile int* arr = SCRATCHPAD0_CORE_1; //pointer to array on core 2
            bubbleSort(arr, 8);                     // sorting
            while(1){};                             //waiting for core 2 to finish sorting
        }
        break;
        
        case 0xa :
            while(1); 
        break;
        
        case 0xb :
            while(1); 
        break;
    }   
    
    return 0;

}

