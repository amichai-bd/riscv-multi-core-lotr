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

//return num+5
int ADDI(int num){
	int res;
	__asm__("ADDI %[m], %[n], 5"
		:[m] "=r" (res)
		:[n] "r" (num)
	);
    return res;
}

//return 1 if num < 2, else return 0
int SLTI(int num){
	int res;
	__asm__("slti %[m], %[n], 2;"
		: [m] "=r"(res)
		: [n] "r"(num));
	return res;
}

//return num&6 (bitwise and)
int ANDI(int num){
	int res;
	__asm__("andi %[m], %[n], 4;"
		: [m] "=r"(res)
		: [n] "r"(num));
	return res;
}

//return num|26 (bitwise or)
int ORI(int num){
	int res;
	__asm__("ori %[m], %[n], 4;"
		: [m] "=r"(res)
		: [n] "r"(num));
	return res;
}

//return num^42 (bitwise xor)
int XORI(int num){
	int res;
	__asm__("xori %[m], %[n], 4;"
		: [m] "=r"(res)
		: [n] "r"(num));
	return res;
}

//return num<<3
int SLLI(int num){
	int res;
	__asm__("slli %[m], %[n], 4;"
		: [m] "=r"(res)
		: [n] "r"(num));
	return res;
}

//return num>>3
int SRLI(int num){
	int res;
	__asm__("srli %[m], %[n], 4;"
		: [m] "=r"(res)
		: [n] "r"(num));
	return res;
}

//return num>>3
int SRAI(int num){
	int res;
	__asm__("srai %[m], %[n], 4;"
		: [m] "=r"(res)
		: [n] "r"(num));
	return res;
}

//////////////////Register-Register Instructions//////////////////

//return num1+num2
int ADD(int num1, int num2){
	int res;
	__asm__("add %[m], %[n1], %[n2];"
		: [m] "=r"(res)
		: [n1] "r"(num1), [n2] "r"(num2));
	return res;
}

//return 1 if num1 < num2, else 0
int SLT(int num1, int num2){
	int res;
	__asm__("slt %[m], %[n1], %[n2];"
		: [m] "=r"(res)
		: [n1] "r"(num1), [n2] "r"(num2));
	return res;
} 


//return 1 if num != 0, else zero 
int SLTU(int num){
	int res;
	__asm__("sltu %[m], %[n], 0"
		: [m] "=r"(res)
		: [n] "r"(num));
	return res;
}

//return num1&num2
int AND(int num1, int num2){
	int res;
	__asm__("and %[m], %[n1], %[n2];"
		: [m] "=r"(res)
		: [n1] "r"(num1), [n2] "r"(num2));
	return res;
}

//return num1|num2
int OR(int num1, int num2){
	int res;
	__asm__("or %[m], %[n1], %[n2];"
		: [m] "=r"(res)
		: [n1] "r"(num1), [n2] "r"(num2));
	return res;
}

//return num1^num2
int XOR(int num1, int num2){
	int res;
	__asm__("xor %[m], %[n1], %[n2];"
		: [m] "=r"(res)
		: [n1] "r"(num1), [n2] "r"(num2));
	return res;
}

//return num1<<num2
int SLL(int num1, int num2){
	int res;
	__asm__("sll %[m], %[n1], %[n2];"
		: [m] "=r"(res)
		: [n1] "r"(num1), [n2] "r"(num2));
	return res;
}

//return num1>>num2
int SRL(int num1, int num2){
	int res;
	__asm__("srl %[m], %[n1], %[n2];"
		: [m] "=r"(res)
		: [n1] "r"(num1), [n2] "r"(num2));
	return res;
}

//return num1-num2
int SUB(int num1, int num2){
	int res;
	__asm__("sub %[m], %[n1], %[n2];"
		: [m] "=r"(res)
		: [n1] "r"(num1), [n2] "r"(num2));
	return res;
}

//return num1>>num2
int SRA(int num1, int num2){
	int res;
	__asm__("sra %[m], %[n1], %[n2];"
		: [m] "=r"(res)
		: [n1] "r"(num1), [n2] "r"(num2));
	return res;
}

////////////////Conditional Branches///////////////////

//return 1 if num1==num2, else 0
int BEQ(int num1, int num2){
	if(num1!=num2)
		return 0;
	return 1;
}

//return 1 if num1!=num2, else 0
int BNE(int num1, int num2){
	if(num1==num2)
		return 0;
	return 1;
}

//return 1 if num1<num2, else 0
int BLT(int num1, int num2){
	if(num1>=num2)
		return 0;
	return 1;
}

//return 1 if num1>=num2, else 0
int BGE(int num1, int num2){
	if(num1<num2)
		return 0;
	return 1;
}



int main()
{
	D_MEM_SHARED[0] = ADDI(0);
	D_MEM_SHARED[1] = SLTI(1);
	D_MEM_SHARED[2] = ANDI(1);
	D_MEM_SHARED[3] = ORI(12);
	D_MEM_SHARED[4] = XORI(41);
	D_MEM_SHARED[5] = SLLI(8);
	D_MEM_SHARED[6] = SRLI(2048);
	D_MEM_SHARED[7] = SRAI(2048);
    D_MEM_SHARED[8] = ADD(123,456);
    D_MEM_SHARED[9] = AND(85,171);
    D_MEM_SHARED[10] = OR(1234,3654);
    D_MEM_SHARED[11] = XOR(42,41);
    D_MEM_SHARED[12] = SLL(4096,3);
	D_MEM_SHARED[13] = SRL(4096,12);
	D_MEM_SHARED[14] = SUB(123,122);
	D_MEM_SHARED[15] = SRA(4096,3);
	D_MEM_SHARED[16] = BEQ(9,9);
	D_MEM_SHARED[17] = BNE(42,42);
	D_MEM_SHARED[18] = BLT(10,10);
	D_MEM_SHARED[19] = BGE(7,7);
}
