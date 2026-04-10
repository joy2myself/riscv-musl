    .text
    .global __memmove_vect
    .type __memmove_vect,%function
    .option push
    .option arch, +v
/* void *__memmove_vect(void *dest, const void *src, size_t n)
 * a0 = dest, a1 = src, a2 = n
 * Returns a0.
 */
__memmove_vect:
    beqz    a2, .Ldone_move           /* n == 0 */
    beq     a0, a1, .Ldone_move       /* dst == src */

    /* overlap check */
    bgeu    a1, a0, .Lforward_move    /* src >= dst then forward move*/

    sub     t2, a0, a1                /* t2 = dst - src */
    bgeu    t2, a2, .Lforward_move    /* no overlap then forward move */

    /* backward move */
    add     t0, a0, a2                /* running dst_end */
    add     t1, a1, a2                /* running src_end */

.Lbackward_loop:
    vsetvli t3, a2, e8, m8, ta, ma    /* t3 = vl (bytes) */
    sub     t0, t0, t3
    sub     t1, t1, t3
    vle8.v  v0, (t1)
    vse8.v  v0, (t0)
    sub     a2, a2, t3
    bnez    a2, .Lbackward_loop
    j       .Ldone_move

    /* forward move, same as __memcpy_vect */
.Lforward_move:
    mv      t0, a0                    /* running dst */
    mv      t1, a1                    /* running src */

.Lforward_loop:
    vsetvli t3, a2, e8, m8, ta, ma
    vle8.v  v0, (t1)
    vse8.v  v0, (t0)
    add     t0, t0, t3
    add     t1, t1, t3
    sub     a2, a2, t3
    bnez    a2, .Lforward_loop
    /* fallthrough */

.Ldone_move:
    ret
.size __memmove_vect, .-__memmove_vect
.option pop
