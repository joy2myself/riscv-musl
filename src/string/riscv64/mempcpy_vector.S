    .text
    .global __mempcpy_vect
    .type __mempcpy_vect,%function
    .option push
    .option arch, +v
/* void *__mempcpy_vect(void *dest, const void *src, size_t n)
 * a0 = dest, a1 = src, a2 = n
 * Returns dest + n.
 */
__mempcpy_vect:
    mv      t0, a0                    /* running dst */
    mv      t1, a1                    /* running src */
    beqz    a2, .Ldone_copy           /* n == 0 then return dest */

.Lbulk_copy:
    vsetvli t2, a2, e8, m8, ta, ma    /* t2 = vl (bytes) */
    vle8.v  v0, (t1)
    vse8.v  v0, (t0)
    add     t0, t0, t2
    add     t1, t1, t2
    sub     a2, a2, t2
    bnez    a2, .Lbulk_copy

.Ldone_copy:
    mv      a0, t0
    ret
.size __mempcpy_vect, .-__mempcpy_vect
.option pop