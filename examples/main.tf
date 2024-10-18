module "s3_website" {
  source = "../"
  bucket_name = "example.org"
  domain_name = "example.org"
  common_tags = {
    x= "y"
  }
}
