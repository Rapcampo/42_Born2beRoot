#!/bin/bash

# Architecture
arc=$(uname -a)

# CPU Physical
pcpu=$(grep "physical id" /proc/cpuinfo | wc -l)

# CPU virtual
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)

# Ram
total_ram=$(free -m | awk '$1 == "Mem:" {print $2}')
used_ram=$(free -m | awk '$1 == "Mem:" {print $3}')
percent_ram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# Disk
total_disk=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
used_disk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk  '{ut += $3} END {print ut}')
percent_disk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft += $2} END {printf("%d"), ut/ft*100}')

# CPU load
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

# Last boot
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM use
lvmt=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvmt -eq 0]; then echo no; else echo yes; fi)

# TCP Connections
tcpc=$(ss -ta | grep ESTABLISHED | wc -l)
#tcpc=$(cat /proc/net/socketstat{,6} | awk '$1 == "TCP:" {print S3}')

# User log
ulog=$(users | wc -l)

# Network
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# Sudo
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	
	--------------------------------------------------------
	#Architecture: $arc
	#CPU physical: $pcpu
	#vCPU: $vcpu
	#Memory Usage: $used_ram/${total_ram}MB ($percent_ram%)
	#Disk Usage: $used_disk/${total_disk}Gb ($percent_disk%)
	#CPU load: $cpul
	#Last boot: $lb
	#LVM use: $lvmu
	#Connexions TCP: $tcpc ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmnd cmd
	--------------------------------------------------------"

