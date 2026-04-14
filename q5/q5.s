.data
filename: .asciz "input.txt"
mode_r:   .asciz "r"
yes_str:  .asciz "Yes\n"
no_str:   .asciz "No\n"

.text
.globl main

main:
    addi sp, sp, -48
    sd   ra, 40(sp)
    sd   s0, 32(sp)
    sd   s1, 24(sp)
    sd   s2, 16(sp)
    sd   s3,  8(sp)
    sd   s4,  0(sp)

    la   a0, filename
    la   a1, mode_r
    call fopen
    mv   s0, a0

    mv   a0, s0
    li   a1, 0
    li   a2, 2
    call fseek

    mv   a0, s0
    call ftell
    mv   s1, a0

    li   s2, 0
    addi s3, s1, -1

pal_loop:
    bge  s2, s3, is_palindrome

    mv   a0, s0
    mv   a1, s2
    li   a2, 0
    call fseek
    mv   a0, s0
    call fgetc
    mv   s4, a0

    mv   a0, s0
    mv   a1, s3
    li   a2, 0
    call fseek
    mv   a0, s0
    call fgetc

    bne  s4, a0, not_palindrome

    addi s2, s2, 1
    addi s3, s3, -1
    j    pal_loop

is_palindrome:
    la   a0, yes_str
    call printf
    j    pal_end

not_palindrome:
    la   a0, no_str
    call printf

pal_end:
    mv   a0, s0
    call fclose

    li   a0, 0
    ld   ra, 40(sp)
    ld   s0, 32(sp)
    ld   s1, 24(sp)
    ld   s2, 16(sp)
    ld   s3,  8(sp)
    ld   s4,  0(sp)
    addi sp, sp, 48
    ret