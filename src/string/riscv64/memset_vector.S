    .text
    .global __memset_vect
    .type __memset_vect,%function
    .option push
    .option arch, +v
/* void *__memset_vect(void *s, int c, size_t n)
 * a0 = s (dest), a1 = c (fill byte), a2 = n (size)
 * Returns a0.
 */
__memset_vect:
    mv      t0, a0                    /* running dst; keep a0 as return */
    beqz    a2, .Ldone_vect           /* n == 0 then return */

    /* Broadcast fill byte once. */
    vsetvli t1, zero, e8, m8, ta, ma
    vmv.v.x v0, a1

.Lbulk_vect:
    vsetvli t1, a2, e8, m8, ta, ma    /* t1 = vl (bytes) */
    vse8.v  v0, (t0)
    add     t0, t0, t1
    sub     a2, a2, t1
    bnez    a2, .Lbulk_vect
    /* fallthrough */

.Ldone_vect:
    ret
.size __memset_vect, .-__memset_vect
.option pop
