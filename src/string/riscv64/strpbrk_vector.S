    .text
    .global __strpbrk_vect
    .type __strpbrk_vect,%function
    .option push
    .option arch, +v
/* char *strpbrk(const char *a0, const char *a1)
   Return a pointer to the first byte of a0 that appears in a1, or NULL.
   Equivalent to s + strcspn(s, b), returning NULL when that lands on the
   terminating NUL. Same page-safe vle8ff scan + stack-table gather as
   strcspn; the NUL is marked as a stopper so the scan terminates. */
__strpbrk_vect:
    addi sp, sp, -256
    li t1, 256
    mv t0, sp
Lpbrk_zero:
    vsetvli t2, t1, e8, m8, ta, ma
    vmv.v.i v8, 0
    vse8.v v8, (t0)
    add t0, t0, t2
    sub t1, t1, t2
    bnez t1, Lpbrk_zero
    li t1, 1
    /* mark every byte of a1 (the set), but NOT NUL yet */
Lpbrk_build:
    lbu t0, 0(a1)
    beqz t0, Lpbrk_setnul
    add t2, sp, t0
    sb t1, 0(t2)
    addi a1, a1, 1
    j Lpbrk_build
Lpbrk_setnul:
    /* mark NUL as a stopper so the scan halts at end of string */
    sb t1, 0(sp)
Lpbrk_loop:
    vsetvli t3, zero, e8, m1, ta, ma
    vle8ff.v v8, (a0)
    csrr t3, vl
    vluxei8.v v16, (sp), v8
    vmsne.vi v0, v16, 0
    vfirst.m t4, v0
    bgez t4, Lpbrk_found
    add a0, a0, t3
    j Lpbrk_loop
Lpbrk_found:
    add a0, a0, t4
    lbu t5, 0(a0)        /* did we stop on a real match or on the NUL? */
    bnez t5, Lpbrk_done
    li a0, 0
Lpbrk_done:
    addi sp, sp, 256
    ret
.size __strpbrk_vect, .-__strpbrk_vect
.option pop
