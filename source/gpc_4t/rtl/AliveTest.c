#include <stdio.h>

//Register-Immediate Instructions
void ADDI(int a){
    a=a+3;
}
void SLTI(int a, int b){
    if(a<3){
        b=1;
    }
} //probably will do with branch, need to check ASSEMBLY
void ANDI(int a){
    a=a&6;
}
void ORI(int a){
    a=a|3;
}
void XORI(int a){
    a=a^9;
}
void SLLI(int a){
    a=a<<3;
}
void SRLI(int a){
    a=a>>2;
}
void SRAI(int a){
    a=a>>3;
} //watch for the sign
void LUI(){}
void AUIPC(){}

//Register-Register Instructions
void ADD(int a, int b){
    a=a+b;
}
void SLT(int a, int b){
    int c;
    a<b? c=1 : c=0;
} //give positive a,b
void SLTU(int a, int b){
    int c;
    a<b? c=1 : c=0;
} //give negative a,b
void AND(int a, int b){
    a=a&b;
}
void OR(int a, int b){
    a=a|b;
}
void XOR(int a, int b){
    a=a^b;
}
void SLL(int a, int b){
    a=a<<b;
}
void SRL(int a, int b){
    a=a>>b;
}
void SUB(int a, int b){
    a=b-a;
}
void SRA(int a, int b){
    a=a>>b;
} //watch for the sign
//Unconditional Jumps
void JAL(){}
void JALR(){}
//Conditional Branches
void BEQ(int a, int b){
    if(a==b){
        a=1;
    }
} //check in the ASSEMBLY if the jump is for BEQ or BNE
void BNE(int a, int b){
    if(a!=b){
        a=1;
    }
} //check in the ASSEMBLY if the jump is for BEQ or BNE
void BLT(int a, int b){
    if(a<b){
        a=1;
    }
} //check in the ASSEMBLY if the jump is for BLT or BGE
void BGE(int a, int b){
    if(a>=b){
        a=1;
    }
} //check in the ASSEMBLY if the jump is for BLT or BGE
//Load and Store Instructions
void STORE(int* a){ //remember to call with STORE(&a)
    int* addrptr=a;
    *addrptr=1;
}
void LOAD(int* a){ //remember to call with LOAD(&a)
    int* addrptr=a;
    int c=*addrptr;
    printf("%d",c);
}

int main()
{
    int a=-16;
    int b=2;
    STORE(&a);
    LOAD(&a);

}
