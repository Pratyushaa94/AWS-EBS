terraform {
  backend "s3" {
    bucket = "terraform-state-pratyushaa-ebs-94"
    key    = "ebs/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
