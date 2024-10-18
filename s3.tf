# S3 bucket for website.
resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.bucket_name}"
  tags   = var.common_tags
}


resource "aws_s3_bucket_ownership_controls" "www" {
  bucket = aws_s3_bucket.www_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "www" {
  bucket = aws_s3_bucket.www_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "www" {
  depends_on = [
    aws_s3_bucket_ownership_controls.www,
    aws_s3_bucket_public_access_block.www,
  ]
  bucket = aws_s3_bucket.www_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.www_bucket.id

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_website_configuration" "www" {
  bucket = aws_s3_bucket.www_bucket.id
  redirect_all_requests_to {
    host_name = "${var.domain_name}"
    protocol = "https"
  }


}

# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root_bucket" {
  bucket = var.bucket_name
  tags = var.common_tags
}
resource "aws_s3_bucket_website_configuration" "root" {
  bucket = aws_s3_bucket.root_bucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_policy" "allow_read_root" {
  bucket = aws_s3_bucket.root_bucket.id
  policy = data.aws_iam_policy_document.allow_public_s3_read.json
}

resource "aws_s3_bucket_ownership_controls" "root" {
  bucket = aws_s3_bucket.root_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "root" {
  bucket = aws_s3_bucket.root_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "root" {
  depends_on = [
    aws_s3_bucket_ownership_controls.root,
    aws_s3_bucket_public_access_block.root,
  ]
  bucket = aws_s3_bucket.root_bucket.id
  acl    = "public-read"
}

# S3 Allow Public read access as data object
data "aws_iam_policy_document" "allow_public_s3_read" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    principals {
      type = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
  }
}
