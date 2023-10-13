output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value = module.home_SouthIndianmusic_hosting.bucket_name
}

output "s3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = module.home_SouthIndianmusic_hosting.website_endpoint
}

output "cloudfront_url" {
  description = "The CloudFront Distribution Domain Name"
  value = module.home_SouthIndianmusic_hosting.domain_name
}