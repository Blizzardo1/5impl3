#!/bin/bash

as -64 -o boot.o boot.s

if [ $? -ne 0 ]; then
    echo "Error: Assembler failed"
    exit 1
fi

ld -s -Ttext 0x200000 -o boot.bin boot.o

if [ $? -ne 0 ]; then
    echo "Error: Linker failed"
    exit 1
fi

g++ -nostdlib -fno-builtin -fno-rtti -fno-exceptions -m64 -c *.cpp

if [ $? -ne 0 ]; then
    echo "Error: Compiler failed"
    exit 1
fi

ld -T linker.ld -o kernel.bin *.o

if [ $? -ne 0 ]; then
    echo "Error: Linker failed"
    exit 1
fi

if [ -d file-system-image ]; then
    rm -rf file-system-image
fi

mkdir -p file-system-image/boot/grub
cp kernel.bin file-system-image/boot/kernel.bin
cp boot.bin file-system-image/boot/boot.bin

if [ $? -ne 0 ]; then
    echo "Error: Copying files failed"
    exit 1
fi

docker run --rm -it -v "$PWD:/work" -it elmariofredo/docker-alpine-mkisofs ls -lash # mkisofs -o 5impl3.iso -b boot.bin -no-emul-boot -boot-load-size 4 -boot-info-table -input-charset utf-8 -J -l -r -T -v -V "5impl3 OS" file-system-image

if [ $? -ne 0 ]; then
    echo "Error: ISO image creation failed"
    exit 1
fi