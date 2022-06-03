/* virtual address of kernel entry point */
__kernel_start = 0xffffff8040080000;

SECTIONS
{
    . = __kernel_start;

    .text : {
        __text_start = .;
        *(.text.boot)
        *(.text .text.*)
        __text_end = .;
    }

    . = ALIGN(4K);

    .rodata : {
        __rodata_start = .;
        *(.rodata .rodata.*)
        __rodata_end = .;
    }

    . = ALIGN(4K);

    .data : {
        __data_start = .;
        *(.data .data.*)
        __data_end = .;
    }

    . = ALIGN(4K);

    .bss : {
        __bss_start = .;
        *(.bss .bss.*)
        __bss_end = .;
    }

    /* end of the binary */
    __kernel_end = ALIGN(4K);

    /DISCARD/ : { *(.comment) *(.gnu*) *(.note*) *(.eh_frame*) }
}
