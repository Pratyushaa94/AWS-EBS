#  Terraform AWS EC2 with EBS Volume Deployment

This project provisions an AWS EC2 instance and attaches an EBS volume using **Terraform**. It includes secure **S3 backend state management**, **environment-based deployments**, and a **GitHub Actions CI/CD pipeline with manual approval** before apply.

---

##  What It Does

- Creates an EC2 instance in your specified AWS region and availability zone
- Provisions a separate EBS volume (default: 8GB, gp3)
- Attaches the EBS volume to the EC2 instance at `/dev/sdh`
- Stores Terraform state in a remote **S3 backend** securely
- Adds cost estimation (manually documented in workflow)
- Applies only after **manual approval** via GitHub Environment
- Supports multiple environments (dev, uat, prod)

---

##  File Structure

```
.
├── main.tf               # Resources: EC2, EBS, attachment
├── provider.tf           # AWS provider configuration
├── variables.tf          # Input variable definitions
├── backend.tf            # S3 remote backend configuration
├── environments/
│   ├── dev.tfvars
│   ├── uat.tfvars
│   └── prod.tfvars
├── terraform.tfvars      # Default values (optional)
├── outputs.tf            # Outputs (EC2 ID, Volume ID)
└── .github/workflows/
    └── terraform.yml     # GitHub Actions workflow
```

---

##  Backend Setup (Automated in Workflow)

Your Terraform `backend.tf` is:
```hcl
terraform {
  backend "s3" {
    bucket = "terraform-state-pratyushaa-ebs-94"
    key    = "ebs/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
```

 This S3 bucket is created automatically inside the GitHub Actions workflow **if it doesn’t already exist**, using the AWS CLI.

---

##  GitHub Actions Workflow Features

- On **push to `main`**, the pipeline triggers:
  1. **Creates S3 backend** (if missing)
  2. Initializes and validates Terraform
  3. Runs `terraform plan` using `dev.tfvars`
  4. Uploads plan + manual cost estimate
- **Manual Approval** gate before `apply` (via GitHub Environments)
- On approval, it downloads the plan and applies it

---

##  GitHub Secrets Required

Go to **Settings > Secrets > Actions** in your GitHub repo and add:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION` (e.g., us-east-1)

Ensure these have at least:
- `AmazonEC2FullAccess`
- `AmazonS3FullAccess`

---

##  Environments

| Environment | Purpose                             |
|-------------|-------------------------------------|
| `dev`       | Developer testing and validation    |
| `uat`       | User Acceptance Testing             |
| `prod`      | Production/live usage               |

---

##  Cost Estimation

Cost is estimated manually in the workflow and uploaded as a Markdown file:
```
| Resource       | Quantity | Pricing (approx) | Total Cost |
|----------------|----------|------------------|------------|
| EC2 Instance   | 1        | $0.0116/hour     | ~$8.50/mo  |
| EBS Volume     | 8GB      | $0.08/GB-month   | ~$0.64/mo  |
| Total Estimate: ~$9.14/month
```

---

##  How to Use

1. Clone this repo or copy files to your GitHub repo
2. Update `environments/dev.tfvars` with your own AMI, instance type, AZ, etc.
3. Push changes to `main`
4. Approve the deployment under GitHub → `Environments → dev-approval`
5. Terraform will apply the infrastructure

---

##  Outputs

- EC2 instance ID
- EBS volume ID

Shown in the GitHub Actions output.

---

##  Next Steps

- Add auto-mount user-data script to EC2 instance
- Add `terraform fmt` and `terraform validate` separately
- Add security groups, key pairs, CloudWatch, etc.
- Optionally integrate Infracost or backend locking (DynamoDB)

---

##  References

- [AWS EC2 Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/)
- [AWS EBS Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions Docs](https://docs.github.com/en/actions)

---

> 💬 For questions or improvements, feel free to collaborate or raise a PR!