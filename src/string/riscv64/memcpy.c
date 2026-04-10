/* Rename the generic memcpy to __memcpy_scalar and include it */
#define memcpy __memcpy_scalar
#include "../memcpy.c"
#undef memcpy
