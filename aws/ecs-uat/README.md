# terraform_iaac
Terraform configuration files for Cloud deployment

Before the below template can be used, you'll need to have Terraform installed locally.
To test on your local dev machine, follow these basic setup steps.

#### 1) ssh to dev machine
#### 2) mkdir ~/terraform; cd ~/terraform
#### 3) curl -O https://releases.hashicorp.com/terraform/0.8.5/terraform_0.8.5_linux_amd64.zip
#### 4) unzip terraform_0.8.5_linux_amd64.zip; rm terraform_0.8.5_linux_amd64.zip
#### 5) echo "export PATH=~/terraform:$PATH" >> ~/.bash_profile; source ~/.bash_profile
Test Terraform has installed successfully.
#### 6) terraform version

You'll also need to install awscli and add your AWS keys.

# customer_uat stack
This stack is made up of two root .tf files.
### variables.tf - containing customer specific information
### main.tf - file that creates build plan and directs variables/outputs into the
various infrastructure directories.

The remainder of the stack is made up of directories that hold key information to
deploy the various infrastructure components.
### ec2 - {variables.tf,ec2.tf}
These two files contain both variables and infrastructure directions.
If successfully deployed the end result should have a running ec2 instance.
### iam - {variables.tf,iam.tf}
This structure will deploy IAM templates (I'm currently looking to make this more flexible using variables)
### rds - {variables.tf,rds.tf}
Deploys a single RDS instance, using variables created in the root of this iaac template.
### s3 - {variables.tf,s3.tf}    
Deploys a single s3 bucket.
### vpc - {variables.tf,sg.tf,vpc_subnets.tf}  
Deploys a vpc, routing tables and various subnet groups all based on information provided by the variables file.

This template is constantly being updated, so this current template will change from time to time.
