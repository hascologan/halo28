# swf-aws-singularity-eks-k8s

An opinionated platform accelerator for the quick deployment of AWS EKS
infrastructure and application supporting tooling.

## Documentation Links

| Link                                              | Description                                                                                                                                    |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [SWF Factory Platform](docs/deployment-guide.md)  | The deployment guide for the SW Factory Platform. Provides technical guidance for the deployment of a SW Factory Platform into an AWS account. |
| [System Administrator Guide](docs/admin-guide.md) | System Administrator Guide for the SW Factory Platform. Provides concepts and suggestions on how to administer an environment beyond day-0.    |

---

## Version Requirements

A set of tools and their tested and supported versions required for deployment
and development of swf-aws-singularity-eks-k8s.

| Tool                 | Version                 | Required | Notes                                                                                                                                                                            |
| -------------------- | ----------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AWS CLI              | 2.0/latest              | Yes      | Installation documentation found [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-version.html).                                                          |
| Terraform            | v1.1.9                  | Yes      | Installation documentation found [here](https://www.terraform.io/downloads).                                                                                                     |
| AWS provider         | v4.14.0                 | Yes      | Provider documentation found [here](https://registry.terraform.io/providers/hashicorp/aws/4.14.0).                                                                               |
| Python               | 3.10.0 or newer patch   | Yes      | Installation documentation found [here](https://www.python.org/downloads/).                                                                                                      |
| Pip                  | v22.0.4 or newer patch  | Yes      | Preferred way to install Ansible. Python packager installer. Installation documentation found [here](https://pip.pypa.io/en/stable/installation/).                               |
| Ansible              | v2.12.5 or newer patch  | Yes      | Ansible & Installation documentation found [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip). |
| Node Version Manager | v0.39.1 or newer patch  | No       | Only Required if using One Cloud AWS Account. Preferred way to install v14.18.0 version of Node. Repository found [here](https://github.com/nvm-sh/nvm).                         |
| Node                 | v14.18.0 or newer patch | No       | Only Required if using One Cloud AWS Account. Used for npm install of aws-azure-login. NPM page found [here](https://nodejs.org/en/download/).                                   |
| aws-azure-login      | v3.4.0 or newer patch   | No       | Only Required if using One Cloud AWS Account. A npm package used for one cloud account access. Found [here](https://www.npmjs.com/package/aws-azure-login).                      |
| Pre-commit           | v2.18.1                 | No       | Only Required for active development and contributions back to the [SKU](https://confluence.tools.s6ef5y.com/display/SKU) team. Found [here](https://pre-commit.com/).           |

## Developers

It is required that for all contributors to the `swf-aws-singularity-eks-k8s`
artifact that `pre-commit` be installed and enabled within a working branch.
This allows developers in different environments to contribute without the need
to worry about being familiar with team coding standards. Illustrated below is
the steps needed to install and enable `pre-commit`.

### Installation of pre-commit

- Windows & Linux User Installation

```bash
$ pip install pre-commit
# Ensure Version is 2.18.1
$ pre-commit --version
pre-commit 2.18.1
```

- MacOS User Installation

```bash
$ brew install pre-commit
# Ensure Version is 2.18.1
$ pre-commit --version
pre-commit 2.18.1
```

### Enabling pre-commit

Once `pre-commit` has been installed it is the responsibility of the developer
to enable the git hook so that on each commit the `pre-commit` framework can be
triggered to run code convention tests. To enable the git hook you must navigate
to the project root in a cli and run the following.

```bash
$ pre-commit install
pre-commit installed at .git/hooks/pre-commit
```

Once enabled each `git commit` will trigger the code conventions configured at
the `.pre-commit-config.yaml` and generate the appropriate changes.

## Quick Start Commands

### Overview

This section is for more advanced users who have experience in deploying the
swf-aws-singularity-eks-k8s artifact. The following instructions
[here](docs/deployment-guide.md) are to be followed for first time user
interaction and deployment. The following commands below assume that that all
tooling and AWS account has been setup correctly with recommended
configurations. The following will go over the `tf-backend-setup`,
`tf-landing-zone`, and `app-config` minimum configuration.

### tf-backend-setup

- Configure the `terraform.tfvars` configuration file in the `tf-backend-setup`
  with appropriate values. Project name should be S3 bucket naming compliant.

```
project_name    = "demo"
region          = "us-east-1"
profile         = "aws-profile"
```

- Run the following CLI commands to initialize and deploy the backend.

```bash
$ terraform init
# Ensure proper apply
$ terraform plan
$ terraform apply
```

- Copy the console Terraform outputs to configure the `tf-landing-zone` remote
  state.

```bash
Apply Complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

tf_build_role = "arn:aws:iam::123456789000:role/demo-TF-Bootstrap-Rol"
tf_lock_status_DDB = "Demo-Terraform-Lock-Status-DDB"
tf_statefile_s3 = "demo-terraform-statefile-12346789012-s3b"
```

### tf-landing-zone

- Configure the `main.tf` in the `tf-landing-zone` to connect the remote state
  deployed prior.

```
# Configure Terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    region         = "us-east-1"
    profile        = "demo"
    dynamodb_table = "Demo-Terraform-Lock-Status-DDB"
    bucket         = "demo-terraform-statefile-123456789012-s3b"

    # Do not change the name below
    key = "tf-landing-zone.tfstate"
  }
}
```

- Replace the temporary `projectname` value in the `Makefile` found at project
  root to create pemkeys directory.
- Run to create the `pemkeys` & `passwords` folder for SSH keys & initialization
  passwords.

```bash
make all
```

- Configure the `terraform.tfvars` in the `tf-landing-zone` with the intended
  resources wished to deploy & ensure required configuration.

```
# Required Project Configurations
project_name    = "Demo"
region          = "us-east-1"
profile         = "demo"
build_role      = "arn:aws:iam::123456789000:role/demo-TF-Bootstrap-Rol"
apex_domain     = "demo.com"
```

- Add the public key created in the `pemkeys` directory to the to the
  appropriate values in the `terraform.tfvars`.

```
# Initial Configuration Public Key
ec2_public_key = <Public Pem Key>

eks_public_key = <Public Pem Key>
```

- Replace the Vault policy name by adding the project prefix.

```
policy_names        = [<Project_Name-KMS-Vault-Pol>]
# Replace with
policy_names        = ["demo-KMS-Vault-Pol"]
```

- Create the `password.auto.tfvars`

```bash
$  echo "master_db_password = \"demopassword\"" >> password.auto.tfvars
```

- Deploy the `tf-landing-zone`.

```bash
# Should state in console that remote backend has been setup on init
$ terraform init
$ terraform plan
$ terraform apply
```

### app-config

- Fetch the Vault KMS ID

```bash
$ terraform state show aws_kms_key.vault_kms
id = "abcdefgh-1234-5678-1234-abcdefghijkl"
```

- Setup the `inventory.ini` with `apex_domain` and Vault KMS ID.

```ini
[all:vars]
project_name='Demo'
aws_region='us-east-1'
vault_key_id='abcdefgh-1234-5678-1234-abcdefghijkl'
sonarqube_version='9.2.1.49989'
k8s_version='1.21.5'
helm_version='3.7.2'
ansible_user='ec2-user'
ansible_ssh_private_key_file='../pemkeys/Demo.pem'
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q -i ../pemkeys/demo.pem ec2-user@bastion.demo.com"'
```

- Run Ansible Playbooks to finish initial deployment.

```bash
$ ansible-playbook -i inventory.ini install-all.yml -e="@../passwords/password.json"
```

---

## Resources

A complete index of all AWS resources created for both the `tf-backend-setup`
and the `tf-landing-zone` can be found at the following.

| Link                                          | Description                                                        |
| --------------------------------------------- | ------------------------------------------------------------------ |
| [TF Backend Setup](tf-backend-setup/TFDOC.md) | All resources created by the `tf-backend-setup` with descriptions. |
| [TF Landing Zone](tf-landing-zone/TFDOC.md)   | All resources created by the `tf-landing-zone` with descriptions.  |
