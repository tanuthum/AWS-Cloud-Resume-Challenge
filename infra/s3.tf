resource "aws_s3_bucket" "resume" {
  bucket = "lilpoony-cloud-resume"
}

resource "aws_s3_bucket_policy" "resume_secure" {
  bucket = aws_s3_bucket.resume.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontReadAccess",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.resume.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.resume_distribution.arn
          }
        }
      }
    ]
  })
}


resource "aws_s3_bucket_ownership_controls" "resume" {
  bucket = aws_s3_bucket.resume.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "lilpoony-access-logs"
}

resource "aws_s3_bucket_logging" "logging" {
  bucket        = aws_s3_bucket.resume.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "access-logs/"
}
