/*McBubble.c
thread 0 from core 1 sorting array located on thread 0 core 2.
thread 1 from core 1 loading an array to be sorted to core 1 shared memory
thread 2 from core 1 loading 2 matrices to be multiple to core 1 shared memory

thread 0 from core 2 loading an array to be sorted to core 2 shared memory
thread 1 from core 2 sorting array located on core 1 shared memory
thread 2 from core 2 multiplies matrices located on core 1 shared memory
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




void multiply(volatile int a[],volatile int b[],volatile int res[]) 
{
    int i,j,k,sum,sum1,sum2;
    res[0]=15;
    for (i = 0; i < 4; i++) {
        res[0]=14;
        for (j = 0; j < 4; j++) {
            res[0]=13;
            sum = 0;
            for (k = 0; k < 4; k++){
                res[0]=12;
                sum1 = a[i * 4 + k];
                res[1] = sum1;
                sum2 = b[k * 4 + j];
                res[2]=sum2;
                sum = sum + sum1 + sum2;
                //sum = sum + a[i * 4 + k] * b[k * 4 + j];
                res[0] = 11;
            }
            res[0] = 10;
            res[i * 4 + j] = sum;
        }
    }
}




int main() {
    int UniqeId = CR_WHO_AM_I[0];
    int counter = 0 ;
    switch (UniqeId) //the CR Address
    {
        case 0x4 : // parameterize 
        {
            while(counter++ < 50){};
            volatile int* arr = SCRATCHPAD0_CORE_2;
            bubbleSort(arr, 8);
            while(1);
        }


        break;
        
        case 0x5 :
        {
            int j;
            int arr[8] = {12,2,0,6,10,18,100,4};
            for(j = 0 ; j < 8 ; j++){
                SCRATCHPAD0_CORE[j] = arr[j];   
            }           
            while(1); 
        }
        
        break;
        
        case 0x6 :
        {
            int j,k,l=0;
            int mat1[16] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};              
            int mat2[16] = {13,14,15,16,9,10,11,12,5,6,7,8,1,2,3,4};
            for(j = 0 ; j < 16 ; j++){
                    SCRATCHPAD1_CORE[j] = mat1[j];
                    SCRATCHPAD2_CORE[j] = mat2[j];
            }
            while(1); 
        }
        break;
        
        case 0x7 :
            while(1); 
        break;
        
        case 0x8 : 
        {
            int j;
            int arr[8] = {6,1,0,3,5,9,50,2};
            for(j = 0 ; j < 8 ; j++){
                SCRATCHPAD0_CORE[j] = arr[j];   
            }           
            while(1);
        }
        break;
        
        case 0x9 :
        {
            while(counter++ < 50){};
            volatile int* arr = SCRATCHPAD0_CORE_1;
            bubbleSort(arr, 8);
            while(1){};
        }
        break;
        
        case 0xa :
        {
            while(counter++ < 200){};
            volatile int* mat1 = SCRATCHPAD1_CORE_1;
            volatile int* mat2 = SCRATCHPAD2_CORE_1;
            volatile int* res  = SCRATCHPAD3_CORE; // To store result
            multiply(mat1, mat2, res);
            //matmul(mat1, mat2, res);    
            //while(1); 
        }
        break;
        
        case 0xb :
            while(1); 
        break;
    }   
    
    return 0;

}

