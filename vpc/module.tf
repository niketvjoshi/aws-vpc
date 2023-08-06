module "vpc" {
  source                = "../modules/aws_vpc"
  vpc_01_cidr_block     = "10.102.0.0/16" 
  subnet_01_cidr_block  = "10.102.10.0/24"  
  subnet_02_cidr_block  = "10.102.20.0/24"
}