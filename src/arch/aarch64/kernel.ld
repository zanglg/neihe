/* virtual address of kernel entry point */
__kernel_start = 0xffff000000080000;

SECTIONS
{
    . = __kernel_start;

    .text : {
        __text_start = .;
        *(.text.boot)
        *(.text .text.*)
        . = ALIGN(4K);
        __text_end = .;
    }

    .rodata : {
        __rodata_start = .;
        *(.rodata .rodata.*)
        . = ALIGN(4K);
        __rodata_end = .;
    }

    .data : {
        __data_start = .;
        *(.data .data.*)
        . = ALIGN(4K);
        __data_end = .;
    }

    .bss : {
        __bss_start = .;
        *(.bss .bss.*)
        . = ALIGN(4K);
        __bss_end = .;
    }

    /* end of the binary */
    __kernel_end = ALIGN(4K);

    /DISCARD/ : { *(.comment) *(.gnu*) *(.note*) *(.eh_frame*) }
}
