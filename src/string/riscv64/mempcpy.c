/* Rename the generic mempcpy to __mempcpy_scalar and include it */
#define mempcpy __mempcpy_scalar
#include "../mempcpy.c"
#undef mempcpy