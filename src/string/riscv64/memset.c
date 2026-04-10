/* Rename the generic memset to __memset_scalar and include it */
#define memset __memset_scalar
#include "../memset.c"
#undef memset
