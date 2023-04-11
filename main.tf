terraform {
	required_providers {
		aws = {
		source  = "hashicorp/aws"
		version = "4.62.0"
		}
	}
}



resource "aws_vpc" "terraform_vpc" {
	cidr_block = "10.0.0.0/16"
	instance_tenancy = "default"
	enable_dns_hostnames = true

	tags = {
		Name = "VPC - secondary"
	}
}


resource "aws_subnet" "public_subnet" {
	vpc_id = aws_vpc.terraform_vpc.id
	cidr_block = "10.0.1.0/24"
	availability_zone = "us-east-1a"

	tags = {
		Name = "Public subnet"
		Environment = "Dev"
	}
}


module "instances" {
	source = "./modules/instances"

	instance_type = "t2.micro"
	key_name = "deployer_key"
	public_subnet = aws_subnet.public_subnet.id
	tag_name = "Terraform EC2"
	env_name = "DEV"
}


module "s3" {
	source = "./modules/s3"

	bucket_name = "testing-devops10"
	tag_name = "bucket S3"
	env_name = "dev"
}