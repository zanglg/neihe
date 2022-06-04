/* virtual address of kernel entry point */
__kernel_start = 0xffffff8040080000;

SECTIONS
{
    . = __kernel_start;

    .text : ALIGN(4K) {
        __text_start = .;
        *(.text.boot)
        *(.text .text.*)
        __text_end = .;
    }

    .rodata : ALIGN(4K) {
        __rodata_start = .;
        *(.rodata .rodata.*)
        __rodata_end = .;
    }

    .data : ALIGN(4K) {
        __data_start = .;
        *(.data .data.*)
        __data_end = .;
    }

    .bss : ALIGN(4K) {
        __bss_start = .;
        *(.bss .bss.*)
        __bss_end = .;
    }

    /* end of the binary */
    __kernel_end = ALIGN(4K);

    /DISCARD/ : { *(.comment) *(.gnu*) *(.note*) *(.eh_frame*) }
}
