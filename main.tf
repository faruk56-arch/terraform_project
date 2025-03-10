
#This configuration sets up an S3 bucket with specific ownership controls, public access settings, ACLs, and uploads objects to the bucket while configuring it to serve as a static website.


#create s3 bucket
resource "aws_s3_bucket" "my_test_bucket" {
  bucket = var.my_terraform_bucket_name

}

#bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.my_test_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#public access block
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_test_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#bucket acl
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.my_test_bucket.id
  acl    = "public-read"
}

#upload objects
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.my_test_bucket.id
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
  content_type = "text/html"
}

#upload objects
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.my_test_bucket.id
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
  content_type = "text/html"
}
#upload objects
resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.my_test_bucket.id
  key    = "profile.png"
  source = "profile.png"
  acl    = "public-read"
}

#website configuration
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.my_test_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

depends_on = [ aws_s3_bucket_acl.example] 
}
