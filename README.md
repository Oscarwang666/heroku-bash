# Collection of Bash scripts for Heroku 

### 1. List all IP Addresses Accessing Your Web Server in September by Frequency  (you can replace 2020-09 to other time)
After login to Heroku in terminal:
```
heroku logs -n 1500 | awk '/^2020-09.*fwd=/{ ips[$8]++ }END{for(i in ips){print i,ips[i]} }' | sort -k2 -rn
```
### 2. Find Top 10 Visited Resource On Your Web Server in September
```
heroku logs -n 1500 | awk -e '/^2020-09.*path/{ print source[$5]++ } END{ for(i in source){print i,source[i]}}' | sort -k2 -rn | head -n10
```
### 3. Script to Back up your Heroku Postgres database

Replace "app_name" to your app name and "backup_dir" to your prefer directory on your system
Then In the terminal run ```bash backup.sh```

```
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
```
(You can add it to cron job so it automatically backup)
```
# Database backup for Heroku on every 23:00 pm
* 23 * * * bash /your-path/backup.sh
```

### 4. Counting requests and status codes per ip
```
heroku logs -n 1500 | awk '/^2020-09-.*fwd/{ print status[$8 " " $12] ++ }END{for(i in status){print i, " " status[i]}  } ' | grep "^fwd" | sort -n -r -k3
```
### Result:
```
fwd="69.110.136.57" status=200  287
fwd="69.110.136.57" status=308  103
fwd="69.110.136.57" status=404  76
fwd="69.110.136.57" status=302  25
fwd="107.242.121.31" status=200  14
fwd="107.242.121.31" status=308  12
fwd="94.128.0.134" status=500  1
fwd="88.222.2.67" status=500  1
```
### 5. Calculate the percentage of all status codes
```
heroku logs -n 1500 | awk '/^2020-09-.*fwd/{ print status[$12] ++ , total++}END{for(i in status){print i," ",status[i]," ",status[i]/total*100,"%"}} ' | grep "^status" | sort -n -r -k2
```
### Result:
```
status=200   301   57.9961 %
status=308   115   22.158 %
status=404   76   14.6435 %
status=302   25   4.81696 %
status=500   2   0.385356 %
```
