    .text
    .global __memrchr_vect
    .type __memrchr_vect,%function
    .option push
    .option arch, +v
__memrchr_vect:
    add a0, a0, a2
Lloop:
    beqz a2, Lnohit

    vsetvli a3, a2, e8, m4, ta, ma
    sub a0, a0, a3
    vle8.v v8, (a0)
    sub a2, a2, a3

    vmseq.vx v0, v8, a1
    vfirst.m a4, v0
    bltz a4, Lloop
Lhit:
    vsetvli zero, a3, e16, m8, ta, ma
    vid.v v16

    /* reduce max index over hit lanes */
    vmv.s.x v24, x0
    vredmaxu.vs v24, v16, v24, v0.t
    vmv.x.s a5, v24

    add a0, a0, a5
    ret
Lnohit:
    li a0, 0
    ret
.size __memrchr_vect, .-__memrchr_vect
.option pop