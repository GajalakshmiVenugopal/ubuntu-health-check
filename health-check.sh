#!/bin/bash

# Vital Configuration
THRESHOLD_CPU=70
THRESHOLD_MEM=80
THRESHOLD_DISK=60
EMAIL=gajalakshmi851@gmail.com
DB_HOSTNAME="127.0.0.1"
DB_USERNAME="bn_opencart"
DB_PASSWORD="9b30b44a0efb4521cefab19e00073685a0ffa2836f00ddac620b7944d4671581"
DB_DATABASE="bitnami_opencart"
DB_PORT=3306

#Boolean Variable
bPassed=true 

# Connect to the EC2 Machine where application is running


# Check the vitals - if it is above the threshold --> echo !!

# Memory check
mem_usage=$(free | grep Mem | tail -1 | awk '{print $3/$2*100}')
echo $mem_usage
if($mem_usage >80); then
    echo 'CPU is running higher than the threshold'
    mail -s "High Memory usage alert" $EMAIL
    bPassed=false #ifsomething goes wrong
fi



# Memory is above threshold


# Disk Check
disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
echo $disk_usage
if(disk_usage >60); then
    echo 'Disk is running higher than the threshold'
    mail -s "High Disk usage alert" $EMAIL
    bPassed=false
fi

# CPU check
cpu_usage=$(top -n1 |grep '%Cpu' | awk '{print $7}' | sed "s/ni//")
echo $cpu_usage
if(cpu_usage >80); then
    echo 'CPU is running higher than the threshold'
    mail -s "High CPU usage alert" $EMAIL
    bPassed=false

#if("$mem_usage >$THRESHOLD_MEM=80")

# Check status of Bitnami services
services_status=(sudo $BITNAMI_STATUS_SCRIPT status)
mail -s "BITNAMI Service Status alert" $EMAIL
bpassed=false

# Check MySql status
if(! mysqladmin -h $DB_HOSTNAME P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD status > /dev/null); then
echo "MySQL is not running"
mail -s "MySQL is down alert" $EMAIL
bpassed=false
fi

# If all is good , then we let automated tests to run !
if(bPassed); then
    echo 'Automated test can run now'
else
    echo 'Some checks did not pass'
fi