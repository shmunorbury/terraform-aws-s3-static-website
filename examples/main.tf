module "s3_website" {
  source      = "../"
  bucket_name = "example.org"
  domain_name = "example.org"
  admin_email = "test@examples.com"
  common_tags = {
    x = "y"
  }
}
