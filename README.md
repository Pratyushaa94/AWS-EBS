# Terraform AWS EC2 with EBS Volume

This project provisions an AWS EC2 instance and attaches an EBS volume to it using Terraform. It also includes GitHub Actions for automation.

---

##  What It Does

- Creates an EC2 instance in your specified AWS region and availability zone
- Provisions a separate EBS volume (default: 8GB, gp3)
- Attaches the EBS volume to the EC2 instance at `/dev/sdh`
- Automates deployment with GitHub Actions on `main` branch push

---

##  File Structure

```
.
├── main.tf               # Resources: EC2, EBS, attachment
├── provider.tf           # AWS provider configuration
├── variables.tf          # Input variable definitions
├── terraform.tfvars      # Input values (like AMI, instance type)
├── outputs.tf            # Outputs (EC2 ID, Volume ID)
└── .github/workflows/
    └── terraform.yml     # GitHub Actions workflow
```

---

##  Prerequisites

- AWS account with access keys
- GitHub repository

---

##  GitHub Secrets Required

Go to `Settings > Secrets > Actions` in your GitHub repo and add:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

These credentials must have permissions like `AmazonEC2FullAccess`.

---

##  How to Use

1. Clone the repo or add files to your GitHub repository
2. Update `terraform.tfvars` with your values (region, AMI, etc.)
3. Push to the `main` branch
4. GitHub Actions will run Terraform and deploy your infrastructure

---

## Example `terraform.tfvars`

```hcl
aws_region         = "us-east-1"
ami_id             = "ami-0fab1b527ffa9b942"  # Replace with your valid AMI
instance_type      = "t2.micro"
availability_zone  = "us-east-1a"
volume_size        = 8
```

---

##  Outputs

- EC2 instance ID
- EBS volume ID

These are printed in the Actions log and can be used in future automation.

---

##  Notes

- This setup **does not** auto-mount the EBS volume inside the EC2 instance
- If needed, a user-data script can be added to `aws_instance` for formatting/mounting

---

##  Next Steps

- Add `terraform validate` and `fmt` steps to GitHub workflow
- Use `remote backend` for state storage (e.g., S3 + DynamoDB)
- Add tagging, security groups, key pairs, etc., as needed

---

##  References

- [AWS EBS Volume Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume)
- [AWS EC2 Instance Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
