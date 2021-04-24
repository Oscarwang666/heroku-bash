#!/bin/bash 

app_name="your-app-name"    # put your app name here
backup_dir="/home/example/" # put a backup directory you prefer    
backup_history="$backup_dir""history.txt"

heroku pg:backups:capture -a $app_name &>/dev/null && heroku pg:backups:download -a $app_name &>/dev/null

if [ $? -eq 0 ];then
	mv latest.dump "$backup_dir`date +"%Y-%m-%d"`.dump"
	echo "Backup sucess -`date`" >>$backup_history
else
	echo "Login fail please login to heroku" >>$backup_history 
	exit
fi
