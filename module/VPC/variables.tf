variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "af-south-1"
}

variable "vpc_tags" {
  description = "The tags to apply to the VPC."
  type        = map(string)
}