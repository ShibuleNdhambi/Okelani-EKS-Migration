provider "aws" {
  region = "af-south-1"
  
}

resource "aws_dynamodb_table" "state_lock_2" {
  name         = "okelani-eks-migration-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "okelani-eks-migration-terraform-state-lock"
    environment = "prod"
    owner       = "disraptor"
    automation  = "terraform"
  }
}
