    .text
    .global __strcpy_vect
    .type __strcpy_vect,%function
    .option push
    .option arch,+v
__strcpy_vect:
    mv a2, a0
Lstrcpy_loop:
    vsetvli a3, zero, e8, m1, ta, ma
    vle8ff.v v8, (a1)
    vmseq.vx v1, v8, zero
    csrr a4, vl
    vfirst.m a5, v1
    vmsif.m v0, v1
    add a1, a1, a4
    vse8.v v8, (a2), v0.t
    add a2, a2, a4
    bltz a5, Lstrcpy_loop

    ret
.size __strcpy_vect, .-__strcpy_vect
.option pop