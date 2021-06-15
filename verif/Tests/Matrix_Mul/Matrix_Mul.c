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
 #define MMIO_GENERAL  (*(volatile int (*)[64])(0x00400F00))//
 
int main()
{
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
    MMIO_GENERAL[0] = res[0][0];
    MMIO_GENERAL[1] = res[0][1];
    MMIO_GENERAL[2] = res[0][2];
    MMIO_GENERAL[3] = res[1][0];
    MMIO_GENERAL[4] = res[1][1];
    MMIO_GENERAL[5] = res[1][2];
    MMIO_GENERAL[6] = res[2][0];
    MMIO_GENERAL[7] = res[2][1];
    MMIO_GENERAL[8] = res[2][2];
    MMIO_GENERAL[63] = 255;
 
    return 0;
}