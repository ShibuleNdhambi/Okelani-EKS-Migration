output "s3_bucket_id" {
  description = "The ID of the S3 bucket."
  value       = aws_s3_bucket.my_bucket.id
}

output "s3_bucket_arn" {
  description = "The path of the S3 bucket."
  value       = aws_s3_bucket.my_bucket.arn
}

output "s3_bucket_path" {
  description = "The path of the S3 bucket."
  value       = aws_s3_bucket.my_bucket.bucket
}

output "s3_bucket_access_point_arn" {
  description = "The access point of the S3 bucket."
  value       = var.is_access_point ? aws_s3_access_point.access_point[0].arn : null
}

output "s3_bucket_access_poin_id" {
  description = "The access point of the S3 bucket."
  value       = var.is_access_point ? aws_s3_access_point.access_point[0].id : null
}

output "s3_bucket_access_point_name" {
  description = "The access point of the S3 bucket."
  value       = var.is_access_point ? aws_s3_access_point.access_point[0].name : null
}