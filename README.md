# 4-grupa-denmarint-terraform-project

This project contains 2 modules (vpc and ec2) and 2 enviroments (dev and stage)

Two arguments defined in terraform.tfvars file are required for deployment:
1. enviroment name
2. ec2 instance type

Environment will have nginx-server server installed with access to external network.
