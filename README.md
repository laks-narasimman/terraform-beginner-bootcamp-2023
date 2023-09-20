# Terraform Beginner Bootcamp 2023

## Semantic versioning :mage: [tag 0.0.1](https://github.com/laks-narasimman/terraform-beginner-bootcamp-2023/tree/0.0.1)
This project is going to have semantic versioning for it's project:
[semver.org](https://semver.org/)

Genera Format is: 
**MAJOR.MINOR.PATCH** ex: `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

### Terraform CLI installation process for Linux: [tag 0.0.2](https://github.com/laks-narasimman/terraform-beginner-bootcamp-2023/tree/0.0.2)
Before we proceed with installing any software , it is worth checking the Linux flavour and version to understand what can work and what can't for your environment

```
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```
- PRETTY_NAME="Ubuntu 22.04.3 LTS" tells about the flavour of Linux
### Step 1:
We ran the command for terraform cli installation from [.gitpod.yml](.gitpod.yml)

however we were prompted by the shell to enter **Yes Or No** to proceed further

This can work but needs to be re-installed manually every time we create a new gitpod instance. 
So there needs to be an automated solution to have this ready wthout manual work which is the reason why we have #4 ticket created in GitHub
### Step 2:
We went to Terraform site for installation steps for **Linux->Ubuntu** 
[terraform site](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Step 3:
Created a bash file called [/bin/install_terraform_cli](/bin/install_terraform_cli) in GitPod under `/bin` and this is expected to automate the installation of Terraform cli for us  

### Step 4:
Chatgpt suggested that for a bash file to run, we need to have __#!/usr/env/bash__ in the start of the file 

`#!`is called Shebang or Shanbang(`#`-means Sha(Sharp)) and (`!`- means exclamatory mark)

### Step 5: 
From the Terraform website in __Step 2__ 

Copy all the commands until ```$  sudo apt-get install terraform``` to the bash file

### Step 6:
Execute 

```$ source ./bin/install_terraform_cli``` 

this needs to install the Terraform CLI without any manual intervention

Execute ```$ terraform```  to check if it works

Note: __source__ is used as prefix to run the Bash script, __source__ can by default execute a file/script without any change of permission, But if you want to execute `$ ./bin/install_terraform_cli` it requires executable permission.

Run below to add x i.e execute permission

```
$ chmod 744 /bin/install_terraform_cli
$ ls -lrt
total 4
-**rwx**r--r-- 1 gitpod gitpod 565 Sep 20 05:35 install_terraform_cli
```
> __x__ in the end of the first block means that the file can be executed without __source__ command in prefix. To know more about file permission in Unix/Linux [Unix File permission](https://en.wikipedia.org/wiki/File-system_permissions)

> Excute permission i.e __x__ is what can give perission to run the script using `./` as prefix. To run any shell script we have to use that as prefix. 
#### Step 7:
 This step is very important, in order for us to automate the software installation and environment to be readily available for us to use Gitpod everytime we re-open we have to define the __tasks__ in ``.gitpod.yml`` file

 Please see [gitpod documentation](
 https://www.gitpod.io/docs/configure/workspaces/tasks) for tasks and as per the flow define the tasks in `.gitpod.yml`:
 ```
 before: |
    source /bin/install_terraform_cli
```
> quick tips of the flow is (`before init command`)

### How to add an enviroment variable(env vars) for the project: [tag 0.0.3](https://github.com/laks-narasimman/terraform-beginner-bootcamp-2023/tree/0.0.3)

env vars in Linux are like an alias to shortern the parths that generally used to work on the projects. 

```
$ env   -> this command shows the existing env vars in the system
$ env|grep 'host' -> this can provide specific env vars involves word as host
$ export PROJECT_ROOT='/usr/bin' -> this command sets an env vars for that particular shell
$ echo $PROJECT_ROOT -> can display the env vars value on the shell
$ gp env PROJECT_ROOT='/usr/bin' -> sets env vars for global i.e for all the shells
```

### How to set env vars in gitpod 
- Use [env file](/bin/.env.example) 
- Add the env vars as many as needed for the project
- Make sure that the global env vars does not break any other software for your system 
- Make sure to use the env vars at the right place ex: to install all the packages you could **cd to workspace** and to work on the project **cd $PROJECT_ROOT** at the end of the .gitpo.yml file

### AWS CLI installation: [tag 0.0.4](https://github.com/laks-narasimman/terraform-beginner-bootcamp-2023/tree/0.0.4)
AWS CLI installed for the project via bash script [AWS Bash](/bin/install_aws_cli)

[Getting started with AWS CLI installs](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[set up aws cli env ](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

#### Step 1:
Add the [aws bash script](/bin/install_aws_cli) to the [gitpod.yml](.gitpod.yml) under the before statement as like the terraform

Make sure that the new aws cli bash file is executable 
> chmod 744 /bin/installaws_cli

> run the `source ./bin/install_aws_cli` and make sure it installs AWS cli
> if it run into issues/errors like "already aws is intalled" then try to add below lines in the code

```
cd /workspace
rm -f '/workspace/awscliv2.zip'
rm -rf '/workspace/aws'
```
This will make sure that the existing aws files are removed and fresh aws is installed

> note that below piece of commands for aws in the .gitpod.yml file

```
- name: aws-cli
    env:
      AWS_CLI_AUTO_PROMPT: on-partial ->this env vars is useful to provide the aws services calls on the shell
```
> ex: aws sts get-caller-identity

Generally we need to remember the command for each services but this env vars can automatically prompt the options available for each services of the aws on the shell

#### Step 2:
- Open AWS console and create an IAM user specifically for the terraformbootcamp
- Add appropriate user permission for the IAM user
- Get the user access key by going into the below

`User->Security Credentials->Access key->CLI`
- Include the value in the respective env vars and make them as global env vars on the shell
```
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=us-west-2
```
******Please****** note that the credentials from AWS can't be saved in .gitpod.yml file or any file in the Gitpod, other wise it will result in violation and AWS account can be locked autmatically 

Also, there could be cyber attackers hacking your aws account to use resources for their business 

Once IAM credentials are obtained, add env vars for them as globally as below:
```json
gp env AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
gp env AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
gp env AWS_DEFAULT_REGION='us-west-2'
```

We can check if the aws credentials are configured correctly by running below command:
```
aws sts get-caller-identity
```

When you are successful with the IAM credential addtion to gitpod as a global variable then you will see output to `aws sts get-caller-identity` as below:
```json
{
    "UserId": "AKIAIOSFODNN7EXAMPLE",
    "Account": "123456789101",
    "Arn": "arn:aws:iam::123456789101:user/terraform-beginner-bootcamp-laks"
}
```

This shall ensure that the aws and terrform cli are ready to be used for the project
