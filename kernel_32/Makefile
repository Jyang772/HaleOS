
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


kernel_32.bin:
	
	nasm -f bin $(SOURCEDIR)/entry_point.s -o kernel_32.bin
	





internal_dependency:


clean:
	rm -f kernel32.bin
