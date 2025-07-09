terraform {
  backend "s3" {
    bucket = "terraform-state-pratyushaa-ebs-why2"
    key    = "ebs/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
