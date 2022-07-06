/*MC_Multitask.c
This test check some limiths of the LOTR
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
#define CR_ID10_PC_EN  ((volatile int *)  (0x01C00150))
#define CR_ID11_PC_EN  ((volatile int *)  (0x01C00154))
#define CR_ID12_PC_EN  ((volatile int *)  (0x01C00158))
#define CR_ID13_PC_EN  ((volatile int *)  (0x01C0015c))

#define CR_ID20_PC_EN  ((volatile int *)  (0x02C00150))
#define CR_ID21_PC_EN  ((volatile int *)  (0x02C00154))
#define CR_ID22_PC_EN  ((volatile int *)  (0x02C00158))
#define CR_ID23_PC_EN  ((volatile int *)  (0x02C0015c))

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
            res[0] = 0xff;
            res[1] = 0xfe;
    for (i = 0; i < 4; i++) {
            // res[2] = 0xfe;

        for (j = 0; j < 4; j++) {
             res[3] = 0xfe;

            sum = 0;
            for (k = 0; k < 4; k++){
                sum1 =  a[i * 4 + k];
                // sum2 = b[k * 4 + j];
                res[6] = sum1+sum2;
                // sum = sum + a[i * 4 + k] + b[k * 4 + j];
            }
            res[7] = sum1+sum2;

            // res[5] = 0xfe;

            res[i * 4 + j] = sum;
        }
    }
}




int main() {
    int UniqeId = CR_WHO_AM_I[0];
    int counter = 0 ;
    switch (UniqeId) //the CR Address
    {
        //core 1 threads:

        case 0x4 : // parameterize 
        {
            CR_ID10_PC_EN[0] = 0;   //freeze itself and wating for core 2 to finish loading array
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
            CR_ID21_PC_EN[0] = 1;   // signals core 1 to start sorting
            while(1); 
        }
        
        break;
        
        case 0x6 :
        {
            int j,k,l=0;
            int mat1[16] = {1,2,3,4,5,6,7,8,9,10,11,12,20,14,15,16};              
            int mat2[16] = {13,14,15,16,9,10,11,12,5,6,7,8,1,2,3,4};
            for(j = 0 ; j < 16 ; j++){
                    SCRATCHPAD1_CORE[j] = mat1[j];
                    SCRATCHPAD2_CORE[j] = mat2[j];
            }
            CR_ID22_PC_EN[0] = 1;   // signals core 2 to start multipling           
            while(1); 
        }
        break;
        
        case 0x7 :
            while(1); 
        break;
        
        //Core 2 threads
        case 0x8 : 
        {
            int j;
            int arr[8] = {6,1,0,3,5,9,50,2};
            for(j = 0 ; j < 8 ; j++){
                SCRATCHPAD0_CORE[j] = arr[j];   
            }
            CR_ID10_PC_EN[0] = 1;   // signals core 1 to start sorting           
            while(1);
        }
        break;
        
        case 0x9 :
        {
            CR_ID21_PC_EN[0] = 0;   //wating for core 1 to finish loading array
            volatile int* arr = SCRATCHPAD0_CORE_1;
            bubbleSort(arr, 8);
            while(1){};
        }
        break;
        
        case 0xa :
        {
            CR_ID22_PC_EN[0] = 0;   //wating for core 1 to finish loading matrices
            volatile int* mat1 = SCRATCHPAD1_CORE_1;
            volatile int* mat2 = SCRATCHPAD2_CORE_1;
            volatile int* res  = SCRATCHPAD3_CORE_1; // To store result
            multiply(mat1, mat2, res);
            // while(1); 

        }
        break;
        
        case 0xb :
            while(1); 
        break;
    }   
    
    return 0;

}

