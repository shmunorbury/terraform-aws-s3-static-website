# aws-s3-cloudfront-static-website

A sane terraform module for creating the simplest and most efficient static website using S3. Given a registered domain will create a new hosted route53 zone and create SSL certs, a cloudfront distribution, and static website S3 buckets that redirect to www.<domain> automatically.
