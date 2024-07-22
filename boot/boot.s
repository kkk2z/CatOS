BITS 16
ORG 0x7C00

START:
    ; Set up the stack
    mov ax, 0x07C0
    mov ss, ax
    mov sp, 0xFFFF

    ; Set up the data segment
    mov ax, 0x07C0
    mov ds, ax
    mov es, ax

    ; Set up the GDT
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 08h:code_segment

BITS 32
code_segment:
    ; Set up the segment registers
    mov ax, data_segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Set up the stack pointer
    mov esp, 0x9FC00

    ; Call kernel main function
    call kernel_main

hang:
    ; Hang the system
    jmp hang

; Define the GDT
gdt_start:
    ; Null descriptor
    dd 0
    dd 0

    ; Code segment descriptor
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x9A
    db 0xCF
    db 0x00

    ; Data segment descriptor
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x92
    db 0xCF
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

TIMES 510 - ($ - $$) db 0
DW 0xAA55
