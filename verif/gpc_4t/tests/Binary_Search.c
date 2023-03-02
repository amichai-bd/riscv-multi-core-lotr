/*AliveTest.c
search integer in an array
test owner: Saar Kadosh
Created : 05/2021
*/
//---------------------------------------------------------
// MEMORY
//    INSTRRAM     : ORIGIN =       , LENGTH =       ,  #words= 
//    DATARAM      : ORIGIN =       , LENGTH =       ,  #words= 
//    STACK        : ORIGIN =       , LENGTH =       ,  #words= 
//    MMIO_GENERAL : ORIGIN =       , LENGTH =       ,  #words= 
//    MMIO_CSR     : ORIGIN =       , LENGTH =       ,  #words= 
//    MMIO_ER      : ORIGIN =       , LENGTH =       ,  #words= 
//    MMIO_DRCT_IN : ORIGIN =       , LENGTH =       ,  #words= 
//    MMIO_DRCT_OUT: ORIGIN =       , LENGTH =       ,  #words= 
//----------------------------------------------------------
#define MMIO_GENERAL  (*(volatile int (*)[1])(0x00400F00))//

int binarySearch(int arr[], int l, int r, int x)
{
    while (l <= r) {
        int m = l + (r - l) / 2;
  
        // Check if x is present at mid
        if (arr[m] == x)
            return m;
  
        // If x greater, ignore left half
        if (arr[m] < x)
            l = m + 1;
  
        // If x is smaller, ignore right half
        else
            r = m - 1;
    }
  
    // if we reach here, then element was
    // not present
    return -1;
}
  
int main()
{
    int arr[] = { 2, 3, 4, 10, 40 };
    int n = 6;
    int x = 10;
    int result = binarySearch(arr, 0, n - 1, x);
    if (result == -1)
        MMIO_GENERAL[0] = 0;
    else
        MMIO_GENERAL[0]=1;

    return 0;
}