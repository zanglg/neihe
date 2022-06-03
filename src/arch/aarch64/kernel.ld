/* virtual address of kernel entry point */
__kernel_start = 0xffffff8040080000;

SECTIONS
{
    . = __kernel_start;

    .text : {
        __text_start = .;
        *(.text.boot)
        *(.text .text.*)
        . = ALIGN(4K);
    }

    .rodata : {
        *(.rodata .rodata.*)
        . = ALIGN(4K);
    }

    .data : {
        *(.data .data.*)
        . = ALIGN(4K);
    }

    .bss : {
        *(.bss .bss.*)
        . = ALIGN(4K);
    }

    /* end of the binary */
    __kernel_end = ALIGN(4K);

    /DISCARD/ : { *(.comment) *(.gnu*) *(.note*) *(.eh_frame*) }
}
