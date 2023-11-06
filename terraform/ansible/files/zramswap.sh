#!/bin/bash

zram_ratio=1

# get the amount of memory in the machine
mem_total_kb=$(grep MemTotal /proc/meminfo | grep -E --only-matching '[[:digit:]]+')
mem_total=$((mem_total_kb * 1024))
zram_total=$((mem_total * zram_ratio))

# load the dependency module
modprobe zram

# initialize the device with zstd compression algorithm
echo zstd >/sys/block/zram0/comp_algorithm
echo $mem_total >/sys/block/zram0/disksize

# Creating the swap filesystem
mkswap /dev/zram0

# Switch the swaps on
swapon -p 100 /dev/zram0
