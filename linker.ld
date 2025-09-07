/* bootloader looks at this image to start execution at the designated entry point */
ENTRY(_start)

/* tell where to put the .o sections in the final kernel image */
SECTIONS
{
  /* start offset */
  . = 2M;

  /* first put multiboot header */
  .text BLOCK(4K) : ALIGN(4K)
  {
    *(.multiboot)
    *(.text)
  }

  /* read-only data */
  .rodata BLOCK(4K) : ALIGN(4K)
  {
    *(.rodata)
  }

  /* read-write data (initialized) */
  .data BLOCK(4K) : ALIGN(4K)
  {
    *(.data)
  }

  /* read-write data (uninit) and stack */
  .bss BLOCK(4K) : ALIGN(4K)
  {
    *(COMMON)
    *(.bss)
  }

  /* add more as needed */
}
