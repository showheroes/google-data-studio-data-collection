#!/bin/bash

# Simple db load script.
# The example call /bin/zsh import_mysqldb.sh reporting or /bin/zsh import_mysqldb.sh arhero
echo '!!! CAUTION, THIS SCRIPT WILL OVERRITE THE DB!!!'
echo 'DB Name to load dump into: '$1

MyUSER="${DS_USER_ENV:-homestead}"
MyPASS="${DS_PASS_ENV:-secret}"
MyDBNAME=$1
MyHOST="${DS_HOST_ENV:-localhost}"
MyPORT="${DS_PORT_ENV:-33060}"

MYSQL=$(which mysql)

# Get data in dd-mm-yyyy format
NOW="$(date +"%d-%m-%Y")"
FILE_DUMPS="../backups/mysql/$MyDBNAME.$NOW.sql"

# Validate the database name
if [[ ! $($MYSQL -e 'SHOW DATABASES' | grep "^${MyDBNAME}$") ]]; then
  echo "Database '${MyDBNAME}' doesn't exist. Please verify and try again."
  exit 0
fi

echo $FILE_DUMPS

# Validate the dump file
if ! [ -f $FILE_DUMPS ]; then
  echo "The file '$FILE_DUMPS' doesn't exist!"
  exit 1
fi

mysql -h $MyHOST -P $MyPORT -u $MyUSER -p$MyPASS $MyDBNAME < $FILE_DUMPS
echo $MyDBNAME' import has been successful'