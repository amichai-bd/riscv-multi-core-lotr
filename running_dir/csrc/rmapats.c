// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  hsG_0__0 (struct dummyq_struct * I1299, EBLK  * I1294, U  I690);
void  hsG_0__0 (struct dummyq_struct * I1299, EBLK  * I1294, U  I690)
{
    U  I1560;
    U  I1561;
    U  I1562;
    struct futq * I1563;
    struct dummyq_struct * pQ = I1299;
    I1560 = ((U )vcs_clocks) + I690;
    I1562 = I1560 & ((1 << fHashTableSize) - 1);
    I1294->I735 = (EBLK  *)(-1);
    I1294->I736 = I1560;
    if (0 && rmaProfEvtProp) {
        vcs_simpSetEBlkEvtID(I1294);
    }
    if (I1560 < (U )vcs_clocks) {
        I1561 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1294, I1561 + 1, I1560);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I690 == 1)) {
        I1294->I738 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I735 = I1294;
        peblkFutQ1Tail = I1294;
    }
    else if ((I1563 = pQ->I1204[I1562].I750)) {
        I1294->I738 = (struct eblk *)I1563->I749;
        I1563->I749->I735 = (RP )I1294;
        I1563->I749 = (RmaEblk  *)I1294;
    }
    else {
        sched_hsopt(pQ, I1294, I1560);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
