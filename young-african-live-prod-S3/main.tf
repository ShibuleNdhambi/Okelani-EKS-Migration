terraform {
  backend "s3" {
    bucket         = "okelani-eks-migration-terraform-state"
    key            = "young-african-lives-prod-bucket/terraform.tfstate"
    region         = "af-south-1"
    dynamodb_table = "okelani-eks-migration-terraform-state-lock"

  }
}


module "S3" {
  source = "../module/S3"

  s3_bucket_name = "young-african-lives-prod-okenlani"

  s3_tags = {
    Name        = "young-african-lives-prod-okelani",
    owner       = "disraptor",
    environment = "prod",
    automation  = "terraform"
  }

}