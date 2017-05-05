#!/bin/bash
# backups all the directory with priority in the external disk
#
# devices explication
#
# /backups          : External disk (backups purpose).
# /home/appweb7     : Is my home user account in my box linux.
# /home/appweb7/bin : Store all my bin perl script.
#

[ -d /backups/backups/bin ] || mkdir -p /backups/backups/bin
[ -d /backups/backups/documents ] || mkdir -p /backups/backups/documents
[ -d /backups/backups/repository ] || mkdir -p /backups/backups/repository
[ -d /backups/backups/www ] || mkdir -p /backups/backups/www
[ -d /backups/backups/mysql ] || mkdir -p /backups/backups/mysql
[ -d /backups/backups/etc ] || mkdir -p /backups/backups/etc

# the old style ...
FECHA=`date +"%Y-%m-%d"`
HORA=`date +"%H%M%S"`
timestamp="$FECHA-$HORA"

cd /backups/backups/bin
archivo="$timestamp"-bin.tar.gz
tar zcf $archivo /home/appweb7/bin 2>&1
chown appweb7:appweb7 $archivo

cd /backups/backups/documents
/home/appweb7/bin/dir_tarall.pl /home/appweb7/Documents 2>&1

cd /backups/backups/repository
/home/appweb7/bin/dir_tarall.pl /home/appweb7/repository 2>&1

cd /backups/backups/www
/home/appweb7/bin/dir_tarall.pl /home/appweb7/www/dev 2>&1

archivo="$timestamp"-etc.tar.gz
cd /backups/backups/etc
tar zcf $archivo /etc 2>&1
