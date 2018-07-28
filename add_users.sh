#!/bin/sh
# Adds security group and 9 users to a server.
# Adds security group to sudoers.
PATH=/bin:/usr/bin:/etc:/usr/sbin:/usr/ucb:/usr/local/bin:/usr/bin/X11:/sbin:.
export PATH

if [ `whoami` != 'root' ]; then
   echo "ERROR: Script must be run as root."
   exit 1
fi

strOS=`uname`
case $strOS in
   AIX)
      #echo "AIX detected"
      strUSERADD="/usr/sbin/useradd"
      strUSERHOME="/home"
      ;;
   SunOS)
      #echo "Solaris detected"
      strUSERADD="/usr/sbin/useradd"
      strUSERHOME="/export/home"
      ;;
   Linux)
      #echo "Linux detected"
      strUSERADD="/usr/sbin/useradd"
      strUSERHOME="/home"
      ;;
esac

strGROUPCK=`cat /etc/group | grep security | wc -l`
if [ $strGROUPCK -eq 0 ]; then 
groupadd security
fi

cat >> /etc/sudoers << EOF

## Allow security to run any commands anywhere 
%security	ALL=(ALL) 	NOPASSWD: ALL

EOF

for i in {1..9}
    do
        $strUSERADD -u 15${i} -g security -d $strUSERHOME/usr15${i} -m -c "Information Secuirty Team" usr${i}
        echo usr${i}:abc123 | /usr/sbin/chpasswd
    done