#Compilers
NASM32 = nasm
GCC32 = gcc -c -m32 -ffreestanding
OBJCOPY32 = objcopy -j .text -j .data -j .rodata -j .bss -S -O binary


#Source files to be used:
CSOURCEFILES = $(wildcard ../$(SOURCEDIRECTORY)/*.c) #All files with .c extentions. 



OBJECTDIRECTORY = temp
SOURCEDIR = source

all: prepare kernel_32.bin


prepare:					#Create folder where dependencies and .elfs will go
	mkdir -p $(OBJECTDIRECTORY)	

						#Inside this folder, we will compile entry_point.s
$(OBJECTDIRECTORY)/entry_point.bin: $(SOURCEDIRECTORY)/entry_point.s
	$(NASM32) -o $@ $<

						#Now it's time to create our dependency file. 
dep:
	@echo ===    Make Dependancy File    ===	#Create file from internal_dependency
	make -C $(OBJECTDIRECTORY) -f ../Makefile internal_dependency
	@echo === Dependancy Search Complete ===

execute_internal_build: dep			#create kernel_32.elf file using dep
	make -C $(OBJECTDIRECTORY) -f ../Makefile kernel_32.elf

$(OBJECTDIRECTORY)/kernel_32.elf.bin: execute_internal_build
	$(OBJCOPY32) $(OBJECTDIRECTORY)/kernel_32.elf $@
	


kernel_32.bin:
	
	nasm -f bin $(SOURCEDIR)/entry_point.s -o kernel_32.bin
	





internal_dependency:
	$(GCC32) -MM $(CSOURCEFILES) > dependency.dep
	#Like -M but do not mention header files that are found in system header directories, nor header files that are included, directly or indirectly, from such a header. 

clean:
	rm -f kernel32.bin
