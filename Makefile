all: clean Bootloader Kernel_32 utility disk.img 



clean:
	make -C boot clean
	make -C util clean
	make -C kernel_32 clean
	rm -f image_maker
	rm -f disk.img


Bootloader:
	@echo
	@echo === Build Bootloader ===
	@echo

	make -C boot

	@echo
	@echo ===  Build Complete  ===
	@echo

Kernel_32:
	@echo
	@echo === Build Kernel_32 ===
	@echo

	make -C kernel_32

	@echo
	@echo === Build Complete ===
	@echo


utility:
	@echo
	@echo ===  Build Utility   ===
	@echo

	make -C util
	mv util/image_maker/image_maker .

	@echo
	@echo ===  Build Complete  ===
	@echo

disk.img: boot/bootloader.bin kernel_32/kernel_32.bin
	@echo
	@echo  === Build Disk.img ===
	@echo
	
			./image_maker $^
			

	@echo
	@echo ===  Build Complete  ===
	@echo


