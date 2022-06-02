// Ref1: cortex_a72_mpcore_trm_100095_0003_06_en.pdf

.section .text.boot
.globl   _start

_start:
	// startup primary core
	mrs  x19, mpidr_el1
	and  x19, x19, #3
	cbnz x19, halt

	b primary_entry

primary_entry:
	bl init_kernel_el
	bl __cpu_setup
	b  __primary_switched

init_kernel_el:
	mrs  x0, CurrentEL
	cmp  x0, 0b1000    // EL2 - BIT[2:3]
	b.eq init_el2

init_el1:
	// Reset Value, Little Endian + MMU Disabled - Ref1(4.3.30)
	ldr x0, =0xC50838
	msr sctlr_el1, x0
	isb

	ret

init_el2:
	// use SP_ELx for Exception level ELx
	msr SPsel, 0x1

	// HCR_RW - BIT(31): Register Width, EL1 is AArch64 - Ref1(4.3.34)
	ldr x0, =0x80000000
	msr hcr_el2, x0
	isb

	// Reset Value, Little Endian + MMU Disabled - Ref1(4.3.30)
	ldr x0, =0x30C50838
	msr sctlr_el2, x0
	isb

	// Allow Non-secure EL1 and EL0 to access physical timer and counter.
	// Enable EL1 physical timers and Clear virtual offset
	ldr x0, =0x3
	msr cnthctl_el2, x0
	msr cntvoff_el2, xzr

	// Disable CP15 traps to EL2 - Ref1(4.3.36)
	msr hstr_el2, xzr

	// virtual cpu id registers - Ref1(4.3.28, 4.3.29)
	mrs x0, midr_el1
	mrs x1, mpidr_el1
	msr vpidr_el2, x0
	msr vmpidr_el2, x1

	// No trap of CPACR, FP and SIMD access to EL2 - Ref1(4.3.35)
	ldr x0, =0x33ff
	msr cptr_el2, x0

	// Reset Value, Little Endian + MMU Disabled - Ref1(4.3.30)
	ldr x0, =0xC50838
	msr sctlr_el1, x0
	isb

	// Switch to EL1
	msr elr_el2, lr
	eret

	// TODO
__cpu_setup:
	// Invalidate local TLB
	tlbi vmalle1
	dsb  nsh

	// Enable FP/ASIMD
	mov x0, #3 << 20
	msr cpacr_el1, x0

	// Reset mdscr_el1 and disable access to the DCC from EL0
	mov x0, #1 << 12
	msr mdscr_el1, x0
	isb

	// MAIR_ELx memory attributes
	//
	// MAIR_ATTR_DEVICE_nGnRnE      UL(0x00)
	// MAIR_ATTR_DEVICE_nGnRE       UL(0x04)
	// MAIR_ATTR_NORMAL_NC          UL(0x44)
	// MAIR_ATTR_NORMAL_TAGGED      UL(0xf0)
	// MAIR_ATTR_NORMAL             UL(0xff)
	// MAIR_ATTR_MASK               UL(0xff)
	//
	// MT_NORMAL		            0
	// MT_NORMAL_TAGGED	            1
	// MT_NORMAL_NC		            2
	// MT_DEVICE_nGnRnE	            3
	// MT_DEVICE_nGnRE	            4
	ldr x0, =0x040044f0ff
	msr mair_el1, x0

	ret

__primary_switched:
	// setup bootstack
	adr x0, __kernel_start
	mov sp, x0

	// goto rust world
	b rust_main

	// unreachable
halt:
	wfe
	b halt
