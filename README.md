# Lift-and-Shift Deployment of TechEazy Application

## **Project Overview**
This project demonstrates a **lift-and-shift deployment** of a sample Java Spring Boot application to **AWS EC2** using **Terraform**.  
The goal is to simulate a real-world scenario where a development team has built an application locally, and it needs to be deployed to a cloud environment in a production-like setup.

The sample application is hosted in GitHub:  
[TechEazy Sample Repo](https://github.com/Trainings-TechEazy/test-repo-for-devops)

---

## **Key Features of the Deployment**

- **Provisioning:** Launches an EC2 instance (Ubuntu 22.04) with a security group allowing HTTP access on port 80.  
- **Dependency Installation:** Installs Java 21, Maven, and Git automatically.  
- **Application Setup:** Clones the GitHub repo, builds the app using `mvn clean package`, and runs it in the background with `nohup`.  
- **Stage-based Configuration:** Supports `Dev` and `Prod` stages with separate configuration files.  
- **Outputs:** Provides the EC2 public IP, DNS, and URL for easy access.  
- **Cost-Saving:** Terraform allows easy teardown using `terraform destroy`.

---

## **Terraform Files and Their Purpose**

| File               | Purpose |
|-------------------|---------|
| `main.tf`          | Main configuration file: provisions EC2 instance, security group, and sets up user data scripts to deploy the application. |
| `variables.tf`     | Defines input variables for EC2 instance type, AWS region, key pair, and deployment stage. |
| `outputs.tf`       | Provides outputs like EC2 public IP, public DNS, and app URL. |
| `terraform.tfvars` | Optional: overrides default variable values (e.g., stage, key pair, region). |

---

## **Prerequisites for Reviewer**

- AWS account with permissions to create EC2 instances and Security Groups.  
- Terraform installed (v1.5+ recommended).  
- SSH key pair in AWS for EC2 access.  
- AWS credentials configured via CLI or environment variables.

---

## **AWS Credentials Setup**

Set your AWS credentials as environment variables:

```bash
export AWS_ACCESS_KEY_ID="YOUR_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET"
export AWS_DEFAULT_REGION="us-east-1"  # You can override with a different region.
```

---

## **Accessing the Instance via External SSH**

If the Terraform-created EC2 instance does not have a public IP or you cannot connect directly, you can still access it using **external SSH** through another EC2 instance (bastion/jump host) in the same VPC.

```bash
ssh -i app_key.pem ubuntu@<APP_PUBLIC_IP> -v
```

If you executed `terraform apply` **from an EC2 instance inside AWS**, you can also use that machine to SSH into the Terraform-created instance using its private IP.  
