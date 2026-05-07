# Aws_Terraform_Modules
Reusable Terraform local modules for AWS infrastructure. Made to be able to add modules easly and to export them for any use.


## modules available 

|modules | folder | description |
|--------|--------|-------------|
| [vpc](#modulesvpc) | [./modules/vpc](./modules/vpc) | vpc, igw, nat, subnets, route tables |
| [security groups](#modulessecurity_groups) | [./modules/security_groups](./modules/security_groups) | a public and private security group |
| [ec2instance](#modulesec2instance) | [./modules/ec2instance/](./modules/ec2instance/) | creates a instance in a private subnet and with a private security group |


### version 

| provider  | version |
|-----------|---------|
| terraform | ~> 1.15.0 |
| aws  | ~> 6.0 |


###  base permissions

Attache this policy [./docs/general/TerraformBasicPermissions.json](./docs/general/TerraformBasicPermissions.json) to your terraform iam user.

> **Note:** The policy uses `ManagedBy = "terraform"` as a resource tag condition
> All resources created by this module must include this tag in `common_tags`, or update the condition value in the policy to match your tagging convention
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


###  requirement

#### modules

none

#### permissions

To use this module attache this policy [./docs/module_vpc/TerraformModuleVpc.json](./docs/module_vpc/TerraformModuleVpc.json) to your terraform iam user.

> **Note:** make sure that Managedby is eather "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work

#### other

none

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
| subnet_public_cidrs | `list(string)` | cidr blocks to create public subnets |
| subnet_private_cidrs | `list(string)` | cidr blocks to create private subnets |


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


###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](#modulesvpc) | [./modules/vpc](./modules/vpc) | vpc to launche the security groups in |


#### permissions

To use this module attache this policy [./docs/module_security_groups/TerraformModuleSg.json](./docs/module_security_groups/TerraformModuleSg.json) to your terraform iam user.

> **Note:** make sure that Managedby is eather "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work

#### others

none

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


## modules/ec2instance

module to create a instance in a private subnet and with a private security group

### usage

```hcl
module "ec2instance" {
  source                    = "./modules/ec2instance"
  common_tags               = local.common_tags
  environment               = var.environment
  # public_key              = var.public_key
  instance_type             = var.instance_type
  ami_id                    = var.ami_id
  subnets_public_ids        = module.vpc.subnets_public_ids
  subnets_private_ids       = module.vpc.subnets_private_ids
  security_group_public_id  = module.security_groups.security_group_public_id
  security_group_private_id = module.security_groups.security_group_private_id
}
```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](#modulesvpc) | [./modules/vpc](./modules/vpc) | vpc to launche the security groups in |
| [security groups](#modulessecurity_groups) | [./modules/security_groups](./modules/security_groups) | private security group to launch the instance in |

#### permissions

To use this module attache this policy [./docs/module_ec2instance/TerraformModuleEc2Instance.json](./docs/module_ec2instance/TerraformModuleEc2Instance.json) to your terraform iam user.

> *Note:* even tho the keypair is not active, the permission already gives the permission required to create/delete one and import the public key
> **Note:** make sure that Managedby is eather "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.

#### others

##### <ins>__ssm managment__</ins>

to enable ssm managment for your instances you have to do the following:

1: create a aws-service role for ec2 with the policy: AmazonSSMManagedInstanceCore
2: on your deployed ec2 instance assosiate the role
3: stop and start the instance so that the role can take effect

Why do it like this? To minimize risks I do not really want to give terraform the ability to create roles or attach them.

##### <ins>__keypair for ssh__</ins>

###### uncomment:
variable public_key in ./variable.tf and ./terraform.tfvars

input public_key in ./main.tf module ec2instance

variable public_key in ./modules/ec2instance/variable.tf

resource "aws_key_pair" "main" in ./modules/ec2instance/main.tf

attribute key_name  in ./modules/ec2instance/main.tf

###### after do: 
enter your public key in the variable publi_key in ./terraform.tfvars 

### terraform.tfvars example

```hcl
# =============================================================================
# module.ec2instance
# =============================================================================

# public_key  = "your-public-key"
instance_type = "t3.micro"
ami_id        = "ami-08bdb1495db49a7f9"
```

### inputs

| name | type | description |
|------|------|-------------|
| local.common_tags | `map(string)` | has keypears environment and managedby, ist used for tagging | 
| environment | `string` | variable used for tagging | 
| vpc_id | `string` | to define in wich vpc the security groups should be made |
| subnets_public_ids | `list(string)` | possible subnets to launch instances in |
| subnets_private_ids | `list(string)` | subnet [0] is used to launch an instance |
| security_group_public_id | `string` | possible to be attached to a instance |
| security_group_private_id | `string` | attached to the instance in the current module |

### outputs

| name | description |
|------|-------------|
| instance_id | instance id for generale use | 
