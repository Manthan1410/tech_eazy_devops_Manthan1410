# Tech Eazy DevOps Project – Task 2

## Overview

This project extends the previous automation for EC2 deployment with the following features:

1. **IAM Roles Creation**  
   - **Read-Only Role**: Can list S3 objects.  
   - **Write Role**: Can create S3 buckets and upload files, but cannot read/download.

2. **EC2 Instance Profile**  
   - The write role is attached to EC2 via an instance profile, allowing automatic S3 interactions.

3. **S3 Bucket Management**  
   - Private S3 bucket creation (name is configurable via Terraform variable `bucket_name`).  
   - Lifecycle rule to delete logs after 7 days.

4. **Log Upload**  
   - EC2 logs (`/var/log/cloud-init.log`) and application logs (`/app/logs`) have to be executed manually; just run the `upload-logs.sh` file or `user_data.sh` file.  
   - Logs are stored under:  
     ```
     s3://<bucket>/app/logs/<hostname>/<timestamp>_cloud-init.log
     s3://<bucket>/app/logs/<hostname>/app.log
     ```

5. **Verification**  
   - The read-only IAM role can list the uploaded files to confirm correct uploads.

---

## Tools & Technologies

- **Terraform** – Infrastructure as Code (IaC)  
- **AWS CLI / Boto3** – AWS automation  
- **Linux Bash** – Shell scripting for user_data and log upload  
- **AWS Services**: EC2, S3, IAM

---

## How to Run the Project

Follow these steps to deploy the EC2 instance, set up IAM roles, and upload logs:

### 1. Configure AWS CLI Credentials
```bash
export AWS_ACCESS_KEY_ID="your_aws_access_key_id"
export AWS_SECRET_ACCESS_KEY="your_aws_secret_access_key"
export AWS_DEFAULT_REGION="us-east-1"
```
2. Initialize Terraform
```
terraform init
```
3. Plan Terraform Deployment
```
terraform plan -var="bucket_name=my-task2-logs-bucket"
```
4. Apply Terraform Deployment
```
terraform apply -auto-approve -var="bucket_name=my-task2-logs-bucket"
```
5. Upload Logs
```
sudo chmod +x /upload-logs.sh
bash upload-logs.sh
