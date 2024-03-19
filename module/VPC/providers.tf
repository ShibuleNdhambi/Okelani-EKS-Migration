provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "automation" = "terraform",
      "owner"      = "diraptor "
    }
  }

  ignore_tags {
    keys = ["CreatorId", "CreatorName"]
  }
}