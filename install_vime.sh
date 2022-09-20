#!/bin/sh

echo 'build vime'
gcc -o vime.elf vime.c
echo 'install vime.elf to /usr/bin/vime'
sudo cp vime.elf /usr/bin/vime
