# Terraform Beginner Bootcamp 2023 - Week 1

- [Root Module Structure](#root-module-structure)
- [Terraform and Input Variables](#terraform-and-input-variables)
  * [Terraform Cloud Variables](#terraform-cloud-variables)
  * [Loading Terraform Input Variables](#loading-terraform-input-variables)
  * [var flag](#var-flag)
  * [var-file flag](#var-file-flag)
  * [terraform.tfvars](#terraformtfvars)
  * [auto.tfvars](#autotfvars)
  * [order of terraform variables](#order-of-terraform-variables)
- [Dealing With Configuration Drift](#dealing-with-configuration-drift)
  * [Fix Missing Resources with Terraform Import](#fix-missing-resources-with-terraform-import)
  * [Fix Manual Configuration](#fix-manual-configuration)
  * [Fix using Terraform Refresh](#fix-using-terraform-refresh)
- [Terraform Modules and structure](#terraform-modules-and-structure)
  * [Passing input variables](#passing-input-variables)
  * [Modules sources](#modules-sources)
- [Terraform-AWS S3 bucket web hosting](#terraform-aws-s3-bucket-web-hosting)
  * [Considerations when using ChatGPT to write Terraform](#considerations-when-using-chatgpt-to-write-terraform)
  * [Working with Files in Terraform](#working-with-files-in-terraform)
    + [Fileexists function](#fileexists-function)
    + [Filemd5](#filemd5)
  * [Path variable](#path-variable)
- [Terraform Locals](#terraform-locals)
  * [Terraform Data Sources](#terraform-data-sources)
  * [Working with JSON](#working-with-json)
- [Terraform to pick content versio change of html files for CDN invalidation](#terraform-to-pick-content-versio-change-of-html-files-for-cdn-invalidation)
  * [Changing the Lifecycle of Resources](#changing-the-lifecycle-of-resources)
  * [Terraform data](#terraform-data)
- [Adding CloudFront cache invalidation](#adding-cloudfront-cache-invalidation)
  * [Provisioners](#provisioners)
  * [local exec](#local-exec)
  * [Remote-exec](#remote-exec)
- [For Each Expressions](#for-each-expressions)
- [Week-1 Quiz notes](#week-1-quiz-notes)
  

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

### Fix using Terraform Refresh 
```
terraform apply -refresh-only -auto-approve

```
## Terraform Modules and structure
It is recommend to place modules in a modules directory when locally developing modules but you can name it whatever you like.

### Passing input variables
We can pass input variables to our module. The module has to declare the terraform variables in its own variables.tf



```
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```
###  Modules sources
Using the source we can import the module from various places eg:

- locally
- Github
- Terraform Registry

```
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```
[Modules sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Terraform-AWS S3 bucket web hosting 
### Considerations when using ChatGPT to write Terraform
LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that could be deprecated. Often affecting providers.
### Working with Files in Terraform
#### Fileexists function
This is a built in terraform function to check the existance of a fil

```
condition = fileexists(var.error_html_filepath)

```
[Reference guide Terraform](https://developer.hashicorp.com/terraform/language/functions/fileexists)

#### Filemd5
[filemd5 to handle a file ](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path variable
In terraform there is a special variable called path that allows us to reference local paths:

- path.module = get the path for the current module
- path.root = get the path for the root module [special path variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)


```json
resource "aws_s3_object" "index_html" 

{ 
  
  bucket = aws_s3_bucket.website_bucket.bucket 

  key = "index.html" 

  source = "${path.root}/public/index.html" 
  
  }
  ```


## Terraform Locals
Locals allows us to define local variables. It can be very useful when we need transform data into another format and have referenced a varaible.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```

[loals variable](https://developer.hashicorp.com/terraform/language/values/locals)

### Terraform Data Sources

This allows use to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[Data sources](https://developer.hashicorp.com/terraform/language/data-sources)


### Working with JSON
We use the jsonencode to create the json policy inline in the hcl.


```
jsonencode ({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

## Terraform to pick content versio change of html files for CDN invalidation
### Changing the Lifecycle of Resources
[Meta Arguments lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
### Terraform data
Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

https://developer.hashicorp.com/terraform/language/resources/terraform-data 

## Adding CloudFront cache invalidation

### Provisioners

Provisioners allow you to execute commands on compute instances eg. a AWS CLI command.

They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists.

[provisioners
](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### local exec

This will execute command on the machine running the terraform commands eg. plan apply


```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

### Remote-exec
This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```

https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec

## For Each Expressions
  
  For each allows us to enumerate over complex data types

```
[for s in var.list : upper(s)]
```

This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.


[Foreachexpression](https://developer.hashicorp.com/terraform/language/expressions/for)

## Week-1 Quiz notes
1. What is the primary objective for this week regarding Terraform?
> Understand all the intricacies of Terraform
2. What is the only required element for the standard module structure?
> The root module
3. What does the "Squash and Merge" option do on a pull request?
> The pull request's commits are squashed into a single commit.
4. What is the command to add tags to your repository?
> git push --tags
5. What kind of validation does the user have for the "user_uid" variable?
> It must match a specific format
6. Which HashiCorp project is believed to store the sensitive Terraform Cloud variables?
> Vault
7. What is the purpose of the outputs.tf file in Terraform?
> Stores the output variables.
8. What is the purpose of using multiple TF files in Terraform?
> To organize and modularize code by splitting them into separate tasks or functionalities.
9. Which file is expected to contain information about required providers and their configurations?
> providers.tf
10. What command in Terraform helps in fixing configuration drift?
> terraform plan
11. What does "terraform import" command do according to the video?
> It helps in bringing missing resources back into the terraform state
12. What is the main issue regarding the Terraform state file in the video?
> The Terraform state file has been deleted and needs to be recovered.
13. What does the VAR flag in Terraform do?
> It sets an input variable or overrides a variable in tfvars
14. What was one of the suggestions for organizing the module structure?
> Separating storage and content delivery into different files
15. What is the name of the module being created in the video?
> Terra House Module
16. Which tool is described as an interactive way to troubleshoot and debug in Terraform?
> Terraform Console
17. How can you ensure a given path is valid in Terraform?
> By using the "file.exists" function
18. Which cloud service allows you to use cloud storage as static website hosting?
> AWS S3
19. What is the purpose of setting up a CDN?
> To provide content delivery through a distributed network.
20. Which AWS service can be used to serve static websites with a CDN in front of it?
> AWS CloudFront
21. What is the purpose of using the data keyword in Terraform?
> To fetch data from cloud resources.
22. What is HCL in the context of Terraform?
> The underlying syntax used by Terraform
23. What is the goal of this lesson?
> To create a content version of TerraTowns
24. What is the role of terraform data in the described process?
> It acts as an imaginary object for tracking variable states.
25. Which terraform meta argument allows control over when a resource gets created or updated?
> Lifecycle.
26. What does the "file provisioner" in Terraform do?
> Copies files from a machine running Terraform to the newly created resource
27. Why are provisioners like local exec and remote exec discouraged by HashiCorp?
> Configuration management tools such as Ansible are a better fit.
28. What does the local exec provisioner do in Terraform?
> It executes a command on the machine running the Terraform commands.
29. Which wildcard symbol can be used to match against all files?
> `*`
30. What is the purpose of using for each in Terraform?
> To iterate or enumerate over complex data structures.
31. Which folder contains the files to be uploaded?
> assets
















