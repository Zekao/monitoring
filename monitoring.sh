#!bin/bash
architecture=$(uname -a)
cpup=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "processor" /proc/cpuinfo | sort | uniq | wc -l)
total=$(free -m | grep Mem | cut -c 18-20)
used=$(free -m | grep Mem | cut -c 31-32)
MB=$(echo MB)
Gb=$(echo Gb)
percentage_ram=$(free | grep Mem | awk '{print $3/$2*100}' | cut -c 1-4)
totaldisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
useddisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
percentage_disk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft += $2} END {print ut/ft*100}' | cut -c 1-4)
load=$(top -bn1 | grep '^%Cpu' | cut -c 11- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
boot=$(who -b | cut -c 23-)
lvms=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvms -eq 0 ]; then echo no; else echo yes; fi)
tcp=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
ulog=$(users | wc -w)
net=$(ip link show | grep ether | cut -c 16-32)
host=$(hostname -i)
sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "		#Architecture : $architecture
		#CPU Physical : $cpup
		#vCPU : $vcpu
		#Memory Usage : $used/$total$MB ($percentage_ram%)
		#Disk Usage : $useddisk/$totaldisk$Gb ($percentage_disk%)
		#CPU load : $load
		#Last boot : $boot
		#LVM use : $lvmu
		#Connexions TCP : $tcp ETABLISHED
		#User log : $ulog
		#Network : IP $host ($net)
		#Sudo : $sudo cmd 
"
