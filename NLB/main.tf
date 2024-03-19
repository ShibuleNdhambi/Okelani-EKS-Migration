provider "aws" {
  region = "af-south-1"
}

terraform {
    backend "s3" {
        bucket         = "okelani-eks-migration-terraform-state"
        key            = "nlb/terraform.tfstate"
        region         = "af-south-1"
        dynamodb_table = "okelani-eks-migration-terraform-state-lock"
    }
}

resource "aws_s3_bucket" "NLB_LOGS" {
  
}

resource "aws_s3_access_point" "logs_ap" {
    bucket = aws_s3_bucket.NLB_LOGS.bucket
    name   = "logs-ap"
    vpc_configuration {
        vpc_id = "vpc-0cdd977ae13d1839c"
    }
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect   = "Allow",
            Principal = "*",
            Action   = "s3:GetObject",
            Resource = "arn:aws:s3:::${aws_s3_bucket.NLB_LOGS.bucket}/*",
            Condition = {
            StringEquals = {
                "aws:sourceVpce" = "vpce-1234567890abcdef0"
            }
            }
        }
        ]
    })
}


resource "aws_lb" "NLB" {
    name               = "okelani-nlb"
    internal           = false
    load_balancer_type = "network"
    subnets            = ["subnet-0cdd977ae13d1839c", "subnet-0a76b5e2ef6d90340", "subnet-00726f5606e9b2f65"]
    enable_deletion_protection = false
    tags = {
        Name        = "okelani-nlb"
        owner       = "disraptor"
        environment = "prod"
        automation  = "terraform"
    }
}