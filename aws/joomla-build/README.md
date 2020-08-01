# docker-tf-aws
## Joomla Docker Package

N:B; docker-compose must be installed and terraform should be installed locally for this test. In this example I used terrafrom v0.11.1 and docker-compose version 1.16.1.

This repo creates a Docker deployment locally, with a running nginx, php7.1-fpm and mysql container stack.

To deploy this setup locally, you'll need to have the docker-compose package installed.

```
cd terraform-docker-joomla
docker-compose up -d
```
Once the entire stack has been deployed locally, you should be able to navigate to localhost in your browser and see the joomla install page.

# AWS deployment

To deploy this environment to an AWS EC2 instance you'll need to have terraform installed and an AWS account. Please note that this stack will be deployed to the Frankfurt region.
You'll need to add the ACCESS_KEY and SECRET_KEY to the variables.tf file, you'll also need to create/upload an SSH key to the region in which you will be deploying the stack, then add the local key path within the variables.tf file.

This TF deployment will also build out a VPC with subnets in order to proision the EC2 server within.

```
cd terraform-docker-joomla/terraform-deploy
terraform init
terraform plan
terrafrom apply
```

The terraform stack will deploy a Ubuntu 16.04 ec2 instance with Docker, docker-compose, git and curl. Once deployed it will then git clone my repo and run docker-compose up -d and start running the docker conatiainers. 

You can now access the phpinfo page by navigating to the EIP of the instance.
