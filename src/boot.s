# Define the start address of the boot loader
.section .text, "ax"
.globl _start
_start:

# Load the kernel into memory
movl $0x200000, %eax   # Set the destination address
movl $0x00, %ebx       # Set the drive number
movl $0x01, %ecx       # Set the number of sectors to read
movl $0x0000, %edx     # Set the sector number
movb $0x02, %ah        # Set disk read function
int $0x13

# Jump to the kernel
jmp *0x200000
