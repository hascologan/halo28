# Platform Deployment Guide

- [Platform Deployment Guide](#platform-deployment-guide)
- [Purpose](#purpose)
- [Overview](#overview)
  - [Software Factory Overview](#software-factory-overview)
    - [What is a software factory?](#what-is-a-software-factory)
  - [Platform Overview](#platform-overview)
    - [What is the Software Factory Platform?](#what-is-the-software-factory-platform)
    - [What should you know to be successful?](#what-should-you-know-to-be-successful)
- [Deploying the Software Factory Platform](#deploying-the-software-factory-platform)
  - [Overview](#overview-1)
    - [Industry Best Practices](#industry-best-practices)
    - [Orchestration](#orchestration)
    - [Configuration Management](#configuration-management)
    - [Automation](#automation)
    - [Security](#security)
  - [Prerequisite](#prerequisite)
    - [WorkStation](#workstation)
    - [AWS Account](#aws-account)
    - [Public DNS Domain](#public-dns-domain)
    - [OpenVPN Access Server](#openvpn-access-server)
    - [Software Factory Platform Deployment Bundle](#software-factory-platform-deployment-bundle)
    - [Deloitte Considerations](#deloitte-considerations)
- [Deployment Guidance](#deployment-guidance)
  - [Preliminary Step](#preliminary-step)
    - [Workstation Setup](#workstation-setup)
      - [General Tips](#general-tips)
      - [Windows 10 Specific Tips](#windows-10-specific-tips)
      - [Mac/Linux Specific Tips](#maclinux-specific-tips)
  - [Step One - Bootstrapping the Target AWS Account](#step-one---bootstrapping-the-target-aws-account)
  - [Step Two - Provisioning AWS Resources in AWS Target Account](#step-two---provisioning-aws-resources-in-aws-target-account)
  - [Step Three - Configuring Software Factory Platform's Servers](#step-three---configuring-software-factory-platforms-servers)
  - [Initial Configuration of the OpenVPN Access Server](#initial-configuration-of-the-openvpn-access-server)
  - [Wrap Up](#wrap-up)
- [UnDeploy / ReDeploy Guidance](#undeploy--redeploy-guidance)
  - [Undeploy](#undeploy)
    - [Resources Outside of Terraform Control](#resources-outside-of-terraform-control)
    - [Step One AWS Resources](#step-one-aws-resources)
    - [Step Two AWS Resources](#step-two-aws-resources)
    - [Step Three Configurations](#step-three-configurations)
  - [ReDeploy](#redeploy)
    - [Step One](#step-one)
    - [Step Two](#step-two)
    - [Step Three](#step-three)

# Purpose

This document serves as the deployment guide for the SW Factory Platform. It
provides technical guidance for the deployment of a SW Factory Platform into an
AWS account.

# Overview

## Software Factory Overview

### What is a software factory?

The Software Factory is an outcomes-driven operating model designed to quickly
deliver secure, high-quality software that users want to use. Using leading-edge
technologies and innovations like automation, container orchestration,
infrastructure as code, robust security controls, and much more, the Software
Factory delivers the speed, effectiveness, and flexibility needed to tackle the
most pressing mission challenges in the world. In complete concert with this
pioneering approach, the Software Factory embraces the DevSecOps methodology --
a shift of operations from a static, reactive security posture, to a proactive,
agile, and continuously improving DevSecOps culture.\
\
The Software Factory approach fosters collaboration, high-velocity delivery, and
risk reduction while improving outcome quality. Adherence to DevSecOps
principles drives the adoption of leading practices, including dependency
isolation, code separation, and concurrency, to enable synchronization between
the platform and applications at runtime. Depending on requirements, the CI/CD
toolset can be configured using a stack of technologies and industry standard
tools such as J-unit, HP Fortify, and SonarQube to automate components of unit
testing, functional testing, and stress testing to expedite deployment, remove
human error, and improve software quality.\
\
The Software Factory also brings accelerators and seed projects designed to
integrate with container orchestration technologies in order to provide
scalability, agility, and fault tolerance. Building and institutionalizing a
more streamlined approach to the development and test integration cycle with
modern tools such as GitLab, SonarQube and Fortify, the Software Factory
platform offers a shortened and high-quality path to field critical mission
applications.

## Platform Overview

### What is the Software Factory Platform?

The Software Factory Platform is the pre-packaged landing zone that underpins
the Software Factory itself. It is the foundation upon which the Software
Factory sits, and the means by which the Software Factory performs its core
functionality. The Software Factory Platform conforms to industry best
practices, and is constantly being updated to the ever changing technical
ecosystem.

The Platform includes DevSecOps tools that provide a continuous integration and
continuous deployment (CI/CD) pipeline to reliably compile, build, test and
deploy code. The Platform embeds security, compliance, monitoring, and testing
into the build process to reduce risk while enhancing delivery speed and
recovery.

Leveraging the power of Terraform, Ansible and AWS, the Software Factory
Platform aims to be as easy to deploy as possible. Representing the Software
Factory's core value of delivering more value faster, the Platform is
configurable under a "single pane of glass". With minimal code changes and
setup, the Platform can be deployed into a single AWS account in a single region
in a matter of hours, replacing days of engineer hours with a robust and
repeatable automated process.

This document will prepare the user and outline the minimal steps necessary to
be successful in deploying this world-class platform.

### What should you know to be successful?

To be as succinct as possible, this platform deployment guide assumes knowledge
of AWS tools and technologies, Terraform, Ansible, and some background in
deploying large systems in an enterprise cloud environment. Throughout the
document, links to external documentation will be referenced to add context,
facilitate further reading, and encourage self-education for concepts not
discussed in detail here. Most of the tooling can be setup within a Windows
environment, but it is recommended that a user take advantage of WSL2 on
Windows, or a Mac/Linux based system.

# Deploying the Software Factory Platform

## Overview

The deployment scripts for the Software Factory Platform provision a fully
functional solution into a single AWS account within a single AWS region.
Deployment of the platform is broken into three sequential steps. The first step
involves bootstrapping activity in which a small number of AWS resources (i.e.,
under 10) are provisioned. These resources are then leveraged to facilitate the
second and third steps. The second step provisions the complete set of
infrastructure components required by the Software Factory Platform (350+ AWS
resources). The third and final step installs and configures application clients
onto a set of platform EC2 instances.

Examination of the root directory of the Software Factory Platform installation
bundle reveals three folders that correspond to the three steps involved in the
deployment of a Software Factory Platform. The `tf-landing-zone` folder
corresponds to Step One, the `tf-backend-setup` folder corresponds to Step Two,
and the `app-config` folder corresponds to step three.

### Industry Best Practices

Industry best practice for solutions hosted in a public cloud recommends
maximizing the number of resources automatically provisioned / configured and
minimizing the number of resources manually provisioned / configured.
Automatically provisioning resources introduces a number of benefits including
speed, accuracy, standardization, repeatability, and reuse.

The technique of automatically provisioning infrastructure is often referred to
as Infrastructure as Code (IaC) is closely aligned to the industry term
"orchestration." Orchestration can be defined as the automated creation,
placement, and configuration of infrastructure components (e.g., networking,
servers.) The technique of automatically installing, configuring, and
maintaining resources (typically applications hosted on servers) is commonly
referred to as "configuration management." Software development organizations
seldom confine their offerings to a single IT category / technology. Therefore,
most orchestration tools offer some configuration management functionality and
most configuration management tools offer a degree of orchestration
functionality. Embracing these methodologies requires discipline to continue
them pass Day 0 and Day 1 operations for a robust and stable environment.

Deployment of the Software Factory Platform leverages
[Terraform](http://www.terraform.io) for orchestration (i.e., steps one and step
two) and [Ansible](http://www.ansible.com) for configuration management (i.e.,
step 3).

### Orchestration

The Terraform scripts contained in the folders `tf-backend-setup` and
`tf-landing-zone` follow standard Terraform coding best practices (e.g., use of
`main.tf`, `variables.tf`, `terraform.tfvars`, etc.). Additionally, most of the
scripts are modularized into separate script files based on AWS resource type.
That is, individual Terraform files are named to indicate the AWS resource type
that is created / configured by the file.

All AWS resources provisioned by the Terraform deployment scripts receive a
meaningful value for their `Name` tag. This value is composed of multiple
sections separated by hyphens. The first section is set to the overall project
name assigned during Software Factory Platform Platform deployment. The sections
following the project name will vary across different AWS resource types. The
last section of the `Name` value is composed of three alphanumeric characters to
indicate an AWS resource type. An example value assigned to the `Name` tag of
EC2 instance provisioned by the Terraform deployment scripts is
`myProj-Network-vpn-EC2`. Encoded in this name value is the overall project
(\"myProj\"), the vpc that the EC2 instance located in (\"Network\"), the name
of the EC2 instance / server (\"vpn\"), and the AWS resource type (\"EC2\"). S3
buckets are named following the pattern
`<project name>-<purpose of bucket>-<AWS account number>-<3 char descriptor>`. 
An example S3 bucket name for a bucket provisioned by the Terraform deployment
scripts is `my-proj-terraform-statefile-123456789012-s3b`.

No AWS EC2 AMI ID is hard-coded into the Terraform deployment scripts.
Hard-coded AMI IDs are problematic as the AMI ID for a specific AMI will vary
from AWS region to AWS region. Additionally, over time all AMIs will deprecate
becoming unavailable for use within the EC2 service. In place of hard-coding AMI
IDs, the Terraform deployment scripts use a combination of AMI owner and AMI
name to dynamically source (at script execution time) the required AMI ID.

To avoid issues introduced by binding to the ephemeral IP addresses assigned to
EC2 instances, EC2 instances within the Software Factory Platform are accessed
using DNS addressing. This includes access from components within the platform
(i.e., private DNS) and without the platform (i.e., public DNS.)

### Configuration Management

Configuration management of the Software Factory Platform servers (i.e., EC2
instances) occurs during step three of the deployment process. It is carried out
by the execution of Ansible playbooks on your local workstation using a
connection between your workstation and a bastion sitting within a public
subnet, which brokers access to the platform's servers located in private
subnets.

### Automation

The deployment process for the Software Factory has been automated to the
fullest extent possible. The process requires manually editing a handful of
files contained in the Deployment Bundle and the performance of a few basic
tasks that cannot be automated. The files that require minor editing include
`Makefile` / `GenKeys.psl`, `tf-backend-setup/terraform.tfvars`,
`tf-landing-zone/main.tf`, `tf-landing-zone/terraform.tfvars`, and
`app-config/inventory.ini`. The manual steps required during deployment include:
obtain a public DNS domain, procure an OpenVPN Access Server license /
subscription, execute a few basic scripts, and retrieve a KMS key ID from a
Terraform state file. Modification of the individual Terraform script files
(i.e., the files modularized by AWS type) and the individual Ansible playbook
`.yml` files is strongly discouraged as it will most likely result in deployment
failure. Auditing of all API calls to all AWS services is enabled and
monitoring. All application and operating system logs are collected and
monitoring. Within AWS services, data at rest is encrypted.

### Security

The SW Factory Platform design follows all normative security industry best
practices. Client web browser traffic to and from the platform is encrypted.
This encryption is supported by both a registered public DNS domain and digital
certificates; both of which are generated, for dedicated use, at each platform
deployment. Inbound traffic is scrutinized by a purpose-built web application
security firewall. The platform's external security perimeter (i.e., its
effective attack surface) is minimized and hardened. Only the handful of
resources (those requiring direct public Internet access) reside within the
platform's only publicly accessible network subnet. AWS recommended security
best practices are followed for all AWS service configurations and
service-to-service integrations. Direct access to individual platform components
is centrally managed using a platform-resident, dedicated authentication /
authorization application. All data at rest within the platform is encrypted
using customer-controlled encryption keys. Auditing and monitoring of all AWS
API calls occurs in near-real-time and automated alerting is in place.
Centralized collection and monitoring of all application logs, operating system
logs, network flow logs, and server system administration logs occurs in
near-real-time and automated alerting is in place.

## Prerequisite

### WorkStation

Deployment of the Software Factory Platform requires a machine with reliable
public internet access (minimum of 10 Mbps). Additionally you will need to
install the following software packages

- Terraform version 1.0 or newer
- AWS CLI version 2.0 or newer
- Go version 1.18 or newer
- Python version 3.8 or newer
- Git version 2.17.1 or newer
- Pre-commit 2.18.1 or newer
- Ansible version 4.0 or newer
  - Ansible is not available for installation on standard Window workstations
  - Ansible can be installed and run on a Windows workstation configured with
    the WSL 2 (Windows Subsystem for Linux) and a Linux distribution
- For Windows workstations, Windows Subsystem for Linux 2 + Linux distribution
  (e.g., Ubuntu).
- Security credentials on your workstation enabling access to the target AWS
  account of the deployment.
  - Options
    - Access key ID and secret access key of IAM user with suitable access level
    - Access key id, secret access key, and token issued from IAM STS with
      suitable access level
  - Required access level: AWS managed IAM policy named
    `AdministratorAccess arn:aws:iam::aws:policy/AdministratorAccess` is
    recommended as the Software Factory Platform leverages a variety of AWS
    services

### AWS Account

The Software Factory Platform should be deployed into a newly acquired (with
default configuration), dedicated AWS account. While it is possible to deploy
the platform into any AWS account, deploying into a leveraged / preexisting AWS
account may introduce complications that would most likely not be present were
you to use a newly acquired, dedicated AWS account.

Prior to deploying the Software Factory Platform, you must ensure that the
service quota limits within the target AWS account will not prevent a successful
deployment. At the time of this writing, the default service quota for the
maximum number of concurrent VPCs in a single region is 5 (i.e., VPCs per
Region.) The default service quota for the maximum number of concurrent
On-Demand Standard (i.e., types A, C, D, H, I, M, R, T, Z) EC2 instances is 5.
The Software Factory Platform requires 5 VPCs and approximately 20 EC2
instances.

Access the target AWS account and determine the current AWS service quotas for
concurrent number of VPCs allowed in a single region and concurrent number of
standard, on-demand EC2 instances. In the AWS Console you can access service
quotas, as well as submit service quota requests, in the Support Center in the
Support Tools section. If the service quota number is less than 10 for VPCs or
less than 30 for EC2 instances, submit AWS Service Quota Requests to bring the
limit up to at least these numbers respectively. Do not attempt to deploy the
Software Factory until all service quota requests have been successfully
processed and are active. At the time of this writing, OneCloud automatically
adjusts the service quota limit for concurrent standard EC2 instances in a
region from 5 to 640 in some AWS regions.

If you would like to take inventory of the number of AWS Resources currently
deployed in an AWS account you can run the following AWS CLI command, after
ensuring that the AWS Config Service is enabled. Additionally, the information
is available through the Config section of AWS Console in the
`Resource Inventory` section. By default the AWS Config service is not enabled
on new AWS accounts, but it is enabled by OneCloud for AWS accounts under its
control.

```bash
$ aws configservice get-discovered-resource-counts --profile <AWS CLI profile> --output table --region <region>
```

**Tips:**

- The AWS Trusted Advisor is another source you can use to obtain useful
  information about AWS quota limits. You can find a Service Limits section in
  the Trusted Advisor Dashboard section of the AWS Console.
- In addition to AWS resource tags, the set of AWS resources that directly
  support the deployment of a SW Factory Platform deployment can easily be
  tracked using the `configservice get-discovered-resource-counts` command above
  - Issue the command just before deploying the SW Factory Platform and save off
    the displayed output
  - Issue the command just after deploying the SW Factory Platform and save off
    the displayed output

### Public DNS Domain

Deployment of the Software Factory Platform requires a public DNS domain to
support DNS-based referencing of the platform's various servers. This not only
eliminates binding to ephemeral server IP addresses but enables "single sign on"
access to all of the platform's servers. This public DNS domain must take the
form of a Route 53 public hosted zone. It can be created / registered with
Amazon Route 53 or an existing DNS domain can be transferred into Route 53.

Setting up the required Route 53 public hosted zone is not covered by the
Terraform deployment scripts and must be performed manually. Do not attempt to
deploy the Software Factory platform until a Route 53 public hosted zone is in
place in the target AWS account.

### OpenVPN Access Server

The Software Factory Platform requires an OpenVPN Access Server license to
enable external client devices to access the platform. Obtaining an OpenVPN
Access Server subscription / license is not covered by the Terraform deployment
scripts and must be performed manually. The subscription / license must be
obtained within the AWS account that will be used to deploy the SW Factory
Platform.

Obtain the OpenVPN Access Server license / subscription through the AWS
Marketplace. You can access the AWS Marketplace home page using this
[link](https://aws.amazon.com/marketplace). On the landing page enter "OpenVPN
Access Server" in the search input field at the top of the page. The free-tier
license, providing 2 concurrent connections, will most likely only prove
suitable for initial exploration of the platform deployment process. For a
production deployment of the platform a 50 concurrent connections license is
recommended.

After procuring your OpenVPN Access Server subscription do not launch the
OpenVPN Access Server. The OpenVPN server utilized by the Software Factory
Platform must be launched by the Terraform deployment scripts. Take note of the
AMI ID behind your OpenVPN subscription. Note that the AMI will vary from AWS
region to AWS region so ensure you obtain the AMI for same region into which you
will deploy the SW Factory Platform. Using the AMI ID, ensure that you can
successfully execute the following command at an AWS CLI prompt, but make sure
that you verify the command in the **same region** that you intend to deploy the
platform into. The output from the command should be an AMI name (i.e.,
approximately 80 characters). Example command and output:

```bash
$ aws ec2 describe-images --image-ids ami-037ff6453f0855c46 --query "Images[0].Name"
OpenVPN Access Server Community Image-fe8020db-5343-4c43-9e65-5ed4a825c931-ami-06585f7cf2fb8855c.4
```

You will use the output from this command in "Manual Steps and Manual Edits"
portion of the preliminary step of the deployment process. Do not attempt to
deploy the Software Factory until you can successfully execute this command.

After the process is complete you may wish to accept the SLR agreement under the
Amazon Marketplace subscription to allow the user or administrator a full view
of all Marketplace Subscriptions. The OpenVPN subscription should show after the
first time agreement.

### Software Factory Platform Deployment Bundle

Obtain the Software Factory Platform Deployment Bundle and place it in a
suitable directory on your workstation. The bundle's directory structure
contains Terraform scripts, Ansible playbooks, and a collection of supporting
resources. Several directories within the bundle serve as working directories
for tools such as Terraform and Ansible. It is important that you do not alter
contents of the Deployment Bundle with the exception of following the direction
provided by this deployment guide.

### Deloitte Considerations

If you will be deploying the Software Factory Platform onto an AWS account under
the control of Deloitte OneCloud, you will have to work with additional layers
of security safeguards. To gain access to any AWS account under OneCloud
control, you must use the AWS Azure AD Access Model. You can find information on
the model
[here](https://resources.deloitte.com/sites/MyTech-Global/Documents_New/Business_of_IT/OneCloud/AWS-Azure-AD-Access-Model.pdf).
The process contained in the model involves the creation of net new AD
credentials, separate from standard Deloitte AD SSO credentials, that are
granted the elevated level of permission required to access a
OneCloud-controlled AWS account. When submitting your MAC Tool request, as part
of the model's process, ensure that you request
`AdministratorAccess arn:aws:iam::aws:policy/AdministratorAccess` permission
level.

With the exception of personal AWS sandbox accounts, in order to use the AWS CLI
or a programming language SDK against an AWS account controlled by OneCloud, you
must first install the AWS Azure AD SSO Plugin onto your local workstation.
After installation and configuration are complete, you can invoke the plugin, at
a command line, and obtain the temporary credentials (i.e., access key id and
secret access key) necessary use of the AWS CLI and the various programming
language SDKs against the AWS account. After the temporary credentials expire
you will have to invoke the plugin again in order to use the AWS CLI and the
various SDKs against that AWS account. You can find information on the plugin
[here](https://resources.deloitte.com/sites/MyTech-Global/Documents_New/Business_of_IT/OneCloud/AWS-Azure-AD-SSO-Plugin.pdf).

Before attempting to deploy the platform into an AWS account controlled by
Deloitte OneCloud, ensure that you are both familiar and comfortable with
Deloitte's AWS Azure AD Access Model and AWS Azure AD SSO Plugin. The amount of
time and effort required to reach a suitable level of confidence with both the
model and the plugin can very greatly from individual to individual.

# Deployment Guidance

Deployment of the platform is broken into three sequential steps. The first step
involves bootstrapping activity in which a small number of AWS resources (i.e.,
under 10) are provisioned. These resources are then leveraged to facilitate the
second and third steps. The second step provisions the complete set of
infrastructure components required by the Software Factory Platform (350+ AWS
resources.) The third and final step installs and configures software onto the
platform's servers.

If you will be deploying the SW Factory Platform into a dedicated AWS account
(recommended) then you may find it useful to run the command below to record a
snapshot of the AWS resources in place before deployment the platform. Running
this same command after deploying the platform can help you, in addition to
using the AWS resource tag Name, to identify the AWS resources that directly
support the platform. This information can prove useful when destroying the
platform.

Additionally, this information is available through the Config section of AWS
Console in the `Resource Inventory` section. By default the AWS Config service
is not enabled on new AWS accounts, but it is enabled by OneCloud for AWS
accounts under its control. The Config service must be enabled for the command
to work.

```bash
$ aws configservice get-discovered-resource-counts --profile <AWS CLI profile> --output table --region <region>
```

## Preliminary Step

To successfully deploy the Software Factory Platform several things must be in
place. A deployment attempt cannot succeed until all the items outlined in this
section are suitably addressed.

As mentioned in the "Deploying the Software Factory Platform/Prerequisites"
section you will need a public DNS domain, an OpenVPN Access Server
subscription, and to have succeeded with the installation of several items onto
your workstation (i.e., AWS CLI, AWS security credentials). In addition,
deployments into an AWS account controlled by Deloitte OneCloud will require the
successful processing of a MAC Tool request in order to obtain access to the
target AWS account. You can refer to the "Deploying the Software Factory
Platform/Prerequisites " section for additional detail on some of these items.

For the remainder of the items required for a successful deployment of the
platform, this section will provide detailed guidance. Namely, installation of
Ansible onto your workstation, installation and use of the AWS Azure AD SSO
Plugin, and a small number of manual edits on a handful of files contained
within the Deployment Bundle.

### Workstation Setup

A number of tools are required for a local machine to successfully to deploy the
platform into an AWS account. Below is a table of tools and the correlating
links to documentation on how to setup those tools for the appropriate operating
system as well as recommended versions.

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

Installing Ansible on a workstation can prove challenging. Using the package
manager `pip` to install Ansible is recommended as it will will not result in
the installation of a deprecated version of `Python` as some Ansible
installation methods are known to do. At the time of this writing, Ansible
cannot be directly installed / run on a Windows workstation. To carry out step
three of the SW Factory Platform deployment process using a Windows workstation,
you will need to first install Windows Subsystem for Linux 2 (WSL2.) Then to
carry out step three you will use a WSL 2 command line prompt to execute Ansible
commands.

As multiple versions of `Python` can coexist on a workstation, it is always a
good idea to check the version of `Python` that will be sourced when you issue
an Ansible command. Using a command line, entering the command
`python --version` or `pip --version` will return a version number. You want
this version to be 3.0 or newer. It is always advisable, after installing
software, to ensure your shell `rc` file is updated to accommodate command
recognition and autocompletion. You can use the following command to do so.

_Determine what Shell is being used before running command below_

```bash
# Examples .bashrc .zshrc
$ echo 'PATH=$HOME/.local/bin:$PATH' >> ~/.<REPLACE_ME>rc`
```

You can find the Ansible Install Guide
[here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip)

**AWS Config File:**

By default, Terraform commands executed on a workstation will leverage an AWS
CLI profile in order to gain access to an AWS account. Commonly, AWS CLI
profiles are stored locally on workstations at `$HOME\.aws\config` for UNIX
based environments and `%USERPROFILE%\.aws` (i.e., `C:\\Users\foo\.aws`) for
Windows environments. Ensure that the default IAM CLI profile, or the one that
you will use, has both access to and sufficient access privilege within the
target AWS account. For access privilege, the AWS managed IAM policy named
`AdministratorAccess arn:aws:iam::aws:policy/AdministratorAccess` is recommended
as the Software Factory Platform leverages a variety of AWS services

**AWS Azure AD SSO Plugin**

If you are deploying the Software Factory Platform into an AWS account
controlled by Deloitte OneCloud, you need to determine if the AWS account is a
personal AWS sandbox account. If it is not an personal AWS sandbox, you must
first install the AWS Azure AD SSO Plugin onto your workstation before you can
deploy the platform. This is because deploying the platform requires that you
access the target AWS account via the AWS CLI. And you will also need to have
submitted a MAC Tool request (part of the AWS Azure AD Access Model), that was
successfully processed, for `AdministratorAccess`
`arn:aws:iam::aws:policy/AdministratorAccessaccess` permission to the target AWS
account.

The AWS Azure AD SSO Plugin is not required when using the AWS Console to access
AWS accounts controlled by OneCloud. However, to access long-lived AWS accounts
controlled by OneCloud (i.e., not personal AWS sandbox accounts) via the AWS
CLI, or any of the various SDKs available, you will need to install the plugin
on your workstation. You can source information on this plugin, including
installation instructions,
[here](https://resources.deloitte.com/sites/MyTech-Global/Documents_New/Business_of_IT/OneCloud/AWS-Azure-AD-SSO-Plugin.pdf).

The AWS Azure AD SSO Plugin requires configuration, at least once, before it can
be used. You can configure it for all AWS CLI profiles on your workstation or
for a single profile. The examples provided in this section illustrate
configuration for a single profile. To configure the plugin issue the command:

```bash
$ aws-azure-login --configure --profile foo
```

During configuration of the plugin you will need to supply the following
information:

- `Azure Tenant ID`
  - Enter the value `36da45f1-dd2c-4d1f-af13-5abe46b99921`
  - This value is shared across all Deloitte employees
- `Azure App ID URI`
  - Enter the value `https://signin.aws.amazon.com/saml#123456789012`
  - Please replace the target AWS account ID for the number "123456789012" in
    the URL above
- Default Username
  - Enter the username belonging to the elevated privilege credentials that you
    obtained from the successful processing of the MAC Tool request. The
    credentials from an elevated privilege account are required to access an AWS
    account under control of Deloitte OneCloud
  - Normally, the user name for the credentials of your elevated privilege
    account will be the same user name as your Deloitte AD SSO username but with
    the addition of a prefix. For example, an individual with the Deloitte AD
    SSO of `joesmith@deloitte.com` might receive `usa-joesmith@deloitte.com` as
    the username.
  - In order to (part of the AWS Azure AD Access Model) that was successfully
    processed
- `Stay logged in` leave the default value of `false`
- `Default Role Arn` leave this blank
- `Default Session Duration` enter a number between 1 and 12

After configuration you will need to use the plugin each time that you require
AWS CLI or SDK access to the target AWS account. To use the plugin to gain AWS
CLI / SDK access to the target AWS account issue the command:

```bash
$ aws-azure-login --mode gui --profile foo
```

A small window will appear, with the Deloitte branding, in which you need to
enter the user name in the input filed below the label "Sign in" for the
elevated privilege account that you obtained from your MAC Tool request (e.g.,
`usa-joesmith@deloitte.com`) and click on `Next`.

Each time that you use the plugin it will provision temporary credentials, via
AWS\' IAM STS, placing the credentials in a `.aws/credentials` file. In the case
of the example command above, a new access key id, secret access key, and token
will be placed in the `credentials` file for the profile named "foo." These
credentials are temporary, lasting a number of hours. The last step (before the
command routes to IAM for credential provisioning) allows you to specify, via
the command line, how many hours you would like the temporary credentials to
remain valid.

#### General Tips

- Ensure that you always include the `--mode gui` command line option. The
  plugin will not work without including the option

#### Windows 10 Specific Tips

- If you are experiencing difficulties with cut and paste operations into a
  PowerShell or Cmd shell, try a right mouse click immediately following the
  failed paste key sequence.
- To use the AWS Azure AD SSO Plugin you will need invoke it from a PowerShell
  or Cmd shell that is run by the Windows 10 user that was automatically created
  on your workstation when you installed the plugin. This user's name matches
  the username of the AD credentials that were created when you used the MAC
  Tool to request the elevated permission levels necessary to access an AWS
  account. The following steps will help you launch a PowerShell run by the
  Windows 10 user with elevated permission levels
  - In the Windows 10 search bar / input region (i.e., lower left hand corner of
    UI), type in `PowerShell`
  - Right click on the `PowerShell` icon and then select `Open file location`
  - In the resulting window hold down the `shift key`, right click on the
    `PowerShell` shortcut, and select the `Run as different user`
  - In the resulting security pop-up dialogue, provide the username for the
    local Windows 10 user provisioned when you installed the plugin. For the
    password, supply the temporary / daily password that you retrieved from the
    Secrets Server, which is a component of the AWS Azure AD Access Model.
- The AWS CLI is automatically configured to use the environmental variable
  named `AWS_PROFILE`. By setting this variable you can avoid the need to
  repeatedly provide the `--profile <profile name>` command line option.
  Remember that once you set an environmental variable you will need to bring up
  a new PowerShell or Cmd Shell in order to pick up new settings.
- Assuming default Windows 10 settings, you will have to temporarily lower the
  script execution security level settings in order to invoke the AWS Azure AD
  SSO Plugin. After you are finished executing the plugin you should restore the
  default script execution security levels.
  - Lower the script execution security level for Windows 10
    - Open a PowerShell with administrator access
    - Execute the command: `Set-ExecutionPolicy RemoteSigned`
    - At the follow up prompt, enter `A`
    - Remember that you will need to launch a new shell in order to obtain an
      updated set of environmental variables and settings
  - To elevate the script execution security level for Windows 10
    - Open a PowerShell with administrator access
    - Execute the command: `Set-ExecutionPolicy Restricted`
    - At the follow up prompt, enter `A`
    - Remember that you will need to launch a new shell in order to obtain an
      updated set of environmental variables and settings
- Debug mode on Windows is set with set `DEBUG=aws-azure-login`

#### Mac/Linux Specific Tips

- Node Version Manager is actively supported for Mac/Linux environments and is
  highly recommended for installing `node` and `npm` to the acquiring of the
  `aws-azure-login` package.
- Debug mode is set with `DEBUG=aws-azure-login`

**Manual Steps and Manual Edits**

The following manual steps and manual file edits are required to support
deployment of the Software Factory Platform. Please complete all, in sequence,
before attempting to deploy the platform.

- Obtain the Software Factory Platform Deployment Bundle and place it in a
  suitable directory on your workstation. The bundle's directory structure
  contains Terraform scripts, Ansible playbooks, and a collection of supporting
  resources. Several directories within the bundle serve as working directories
  for tools such as Terraform and Ansible. It is important that you do not alter
  contents of the Deployment Bundle with the exception of direction provided by
  this deployment guide.
- Select an overall project name to refer to the Software Factory Platform
  deployment. Please select a concise, meaningful name. A single word containing
  approximately eight characters would work well, but you are free to use any
  string. This overall project name will be used in multiple ways during the
  platform's deployment (e.g., as a prefix to the value assigned to the `Name`
  tag of provisioned AWS resources, file names for asymmetric key pair,
  incorporated into the naming of S3 buckets, etc.). For this reason you should
  avoid selecting a string that would result in a failed attempt to provision an
  AWS resource. In general, you should use a string that complies with the AWS
  S3 bucket naming rules
  ([Naming Rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)).
  - Within the platform Deployment Bundle, edit the file `Makefile` (for a
    Mac/Linux workstation) or the file `GenKeys.psl` (for a Windows workstation)
    and set the variable `projectname` to the overall project name you selected.
    These files are located in the root directory of the SW Factory Platform
    Deployment Bundle.
  - Within the platform Deployment Bundle, edit the
    `tf-landing-zone/terraform.tfvars` file.
    - In this file locate the `Server Configuration` section.  Within this
      section locate the `vault` server.  Within the `vault` server
      configuration code locate the `policy_names` key and set its value to a
      list of a single string of `-KMS-Vault-Pol` prefixed by the overall
      project name.
    - For example, if the overall project name that you selected is `Demo` then
      you would set the policy_names key to the value of `Demo-KMS-Vault-Pol`.
      Note: this value is a list of strings containing the single string
      Demo-KMS-Vault-Pol
- Establish a public DNS domain for exclusive use by the Software Factory
  Platform
  - Options
    - In the target AWS account, create a public Route 53 hosted zone for the
      public DNS domain
    - Transfer registration of an existing public DNS domain to AWS Route 53,
      creating within the target AWS account a public Route 53 hosted zone for
      the domain
  - Within the platform Deployment Bundle, edit the `app-config/inventory.ini`
    file by replacing the place holder string `<apex domain name>` with the
    public domain name that will be used by the platform.
    - Use your editor's search / replace feature for convenience and accuracy as
      the placeholder exists in several locations within the file.
    - For example, if you registered the public DNS domain of `demo.com` then
      for the bastion server you would replace the URI
      `bastion.<apex domain name>` with the URI `bastion.demo.com`.
- Generate an asymmetric key pair to support SSH access into the Software
  Factory Platform's servers. The filenames of these keys must follow a specific
  naming pattern and the keys must reside in a specific folder within the
  Deployment Bundle.
  - As a convenience, the Software Factory Platform Deployment Bundle contains a
    makefile (for Unix/Linux workstations) and a PowerShell script (for Windows
    workstations), located in the root directory, that you can manually invoke
    to generate a key pair
    - For deployments on a Mac/Linux workstation, execute the makefile named
      `Makefile` with the command `make pemkey`
    - For deployments on a Windows workstation
      - A PowerShell script is included in the Deployment Bundle that will
        generate an asymmetric key pair. Invoke this script twice and store both
        passwords (e.g., in a file) for use in a later step
        - The file `GenKeys.ps1`, located in the Deployment Bundle root
          directory, contains the PowerShell script commands to provision the
          key pair
        - Ensuring that you are in the Deployment Bundle root directory, execute
          the command `.\GenKeys.ps1`
      - Alternatively, you could execute the makefile named `Makefile` using a
        `WSL2` install on a Windows machine.
  - Successfully executing the makefile or the script will
    - Create the `pemkeys` subdirectory off of the bundle's root directory
    - Create asymmetric key pair. The public key will be named
      `<overall project name>.pem.pub`. The private key will be named
      '<overall project name>.pem`.
    - Create the `passwords` subdirectory off of the bundle's root directory
    - Generate passwords and save it as a JSON file
    - During step 2 of the deployment process, Terraform will access the public
      key and place it on each of the platform's servers to enable remote access
      for the Ansible commands in step 3.
  - Edits for the public key
    - Navigate into the `pemkeys` directory, which is located directly at the
      root of the platform Deployment Bundle. Open the file with the `.pub`
      extension (i.e., the public key of the key pair) and copy the contents of
      the file into your workstation's system buffer (e.g., "control c").
    - Tips
      - There are three parts to a public key: type, key, comment.
      - If you used the `GenKeys.ps1` script to generate the asymmetric key pair
        you will need to check the comment portion of the key and remove any
        `\' characters that you locate. The comment part of the key follows the `=`character. The`\`
        character is problematic when it occurs within a literal string within a
        Terraform script. You can safely alter (i.e., remove all `\` characters)
        the comment section of the public key without impacting the function of
        the public key.
    - Open the file `tf-landing-zone/terraform.tfvars` and locate the
      `Initial Configuration Public Key` section. Set the value of the key named
      `ec2_public_key` to the public key value that you copied into your
      workstation's buffer enclosed by double quotes (e.g.,
      `ec2_public_key = "ssh-rsa..."`). Also set the value of the key named
      eks_public_key to the public key value contained in your workstation's
      buffer enclosed by double quotes. Simply put, in the file
      `tf-landing-zone/terraform.tfvars` you replace the string
      `<Public Pem Key>` with the contents of the public key file (i.e.,
      contents of the file in `pemkeys` directory that has the `.pub` extension)
  - Edits for the private key
    - Open the file `app-config/inventory.ini` and replace all occurrence of the
      place holder `<private pem key>` with the file name of the private key
      located in the `pemkeys` directory.
    - Tips
      - The private key will have a `.pem` extension, whereas the public key
        will have a `.pub` extension. For example, if your overall project named
        is `Demo` then the public key would be named Demo.pem.pub and the
        private key would be named `Demo.pem`. So you would replace all
        occurrences of `<pem key name>` with `Demo.pem`.
      - During the edits ensure that you do not delete the relative addressing
        that prefixes filename of the public key (i.e., `../pemkeys/`).
- Procure a subscription / license for an `OpenVPN Access Server` in the AWS
  Marketplace, doing so within the AWS account that will be used to deploy the
  SW Factory Platform.

  - You can access the main page of AWS Marketplace with this
    [link](https://aws.amazon.com/marketplace).
  - At the AWS Marketplace main page enter "OpenVPN Access Server" into the
    search input field at the top of the page and select a suitable
    subscription. When configuring the subscription ensure that you
    - Specify the AWS region that you will deploy the SW Factory Platform. Note
      that the AMI for OpenVPN Access Server will vary from AWS region to AWS
      region so take care with this step.
    - Note the AMI ID behind the subscription, as you will need to supply this
      id in the AWS CLI command below.
    - The final step of configuring your subscription provides a "Continue to
      Launch" button. Do not select this button to manually launch the OpenVPN
      Access Server. The server must be launched, along with the rest of the
      platform's EC2 instances, as part of the second step of the SW Factory
      Platform deployment process.
  - Execute the following AWS CLI command (i.e., EC2 command), ensuring that you
    supply the AMI ID behind the OpenVPN subscription. The output resulting from
    this command is the AMI name behind the OpenVPN Access Server subscription.
  - Edit the file `tf-landing-zone/terraform.tfvars` and locate
    `Server Configurations` section. Within the `vpn` block in this section set
    the `ami_name` attribute to the AMI name (enclosed in double quotes)

  - Example of the command and output:

`aws ec2 describe-images --image-ids ami-037ff6453f0855c46 --query "Images[0].Name"`

`OpenVPN Access Server Community Image-fe8020db-5343-4c43-9e65-5ed4a825c931-ami-06585f7cf2fb8855c.4`

## Step One - Bootstrapping the Target AWS Account

Before initiating the SW Factory Platform deployment process, ensure that you
have successfully worked through the entire "Preliminary Step" section above. In
particular, ensure that you have successfully worked through the "Manual Steps
and Manual Edits" sub section. You cannot successfully deploy the platform
without first completing the Preliminary Step outlined above.

The first step of the SW Factory Platform deployment process involves
provisioning AWS resources to support the remote storage and versioning of a
Terraform state file. A Terraform state file tracks all resources under control
of a Terraform configuration. The SW Factory Platform deployment process uses a
remote state file, located in an AWS S3 bucket, versus a local state file that
would be located on the same workstation that executes the Terraform commands.
By locating the state file remotely multiple individuals are able to execute
Terraform scripts to provision / manage the same set of resources. However, to
avoid the potential for concurrent, competing updates from multiple individuals,
a platform-specific locking mechanism (i.e., DynamoDB table) is employed to
ensure single-threaded updates to the remote state file.

To execute Step One of the SW Factory Platform locate the SW Factory Platform
Deployment Bundle and navigate to the `tf-backend-setup` folder. Edit the
`tf-backend-setup/terraform.tfvars` file.

- Set `project_name` to the overall project name that you decided on earlier in
  the "Manual Steps and Manual Edits" section of this document
- Set `region` to the region that you will deploy the platform into
- Set `profile` to an AWS CLI profile on your workstation that has both access
  to and sufficient permission levels in the target AWS account.

Example:

```go
project_name = "Demo"

region = "us-east-1"

profile = "demo"
```

After properly configuring the `tf-backend-setup/terraform.tfvars` file and
saving the configuration changes, execute the Terraform commands below in the
`tf-backend-setup` folder, doing so in order. The `terraform plan` command is
optional. These commands provision the necessary AWS resources required to
accommodate the remote storage / management of the Terraform state file.

Executing each command will produce several lines of output. Within the output
generated from executing the `terraform init` command, look for a
`Terraform has been successfully initialized!` message. Within the output
generated from executing the `terraform plan` command, look for a
`Plan: 6 to add, 0 to change, 0 to destroy.` message. Within the output
generated from executing the `terraform apply` command look for a
`Apply complete! Resources: 6 added, 0 changed, 0 destroyed.` message. Note: the
terraform apply command will require that you explicitly approve of provisioning
the proposed AWS resources, by entering `yes` at the command line.

```bash
$ terraform init

$ terraform plan

$ terraform apply
```

The output generated from executing the `terraform apply` command above includes
two values that you need to take note of as they will be needed in a later step
of the deployment process. Take note of the values of `tf_build_role`,
`tf_lock_status_DDB`, and `tf_statefile_s3`. The `terraform apply` command
typically takes less than a minute to complete.

```bash
Apply Complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

tf_build_role = "arn:aws:iam::123456789012:role/Demo-TF-Bootstrap-Rol"

tf_lock_status_DDB = "Demo-Terraform-Lock-Status-DDB"

tf_statefile_s3 = "demo-terraform-statefile-12346789012-s3b"
```

**Related Links:**

- [Terraform Remote State](https://www.terraform.io/docs/language/state/remote.html)
- [Operations with Remote Terraform State](https://www.terraform.io/docs/language/state/backends.html)

## Step Two - Provisioning AWS Resources in AWS Target Account

You must successfully complete Step One before you can successfully execute step
two of the SW Factory Platform deployment process. Step Two provisions the
complete set of AWS resources required by the platform (i.e., 350+ AWS
resources.) Navigate to the `tf-landing-zone` directory. Prior to executing the
Terraform commands necessary to provision this infrastructure, you will need to
edit two files in this directory: `tf-landing-zone/main.tf` and
`tf-landing-zone/terraform.tfvars`.

**Editing the main.tf File**

Edit the `tf-landing-zone/main.tf` file as directed by this section

- Set `region` to the region that you will deploy the platform into
- Set `profile` to an AWS CLI profile on your workstation that has both access
  to and sufficient permission levels in the target AWS account
- Set `dynamodb_table` to the name of the DynamoDB table that was provisioned in
  Step One. This name was output to the command line after executing the
  `terraform apply` command
- Set `bucket` to the name of the S3 bucket that was provisioned in Step One.
  This name was output to the command line after executing the `terraform apply`
  command

Here is an example. Note, that only a portion of the `main.tf` file is shown
below.

```go
# Configure Terraform
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    region         = "us-east-1"
    profile        = "demo"
    dynamodb_table = "Demo-Terraform-Lock-Status-DDB"
    bucket = "demo-terraform-statefile-123456789012-s3b"

    # Do not change the name below
    key = "tf-landing-zone.tfstate"
  }
}
```

**Related Links:**

- [Terraform S3 Backend](https://www.terraform.io/docs/language/settings/backends/s3.html)

**Deloitte Considerations:**

If you are deploying the SW Factory Platform into an AWS account under control
of Deloitte OneCloud, you will have to maintain the `ignore_tags` block within
the `tf-landing-zone/main.tf` file. OneCloud automatically applies resource tags
to all resources created within AWS accounts under its control. In cases where a
Terraform deployment script supplies the same tag, OneCloud will over write the
value supplied by the script. When Terraform refreshes the state of a resource
that it manages, it will consider net-new tags or tags with unexpected values as
"resource configuration drift." To help address some of the issues introduced by
the mandatory resource tags applied by OneCloud, you must maintain a list of AWS
resource tags, in the `ignore_tags` block, that you would like Terraform to
ignore (i.e., not delete.) Unfortunately, the number of these tags, as well as
the name of any given tag, can change over time. Therefore, the `ignore_tags`
block is something that requires ongoing attention from you. You must add tags
to the block when OneCloud begins using a new tag and you must both add the tag
to the block and begin using a new tag name in the Terraform scripts when
OneCloud begins using one of the tags used in the Terraform scripts.

**Editing the terraform.tfvars File**

Edit the `tf-landing-zone/terraform.tfvars` file as directed by this section. In
most cases, edits to this file should be limited to:

- Setting the values of a subset of keys in the `Project Configurations` section
- Making a decision on the `DEV USAGE` section
  - For production deployments, delete the section (i.e., two header comment
    lines and six terraform statements)
  - For non production deployments, you can leave the section (i.e., two header
    comment lines and six terraform statements) in tact for increased efficiency
    / convenience
- Setting the value for the `policy_name` key for the `vault` server
  configuration within the `Server Configuration` section (see "Manual Steps and
  Manual Edits" section above.)
- Setting the value for the `ami_name` key for the `vpn` server configuration
  within the `Server Configuration` section (see "Manual Steps and Manual Edits"
  section above.)
- Setting the value of the `public_key` key within the "Initial Configuration
  Public Key" section (see "Manual Steps and Manual Edits" section above)

Before you make any edits to this file, other than those listed above, ensure
that you are an experience AWS Architect, reasonably experienced with Terraform,
and that you fully understand the ramifications of your edits.

**"Project Configurations" section details:**

- Set `project_name` to the overall project name that you decided on earlier in
  the "Manual Steps and Manual Edits" section of this document
- Set `region` to the region that you will deploy the platform into
- Set `profile` to an AWS CLI profile on your workstation that has both access
  to and sufficient permission levels in the target AWS account
- Set `build_role` to the name of the role that was provisioned in Step One.
  This name was output to the command line after executing the `terraform apply`
  command
- Set `apex_domain` to the Route 53 hosted public DNS domain that you obtained
  for exclusive use by this deployment of the SW Factory Platform
- Do not modify the remaining three settings unless you are experienced with
  Terraform, AWS networking, and you that you account for all of the places
  within `terraform.tfvars` that you must update to accommodate the change you
  are making
  - The `alb_vpc` key holds the name of the VPC that the Application Load
    Balancer will reside in
  - The `alb_subnet_name` key holds the name of the subnet the Application Load
    Balancer will reside in
  - The `alb_cidr_block`s key holds the range of origination IP addresses that
    the Application Load Balancer will accept requests from

Example code, assuming that you registered the public hosted domain `demo.com`
for exclusive use of the SW Factory Platform deployment.

> Note that only a portion of the terraform.tfvars file is shown below.

```go
# Project Configurations
project_name    = "Demo"
region          = "us-east-1"
profile         = "demo"
build_role      = "arn:aws:iam::123456789012:role/Demo-TF-Bootstrap-Rol"
apex_domain     = "demo.com"
alb_vpc         = "Network"
alb_subnet_name = "public"
alb_cidr_blocks = [
  "0.0.0.0/0"
]
```

**"DEV USAGE" section details:**

When deploying a SW Factory Platform for non production purposes, the ability to
create / destroy the entire platform with single Terraform command is both
efficient and convenient. For production deployment of a SW Factory Platform,
the negative impact of accidentally deleting the complete platform with a single
command warrants the introduction of safe guards. By leaving the six terraform
commands in the DEV USAGE section in place, you will be able to bring up / tear
down the complete platform using a single Terraform command. Therefore, for
production deployments of the platform, ensure that you comment out or
completely remove this section.

**"Server Configuration" section details:**

There are two file edits required for this section. These edits should have been
already performed while you followed the guidance provided by the "Manual Steps
and Manual Edits" section above.

The first edit provided the AMI name for the OpenVPN Access server (i.e., `vpn`
server in the `Server Configurations` section.)

The second edit involved a security key for the Vault server. An AWS IAM Policy
is assigned to the EC2 instance, during initial configuration, that will host
the HashiCorp Vault software. This policy grants the server use of an AWS KMS
key that enables the Vault server to boot into an "unsealed" state. Without this
IAM Policy in place on the server it would be necessary to manually "unseal" the
Vault server, with a security key, each time the server was booted. This edit
involved setting the value of `policy_names` in the `vault` server section of
the `Server Configurations` section.

**"Initial Configuration Public Key" section details:**

Following guidance provided in the "Manual Steps and Manual Edits" section
above, you executed a makefile or PowerShell script to generate a PEM key pair.
You then edited the `app-config/inventory.ini` file and the
`tf-landing-zone/terraform.tfvars` file using results generated by executing the
makefile / script. When the Terraform scripts for Step Two of the SW Factory
Platform deployment process are executed, all EC2 instances created receive the
public key from the PEM key pair. Step three of the deployment process uses the
private key from the key pair, located in the `pemkey` directory on your
workstation, to facilitate remote access that enables software installation and
configuration by Ansible.

**Deloitte Considerations:**

If you are deploying the SW Factory Platform into an AWS account under OneCloud
control, you will not be able to specify the IP origination CIDR block of
`0.0.0.0/0`, except for ingress traffic flowing over port `80` or port `443`.
For ingress traffic flowing over port `22`, you must specify an IP origination
CIDR block that is owned by Deloitte. You will therefore have to be connected to
DeloitteVPN in order to SSH into the Bastion server contained within your SW
Factory Platform deployment.

Within the "Server Configurations" section locate the `Bastion` server within
the `ec2_servers` block. Inside the Bastion server's configuration block locate
the `cidr_blocks` key located in the `ssh` block that resides in the `ingress`
block.

- For deployments into an AWS account under the control of OneCloud ensure that
  the `cidr_blocks` key is set to `["167.219.0.140/32","167.219.88.140/32"]`

- For deployments into an AWS account not under control of OneCloud set the
  cidr_blocks key to `["0.0.0.0/0"]` or more restrictive list of CIDR blocks as
  is appropriate for your situation.

**Master DB Password:**

Some aspects of the SW Factory Platform deployment have yet to be automated. At
this time, take the following action for one such element.

1. Create a new file inside the `tf-landing-zone` directory and name it
   `password.auto.tfvars`

2. Within this file add the line below in which which you replace
   `<USER_PASSWORD>` with the master database password that you will use for the
   platform's RDS instance.

_`<USER_PASSWORD>` must be at least 8 characters_

```go
master_db_password = "<USER_PASSWORD>"
```

**Executing Terraform Commands**

After properly configuring the `tf-landing-zone/main.t`f and
`tf-landing-zone/terraform.tfvars` files, and saving the configuration changes,
execute the following Terraform commands in the `tf-landing-zone` folder, doing
so in order. The `terraform plan` command is optional. These commands will
provision the complete set of AWS resources required by the platform (i.e., 375+
AWS resources.)

Executing each command will produce several lines of output. Within the output
generated from executing the `terraform init` command, look for a
`Successfully configured the backend "s3"! Terraform will automatically use this backend unless the backend configuration changes.`
message and a `Terraform has been successfully initialized!` message. Within the
output generated from executing the `terraform plan` command, look for a
`Plan: 365 to add, 0 to change, 0 to destroy.` message. Note that the number of
<<<<<<< HEAD resources will vary and that the `terraform apply` command will
require that you explicitly approve the provisioning of the proposed AWS
resources, by entering `yes` at the command line. ======= <<<<<<< HEAD resources
will vary and that the `terraform apply` command will require that you
explicitly approve the provisioning of the proposed AWS resources, by entering
`yes` at the command line. ======= resources will vary and that the
`terraform apply` command will require that you explicitly approve the
provisioning of the proposed AWS resources, by entering `yes` at the command
line.

> > > > > > > main main

```bash
$ terraform init

$ terraform plan

$ terraform apply
```

You can expect the provisioning of these AWS resources to take something in the
order of 20 - 45 minutes. Once the AWS resources are provisioned they are under
control of Terraform. Do not make configuration changes to them, except through
Terraform commands. Making configuration changes directly, without using
Terraform commands, can introduce issues that might prove difficult to resolve.

**Related Links:**

- [Terraform Commands Overview](https://www.terraform.io/docs/cli/commands/index.html),
- [Handling Drift with Terraform](https://www.hashicorp.com/blog/detecting-and-managing-drift-with-terraform)

## Step Three - Configuring Software Factory Platform's Servers

The third step, and final step, in the SW Factory Platform deployment process
will install and configure software on the platform servers provisioned by
step 2. This is achieved by executing an Ansible command on your local
workstation that connects to the platform's servers via the platform's `Bastion`
server. The `Bastion server` is located in a publicly accessible subnet in one
of the platform's VPCs.

If you are a Deloitte employee ensure that you are connected to Deloitte VPN
before executing this command. If you are having issues with this command ensure
that you are connected to https://vpn.deloittenet.com/all (i.e., ensure the vpn
server setting: `n.vpn.deloittenet.com/all`).

If you are using a Windows workstation to deploy the SW Factory Platform, you
will need to execute the Ansible command below from a Linux prompt provided
WSL2. You can refer to the Deployment "Guidance / Preliminary Step / Workstation
Setup" section in this document for more information regarding WSL2.

Before executing the Ansible command you will need to retrieve the Id of an AWS
KMS key that was provisioned by Step Two of the deployment process. In a command
line prompt navigate to the `tf-landing-zone` directory located in the root
directory of the Deployment Bundle. This is the directory that you used to issue
Terraform commands in Step Two of the deployment process. Execute the following
command and copy the value that is displayed for the key named `id` into your
workstation clipboard.

```bash
$ terraform state show aws_kms_key.vault_kms
id = "abcdefgh-1234-5678-1234-abcdefghijkl"
```

Navigate to the `app-config` directory located in the root directory of the
Deployment Bundle and edit the inventory.ini file. Within the `[all:vars]`
section of this file locate the `vault_key_id` key and set its value to the key
id that you copied into your workstation's buffer in the previous step.
Additionally, set the value of the `sonarqube_version` key to the latest
community version available. You can source SonarQube release information
[here](https://binaries.sonarsource.com/Distribution/sonarqube/). A long term
support (LTS) release is recommended.

Example (only showing the `[all:vars]` section of the `inventory.ini` file).
Note that only a portion of the `inventory.ini` file is shown below.

```ini
[all:vars]
aws_region='us-east-1'
vault_key_id='abcdefgh-1234-5678-1234-abcdefghijkl'
sonarqube_version='8.9.1.44547'
ansible_user='ec2-user'
ansible_ssh_private_key_file='../pemkeys/Demo.pem'
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o
ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q -i
../pemkeys/demo.pem ec2-user@bastion.demo.com"'

; ansible_ssh_common_args=\'-o StrictHostKeyChecking=no\'
```

Now with all of the preparation complete for step three, you can execute the
Ansible command that will run all of the individual Ansible playbooks to install
and configure software on the servers contained in the SW Factory Platform.
Navigate to the `app-config` directory located in the root directory and execute
the Ansible command from this directory. As the command is involved, the
following explanation and guidance is provided:

- Ensure that you execute this command from a Linux prompt in the `app-config`
  directory.
- The command executes a single playbook, named `install-all.yml` that will in
  turn execute each of the individual playbooks that are specialized per server
- Retrieve the two passwords that you generated following guidance in the
  "Manual Steps and Manual Edits" section above.
  - Use one password as the value of the command line argument `ds_pwd`
  - Use the other password as the value for the command line argument
    `admin_pwd`
- Expect this command to run somewhere in the neighborhood of 20 - 45 minutes.
  If most of the servers require updates/patches before software
  installation/configuration you will see a longer execution time for this
  command.

<<<<<<< HEAD _Make sure the entire command entered within 1 line in your
terminal AFTER changing password strings_

=======

> > > > > > > main

```bash
ansible-playbook -i inventory.ini install-all.yml
-e="@../passwords/password.json"
```

**Related Links:**

- [Vault Auto-Unseal](https://learn.hashicorp.com/tutorials/vault/autounseal-aws-kms)
- [Ansible - How to build your inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)

## Initial Configuration of the OpenVPN Access Server

Initial configuration of the OpenVPN Access Server is not performed in step
three of the SW Factory Platform deployment process because it requires manual
configuration and user EULA (End User License Agreement) input. Complete the
following configuration steps in order.

**SSH to the Server Hosting OpenVPN Access Server**

Using the SSH tool of your choice, connect to the OpenVPN Access server with the
user name `openvpnas`. Connect using the URL for the OpenVPN Access server that
was defined in Step Two of the deployment process. For example, if the public
DNS name registered for the SW Factory deployment is `demo` then you would use
the URI `vpn.demo.com` (e.g., `openvpnas@vpn.demo.com`). Ensure that the SSH
tool is configured with the location of the private key from the asymmetric key
pair that was created during the platform's preliminary step of the deployment
process. If you are using an SSH command within a shell, ensure that you specify
the location of the private key (e.g.,
`ssh -i <path-to-pemkey> openvpnas@vpn.demo.com`). During Step Two of the
deployment process, the public key from this asymmetric key pair was placed on
the EC2 instance running the OpenVPN Access software.

Upon the initial SSH session to the OpenVPN Access server you will need to
accept the EULA and then provide initial configuration input. In all but one
instance, use the supplied default value for the initial configuration options.

- `Will this be the primary Access Server node?` YES, the default
- `Please specify the network interface and IP address to be used by the Admin Web UI:`
  1, the default
- `Please specify the TCP port number for the Admin Web UI.` **443 this is NOT
  the default**
- `Please specify the TCP port number for the OpenVPN Daemon.` 443, the default
- `Should client traffic be routed by default through the VPN?` NO, the default
- `Should client DNS traffic be routed by default through the VPN?` NO, the
  default
- `Use local authentication via internal DB?` YES, the default
- `Private subnets detected: ['172.20.0.0/20']. Should private subnets be accessible to clients by default?`
  YES, the default
- `Do you wish to login to the Admin UI as "openvpn"?` YES, the default
- `Please specify your Activation key (or leave blank to specify later):` blank,
  the default

After supplying all the required configuration settings, as prescribed above,
20+ lines of output will display indicating progress through various
initialization activities. Towards the very end of this output you will see a
section that begins with
`During normal operations, OpenVPN AS can be accessed via these URLs:` Take note
of the URL for the `Admin UI`. Before exiting this SSH session set the password
for the user id that will be used to log into the OpenVPN Access Server Admin
UI; that is, set the password for the user `openvpn`. Enter the following
command supplying the value that is assigned to admin_pwd, which is one of the
two random passwords created in the preliminary step of the SW Factory Platform
deployment process.

`sudo passwd openvpn`

`Enter new UNIX password:` supply the value of admin_pwd

**Tips:**

- If you are experiencing difficulties with cut and paste operations into your
  SSH tool or command shell, try a right mouse click immediately following the
  failed paste key sequence.
- If you are a Deloitte employee you will need to be connected to Deloitte VPN
  for this to work; the origination IP address for any ingress traffic the the
  SW Factory Platform, with the exception of port 80 and port 443, must be from
  an Deloitte owned CIDR range. If you are still having issues ensure that you
  are connected to https://vpn.deloittenet.com/all (i.e., server:
  n.vpn.deloittenet.com/all).
- If you are pasting in an OS shell generated by using Putty neither the control
  V paste nor the right mouse click will produce any visible character display;
  it works but you get no visual feedback. However, using the control V + right
  mouse click sequence twice and getting a "password successfully set" message
  is an indication that the cut and paste operation worked.

**HTTP to the OpenVPN Access Server Admin Web UI**

Using the web browser of your choice, access the OpenVPN Access Admin Web UI
using the URL, displayed in
`During normal operations, OpenVPN AS can be accessed via these URLs:`section,
that you noted during the initial SSH session. To gain access supply the user
name `openvpn` and for the password supply the `admin_pwd`, which was one of the
two random passwords created in the preliminary step of the SW Factory Platform
deployment process. Ensure that you use the same password value that you did
when you issued the command `sudo passwd openvpn` during the initial SSH session
to set the password for the `openvpn` user.

After accepting the EULA, select `Network Settings` in the `Configuration`
section of the navigation pane on the left-hand side of the page. On the
resulting page, in the input field labeled `Hostname or IP Address:` replace the
hard IP address listed with the URI set up for the OpenVPN Access server in step
two of the SW Factory Platform's deployment process. For example, if the public
DNS name registered for the SW Factory deployment is demo then you would replace
the hard IP address with `vpn.demo.com`.

In the VPN Settings, change the private subnet CIDR range from `172.20.0.0/20`
to `172.20.0.0/16` under Routing so the VPN can access all other services in the
WAN. Then under DNS Settings, change the setting, "Have Clients use the same DNS
servers as the Access Server Host" to `Yes`.

Create a user profile in user management, login through the user UI at
`vpn.demo.com`, and download both OpenVPN client and the User Profile file.
Import the User Profile and connect to the OpenVPN server host. All private
instances should now be available through their domain name.

**Tips:**

- If you are a Deloitte employee
  - Ensure that you are not connected to Deloitte VPN.
  - Your attempt to access the OpenVPN Access Admin Web UI via its URL might be
    blocked by Deloitte Cyber Security because the URL contains `vpn`. To get
    around this use the hard IP address of the server (e.g.,
    `https://123.123.123.123/admin`)
- If a digital certificate has not yet been installed on the EC2 instance
  hosting the OpenVPN Access Server
  - Your browser will raise a security warning (i.e.,
    `NET::ERR_CERT_AUTHORITY_INVALID`)
  - Simply proceed through with access of the web page by clicking on the
    Advanced button and then the `Proceed to 123.123.123.123 (unsafe)` link.
- Changing from the hard IP address to the URI can destabilize the connection to
  the server that you are currently using (i.e., to make the change itself.) You
  may need to reconnect to the server again.

## Wrap Up

If you will not be directly responsible for operational administration of this
SW Factory Platform deployment, ensure suitable transition to the resource(s)
that will provide operational administration.

- Ensure that the resource(s) has access to the target AWS account that the
  platform was deployed into. As administration activity spans several AWS
  service the AWS managed IAM policy named
  `AdministratorAccess arn:aws:iam::aws:policy/AdministratorAccess` is
  recommended.
- Ensure that the resource(s) has access to the OpenVPN Access Server
  - For now, access the OpenVPN Access Server Web UI and manually add the
    resource(s)
  - Future
    - If a group does not exist in IdM that grants access to the OpenVPN Access
      Server, add the group
    - If the resource(s) does not exist on the IdM server, create a user /
      identity for the resource(s)
    - Add the resource(s) to the group that grants access to the OpenVPN Access
      Server

# UnDeploy / ReDeploy Guidance

You may find the need to undeploy a SW Factory Platform deployment and perhaps
redeploy it. To that end, this section provides guidance and practical advice.

The automated deployment of the SW Factory Platform involves the auto generation
of names for AWS resources. By design, most autogenerated names do not
incorporate random values. Therefore, for a given "overall project" the same
name will be assigned to a specific resources across deployments. This will
cause no issue for the first deployment of the SW Factory Platform into an AWS
account. However, name collisions are possible for the second (and subsequent)
deployments of the SW Factory Platform for a given application name into a
single AWS account. In general, when a name collision prevents the successful
execution of a `terraform apply` command, delete / remove the pre existing AWS
resource with the name.

## Undeploy

If you want to undeploy the entire SW Factory Platform, undeploy the Step Two
AWS Resources first and only undeploy Step One AWS Resources after a complete,
successful undeployment of Step Two AWS Resources. If you want to undeploy Step
Two AWS Resources and then redeploy them, it possible to possible reuse all
existing Step One AWS Resources "as is."

### Resources Outside of Terraform Control

- Public Domain

  - You are charged monthly/annual for public DNS Domain registration
  - If your intention is to terminate / shutdown an AWS account to which you
    deployed a SW Factory Platform, consider the public DNS Domain registration
    - If the hosted zone records exist in Route 53, within the AWS account you
      are terminating, consider transferring the hosting of the records to
      another location (e.g., another AWS account, a DNS domain registrar other
      than AWS) while the AWS account is still active.
    - Transferring the hosting of records will be easier while the AWS account
      is still active

- OpenVPN Access Server subscription from AWS Marketplace may involve cost.

### Step One AWS Resources

- Tips:
  - Value of `Name` tag for AWS resources
    - Any resource with `Name` tag value that is prefixed by "DCS" was
      provisioned by Deloitte Cyber Security
    - All resources provisioned during the deployment of a SW Factory Platform
      will have a prefix of the "overall project" name that you specified when
      deploying
  - After provisioning Step One AWS resources successfully you can leave them in
    place to support multiple deployments / redeployments of Step Two AWS
    resources
- To undeploy Step One AWS resources
  - navigate to the directory `tf-backend-setup` and issue `terraform destroy`
  - Manual steps
    - Deleting the S3 bucket that holds the Terraform state file for Step Two of
      the SW Factory Platform deployment process
      - You will need to delete this bucket before running the terraform scripts
        in the `tf-backend-setup` folder a second or subsequent time. This is
        because the deployment process uses the same name for the bucket (i.e.,
        `<overall project name>-terraform-statefile-123456789012-s3b` [note the
        embedded AWS account number]) every time.
      - Unless you have preemptively emptied this bucket, the
        `terraform destroy` command will not be able to delete the bucket. If
        necessary, empty the bucket and rerun the terraform destroy command.
      - Object versioning is enabled for the bucket. While viewing the bucket's
        contents in the AWS Console ensure that the `Show versions` toggle
        button is engaged so that you can see all of the bucket's objects
  - Undeploying Step One AWS Resources typically takes a couple of minutes.

### Step Two AWS Resources

- Tips:
  - Value of `Name` tag for AWS resources
    - Any resource with `Name` tag value that is prefixed by "DCS" was
      provisioned by Deloitte Cyber Security
    - All resources provisioned during the deployment of a SW Factory Platform
      will have a prefix of the "overall project" name that you specified when
      deploying
  - If your intent is to redeploy the entire SW Factory Platform, you will need
    to perform a `terraform destroy` on Step Two AWS resources. However, it is
    not necessary to do the same for Step One AWS resources; you can either
    reuse preexisting Step One resources or destroy them and create them again.
- To undeploy Step Two AWS resources navigate to the directory:
  `tf-landing-zone` and issue a `terraform destroy`. This command usually takes
  20 minutes but can take longer if you have to assist with taking manual steps
  to assist the command.
- Things to note
  - KMS keys will be scheduled for deletion in one months time. The `Alias`
    created for each key should be removed/destroyed by the `terraform destroy`
    command. Because a set value is used for a given key's `Alias`, across all
    deployments, you will need to manually intervene in cases where a key's
    `Alias` is not successfully removed/destroyed by the `terraform destroy`
    command. To do so, simply access the key in question and remove the `Alias`.
    This frees up the value that the `Alias` was set to so that the value can be
    reused for a new key's `Alias` in a subsequent deployment.
  - RDS snapshots, generated during the deletion of RDS instances, are left in
    place within the RDS service.
    - You decide what to do with them
    - You will run into a name collision error on your `terraform destroy`
      command on the second time you undeploy Step Two AWS resources unless you
      rename or delete preexisting RDS snapshots.
  - For Deloitte employees launching into an AWS account controlled by OneCloud:
    occasionally, executing a `terraform destroy` command on a SW Factory
    Platform deployed in an AWS account under Deloitte OneCloud will result in a
    condition that requires manual intervention to clear up
    - Issue you can resolve without opening an AWS support ticket
      - The `terraform destroy` command will not be able to delete a number of
        resources (typically VPC subnets)
        - The command will eventually time out (e.g., 20 minutes.)
        - These are VPC subnets that contain Network Interfaces that were placed
          there by OneCloud. These Network Interfaces were not provisioned by
          the Terraform scripts that deploy the platform. Since Terraform did
          not provision them is unaware of then and only knows that it is
          blocked from deleting a subnet that contains the Network Interfaces.
        - You will need to access the VPC section of the AWS Console and click
          on `Endpoints` in the left-hand, navigation pane. Delete all of the
          Endpoints that were provisioned by OneCloud (i.e., the value for their
          `Name` tag will start with `DSC-`). You can recognize these as the
          value of the Name tag will be blank and they will be associated with
          the subnets that Terraform cannot destroy
        - After you have ensured that the delete action on all of the Endpoints
          has successfully processed, issue a `terraform destroy` command again
          to delete the subnets. This command will get past the subnet deletions
          but will hang up on some of the VPCs.
        - Using the VPC section of the AWS Console, manually delete all of these
          VPCs and issue the terraform destroy command again to finish off the
          tear down of the AWS resources that support the deployment.
      - The `terraform destroy` command will not be able to complete if
        preexisting RDS snapshots exist from prior `terraform destroy`
        executions.
        - The RDS instance provisioned by the SW Factory Platform is configured
          to generate a snapshot when it is destroyed. For a given overall
          project name, in a single AWS account, the same RDS snapshot name will
          be time and time again.
        - You will need to delete or rename any preexisting RDS snapshots in
          order for a second, and subsequent, `terraform destroy` commands to
          succeed.
      - The `terraform destroy` will not be able to delete an IAM policy that is
        provisions in order to access the Vault server. The error occurs because
        the IAM policy is still referenced by an IAM provisioned by the SW
        Factory Platform deployment. The IAM policy is named:
        `<overall project name>-KMS-Vault-Pol`. The IAM role is named:
        `<overall project name>-vault-Rol`. Delete the IAM Role and then delete
        the IAM policy.
    - Issue that will require you to open an AWS support ticket to resolve
      - On occasion, a `terraform destroy` command will result in orphaned
        Network Interfaces. These are Network Interfaces that are tied to a VPC
        Endpoint that no longer exists (yet the supporting Network Interface
        remains.)
      - You can detect these orphans by using the EC2 portion of the AWS Console
        and examine the value of the Description column to detect what resource
        each Network Interface supports. You will need to check the Endpoints
        section of the VPC Section of the AWS Console to determine if an
        Endpoint exists or not.
      - You will need to open a support request ticket with AWS requesting the
        removal of all orphaned Network Interfaces.

### Step Three Configurations

Undeploy Step 2 AWS Resources takes care of removing all Step 3 software
installations and configurations.

## ReDeploy

The deployment process documented in this guide is organized into a preliminary
step followed by three steps. For a given overall project name, redeployment of
a SW Factory Platform into a single AWS account does not require that you to
repeat the preliminary step. While you may choose to repeat the preliminary step
(e.g., generate a different symmetric key pair), this is not necessary. It is
possible to reuse the AWS resources provisioned from a previous SW Factory
Platform deployment in a subsequent deployment.

### Step One

You need to ensure that you deleted the S3 bucket used to house the Terraform
state file for Step Two of the SW Factory Platform deployment process

You will want to ensure that you deleted all AWS resources that were provisioned
by any prior deployments of the SW Factory Platform

- The value of the `Name` tag of AWS resources provisioned by a deployment of
  the SW Factory Platform will be prefixed by the overall project name that was
  used for the deployment.

- You may have issued the following command before and after the deployment of
  the platform. This can help you determine how to ensure that all AWS resources
  provisioned by a prior deployment of the platform have been cleaned up.
  However, this technique may have limited value if you are not working with an
  AWS account that is dedicated to the SW Factory Platform deployment. Use of
  the command requires that the AWS Config service has been enabled on the AWS
  account. Issue the command before you deploy and then after you deploy. Take
  note of the output of both commands in order to track the AWS resources
  provisioned in support of the SW Factory Platform.

```bash
aws configservice get-discovered-resource-counts --profile <AWS CLI profile> --output table --region <region>
```

Always issue the `terraform init` command as the first action of a deployment /
redeployment.

For a given overall project name, on the second and subsequent deployment of the
SW Factory Platform into the same AWS Account, you may run into redeployment
issues that stem from orphaned AWS resources that were not cleaned up by the
`terraform destroy` command. Most of these types of issues will manifest as a
name collision error because the automated SW Factory Platform deployment
processes uses / reuses the same name for the same resource across all
deployments. The value assigned to the `Name` tag of all provisioned AWS
resources is prefixed by the overall project name that you designated (e.g.,
`\<overall project name\>-\<resource type\>`, for example foo-KMS-Vault_Pol).
Name collision errors generally show up as an error for the terraform apply
command:
`Error: error create <AWS Resources type (resource name)>: EntityAlready Exists:... For example, Error: error creating IAM Role (foo-elk-Rol): EntityAlreadyExists: Role with name foo-elk-Rol already exists`.

### Step Two

Always issue a `terraform init` command as the first step of any deployment /
undeployment. command.

Follow the instructions of this guide which eventually get to issuing the
`terraform apply` command.

### Step Three

- Redeploy software to a single server
  - Mutable Server - run play book to remove, run play book to install /
    configure
  - Immutable Server - isolate the EC2 server hosting the software. Terminate
    it. Run the `terraform apply` command in the tf-landing-zone directory
