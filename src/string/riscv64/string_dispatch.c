#include <stddef.h>
#include <sys/auxv.h>
#include "libc.h"

void *__memset_scalar(void *s, int c, size_t n);
void *__memset_vect(void *s, int c, size_t n);
void *__memcpy_scalar(void *restrict dest, const void *restrict src, size_t n);
void *__memcpy_vect(void *restrict dest, const void *restrict src, size_t n);
void *__mempcpy_scalar(void *dest, const void *src, size_t n);
void *__mempcpy_vect(void *dest, const void *src, size_t n);
void *__memmove_scalar(void *restrict dest, const void *restrict src, size_t n);
void *__memmove_vect(void *restrict dest, const void *restrict src, size_t n);
void *__memccpy_scalar(void *restrict dest, const void *restrict src, int c, size_t n);
void *__memccpy_vect(void *restrict dest, const void *restrict src, int c, size_t n);
void *__memchr_scalar(const void *s, int c, size_t n);
void *__memchr_vect(const void *s, int c, size_t n);
int __memcmp_scalar(const void *s1, const void *s2, size_t n);
int __memcmp_vect(const void *s1, const void *s2, size_t n);
void *__memrchr_scalar(const void *s, int c, size_t n);
void *__memrchr_vect(const void *s, int c, size_t n);

char *__strcat_scalar(char *dest, const char *src);
char *__strcat_vect(char *dest, const char *src);
char *__strncat_scalar(char *dest, const char *src, size_t n);
char *__strncat_vect(char *dest, const char *src, size_t n);
size_t __strlen_scalar(const char *s);
size_t __strlen_vect(const char *s);
size_t __strnlen_scalar(const char *s, size_t maxlen);
size_t __strnlen_vect(const char *s, size_t maxlen);
int __strcmp_scalar(const char *s1, const char *s2);
int __strcmp_vect(const char *s1, const char *s2);
int __strncmp_scalar(const char *s1, const char *s2, size_t n);
int __strncmp_vect(const char *s1, const char *s2, size_t n);
char *__strchr_scalar(const char *s, int c);
char *__strchr_vect(const char *s, int c);
char *__strchrnul_scalar(const char *s, int c);
char *__strchrnul_vect(const char *s, int c);
char *__strcpy_scalar(char *dest, const char *src);
char *__strcpy_vect(char *dest, const char *src);
char *__strncpy_scalar(char *dest, const char *src, size_t n);
char *__strncpy_vect(char *dest, const char *src, size_t n);
char *__strrchr_scalar(const char *s, int c);
char *__strrchr_vect(const char *s, int c);
char *__strstr_scalar(const char *h, const char *n);
char *__strstr_vect(const char *h, const char *n);
char *__strpbrk_scalar(const char *s, const char *b);
char *__strpbrk_vect(const char *s, const char *b);
size_t __strspn_scalar(const char *s, const char *c);
size_t __strspn_vect(const char *s, const char *c);
size_t __strcspn_scalar(const char *s, const char *c);
size_t __strcspn_vect(const char *s, const char *c);
int __strcasecmp_scalar(const char *a, const char *b);
int __strcasecmp_vect(const char *a, const char *b);
int __strncasecmp_scalar(const char *a, const char *b, size_t n);
int __strncasecmp_vect(const char *a, const char *b, size_t n);

/* string function pointer, runtime-dispatched based on RVV support */
#ifndef __riscv_vector
static void *(*__memset_ptr)(void *, int, size_t) = __memset_scalar;
static void *(*__memcpy_ptr)(void *, const void *, size_t) = __memcpy_scalar;
static void *(*__mempcpy_ptr)(void *, const void *, size_t) = __mempcpy_scalar;
static void *(*__memmove_ptr)(void *, const void *, size_t) = __memmove_scalar;
static void *(*__memccpy_ptr)(void *, const void *, int, size_t) = __memccpy_scalar;
static void *(*__memchr_ptr)(const void *, int, size_t) = __memchr_scalar;
static int (*__memcmp_ptr)(const void *, const void *, size_t) = __memcmp_scalar;
static void *(*__memrchr_ptr)(const void *, int, size_t) = __memrchr_scalar;

