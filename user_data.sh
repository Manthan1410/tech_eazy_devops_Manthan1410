#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y awscli

mkdir -p /app/logs

echo "Application started at $(date)" >> /app/logs/app.log

sudo cp /home/ubuntu/tech_eazy_devops_Manthan1410/terraform-files-task2/upload-logs.sh /usr/local/bin/upload-logs.s
chmod +x /usr/local/bin/upload-logs.sh

export bucket_name="my-task2-logs-bucket"
export region="us-east-1"

/usr/local/bin/upload-logs.sh

cat <<EOF | sudo tee /etc/systemd/system/upload-logs.service
[Unit]
Description=Upload logs to S3 on shutdown
DefaultDependencies=no
Before=shutdown.target reboot.target halt.target

[Service]
Type=oneshot
Environment="bucket_name=${bucket_name}"
Environment="region=${region}"
ExecStart=/usr/local/bin/upload-logs.sh

[Install]
WantedBy=halt.target reboot.target shutdown.target
EOF

sudo systemctl enable upload-logs.service

