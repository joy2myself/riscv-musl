    .text
    .global __strstr_vect
    .type __strstr_vect,%function
    .option push
    .option arch, +v
/* char *strstr(const char *a0, const char *a1)
   Locate substring a1 in a0. A vectorized scan (vle8ff, page-boundary safe)
   finds candidate positions of needle[0]; each candidate is verified with a
   byte loop that stops at the needle's NUL (match) or at a mismatch/the
   haystack NUL. Both phases stop at a NUL, so no load ever crosses past the
   end of either string into an unmapped page. */
__strstr_vect:
    lbu t0, 0(a1)            /* c0 = needle[0] */
    beqz t0, Lss_ret_h       /* empty needle -> return haystack */
Lss_loop:
    vsetvli t1, zero, e8, m1, ta, ma
    vle8ff.v v8, (a0)
    csrr t1, vl
    vmseq.vx v1, v8, t0      /* lanes == c0 */
    vmseq.vi v2, v8, 0       /* NUL lanes */
    vfirst.m t2, v1
    vfirst.m t3, v2
    bltz t2, Lss_no_c0       /* no c0 in this chunk */
    bltz t3, Lss_candidate   /* c0 present, no NUL -> candidate */
    bltu t2, t3, Lss_candidate /* c0 occurs before NUL */
    /* NUL at or before c0 -> end of haystack reached */
Lss_notfound:
    li a0, 0
    ret
Lss_no_c0:
    bgez t3, Lss_notfound    /* hit NUL with no c0 -> not found */
    add a0, a0, t1
    j Lss_loop
Lss_candidate:
    add a0, a0, t2           /* a0 -> candidate (h[*]==c0) */
    mv t4, a0                /* haystack cursor */
    mv t5, a1                /* needle cursor */
Lss_verify:
    lbu t6, 0(t5)
    beqz t6, Lss_match       /* needle exhausted -> match at a0 */
    lbu a2, 0(t4)
    bne a2, t6, Lss_advance  /* mismatch (a2 may be NUL) */
    addi t4, t4, 1
    addi t5, t5, 1
    j Lss_verify
Lss_advance:
    addi a0, a0, 1           /* slide one byte and rescan */
    j Lss_loop
Lss_match:
    ret
Lss_ret_h:
    ret
.size __strstr_vect, .-__strstr_vect
.option pop