static char *(*__strcat_ptr)(char *, const char *) = __strcat_scalar;
static char *(*__strncat_ptr)(char *, const char *, size_t) = __strncat_scalar;
static size_t (*__strlen_ptr)(const char *) = __strlen_scalar;
static size_t (*__strnlen_ptr)(const char *, size_t) = __strnlen_scalar;
static int (*__strcmp_ptr)(const char *, const char *) = __strcmp_scalar;
static int (*__strncmp_ptr)(const char *, const char *, size_t) = __strncmp_scalar;
static char *(*__strchr_ptr)(const char *, int) = __strchr_scalar;
static char *(*__strchrnul_ptr)(const char *, int) = __strchrnul_scalar;
static char *(*__strcpy_ptr)(char *, const char *) = __strcpy_scalar;
static char *(*__strncpy_ptr)(char *, const char *, size_t) = __strncpy_scalar;
static char *(*__strrchr_ptr)(const char *, int) = __strrchr_scalar;
static char *(*__strstr_ptr)(const char *, const char *) = __strstr_scalar;
static char *(*__strpbrk_ptr)(const char *, const char *) = __strpbrk_scalar;
static size_t (*__strspn_ptr)(const char *, const char *) = __strspn_scalar;
static size_t (*__strcspn_ptr)(const char *, const char *) = __strcspn_scalar;
static int (*__strcasecmp_ptr)(const char *, const char *) = __strcasecmp_scalar;
static int (*__strncasecmp_ptr)(const char *, const char *, size_t) = __strncasecmp_scalar;
#else
static void *(*__memset_ptr)(void *, int, size_t) = __memset_vect;
static void *(*__memcpy_ptr)(void *, const void *, size_t) = __memcpy_vect;
static void *(*__mempcpy_ptr)(void *, const void *, size_t) = __mempcpy_vect;
static void *(*__memmove_ptr)(void *, const void *, size_t) = __memmove_vect;
static void *(*__memccpy_ptr)(void *, const void *, int, size_t) = __memccpy_vect;
static void *(*__memchr_ptr)(const void *, int, size_t) = __memchr_vect;
static int (*__memcmp_ptr)(const void *, const void *, size_t) = __memcmp_vect;
static void *(*__memrchr_ptr)(const void *, int, size_t) = __memrchr_vect;

static char *(*__strcat_ptr)(char *, const char *) = __strcat_vect;
static char *(*__strncat_ptr)(char *, const char *, size_t) = __strncat_vect;
static size_t (*__strlen_ptr)(const char *) = __strlen_vect;
static size_t (*__strnlen_ptr)(const char *, size_t) = __strnlen_vect;
static int (*__strcmp_ptr)(const char *, const char *) = __strcmp_vect;
static int (*__strncmp_ptr)(const char *, const char *, size_t) = __strncmp_vect;
static char *(*__strchr_ptr)(const char *, int) = __strchr_vect;
static char *(*__strchrnul_ptr)(const char *, int) = __strchrnul_vect;
static char *(*__strcpy_ptr)(char *, const char *) = __strcpy_vect;
static char *(*__strncpy_ptr)(char *, const char *, size_t) = __strncpy_vect;
static char *(*__strrchr_ptr)(const char *, int) = __strrchr_vect;
static char *(*__strstr_ptr)(const char *, const char *) = __strstr_vect;
static char *(*__strpbrk_ptr)(const char *, const char *) = __strpbrk_vect;
static size_t (*__strspn_ptr)(const char *, const char *) = __strspn_vect;
static size_t (*__strcspn_ptr)(const char *, const char *) = __strcspn_vect;
static int (*__strcasecmp_ptr)(const char *, const char *) = __strcasecmp_vect;
static int (*__strncasecmp_ptr)(const char *, const char *, size_t) = __strncasecmp_vect;
#endif

void *memset(void *s, int c, size_t n)
{
	return __memset_ptr(s, c, n);
}

void *memcpy(void *restrict dest, const void *restrict src, size_t n)
{
	return __memcpy_ptr(dest, src, n);
}

