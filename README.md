# Load Balancer test environment

This is an environment to test the automatic updating of an internet facing Network LoadBalancer Target Group with the IP addresses of an internal Application Load Balancer as they scale.

Terraform will create the following:

- VPC
  - IG
  - RTs
  - Subnets (2 public, 1 private)
  - Security Groups
  - EC2 Instance (Nginx web server)
  - Network Load Balancer
  - Application Load Balancer
  - Lambda Function (including IAM policy/role and event trigger)
