terraform {
  backend "s3" {
    bucket         = "okelani-eks-migration-terraform-state"
    key            = "yal-rapidpro-prd-bucket/terraform.tfstate"
    region         = "af-south-1"
    dynamodb_table = "okelani-eks-migration-terraform-state-lock"

  }
}


module "S3" {
  source = "../module/S3"

  s3_bucket_name = "yal-rapidpro-prd-okelani"

  s3_tags = {
    Name        = "yal-rapidpro-prd-okelani",
    owner       = "disraptor",
    environment = "prod",
    automation  = "terraform"
  }

  is_access_point = true

}