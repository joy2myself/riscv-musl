    .text
    .global __strcspn_vect
    .type __strcspn_vect,%function
    .option push
    .option arch, +v
/* size_t strcspn(const char *a0, const char *a1)
   Length of the initial segment of a0 made up of bytes NOT in a1.
   Build a 256-byte "stop" table on the stack (a1's bytes plus NUL marked),
   then scan a0: a gathered table entry != 0 ends the segment. The scan of
   a0 uses vle8ff so it never loads across a page boundary; the indexed
   gather only touches the fully-mapped 256-byte table. */
__strcspn_vect:
    addi sp, sp, -256
    /* zero the table */
    li t1, 256
    mv t0, sp
Lcspn_zero:
    vsetvli t2, t1, e8, m8, ta, ma
    vmv.v.i v8, 0
    vse8.v v8, (t0)
    add t0, t0, t2
    sub t1, t1, t2
    bnez t1, Lcspn_zero
    /* mark NUL as a stopper so the scan halts at end of string */
    li t1, 1
    sb t1, 0(sp)
    /* mark every byte of a1 */
Lcspn_build:
    lbu t0, 0(a1)
    beqz t0, Lcspn_scan
    add t2, sp, t0
    sb t1, 0(t2)
    addi a1, a1, 1
    j Lcspn_build
Lcspn_scan:
    mv a2, a0            /* remember start */
Lcspn_loop:
    vsetvli t3, zero, e8, m1, ta, ma
    vle8ff.v v8, (a0)
    csrr t3, vl
    vluxei8.v v16, (sp), v8      /* gather table[a0[i]] */
    vmsne.vi v0, v16, 0          /* lanes that are stoppers */
    vfirst.m t4, v0
    bgez t4, Lcspn_found
    add a0, a0, t3
    j Lcspn_loop
Lcspn_found:
    add a0, a0, t4
    sub a0, a0, a2
    addi sp, sp, 256
    ret
.size __strcspn_vect, .-__strcspn_vect
.option pop