void *mempcpy(void *dest, const void *src, size_t n)
{
	return __mempcpy_ptr(dest, src, n);
}

void *memmove(void *dest, const void *src, size_t n)
{
	return __memmove_ptr(dest, src, n);
}

void *memccpy(void *restrict dest, const void *restrict src, int c, size_t n)
{
	return __memccpy_ptr(dest, src, c, n);
}

void *memchr(const void *s, int c, size_t n)
{
	return __memchr_ptr(s, c, n);
}

int memcmp(const void *s1, const void *s2, size_t n)
{
	return __memcmp_ptr(s1, s2, n);
}

void *memrchr(const void *s, int c, size_t n)
{
	return __memrchr_ptr(s, c, n);
}

char *strcat(char *dest, const char *src)
{
	return __strcat_ptr(dest, src);
}

char *strncat(char *dest, const char *src, size_t n)
{
	return __strncat_ptr(dest, src, n);
}

size_t strlen(const char *s)
{
	return __strlen_ptr(s);
}

size_t strnlen(const char *s, size_t maxlen)
{
	return __strnlen_ptr(s, maxlen);
}

int strcmp(const char *s1, const char *s2)
{
	return __strcmp_ptr(s1, s2);
}

int strncmp(const char *s1, const char *s2, size_t n)
{
	return __strncmp_ptr(s1, s2, n);
}

char *strchr(const char *s, int c)
{
	return __strchr_ptr(s, c);
}

char *strchrnul(const char *s, int c)
{
	return __strchrnul_ptr(s, c);
}

char *strcpy(char *dest, const char *src)
{
	return __strcpy_ptr(dest, src);
}

char *strncpy(char *restrict dest, const char *restrict src, size_t n)
{
	return __strncpy_ptr(dest, src, n);
}

char *strrchr(const char *s, int c)
{
	return __strrchr_ptr(s, c);
}

char *strstr(const char *h, const char *n)
{
	return __strstr_ptr(h, n);
}

char *strpbrk(const char *s, const char *b)
{
	return __strpbrk_ptr(s, b);
}

size_t strspn(const char *s, const char *c)
{
	return __strspn_ptr(s, c);
}

size_t strcspn(const char *s, const char *c)
{
	return __strcspn_ptr(s, c);
}

int strcasecmp(const char *a, const char *b)
{
	return __strcasecmp_ptr(a, b);
}

int strncasecmp(const char *a, const char *b, size_t n)
{
	return __strncasecmp_ptr(a, b, n);
}

static inline int __has_rvv_via_hwcap(void)
{
	const unsigned long V_bit = (1ul << ('V' - 'A'));
	unsigned long hwcap = __getauxval(AT_HWCAP);
	return (hwcap & V_bit) != 0;
}

hidden void __init_riscv_string_optimizations(void)
{
	if (__has_rvv_via_hwcap()) {
		__memset_ptr = __memset_vect;
		__memcpy_ptr = __memcpy_vect;
		__mempcpy_ptr = __mempcpy_vect;
		__memmove_ptr = __memmove_vect;
		__memccpy_ptr = __memccpy_vect;
		__memchr_ptr = __memchr_vect;
		__memcmp_ptr = __memcmp_vect;
		__memrchr_ptr = __memrchr_vect;

		__strcat_ptr = __strcat_vect;
		__strncat_ptr = __strncat_vect;
		__strlen_ptr = __strlen_vect;
		__strnlen_ptr = __strnlen_vect;
		__strcmp_ptr = __strcmp_vect;
		__strncmp_ptr = __strncmp_vect;
		__strchr_ptr = __strchr_vect;
		__strchrnul_ptr = __strchrnul_vect;
		__strcpy_ptr = __strcpy_vect;
		__strncpy_ptr = __strncpy_vect;
		__strrchr_ptr = __strrchr_vect;
		__strstr_ptr = __strstr_vect;
		__strpbrk_ptr = __strpbrk_vect;
		__strspn_ptr = __strspn_vect;
		__strcspn_ptr = __strcspn_vect;
		__strcasecmp_ptr = __strcasecmp_vect;
		__strncasecmp_ptr = __strncasecmp_vect;
	}
}
