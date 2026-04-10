    .text
    .global __strnlen_vect
    .type __strnlen_vect,%function
    .option push
    .option arch, +v
__strnlen_vect:
    mv a2, a0
    mv a0, a1
Lstrnlen_vector_loop:
    beqz a1, Lend_strnlen_vector_loop
    vsetvli zero, a1, e8, m1, ta, ma
    vle8ff.v v0, (a2)
    vmseq.vi v8, v0, 0
    vfirst.m a4, v8 /* first occurence of \0 */
    csrr a3, vl
    add a2, a2, a3
    sub a1, a1, a3
    bltz a4, Lstrnlen_vector_loop
    add a1, a1, a3
    sub a0, a0, a1
    add a0, a0, a4
Lend_strnlen_vector_loop:
    ret
.size __strnlen_vect, .-__strnlen_vect
.option pop