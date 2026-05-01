# Aws_Terraform_Modules
Reusable Terraform local modules for AWS infrastructure. Made to be able to add modules easly and to export them for any use.

## Version

| Name | Version |
|------|---------|
|Terraform| 1.15.0 |
| Aws | 6.0 |

## Modules Available 

|Modules | Folder | Description |
|--------|--------|-------------|
| [vpc][modules/vpc] | [./module/vpc][./module/vpc] | Vpc, Igw, Nat, Subnets, Route tables |
| [Security Groups][modules/security_groups] |[./module/security_groups][./module/security_groups] | A Public and Private Security Group |

## modules/vpc

Creates a full vpc setup with public and private subnets on multible azs.

### Usage

```hcl
module "vpc" {                            
  source               = "./modules/vpc"          
  environment          = var.environment         
  vpc_cidr             = var.vpc_cidr             
  azs                  = var.azs                  
  subnet_public_cidrs  = var.subnet_public_cidrs  
  subnet_private_cidrs = var.subnet_private_cidrs 
}
```

### terraform.tfvars example

```hcl
environment = "dev" 
vpc_cidr             = "10.0.0.0/16"
azs                  = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
subnet_public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
subnet_private_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
```

### Inputs

| Name | Type | Description |
|------|------|-------------|
| environment | string | Variable used for tagging | 
| vpc_cidr | string | Cidr to create a vpc |
| azs | list(string) | A list of azs to deploy in |
| private_subnets_cidr | list(string) | Cidr blocks to creat public subnets |
| public_subnets_cidr | list(string) | Cidr blocks to public subnets |

### Outputs

| Name | Description |
|------|-------------|
| vpc_id | Vpc id to use in the root module or and in other modules |
| subnets_public_ids | The ids of the public subnets in the vpc, in a list |
| subnets_private_ids | The ids of the private subnets in the vpc, in a list |

## modules/security_groups