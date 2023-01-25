#!/bin/bash

# Variables
# TODO: The directory of your Nextcloud installation (this is a directory under your web root)
nextcloudFileDir='/var/www/nextcloud'

# TODO: Your web server user
webserverUser='www-data'

# TODO: The service name of the web server. Used to start/stop web server (e.g. 'systemctl start <webserverServiceName>')
webserverServiceName='nginx'


# Set variables
nextcloudFileDirSed=${nextcloudFileDir//\//\\/}

sed -i "s/^nextcloudFileDir.*/nextcloudFileDir=$nextcloudFileDirSed/" ./NextcloudBackup.sh

sed -i "s/^nextcloudFileDir.*/nextcloudFileDir=$nextcloudFileDirSed/" ./NextcloudRestore.sh

sed -i "s/^webserverUser.*/webserverUser=$webserverUser/" ./NextcloudBackup.sh
sed -i "s/^webserverUser.*/webserverUser=$webserverUser/" ./NextcloudRestore.sh

sed -i "s/^webserverServiceName.*/webserverServiceName=$webserverServiceName/" ./NextcloudBackup.sh
sed -i "s/^webserverServiceName.*/webserverServiceName=$webserverServiceName/" ./NextcloudRestore.sh

# Get variables directly from Nextcloud
function occ_get() {
	#sudo -u "${webserverUser}" php ${nextcloudFileDir}/occ config:system:get "$1"
	sudo nextcloud.occ config:system:get "$1"
}

# The directory of your Nextcloud data directory (outside the Nextcloud file directory)
nextcloudDataDir=$(occ_get datadirectory)
nextcloudDataDirSed=${nextcloudDataDir//\//\\/}
if echo "$nextcloudFileDir" | grep -q "$nextcloudDataDir"; then 
	
	sed -i "s/^nextcloudDataDir.*/# nextcloudDataDir/" ./NextcloudBackup.sh
	sed -i "s/^nextcloudDataDir.*/# nextcloudDataDir/" ./NextcloudRestore.sh
	
else
	sed -i "s/^nextcloudDataDir.*/nextcloudDataDir=$nextcloudDataDirSed/" ./NextcloudBackup.sh
	sed -i "s/^nextcloudDataDir.*/nextcloudDataDir=$nextcloudDataDirSed/" ./NextcloudRestore.sh
	
fi

# The name of the database system (one of: mysql, mariadb, postgresql)
databaseSystem=$(occ_get dbtype)
sed -i "s/^databaseSystem.*/databaseSystem=$databaseSystem/" ./NextcloudBackup.sh
sed -i "s/^databaseSystem.*/databaseSystem=$databaseSystem/" ./NextcloudRestore.sh

# Your Nextcloud database name
nextcloudDatabase=$(occ_get dbname)
sed -i "s/^nextcloudDatabase.*/nextcloudDatabase=$nextcloudDatabase/" ./NextcloudBackup.sh
sed -i "s/^nextcloudDatabase.*/nextcloudDatabase=$nextcloudDatabase/" ./NextcloudRestore.sh

# Your Nextcloud database user
dbUser=$(occ_get dbuser)
sed -i "s/^dbUser.*/dbUser=$dbUser/" ./NextcloudBackup.sh
sed -i "s/^dbUser.*/dbUser=$dbUser/" ./NextcloudRestore.sh

# The password of the Nextcloud database user
dbPassword=$(occ_get dbpassword)
sed -i "s/^dbPassword.*/dbPassword=$dbPassword/" ./NextcloudBackup.sh
sed -i "s/^dbPassword.*/dbPassword=$dbPassword/" ./NextcloudRestore.sh
