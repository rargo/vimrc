#!/bin/sh

echo 'build ve'
gcc -o ve.elf ve.c
echo 'install ve.elf to /usr/bin/ve'
sudo cp ve.elf /usr/bin/ve
