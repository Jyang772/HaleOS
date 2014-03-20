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

       /* Create disk.img */

       disk_image_fd = open("disk.img", O_RDWR | O_CREAT | O_TRUNC, 0644);
       if(disk_image_fd <= 0)
       {
           std::cout << "ERROR: cannot create disk.img.\n";
           exit(1);
       }

       /* Read Bootloader.bin and copy it to disk.img */

       bootloader_fd = open(argv[1], O_RDONLY);
       if(bootloader_fd <= 0)
       {
           std::cout << "ERROR: cannot open bootloader.bin.\n";
           exit(1);
       }

       copy_file(disk_image_fd, bootloader_fd)

       /* add 0x00s to fit the filesize to 512 byte sectors */
               stat(argv[1], &file_stat);
               file_size = file_stat.st_size;

               file_zero(disk_image_fd, &file_size);
               bootloader_size = file_size;

               close(bootloader_fd);
}


void fill_zero(int fd, int *file_size)
{
    unsigned char buf = 0;

    int i;

    if (*file_size % 512)
    {
        for (i=0 ; i<512-*file_size%512 ; i++)
            write(fd, &buf, 1);
        *file_size += 512 - *file_size % 512;
    }
}


void copy_file(int dest_fd, int source_fd)
{
    unsigned char buf = 0;

    while (read(source_fd, &buf, 1) > 0)
        write(dest_fd, &buf, 1);                //Read until end of file. At EOF, returns 0 and exits while loop
}
