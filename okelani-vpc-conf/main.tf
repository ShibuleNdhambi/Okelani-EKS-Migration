provider "aws" {
  region = "af-south-1"
}


terraform {
    backend "s3" {
        bucket = "okelani-eks-migration-terraform-state"
        key    = "vpc/terraform.tfstate"
        region = "af-south-1"
        dynamodb_table = "okelani-eks-migration-terraform-state-lock"
    }
    
}
module "vpc" {
    source = "../module/VPC"
    vpc_tags = {
        environment = "prod"
        owner       = "disraptor"
        automation  = "terraform"
        resource    = "vpc"
    }
}