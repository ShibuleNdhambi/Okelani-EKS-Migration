terraform {
  backend "s3" {
    bucket         = "okelani-eks-migration-terraform-state"
    key            = "yal-idinsights-models-bucket/terraform.tfstate"
    region         = "af-south-1"
    dynamodb_table = "okelani-eks-migration-terraform-state-lock"

  }
}


module "S3" {
  source = "../module/S3"

  s3_bucket_name = "yal-idinsights-models-okelani"

  s3_tags = {
    Name        = "yal-idinsights-models-okelani",
    owner       = "disraptor",
    environment = "prod",
    automation  = "terraform"
  }

}