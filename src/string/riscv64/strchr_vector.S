    .text
    .global __strchr_vect
    .type __strchr_vect,%function
    .option push
    .option arch, +v
__strchr_vect:
Lstrchr_loop:
    vsetvli t0, zero, e8, m1, ta, ma
    vle8ff.v v0, (a0)
    vmseq.vi v8, v0, 0
    vmseq.vx v9, v0, a1
    vfirst.m a2, v8 /* first occurrence of \0 */
    vfirst.m a3, v9 /* first occurrence of a1 */
    sltz a4, a3
    sltu a5, a2, a3
    or a4, a4, a5
    beqz a4, Lfound_ch /* Found a1, not preceded by \0? */
    csrr a6, vl
    add a0, a0, a6
    bltz a2, Lstrchr_loop /* Didn't find \0? */
    li a0, 0
    ret
Lfound_ch:
    add a0, a0, a3
    ret
.size __strchr_vect, .-__strchr_vect
.option pop