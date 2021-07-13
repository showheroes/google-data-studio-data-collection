#!/bin/bash

# Shell script to backup MySql database
# The example call /bin/zsh backup_mysqldb.sh

echo '!!! CAUTION, THIS SCRIPT WILL MAKE DUMPs!!!'
echo 'Dumping start:'

#DB reporting
MyUSER_REPORTING="${REPORTING_USER_ENV:-homestead}"
MyPASS_REPORTING="${REPORTING_USER_ENV:-secret}"
MyDBNAME_REPORTING="${REPORTING_USER_ENV:-reporting}"
MyHOST_REPORTING="${REPORTING_USER_ENV:-localhost}"
MyPORT_REPORTING="${REPORTING_USER_ENV:-33060}"

#DB adhero
MyUSER_ADHERO="${ADHERO_USER_ENV:-homestead}"
MyPASS_ADHERO="${ADHERO_USER_ENV:-secret}"
MyDBNAME_ADHERO="${ADHERO_USER_ENV:-adhero}"
MyHOST_ADHERO="${ADHERO_USER_ENV:-localhost}"
MyPORT_ADHERO="${ADHERO_USER_ENV:-33060}"

# Linux bin paths, change this if it can not be autodetected via which command
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"

# Backup Dest directory, change this if you have someother location
DEST="../backups"

# Main directory where backup will be stored
MBD="$DEST/mysql"

# Get hostname
HOST="$(hostname)"

# Get date in dd-mm-yyyy format
NOW="$(date +"%d-%m-%Y")"

# if is exist a directory
if ! [ -d $MBD ];
then
[ ! -d $MBD ] && mkdir -p $MBD || :
echo 'The directory has been created'
else
rm -rf "$MBD/*"
echo 'The directory has been cleaned'
fi

# file's name
FILE_REPORTING="$MBD/$MyDBNAME_REPORTING.$NOW.sql"
FILE_ADHERO="$MBD/$MyDBNAME_ADHERO.$NOW.sql"

# dumping reporting
$MYSQLDUMP -h $MyHOST_REPORTING -P $MyPORT_REPORTING -u $MyUSER_REPORTING -p$MyPASS_REPORTING $MyDBNAME_REPORTING vl_teams vl_players > $FILE_REPORTING
echo "Dump has been created $MyDBNAME_REPORTING"

# dumping adhero
$MYSQLDUMP -h $MyHOST_ADHERO -P $MyPORT_ADHERO -u $MyUSER_ADHERO -p$MyPASS_ADHERO $MyDBNAME_ADHERO publishers > $FILE_ADHERO
echo "Dump has been created $MyDBNAME_ADHERO"