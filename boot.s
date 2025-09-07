/* constants for the multiboot header */
.set ALIGN,     1<<0              /* align loaded modules on page boundaries */
.set MEMINFO,   1<<1              /* provide memory map */
.set FLAGS,     ALIGN | MEMINFO   /* multiboot 'flag' field */
.set MAGIC,     0x1BADB002        /* 'magic' number lets bootlader find the header */
.set CHECKSUM,  -(MAGIC + FLAGS)  /* checksum of above, to prove we are multiboot */

/* multiboot header, marking program as a kernel */
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

/* allocate room for a stack */
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

/* specify entry point */
.section .text
.global _start
.type _start, @function
_start:
    /* load into 32-bit protected mode */
    
    /* point esp register to stop of stack */
    mov $stack_top, %esp
    
    /* initialize processor state */
    /* enter high-level kernel */
    call kernel_main

    /* put computer into infinite loop */
    /* disable interrupts */
    cli # clear interupt
    /* wait for next interrupt */
1:  hlt # halt instruction
    /* jump back to hlt if woken by non-maskable interrupt or due to system management mode */
    jmp 1b

/* set size of _start to current location '.' minus its start */
.size _start, . - _start
