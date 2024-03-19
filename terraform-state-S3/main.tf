module "S3" {
  source = "../module/S3"

  s3_bucket_name = "okelani-eks-migration-terraform-state"

  s3_tags = {
    Name        = "okekani-eks-migration-terraform-state",
    owner       = "disraptor",
    environment = "prod",
    automation  = "terraform"
  }
}