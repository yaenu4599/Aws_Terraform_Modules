# Aws_Terraform_Modules
Reusable Terraform local modules for AWS infrastructure. Made to be able to add modules easly and to export them for any use.


## modules available 

|modules | folder | description |
|--------|--------|-------------|
| [vpc](#modulesvpc) | [./modules/vpc](./modules/vpc) | vpc, igw, nat, subnets, route tables |
| [security groups](#modulessecurity_groups) | [./modules/security_groups](./modules/security_groups) | a public and private security group |


### version 

| provider  | version |
|-----------|---------|
| terraform | ~> 1.15.0 |
| aws  | ~> 6.0 |


###  base permissions

Attache this policy [./docs/permissions/TerraformBasicPermissions.json](./docs/permissions/TerraformBasicPermissions.json) to your terraform iam user.

> **Note:** The policy uses `ManagedBy = "terraform"` as a resource tag condition.
> All resources created by this module must include this tag in `common_tags`, 
> or update the condition value in the policy to match your tagging convention.
> 


###  base terraform.tfvars elements

```hcl
# =============================================================================
# tag
# =============================================================================

environment = "dev"
managedby   = "terraform"
```

## modules/vpc

Creates a full vpc setup with public and private subnets across multiple azs. 

For each az defined in var.azs, one public and one private subnet will be created. Each private subnet gets its own nat gateway (deployed in the corresponding public subnet) and an associated route table that routes outbound traffic through it.


### usage

```hcl
module "vpc" {                            
  source               = "./modules/vpc" 
  common_tags          = local.common_tags         
  environment          = var.environment         
  vpc_cidr             = var.vpc_cidr             
  azs                  = var.azs                  
  subnet_public_cidrs  = var.subnet_public_cidrs  
  subnet_private_cidrs = var.subnet_private_cidrs 
}
```


###  required permissions

To use this module attache this policy [./docs/permissions/TerraformModuleVpc.json](./docs/permissions/TerraformModuleVpc.json) to your terraform iam user.

> **Note:** mMke sure that Managedby is eather "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.


### terraform.tfvars example

```hcl
# =============================================================================
# modules.vpc
# =============================================================================

vpc_cidr = "10.0.0.0/16"
azs      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

# subnet_public_cidrs and subnet_private_cidrs must have the same number of entries as azs
subnet_public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
subnet_private_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
```


### inputs

| name | type | description |
|------|------|-------------|
| local.common_tags | `map(string)` | has keypears environment and managedby, ist used for tagging | 
| environment | `string` | variable used for tagging | 
| vpc_cidr | `string` | cidr to create a vpc |
| azs | `list(string)` | a list of azs to deploy in |
| private_subnets_cidr | `list(string)` | cidr blocks to creat public subnets |
| public_subnets_cidr | `list(string)` | cidr blocks to public subnets |


### outputs

| name | description |
|------|-------------|
| vpc_id | vpc id to use in the root module or and in other modules |
| subnets_public_ids | the ids of the public subnets in the vpc, in a list |
| subnets_private_ids | the ids of the private subnets in the vpc, in a list |


## modules/security_groups

Creates a public and private security group. 

The public security group is for instances in the public subnets and allows http(80), https(443) and optionally ssh(22) when var.allow_ssh has one or more cidr_blocks defined.

The private security group is for instances in the private subnets and also allows http(80) and https(443) but both can only be accessed through a instance or Load balancer that uses the public security group.


### required modules 

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](#modulesvpc) | [./modules/vpc](./modules/vpc) | vpc id is needed |


### usage

```hcl
module "security_groups" {
  source      = "./modules/security_groups"
  common_tags = local.common_tags
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  allow_ssh   = var.ssh_allowed_cidrs
}
```


###  required permissions

To use this module attache this policy [./docs/permissions/TerraformModuleSg.json](./docs/permissions/TerraformModuleSg.json) to your terraform iam user.

> **Note:** mMke sure that Managedby is eather "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.


### terraform.tfvars example

```hcl
# =============================================================================
# module.security_groups
# =============================================================================

ssh_allowed_cidrs = []
```


### inputs

| name | type | description |
|------|------|-------------|
| local.common_tags | `map(string)` | has keypears environment and managedby, ist used for tagging | 
| environment | `string` | variable used for tagging | 
| vpc_id | `string` | to define in wich vpc the security groups should be made |
| ssh_allowed_cidrs | `set(string)` | makes it easy to allow certain cidr blocks to be used for ssh and can be left empty |


### outputs

| name | description |
|------|-------------|
| security_group_public_id | used to creat public instances |
| security_group_private_id | used to creat private instances |
