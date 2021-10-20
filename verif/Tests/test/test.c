#define SHARED_SPACE  ((volatile int *) (0x00400f00))
int main() {
	int a,b,c;
	a = 5;
    b=4;
    c=a+b;
    SHARED_SPACE[0] = c;
}