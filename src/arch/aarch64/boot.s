.section .text.boot
.globl   _start

_start:
	// startup primary core
	mrs  x19, mpidr_el1
	and  x19, x19, #3
	cbnz x19, halt

	// 1. TODO: initialize system register
	// 2. switch to EL1
	// 3. TODO: setup page table, enable mmu
	// 4. TODO: clear bss, setup bootstack
el_setup:
	// use SP_ELx for Exception level ELx
	msr SPsel, #1

	// current exception level
	mrs x0, CurrentEL
	and x0, x0, #0b1100
	lsr x0, x0, #2

el2_setup:
	// switch to EL1 if we're in EL2
	cmp x0, #1
	beq el1_setup

	// at EL2, switch to EL1
	adr x0, el1_setup
	msr elr_el2, x0
	eret

el1_setup:
	// setup bootstack
	adrp x1, __kernel_start
	sub  x1, x1, #8
	mov  sp, x1

	// goto rust world
	b rust_main

	// unreachable
halt:
	wfe
	b halt
