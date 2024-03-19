terraform {
  backend "s3" {
    bucket = "okelani-eks-migration-terraform-state"
    key    = "sql-dump-store/terraform.tfstate"
    region = "af-south-1"
    dynamodb_table = "okelani-eks-migration-terraform-state-lock"
    
  }
}


module "S3" {
  source = "../module/S3"

  s3_bucket_name = "okelani-sql-dump-store"

  s3_tags = {
    Name        = "okekani-sql-dump-store",
    owner       = "disraptor",
    environment = "prod",
    automation  = "terraform"
  }

  is_access_point = true

}