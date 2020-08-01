# terraform-fullstack

You will need to add variables such as, your AWS provider keys - region - ec2/rds sizes - VPC CIDR (something like '10.0.0.0/16')
ASG min/max/desired number of instances - IP's for external access (if required) for restriction, and any other detail required
from the variable file.

This plan uses Terrform v0.11.1.

From root run...

```
terraform init
terraform plan
terraform apply
```

To pull down stack run...

```
terraform destroy
```
