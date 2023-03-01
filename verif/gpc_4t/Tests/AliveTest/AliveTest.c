/*AliveTest.c
test many on the core arithmatic and branch operations
test owner: Saar Kadosh
Created : 05/2021
*/
// 4KB of D_MEM
// 0x400800 - 0x400fff - Shared
//
// 0x400600 - 0x40_0800 - Thread 3
// 0x400400 - 0x40_0600 - Thread 2
// 0x400200 - 0x40_0400 - Thread 1
// 0x400000 - 0x40_0200 - Thread 0

// REGION == 2'b01;

#define D_MEM_SHARED ((volatile int *) (0x00400f00))

//////////Register-Immediate Instructions///////////
void ADDI(int a){
    D_MEM_SHARED[0] = a+1;
}
void SLTI(int a){
    D_MEM_SHARED[1] = a<5;
}
void ANDI(int a){
    D_MEM_SHARED[2] = a&6;
}
void ORI(int a){
    a=a|26;
    if(a==30)
    	D_MEM_SHARED[3] = 1;
}
void XORI(int a){
    D_MEM_SHARED[4] = a^42;
}
void SLLI(int a){
    a=a<<3;
    if(a==64)
    	D_MEM_SHARED[5] = 1;
}
void SRLI(int a){
    __asm__("lui a5,0x41;"
    "addi a5,a5,-512;"
    "lw a4,-20(s0);"
    "srli a4,a4,0xc;"
    "sw	a4,24(a5)");
}

void SRAI(int a){
    a=a>>3;
    if(a==-1024)
    	D_MEM_SHARED[7] = 1;
}

//////////////////Register-Register Instructions//////////////////
void ADD(int a, int b){
    a=a+b;
    if(a==579)
    	D_MEM_SHARED[8] = 1;
}


void SLT(int a, int b){
	D_MEM_SHARED[9]= a<b ? 1 : 0;
} 

/////////////////////////////////////
void SLTU(int a){
	D_MEM_SHARED[10]= a==0 ? 0 : 1;
}
/////////////////////////////////////

void AND(int a, int b){
    D_MEM_SHARED[11]=a&b;
}
void OR(int a, int b){
    a=a|b;
    if(a==3798)
    	D_MEM_SHARED[12] = 1;
}
void XOR(int a, int b){
    D_MEM_SHARED[13] = a^b;
}
void SLL(int a, int b){
    a=a<<b;
    if(a==32768)
    	D_MEM_SHARED[14] = 1;
}
void SRL(int a, int b){
    __asm__("lui a5,0x41;"
        "addi a5,a5,-512;"
        "lw  a4,-24(s0);"
        "lw  a3,-20(s0);"
        "srl a4,a3,a4;"
        "sw  a4,60(a5);");
}
void SUB(int a, int b){
    D_MEM_SHARED[16]=b-a;
}
void SRA(int a, int b){
    a=a>>b;
    if(a==-1024)
    	D_MEM_SHARED[17] = 1;
}

////////////////Conditional Branches///////////////////
void BEQ(int a, int b){
    if(a!=b)
        D_MEM_SHARED[18] = 1;
}
void BNE(int a, int b){
    if(a==b)
        D_MEM_SHARED[19] = 1;
}
void BLT(int a, int b){
    if(a>=b)
        D_MEM_SHARED[20] = 1;
}
void BGE(int a, int b){
    if(a<b)
        D_MEM_SHARED[21] = 1;
}



int main()
{
	ADDI(0);
	SLTI(1);
	ANDI(1);
	ORI(12);
	XORI(41);
	SLLI(8);
	SRLI(4096);
	SRAI(-4096);
    ADD(123,456);
    AND(85,171);
    OR(1234,3654);
    XOR(42,41);
    SLL(4096,3);
	SRL(4096,12);
	SUB(123,122);
	SRA(-4096,3);
	BEQ(5,9);
	BNE(42,42);
	BLT(9,4);
	BGE(1,7);
}
