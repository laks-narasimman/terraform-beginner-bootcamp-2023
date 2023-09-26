# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT
│
├── main.tf                 # to determine the string that needs to be generatd ex: AWS s3 bucket
├── variables.tf            # stores the structure of input variables that you want addtionall include in the terraform project and workspace
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables
In order for us remotely destroy the infrastructure, we need to define variables in Terraform Cloud under Orgazniation->Variables

In terraform we can set two kind of variables:
- Enviroment Variables - those you would set in your bash terminal eg. AWS credentials
- Terraform Variables - those that you would normally set in your tfvars file


We can set Terraform Cloud variables to be sensitive so they are not shown visibliy in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_ud="my-user_id"`

### var-file flag

To set lots of variables, it is more convenient to specify their values in a variable definitions file (with a filename ending in either .tfvars or .tfvars.json) and then specify that file on the command line with -var-file:
```
terraform apply -var-file="testing.tfvars"
```
```
testing.tfvars configurtion woud be as below
image_id = "ami-abc123"
availability_zone_names = [
  "us-east-1a",
  "us-west-1c",
]

```
Please note: __terraform.tfvars__ and __auto.tfvars__ are not required to be in `-var -flag` as they are automatically loaded

### terraform.tfvars

This is the default file to load in terraform variables in remote ex: gitpod , jumppad and this gets automatically processed by terraform

### auto.tfvars

- This is another way of loading terraform variables that you want to set locally , this can automatically get loaded as well.

Ex: `instance_type = "t2.large"`

### order of terraform variables


![Terraform variable order precedence](https://github.com/laks-narasimman/terraform-beginner-bootcamp-2023/assets/124524141/1c5fe826-2f99-4b99-9e0e-7f2e5a6c0c10)

## Dealing With Configuration Drift
What happens if we lose our state file?
If you lose your statefile, you most likley have to tear down all your cloud infrastructure manually.

You can use terraform port but it won't for all cloud resources. You need check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import
> terraform import aws_s3_bucket.bucket bucket-name

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import) 

[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration
If someone goes and delete or modifies cloud resource manually through ClickOps.

If we run Terraform plan is with attempt to put our infrstraucture back into the expected state fixing Configuration Drift