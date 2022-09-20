#!/bin/sh

echo 'build vime'
gcc -o ve.elf ve.c
echo 'install vime.elf to /usr/bin/vime'
sudo cp vime.elf /usr/bin/vime
