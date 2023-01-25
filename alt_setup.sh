#!/bin/bash

# Create empty configuration file.
configuration_filename="backup.conf"
cp -fr backup.conf.sample "$configuration_filename"
#echo "" > restore.conf

# Variables
# TODO: The directory of your Nextcloud installation (this is a directory under your web root)
nextcloudFileDir='/var/www/nextcloud'

# TODO: Your web server user
webserverUser='www-data'

# TODO: The service name of the web server. Used to start/stop web server (e.g. 'systemctl start <webserverServiceName>')
webserverServiceName='nginx'

# Set variables
nextcloudFileDirSed=${nextcloudFileDir//\//\\/}

sed -i "s/^nextcloudFileDir.*/nextcloudFileDir=$nextcloudFileDirSed/" "$configuration_filename"
sed -i "s/^webserverUser.*/webserverUser=\'$webserverUser\'/" "$configuration_filename"
sed -i "s/^webserverServiceName.*/webserverServiceName=\'$webserverServiceName\'/" "$configuration_filename"

# Get variables directly from Nextcloud
function occ_get() {
	#sudo -u "${webserverUser}" php ${nextcloudFileDir}/occ config:system:get "$1"
	sudo nextcloud.occ config:system:get "$1"
}

# The directory of your Nextcloud data directory (outside the Nextcloud file directory)
nextcloudDataDir=$(occ_get datadirectory)
nextcloudDataDirSed=${nextcloudDataDir//\//\\/}
if echo "$nextcloudFileDir" | grep -q "$nextcloudDataDir"; then 
	sed -i "s/^nextcloudDataDir.*/# nextcloudDataDir/" "$configuration_filename"
else
	sed -i "s/^nextcloudDataDir.*/nextcloudDataDir=\'$nextcloudDataDirSed\'/" "$configuration_filename"
fi

# The name of the database system (one of: mysql, mariadb, postgresql)
databaseSystem=$(occ_get dbtype)
sed -i "s/^databaseSystem.*/databaseSystem=\'$databaseSystem\'/" "$configuration_filename"

# Your Nextcloud database name
nextcloudDatabase=$(occ_get dbname)
sed -i "s/^nextcloudDatabase.*/nextcloudDatabase=\'$nextcloudDatabase\'/" "$configuration_filename"

# Your Nextcloud database user
dbUser=$(occ_get dbuser)
sed -i "s/^dbUser.*/dbUser=\'$dbUser\'/" "$configuration_filename"

# The password of the Nextcloud database user
dbPassword=$(occ_get dbpassword)
sed -i "s/^dbPassword.*/dbPassword=\'$dbPassword\'/" "$configuration_filename"
