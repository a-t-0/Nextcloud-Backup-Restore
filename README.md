## Backup & Restore Snap Nextcloud
This contains scripts to automatically back up and restore Nextcloud.

## Usage
Run once:
```sh
chmod +x *.sh
./alt_setup.sh
```

### Create backup
```sh
sudo ./NextcloudBackup.sh
```

### Restore backup
```sh
sudo ./NextcloudRestore.sh <backup date>
```
E.g.:
```sh
sudo ./NextcloudRestore.sh 20230125_140603
sudo ./NextcloudRestore.sh 20230126_174139 # Without calendar.
sudo ./NextcloudRestore.sh 20230126_174856 # With calendar and one entry.
```

## Backup location
By default the backup location is set in `NextcloudBackupRestore.conf.sample` with:
```sh
backupMainDir='/media/hdd/nextcloud_backup'
```
After updating it, run:
```sh
./alt_setup.sh
```
again, before creating your new backups.

## How to help
Make sure the `sql` database of Nextcloud also gets restored automatically.