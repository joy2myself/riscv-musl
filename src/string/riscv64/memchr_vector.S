    .text
    .global __memchr_vect
    .type __memchr_vect,%function
    .option push
    .option arch, +v
__memchr_vect:
Lloop:
    vsetvli zero, a2, e8, m8, ta, ma

    vle8ff.v v0, (a0)
    /* Find the a1 inside the loaded data.  */
    vmseq.vx v8, v0, a1
    vfirst.m a4, v8

    /* Skip the loop if we find the matched a1.  */
    bgez a4, Lfound

    csrr a3, vl
    sub a2, a2, a3
    add a0, a0, a3

    bnez a2, Lloop

    li a0, 0
    ret
Lfound:
    add a0, a0, a4
    ret
.size __memchr_vect, .-__memchr_vect
.option pop