nasm -o bootloader.bin /boot/bootloader.asm

g++ -o image_maker /util/image_maker/image_maker.cpp

nasm -f bin -o kernel.bin kernel_32/source/entry_point.s 
