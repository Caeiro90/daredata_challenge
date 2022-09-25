resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
  tags = {
    Name = var.s3_bucket_name
  }
  force_destroy = true
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

output "arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "id" {
  value = aws_s3_bucket.s3_bucket.id
}

output "bucket" {
  value = aws_s3_bucket.s3_bucket.bucket
}