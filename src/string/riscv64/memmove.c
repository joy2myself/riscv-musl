/* Rename the generic memmove to __memmove_scalar and include it */
#define memmove __memmove_scalar
#include "../memmove.c"
#undef memmove
