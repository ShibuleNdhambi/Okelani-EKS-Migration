variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "af-south-1"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "s3_tags" {
  description = "The tags to apply to the S3 bucket."
  type        = map(string)
}

variable "is_access_point" {
  description = "Whether to create an S3 access point."
  type        = bool
  default     = false

}