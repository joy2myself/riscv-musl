    .text
    .global __strspn_vect
    .type __strspn_vect,%function
    .option push
    .option arch, +v
/* size_t strspn(const char *a0, const char *a1)
   Length of the initial segment of a0 made up entirely of bytes in a1.
   Build a 256-byte "accept" table from a1 (NUL is never marked, since a1 is
   a string), then scan a0 and stop at the first byte not in the set; a NUL
   in a0 stops the scan naturally. The scan uses vle8ff (page-boundary safe);
   the gather only touches the fully-mapped 256-byte table. */
__strspn_vect:
    addi sp, sp, -256
    li t1, 256
    mv t0, sp
Lspn_zero:
    vsetvli t2, t1, e8, m8, ta, ma
    vmv.v.i v8, 0
    vse8.v v8, (t0)
    add t0, t0, t2
    sub t1, t1, t2
    bnez t1, Lspn_zero
    li t1, 1
Lspn_build:
    lbu t0, 0(a1)
    beqz t0, Lspn_scan
    add t2, sp, t0
    sb t1, 0(t2)
    addi a1, a1, 1
    j Lspn_build
Lspn_scan:
    mv a2, a0
Lspn_loop:
    vsetvli t3, zero, e8, m1, ta, ma
    vle8ff.v v8, (a0)
    csrr t3, vl
    vluxei8.v v16, (sp), v8      /* gather accept[a0[i]] */
    vmseq.vi v0, v16, 0          /* lanes NOT in the accept set */
    vfirst.m t4, v0
    bgez t4, Lspn_found
    add a0, a0, t3
    j Lspn_loop
Lspn_found:
    add a0, a0, t4
    sub a0, a0, a2
    addi sp, sp, 256
    ret
.size __strspn_vect, .-__strspn_vect
.option pop
