resource "aws_s3_bucket" "s3-module" {
	bucket = var.bucket_name

	tags = {
		Name = var.tag_name
		Environment = var.env_name
	}
}
