#!/bin/bash

BUCKET_NAME="my-task2-logs-bucket"
REGION="us-east-1"
HOSTNAME=$(hostname)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Upload system log
if [ -f /var/log/cloud-init.log ]; then
    aws s3 cp /var/log/cloud-init.log s3://$BUCKET_NAME/app/logs/$HOSTNAME/${TIMESTAMP}_cloud-init.log --region $REGION
fi

# Upload app logs
if [ -d /home/ubuntu/tech_eazy_devops_Manthan1410 ]; then
    aws s3 cp /home/ubuntu/tech_eazy_devops_Manthan1410 s3://$BUCKET_NAME/app/logs/$HOSTNAME/ --recursive --region $REGION
fi


