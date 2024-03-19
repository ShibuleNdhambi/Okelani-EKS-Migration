resource "aws_s3_bucket" "my_bucket" {
  bucket = var.s3_bucket_name

  tags = var.s3_tags
}

data "aws_canonical_user_id" "current" {}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]

    resources = ["${aws_s3_bucket.my_bucket.arn}", "${aws_s3_bucket.my_bucket.arn}/*"]
  }
}

# resource "aws_s3_bucket_policy" "s3_policy" {
#   bucket = aws_s3_bucket.my_bucket.id
#   policy = data.aws_iam_policy_document.s3_policy.json
# }



resource "aws_s3_access_point" "access_point" {
  count  = var.is_access_point ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id
  name   = "${var.s3_bucket_name}-ap"
}


