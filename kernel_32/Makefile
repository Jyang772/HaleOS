

SOURCEDIR = source

all: kernel_32.bin

kernel_32.bin:
	
	nasm -f bin $(SOURCEDIR)/entry_point.s -o kernel_32.bin
	
clean:
	rm -f kernel32.bin
