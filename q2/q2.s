.data
fmt_ld:    .string "%ld"
fmt_space: .string " "
fmt_nl:    .string "\n"

.text
.globl main

main:
    addi sp, sp, -64
    sd   ra, 56(sp)
    sd   s0, 48(sp)
    sd   s1, 40(sp)
    sd   s2, 32(sp)
    sd   s3, 24(sp)
    sd   s4, 16(sp)
    sd   s5,  8(sp)
    sd   s6,  0(sp)

    addi s0, a0, -1
    mv   s1, a1

    slli a0, s0, 3
    call malloc
    mv   s2, a0

    slli a0, s0, 3
    call malloc
    mv   s3, a0

    li   t0, 0
init_loop:
    bge  t0, s0, init_done
    slli t1, t0, 3
    add  t1, s3, t1
    li   t2, -1
    sd   t2, 0(t1)
    addi t0, t0, 1
    j    init_loop
init_done:

    li   t0, 0
parse_loop:
    bge  t0, s0, parse_done
    addi t1, t0, 1
    slli t2, t1, 3
    add  t2, s1, t2
    ld   a0, 0(t2)
    call atoi
    slli t2, t0, 3
    add  t2, s2, t2
    sd   a0, 0(t2)
    addi t0, t0, 1
    j    parse_loop
parse_done:

    slli a0, s0, 3
    call malloc
    mv   s4, a0
    li   s5, 0

    addi t0, s0, -1
nge_loop:
    bltz t0, nge_done

    slli t1, t0, 3
    add  t1, s2, t1
    ld   t1, 0(t1)

pop_while:
    beqz s5, pop_done
    addi t2, s5, -1
    slli t3, t2, 3
    add  t3, s4, t3
    ld   t3, 0(t3)
    slli t4, t3, 3
    add  t4, s2, t4
    ld   t4, 0(t4)
    ble  t4, t1, pop_it
    j    pop_done
pop_it:
    addi s5, s5, -1
    j    pop_while
pop_done:

    beqz s5, skip_record
    addi t2, s5, -1
    slli t3, t2, 3
    add  t3, s4, t3
    ld   t3, 0(t3)
    slli t4, t0, 3
    add  t4, s3, t4
    sd   t3, 0(t4)
skip_record:

    slli t2, s5, 3
    add  t2, s4, t2
    sd   t0, 0(t2)
    addi s5, s5, 1

    addi t0, t0, -1
    j    nge_loop
nge_done:

    li   s6, 0
print_loop:
    bge  s6, s0, print_done

    beqz s6, skip_space
    la   a0, fmt_space
    call printf
skip_space:

    slli t0, s6, 3
    add  t0, s3, t0
    ld   a1, 0(t0)
    la   a0, fmt_ld
    call printf

    addi s6, s6, 1
    j    print_loop
print_done:

    la   a0, fmt_nl
    call printf

    li   a0, 0
    ld   ra, 56(sp)
    ld   s0, 48(sp)
    ld   s1, 40(sp)
    ld   s2, 32(sp)
    ld   s3, 24(sp)
    ld   s4, 16(sp)
    ld   s5,  8(sp)
    ld   s6,  0(sp)
    addi sp, sp, 64
    ret