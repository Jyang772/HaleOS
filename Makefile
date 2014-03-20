all: clean Bootloader utility disk.img



clean:
	make -C boot clean
	make -C util clean
	rm -f disk.img


Bootloader:
	@echo
	@echo === Build Bootloader ===
	@echo

	make -C boot

	@echo
	@echo ===  Build Complete  ===
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

disk.img: boot/bootloader.bin 
	@echo
	@echo  === Build Disk.img ===
	@echo
	
			./image_maker $^
			

	@echo
	@echo ===  Build Complete  ===
	@echo


