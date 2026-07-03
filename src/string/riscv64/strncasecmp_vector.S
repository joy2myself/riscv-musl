    .text
    .global __strncasecmp_vect
    .type __strncasecmp_vect,%function
    .option push
    .option arch, +v
/* int strncasecmp(const char *a0, const char *a1, size_t a2)
   Case-insensitive compare of at most a2 bytes. vle8ff keeps loads from
   crossing a page boundary; vl is also capped by the remaining count so we
   never read past the n-th byte. */
__strncasecmp_vect:
    beqz a2, Lncase_zero
    li t0, 65            /* 'A' */
    li t1, 26
    li t2, 32
Lncase_loop:
    vsetvli zero, a2, e8, m1, ta, mu
    vle8ff.v v8, (a0)
    vle8ff.v v16, (a1)
    csrr a3, vl
    /* fold left */
    vsub.vx v24, v8, t0
    vmsltu.vx v0, v24, t1
    vadd.vx v8, v8, t2, v0.t
    /* fold right */
    vsub.vx v24, v16, t0
    vmsltu.vx v0, v24, t1
    vadd.vx v16, v16, t2, v0.t
    /* NUL in left or mismatch */
    vmseq.vi v1, v8, 0
    vmsne.vv v2, v8, v16
    vmor.mm v1, v1, v2
    sub a2, a2, a3
    vfirst.m a4, v1
    bgez a4, Lncase_end
    add a0, a0, a3
    add a1, a1, a3
    bnez a2, Lncase_loop
    /* exhausted n with no NUL/diff: all compared bytes were equal -> 0 */
    li a0, 0
    ret
Lncase_end:
    add a0, a0, a4
    add a1, a1, a4
    lbu a4, 0(a0)
    lbu a5, 0(a1)
    addi a6, a4, -65
    sltiu a6, a6, 26
    slli a6, a6, 5
    add a4, a4, a6
    addi a6, a5, -65
    sltiu a6, a6, 26
    slli a6, a6, 5
    add a5, a5, a6
    sub a0, a4, a5
    ret
Lncase_zero:
    li a0, 0
    ret
.size __strncasecmp_vect, .-__strncasecmp_vect
.option pop
