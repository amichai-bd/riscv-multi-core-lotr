#include "stdio.h"
#ifdef __cplusplus
extern "C" {
#endif
extern char at_least_one_object_file;
extern void *kernel_scs_file_ht_new(const void *, int);
extern int kernel_scs_file_ht_get(void *, const char *, int *);
extern int  strcmp(const char*, const char*);
  typedef struct {
    char* dFileName;
  } lPkgFileInfoStruct;

  typedef struct {
    char* dFileName;
    char* dRealFileName;
    long dFileOffset;
    unsigned long dFileSize;
    int dFileModTime;
    unsigned int simFlag;
  } lFileInfoStruct;

static int lNumOfScsFiles;
  static lFileInfoStruct lFInfoArr[] = {
  {"synopsys_sim.setup_0", "/eda/synopsys/2019-20/RHELx86/VCS_2019.06-SP2/vcs/P-2019.06-SP2//bin/synopsys_sim.setup", 75919, 3536, 1575346832, 0},
  {"linux64/packages/synopsys/lib/64/NOVAS__.sim", "", 0, 75919, 0, 0},
  {"linux64/packages/synopsys/lib/64/NOVAS.sim", "", 79455, 50002, 0, 0},
