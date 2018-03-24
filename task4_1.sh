#! /bin/bash
# (C)2018 Ihor Sokorchuk, ihor.sokorchuk@nure.ua

echo '--- Hardware ---'

# CPU: Intel xeon 2675
echo -n 'CPU: '
dmidecode -s processor-version 2>/dev/null || echo 'Unknow'

# RAM: xxxx 
echo -n 'RAM: '
# dmidecode -t 17

# Motherboard: XXX XX / ??? / Unknown
echo -n 'Motherboard: '
dmidecode -s baseboard-product-name 2>/dev/null || echo 'Unknow'

# System Serial Number: XXXXXX
echo -n 'System Serial Number: '
dmidecode -s system-serial-number 2>/dev/null || echo 'Unknow'

echo '--- System ---'

# OS Distribution: xxxxx (например Ubuntu 16.04.4 LTS)
echo -n 'OS Distribution: '
if test -f /etc/system-release; then
   cat /etc/system-release
else
   echo 'Unknow'
fi

# Kernel version: xxxx (например 4.4.0-116-generic)
echo -n 'Kernel version: '
uname -r

# Installation date: xxxx
echo -n 'Installation date: '
if test -f /var/log/installer; then 
   ls -ld /var/log/installer
else
   echo 'Unknow'
fi

# Hostname: yyyyy
echo -n 'Hostname: '
uname -n

IFS=',' read -r -a up_array <<< "$(uptime)"
tmp_str="${up_array[0]#*up}"
up_time="${tmp_str// /}"
tmp_str="${up_array[1]%user?}"
up_users="${tmp_str// /}"

# Uptime: XX days
echo "Uptime: $up_time"

# Processes running: 56684
echo -n 'Processes running: '
ps -A | wc -l

# User logged in: 665
echo "User logged in: $up_users"

echo '--- Network ---'
# <Iface #1 name>:  IP/mask
# <Iface #2  name>:  IP/mask
# …
# <Iface #N  name>:  IP/mask
ip addr | awk '/^[0-9]+/ { if_nr=substr($1,0,length($1)-1); if_name=$2 } $1 == "inet" { print "Iface #" if_nr, if_name, $2; }'
