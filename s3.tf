# Create a S3 bucket 
resource "aws_s3_bucket" "my-bucket" {
  bucket = var.bucket-name
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

# Define the bucket ownership. Everything inside this bucket is owned by the bucket owner itself
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.my-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# By default, new buckets and objects don't allow public access. To Make the bucket public use the code below
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Following code explicitly disables the default S3 bucket security settings. 
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.my-bucket.id
  acl    = "public-read"
}

# Add SNS Notification to the bucket
resource "aws_s3_bucket_notification" "notif" {
  bucket = aws_s3_bucket.my-bucket.id

  topic {
    topic_arn = aws_sns_topic.topic.arn

    events = [
      "s3:ObjectCreated:*",
    ]

  }
}

# Uploading index.html file to our bucket
resource "aws_s3_object" "index" {
depends_on = [ aws_s3_bucket_notification.notif ]

  bucket = aws_s3_bucket.my-bucket.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}
