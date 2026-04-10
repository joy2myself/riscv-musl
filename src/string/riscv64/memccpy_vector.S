    .text
    .global __memccpy_vect
    .type __memccpy_vect,%function
    .option push
    .option arch, +v
__memccpy_vect:
    mv a5, a0
Lloop:
    vsetvli zero, a3, e8, m8, ta, ma
    vle8ff.v v0, (a1)

    vmseq.vx v8, v0, a2
    vfirst.m a6, v8
    csrr a4, vl
    bgez a6, Lfound
    vse8.v v0, (a5)

    sub a3, a3, a4
    add a1, a1, a4
    add a5, a5, a4
    bnez a3, Lloop
    mv a0, zero
    ret
Lfound:
    addi a6, a6, 1
    vsetvli zero, a6, e8, m8, ta, ma
    vse8.v v0, (a5)
    add a0, a5, a6
    ret
.size __memccpy_vect, .-__memccpy_vect
.option pop