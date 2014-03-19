#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>          //Used for changing file descriptor
#include <unistd.h>
#include <sys/stat.h>
#include	<iostream>

#define SECTOR 512

void fill_zero(int fd, int *file_size);
void copy_file(int dest_fd, int source_fd);


int main(int argc, char** argv)             //Taking in arguments from Makefile
{

       int disk_image_fd, bootloader_fd, kernel32_fd, kernel64_fd;
       struct stat file_stat;                //http://pubs.opengroup.org/onlinepubs/009695399/functions/stat.html
       int file_size, bootloader_size, kernel_32_size;
       unsigned short total_sector_number, kernel_32_sector_number;

       if(argc < 4)
       {
           std::cout << "Error: bootloader.bin, kernel_32.bin and kernel_64.bin are needed.\n";
           exit(1);
       }



}
