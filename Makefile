all: Bootloader utility  

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



clean:
	make -C boot clean

	make -C utility clean
	rm -f disk.img
