resource "aws_s3_bucket" "bucket" {
  bucket = "${local.env}-${local.eks_name}-gin-bucket-backend"

  tags = {
    Name        = "${local.env}-${local.eks_name}-gin-bucket-backend"
    Environment = "${local.env}"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::prod-eks-gin-bucket-backend/*"
    }
  ]
}
POLICY
}
