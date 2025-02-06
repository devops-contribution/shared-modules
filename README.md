# Terraform Shared Modules Repository

## Overview
This repository contains reusable Terraform modules for provisioning cloud infrastructure. These modules follow best practices for modularization and can be used across multiple projects.

## Directory Structure
```
.
├── README.md
└── modules
    ├── eks
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── vpc
        ├── main.tf
        ├── outputs.tf
        └── variables.tf

4 directories, 7 files
```

## Usage
Each module can be used independently in your Terraform configurations. These modules should be sourced from this repository into another Terraform project.

### Example: Using the `eks` Module
In your separate Terraform repository:
```hcl
module "eks" {
  source       = "git::https://github.com/your-org/terraform-modules.git//modules/eks?ref=main"
  cluster_name = "my-eks-cluster"
  subnet_ids   = ["subnet-abc", "subnet-def"]
}
```

### Example: Using the `vpc` Module
```hcl
module "vpc" {
  source     = "git::https://github.com/your-org/terraform-modules.git//modules/vpc?ref=main"
  vpc_name   = "my-vpc"
  cidr_block = "10.0.0.0/16"
}
```

## Best Practices
- **Keep modules small and focused** – each module should serve a single purpose.
- **Use versioning** – tag releases to ensure stability.
- **Follow Terraform best practices** – maintain proper `variables.tf`, `outputs.tf`, and documentation.
- **Lint and validate** – use `terraform fmt`, `terraform validate`, and `tflint` to maintain code quality.

## Linting & Validation (GitHub Actions)
This repository is configured to run Terraform linting and validation using GitHub Actions.

### Running Checks Locally
Before pushing changes, run:
```sh
terraform fmt -recursive
terraform validate
terraform plan
```

## Contributing
1. Fork the repository and create a new branch.
2. Make changes and test them.
3. Open a pull request with a detailed description.

## License
NA
