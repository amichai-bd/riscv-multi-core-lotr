#define D_MEM_SHARED ((volatile int *) (0x00400f00))
//alive test for the RISCV simple core
int main()
{
    int a = 1;
    int b = 2;

    ////////////////Register-Immediate Instructions////////////////
    D_MEM_SHARED[0] = a+1;
    D_MEM_SHARED[1] = a<5;
    D_MEM_SHARED[2] = a&6;
    D_MEM_SHARED[3] = a|26;
    D_MEM_SHARED[4] = a^42;
    D_MEM_SHARED[5] = a<<3;
    D_MEM_SHARED[6] = a>>3;
    D_MEM_SHARED[7] = a>>3;
    D_MEM_SHARED[8] = a+b;
    D_MEM_SHARED[9] = a<b ? 1 : 0;
    D_MEM_SHARED[10] = a==0 ? 0 : 1;
    D_MEM_SHARED[11] = b & a;
    D_MEM_SHARED[12] = b | a;
    D_MEM_SHARED[13] = b ^ a;
    D_MEM_SHARED[14] = b << a;
    D_MEM_SHARED[15] = b >> a;
    
    	


}
