
Bootloader:
	@echo
	@echo === Build Bootloader ===
	@echo

	make -C boot/

	@echo
	@echo ===  Build Complete  ===
	@echo




utility: 
	@echo
	@echo === Build Disk Creator ===
	@echo 

	make -C disk/
	mv disk/create/create_disk .
	
	@echo
	@echo ===  Build Complete  ===
	@echo
	

clean:
	make -C boot clean
	
	@echo
	@echo ===  Clean Complete  ===
	@echo
