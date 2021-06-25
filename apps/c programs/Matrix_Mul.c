/*Matrix_Mul.c
Calculate 3x3 matrix multiply
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

void multiply(int mat1[][3], int mat2[][3], int res[][3])
{
    int i, j, k;
    for (i = 0; i < 3; i++) {
        for (j = 0; j < 3; j++) {
            res[i][j] = 0;
            for (k = 0; k < 3; k++)
                res[i][j] += mat1[i][k] * mat2[k][j];
        }
    }
}
#define MMIO_GENERAL  ((volatile int *) (0x00400f00)) 
int main()
{
    int i,j;
    int k=0;
    int mat1[3][3];              
    mat1[0][0] = 1;
    mat1[0][1] = 2;
    mat1[0][2] = 3;
    mat1[1][0] = 4;
    mat1[1][1] = 5;
    mat1[1][2] = 6;
    mat1[2][0] = 7;
    mat1[2][1] = 8;
    mat1[2][2] = 9;
    int mat2[3][3];
    mat2[0][0] = 9;
    mat2[0][1] = 8;
    mat2[0][2] = 7;
    mat2[1][0] = 6;
    mat2[1][1] = 5;
    mat2[1][2] = 4;
    mat2[2][0] = 3;
    mat2[2][1] = 2;
    mat2[2][2] = 1;
    int res[3][3]; // To store result
    multiply(mat1, mat2, res);
     for(i=0;i<3;i++)
        for(j=0;j<3;j++)
        MMIO_GENERAL[k++]=res[i][j];         

    return 0;
}