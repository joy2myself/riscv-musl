    .text
    .global __strcat_vect
    .type __strcat_vect,%function
    .option push
    .option arch, +v
__strcat_vect:
    mv a2, a0
    /* Perform `strlen(a0)`.  */
Lstrlen_loop:
    vsetvli a3, zero, e8, m1, ta, ma

    vle8ff.v v8, (a2)
    vmseq.vx v0, v8, zero
    csrr a4, vl
    vfirst.m a5, v0
    add a2, a2, a4
    bltz a5, Lstrlen_loop

    sub a2, a2, a4
    add a2, a2, a5

    /* Perform `strcpy(a0, a1)`.  */
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
.size __strcat_vect, .-__strcat_vect
.option pop