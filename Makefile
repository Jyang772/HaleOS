
Bootloader:
	@echo
	@echo === Build Bootloader ===
	@echo

	make -C boot/

	@echo
	@echo ===  Build Complete  ===
	@echo




clean:
	make -C boot clean
	
	@echo
	@echo ===  Clean Complete  ===
	@echo
