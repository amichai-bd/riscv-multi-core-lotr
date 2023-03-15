/*MultiThread.c
calculate 4 different arithmatic calculations one on each thread
test owner: Saar Kadosh
Created : 22/08/2021
*/
// 4KB of D_MEM
// 0x400800 - 0x400fff - Shared
//
// 0x400600 - 0x400800 - Thread 3
// 0x400400 - 0x400600 - Thread 2
// 0x400200 - 0x400400 - Thread 1
// 0x400000 - 0x400200 - Thread 0

// REGION == 2'b01;
#define SHARED_SPACE  ((volatile int *) (0x00400f00))
#define CR_THREAD  ((volatile int *) (0x00C00004))

int Thread (int* row, int mat[4][4], int thread){
    int res;
    for(int i=0; i<4; i++){
        res=0;
        for(int j=0; j<4; j++){
            res+=row[j]*(mat[j][i]);
        }
        SHARED_SPACE[4*thread+i] = res;
    }
}

 

int main() {
    int x = CR_THREAD[0];
    int mat1[4][4] = {{1,2,3,4},{5,6,7,8},{9,10,11,12},{13,14,15,16}};              
    int mat2[4][4] = {{13,14,15,16},{9,10,11,12},{5,6,7,8},{1,2,3,4}}; 
    int row[4];
    switch (x) //the CR Address
    {
        
        case 0x0 : //expect each thread to get from the MEM_WRAP the correct Thread.
            for( int i = 0 ; i < 4 ; i++)
                row[i] = mat1[x][i];
            Thread(row, mat2, 0);
        break;
        case 0x1 :
            for( int i = 0 ; i < 4 ; i++)
                row[i] = mat1[x][i];
            Thread(row, mat2, 1);
        break;
        case 0x2 :
            for( int i = 0 ; i < 4 ; i++)
                row[i] = mat1[x][i];
            Thread(row, mat2, 2);
        break;
        case 0x3 :
            for( int i = 0 ; i < 4 ; i++)
                row[i] = mat1[x][i];
            Thread(row, mat2, 3);
        break;
    }   

}

