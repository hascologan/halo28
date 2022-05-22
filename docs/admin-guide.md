# Admin Guide

- [Admin Guide](#admin-guide)
  - [Overview of SW Factory](#overview-of-sw-factory)
    - [Overview of SW Factory Platform](#overview-of-sw-factory-platform)
  - [Standard Terminology](#standard-terminology)
    - [Application Related](#application-related)
    - [Individual Related](#individual-related)
  - [Prerequisites & Overview](#prerequisites--overview)
    - [Role of the System Administrator](#role-of-the-system-administrator)
    - [System Administrator’s Skill Level](#system-administrators-skill-level)
    - [System Administrator’s Workstation Configuration](#system-administrators-workstation-configuration)
  - [Platform’s Major Components](#platforms-major-components)
    - [Platform Applications](#platform-applications)
      - [General Platform Applications](#general-platform-applications)
      - [AWS Services](#aws-services)
  - [Individuals that Interact with the Platform](#individuals-that-interact-with-the-platform)
    - [Application Developer](#application-developer)
    - [Application User](#application-user)
    - [AWS Account Owner](#aws-account-owner)
    - [AWS Account Administrator](#aws-account-administrator)
    - [System Administrator](#system-administrator)
    - [Cloud Architect / Cloud Engineer](#cloud-architect--cloud-engineer)
  - [SW Factory Platform Security](#sw-factory-platform-security)
    - [Overview](#overview)
  - [Accessing the SW Factory Platform’s Infrastructure Components](#accessing-the-sw-factory-platforms-infrastructure-components)
    - [AWS AD SSO Plugin](#aws-ad-sso-plugin)
      - [Installing the Plugin](#installing-the-plugin)
      - [Using The Plugin](#using-the-plugin)
        - [Windows 10 Tips](#windows-10-tips)
        - [Mac/Linux Specific Tips](#maclinux-specific-tips)
  - [Normal Operation](#normal-operation)
    - [System Generated Messages](#system-generated-messages)
    - [Backups](#backups)
      - [Platform Applications with Integrated Backup Functionality](#platform-applications-with-integrated-backup-functionality)
      - [Platform Applications without Integrated Backup Functionality](#platform-applications-without-integrated-backup-functionality)
    - [Aggregating System Logs and Metrics](#aggregating-system-logs-and-metrics)
      - [Metrics](#metrics)
      - [System Logs and ELK](#system-logs-and-elk)
        - [Filebeat](#filebeat)
      - [AWS System Logs and Metrics](#aws-system-logs-and-metrics)
        - [CloudTrail](#cloudtrail)
        - [System Logs with AWS CloudWatch](#system-logs-with-aws-cloudwatch)
        - [VPC Flow Logs](#vpc-flow-logs)
        - [Access Logs for Application Load Balancers (ALB)](#access-logs-for-application-load-balancers-alb)
        - [CloudWatch Events & Alerts](#cloudwatch-events--alerts)
    - [IaC & Configuration Administration](#iac--configuration-administration)
      - [Overview](#overview-1)
      - [Terraform](#terraform)
      - [Ansible](#ansible)
  - [Administrative Tasks](#administrative-tasks)
    - [OS Update/Patches, Application Updates, Security Patches](#os-updatepatches-application-updates-security-patches)
    - [Identity and Access Management](#identity-and-access-management)
    - [AWS Service Quotas](#aws-service-quotas)
    - [Rebooting Servers](#rebooting-servers)
  - [Abnormal Operations](#abnormal-operations)
    - [CloudWatch Alarms](#cloudwatch-alarms)
    - [ELK Alerts](#elk-alerts)

## Overview of SW Factory

The Software Factory is an outcomes-driven operating model designed to quickly
deliver secure, high-quality software that users want to use. Using leading-edge
technologies and innovations like automation, container orchestration,
infrastructure as code, robust security controls, and much more, the Software
Factory delivers the speed, effectiveness, and flexibility needed to tackle the
most pressing mission challenges in the world. In complete concert with this
pioneering approach, the Software Factory embraces the DevSecOps methodology – a
shift of operations from a static, reactive security posture, to a proactive,
agile, and continuously improving DevSecOps culture.

The Software Factory approach fosters collaboration, high-velocity delivery, and
risk reduction while improving outcome quality. Adherence to DevSecOps
principles drives the adoption of leading practices, including dependency
isolation, code separation, and concurrency, to enable synchronization between
the platform and applications at runtime. Depending on requirements, the CI/CD
toolset can be configured using a stack of technologies and industry standard
tools such as J-unit, HP Fortify, and SonarQube to automate components of unit
testing, functional testing, and stress testing to expedite deployment, remove
human error, and improve software quality.

The Software Factory also brings accelerators and seed projects designed to
integrate with container orchestration technologies in order to provide
scalability, agility, and fault tolerance. Building and institutionalizing a
more streamlined approach to the development and test integration cycle with
modern tools such as GitLab, SonarQube and Fortify, the Software Factory
platform offers a shortened and high-quality path to field critical mission
applications.

### Overview of SW Factory Platform

The Software Factory Platform is the pre-packaged landing zone that underpins
the Software Factory itself. It is the foundation upon which the Software
Factory sits, and the means by which the Software Factory performs its core
functionality. The Software Factory Platform conforms to industry best
practices, and is constantly being updated to the everchanging technical
ecosystem.

The Platform includes DevSecOps tools that provide a continuous integration and
continuous deployment (CI/CD) pipeline to reliably compile, build, test and
deploy code. The Platform embeds security, compliance, monitoring, and testing
into the build process to reduce risk while enhancing delivery speed and
recovery.

Leveraging the power of Terraform, Ansible and AWS, the Software Factory
Platform aims to be as easy to deploy as possible. Representing the Software
Factory’s core value of delivering more value faster, the Platform is
configurable under a “single pane of glass”. With minimal code changes and
setup, the Platform can be deployed into a single AWS account in a single region
in a matter of hours, replacing days of engineer hours with a robust and
repeatable automated process.

This document will prepare the user and outline the minimal steps necessary to
be successful in deploying this world-class platform.

## Standard Terminology

To increase the readability and the efficiency of this document, some common
terms will be replaced with more descriptive terms. Additionally, some common
terms will be given specific definitions. For example, as the term “application”
can often prove ambiguous within a technical discussion, it will be qualified as
either “deployed application” or “platform application” within this guide.
Standard terms will be bolded to visually alert the reader that the term's
definition should be referenced in one of the following tables.

### Application Related

| Term                 | Description                                                                                                                                                                                     |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Deployed Application | An application developed upon and deployed onto a SW Factory Platform.                                                                                                                          |
| Platform Application | A number of open source or commercial applications (e.g., HashiCorp Vault) that combine to form, along with a collection of AWS services and other technical components, a SW Factory Platform. |

### Individual Related

| Term                             | Description                                                                                                                             |
| -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Application Developer            | software developer who uses a SW Factory Platform to both develop and deploy a _Deployed Application_.                                  |
| Application User                 | End user of a _Deployed Application_.                                                                                                   |
| AWS Account Owner                | Individual possessing the IAM root account credentials for the AWS account the SW Factory Platform is deployed into.                    |
| AWS Account Administrator        | Individual with IAM credentials that has administrative access privileges for the AWS account the SW Factory Platform is deployed into. |
| Cloud Architect / Cloud Engineer | Technical resource that deploys and / or modifies a SW Factory Platform.                                                                |
| System Administrator             | SW Factory System Administrator; target audience for this document.                                                                     |

## Prerequisites & Overview

### Role of the System Administrator

The SW Factory Platform System Administrator will perform basic administrative
tasks, actively monitor the platform, and take appropriate action when anomalies
arise. Normal activities include:

- AWS
  - Limited to to AWS services and integrations that directly support the SW
    Factory Platform deployment
  - Does not extend to the broader AWS account concerns beyond the platform
    deployment
- IdM
  - Add / remove an identity to the IdM server
  - Add / remove / modify an identity’s access level to components
- Vault
  - Add / remove / modify roles that contain security credentials (e.g.,
    passwords / keys / access tokens)
  - Add / remove / modify roles. Roles provide access to passwords / keys /
    access tokens / etc.
- Manual Spot Checking (proactive, regular cadence)
  - Evidence of expected log / metrics processing (e.g., recent files of
    appropriate size)
  - Evidence of expected backup activity (e.g., recent files of appropriate
    size, backup success messages)
- Respond to automated alerts generated by the SW Factory Platform
  - Diagnose severity
  - Collect information
  - Engage Cloud Engineer / Cloud Architect

### System Administrator’s Skill Level

System Administrator of a SW Factory Platform deployment will possess basic
knowledge / experience in the following areas:

- AWS systems administration
- Application support
  - Operational support
  - Basic incident troubleshooting
  - Familiarity with containerization technologies
- Core AWS Services such as
  - Compute - EC2, EBS, EFS
  - Storage - EBS, EFS / FSx, S3, RDS
  - Networking - ALB, Route 53, WAF, VPC (e.g., NAT Gateway, VPC Endpoints, VPC
    Transit Gateways)
  - Security / Monitoring - IAM, CloudWatch

### System Administrator’s Workstation Configuration

System administration of a SW Factory Platform deployment will require a
properly configured workstation. Workstation preparation includes the
installation / configuration of two application packages and and the presence of
suitable AWS credentials.

- AWS CLI version 2.0 or newer
- VPN client
  - The OpenVPN client can be sourced here.
  - An individual (e.g., System Administrator, Cloud Architect / Cloud Engineer)
    possessing suitable access levels will need to create a new user on the
    deployed platform’s OpenVPN Access Server to enable access
- Workstation resident AWS security credentials that enable access to the target
  AWS account containing the deployment.
  - Options
    - Access key ID and secret access key of IAM user, with suitable access
      level
    - Access key id, secret access key, and token issued from IAM STS, with
      suitable access level
  - System administration work requires access to a variety of AWS services. The
    AWS managed IAM policy named AdministratorAccess
    arn:aws:iam::aws:policy/AdministratorAccess is recommended.

## Platform’s Major Components

The main function of the SW Factory Platform is to provide a vehicle for the
development and deployment of Deployed Applications. However, It is more useful,
from a system administration perspective, to conceive of the platform as
described in this section.

At a high level, the SW Factory Platform is comprised of a collection of
interoperating Platform Applications (e.g., RHEL IdM, HashiCorp Vault,
SonarQube, Jenkins) that are underpinned by AWS Infrastructure and other
components. A publicly accessible bastion server (i.e., hardened server
configured for SSH access) is included in the platform, but is not listed below.

### Platform Applications

#### General Platform Applications

Each of the following applications are hosted on a dedicated EC2 instance. All
EC2 instances are instrumented with both the SSM agent and the CloudWatch Logs
agent.

- Active Directory
  - Brokers SAML2 federated access to platform
  - NOTE: an upcoming, future addition to platform. Might take form as a managed
    service (i.e., AWS Directory Service) or a native install of AD on an EC2
    instance
- ELK (Elasticsearch, Logstash, Kibana)
  - Centrally collects and monitors / processes all of the logs and metrics
    across the entire SW Factory Platform deployment. Logs include: OS logs,
    individual AWS service logs, VPC Flow Logs, CloudTrail logs, ??Access
    Logs??, and ??results of backups??
  - The logs / metrics for the entire platform (i.e., Platform Applications,
    Deployed Applications, and AWS services) are stored and processed
- IdM
  - RHEL Identity Manager IdM (aka IPA)
  - Identity Management (i.e., user id and password authentication)
  - Access Management (i.e., defined access levels to Platform Applications
    using Vault to store security credentials)
- OpenVPN Access Server
  - Hardened publicly-accessible platform EC2 instance configured to support SSH
    connections
- Vault
  - HashiCorp’s Vault
  - Secure, store, and control security credentials (e.g., access tokens,
    passwords, certificates, encryption keys) and other sensitive information
  - Security roles organized into roles. Access management to Platform
    Applications managed by IdM
- Development Environment Platform Applications (i.e., supports Application
  Developers) _GitLab _ Web-based, DevOps lifecycle tool
  - Jenkins
    - Automates building, testing, and deployment of software
  - SonarQube
    - Continuous inspection of software code quality
  - Nexus
    - Artifact Hosting
  - OpenSCAP (Security Content Automation Protocol)
    - Discover, monitor, and address container vulnerabilities across entire
      container lifecycle
    - Leverages XCCDF (Extensible Configuration Checklist Description Format)

#### AWS Services

A SW Factory Platform deployment is supported by the configuration and
integration of several AWS Services.

- ACM (AWS Certificate Manager)
  - Host digital certificates
  - Certificates issued by AWS ACM support the public DNS Domain name dedicated
    to the Software Factory Platform deployment
- ALB (Application Load Balancer)
  - External load balancing of ingress traffic across the platform's resources
- EC2 (Elastic Cloud Compute)
  - Hosts a number of open source / commercial Platform Applications
  - All EC2 instances are instrumented with the SSM agent and the CloudWatch
    Logs agent
- KMS (Key Management Service)
  - Management of data encryption keys
- Route 53 (i.e., AWS DNS Service)
  - Registers and advertises public DNS domain name used by a SW Factory
    Platform deployment.
  - URIs defined for several of the platform’s servers enabling remote,
    browser-based access to Platform Applications.
  - Private DNS zone enabling URI, vs IP, access of platform’s VPCs
- S3 (Simple Storage Service)
  - Object storage for logs, backups, and more
- VPC (Virtual Private Cloud)
  - Two public subnets and four private subnets connected via single VPC Transit
    Gateway
  - VPC Endpoint Gateways employed (i.e., S3 connectivity)
  - Two NAT Gateways enables public Internet access for Platform Applications
    located in private subnets
- WAF (Web Application Firewall)
  - Firewall protection for the external ALB

## Individuals that Interact with the Platform

### Application Developer

Individual engaged in application development using a SW Factory Platform
deployment. The developed applications (i.e., _Deployed Applications_) are
deployed onto the same SW Factory Platform deployment used to develop them.

### Application User

End user of a _Deployed Application_; do not directly interact with the SW
Factory Platform deployment.

### AWS Account Owner

Individual possessing the IAM root account credentials for the AWS account the
SW Factory Platform is deployed into. Will most likely engage an _AWS Account
Administrator_ to provide stewardship of the AWS account. Will not necessarily
interact with the SW Factory Platform deployment.

### AWS Account Administrator

Individual with IAM credentials that has administrative access privileges for
the AWS account the SW Factory Platform is deployed into. Responsible for all
aspects of the AWS account (e.g., provisioning IAM users, detecting/resolving
AWS service quota issues, managing cost, etc.) The _AWS Account Owner_ and _AWS
Account Administrator_ may be one in the same. Will not necessarily interact
with the SW Factory Platform deployment.

### System Administrator

The target audience for this document is the individual(s) responsible for
normal, day-to-day administration of a SW Factory Platform deployment. The
_System Administrator(s)_ will engage a _Cloud Architect / Cloud Engineer_ for
trouble shooting of all but the most basic issues of anomalies.

### Cloud Architect / Cloud Engineer

Individual responsible for deploying and / or trouble shooting issues with a SW
Factory Platform deployment.

## SW Factory Platform Security

### Overview

The SW Factory Platform design follows all normative security industry best
practices.

The SW Factory Platform’s external security perimeter is minimized and hardened.
It includes a public Route 53 hosted zone, an external Application Load
Balancer, two NAT Gateways, an OpenVPN Access Server, and a bastion server.
Allowed ingress traffic is delivered by Route 53 to a Web Application Firewall,
configured per AWS best practice, that in turn hands traffic off to the external
Application Load Balancer.

All client web browser interaction with a SW Factory Platform deployment is
encrypted. During a platform deployment, a _Cloud Architect / Cloud Engineer_
will register, via Route 53, a DNS domain for the exclusive use of the platform.
Additionally, during the deployment process, the AWS Certificate Manager service
is used to provision digital certificates that are associated with the
platform’s external Application Load Balancer.

AWS security best practices are followed for individual AWS service
configurations as well as for AWS service-to-service integrations. This
includes, among many other things, the use of encryption keys, managed by KMS,
to encrypt data at rest.

Platform-internal data communications are kept within the private AWS network,
as opposed to introducing public Internet hops, by utilizing a VPC Transit
Gateway and VPC Endpoint Gateways.

All EC2 instances are instrumented with the SSM agent and the CloudWatch Logs
agent. All of the platform’s log messages and metrics are collected and
processed by the platform’s ELK server.

- Operating system logs, SSM agent logs, application logs, server metrics for
  _Platform Applications_, and _Deployed Applications_
- VPC Flow logs
- CloudTrail logs
- Individual AWS service logs (e.g., WAF)
- Additional logging available for certain AWS services (e.g., S3 access logs)
- Success / failure logs for backups (i.e., AWS services, _Platform
  Applications_)

Implementing secure _Application User_ access to a _Deployed Application_ falls
within the purvey of the _Application Developer_, and is not addressed by the
_System Administrator_.

Managing secure access to _Platform Applications_, on an individual by
individual basis, is one of the _System Administrator’s_ normal duties. To
support this, the platform contains a RHEL IdM server (for authentication /
authorization) and a HashiCorp Vault server (for managing security credentials
and other sensitive data.)

The bastion server’s only use occurs during the third step of the SW Factory
Platform’s deployment process. In this step, a _Cloud Architect / Cloud
Engineer_ executes Ansible commands on a workstation to install and to configure
software on each of the platform’s EC2 servers. Remotely configuring the EC2
servers is made possible by use of an asymmetric key pair and the bastion
server. During step two of the deployment process, an asymmetric key pair is
generated on the _Cloud Architect’s / Cloud Engineer’s_ workstation and the
public key from this pair is placed on each of the EC2 servers. With the private
key on the Cloud Architect’s / Cloud Engineer’s workstation and the presence of
the bastion server in a public subnet of the platform’s network, the _Cloud
Architect / Cloud Engineer_ can remotely install and configure software onto
each of the platform’s EC2 servers.

## Accessing the SW Factory Platform’s Infrastructure Components

A SW Factory Platform can be deployed into any single AWS account. Determining
the requirements for accessing a platform’s infrastructure components (i.e.,
contained within an AWS account) requires consideration of generic factors,
applicable across any given AWS account, as well as factors that only apply to
AWS accounts under the control of Deloitte OneCloud.

For AWS accounts not controlled by Deloitte OneCloud, a platform’s
infrastructure can be freely accessed using the AWS Console, the AWS CLI, and a
variety of programming language SDKs.

To simplify the remainder of this explanation, AWS accounts controlled by
Deloitte OneCloud will be classified as either “personal sandbox” AWS accounts
or as “long-lived” AWS accounts. Both account types require that Deloitte
employees use the Deloitte’s
[Azure AD Access Model](https://resources.deloitte.com/sites/MyTech-Global/Documents_New/Business_of_IT/OneCloud/AWS-Azure-AD-Access-Model.pdf)
to gain access. The model embodies a process that all Deloitte employees must
follow in order to gain access to an AWS account under the control of Deloitte
OneCloud. This process contains a required action - use of the MAC
[(Modern Access Control Tool)](https://mac.us.deloitte.com/) to request elevated
security credentials for the AWS account. A successfully processed request
returns the elevated security credentials, to the requestor, that must be used
in order to access the AWS account under control of Deloitte OneCloud.

After obtaining elevated security credentials, the AWS Console can be used to
access an AWS account under OneCloud control. This is true for both sandbox
accounts and long-lived accounts. For sandbox accounts alone, an IAM user can be
provisioned in order to make available an access key id and secret access key.
These credentials can then be configured onto a workstation to enable AWS CLI
access as well as programming language SDK access to the AWS account. IAM users
cannot be created within a long-lived account. However, AWS CLI and programming
language SDK access is still possible for long-lived accounts via the Deloitte
[AWS Azure AD SSO Plugin](https://resources.deloitte.com/sites/MyTech-Global/Documents_New/Business_of_IT/OneCloud/AWS-Azure-AD-SSO-Plugin.pdf).
By installing, configuring, and using the plugin on a workstation, temporary IAM
credentials (i.e., access key id, secret access key, token) can be obtained to
enable AWS CLI access and programming language SDK access for long-lived
accounts. However, access is temporary and the plugin must be executed, via a
shell command, again once the temporary credentials have expired. There is no
limit to the number of times that the temporary credentials can be used while
they remain valid.

### AWS AD SSO Plugin

AWS CLI access and programming language SDK access to long-lived AWS accounts
requires use of the Deloitte
[AWS Azure AD SSO Plugin](https://resources.deloitte.com/sites/MyTech-Global/Documents_New/Business_of_IT/OneCloud/AWS-Azure-AD-SSO-Plugin.pdf).
To use the plugin, it will need to be installed and configured, at least once,
on the workstation used to access the long-lived account.

#### Installing the Plugin

The
[AWS Azure AD SSO Plugin](https://resources.deloitte.com/sites/MyTech-Global/Documents_New/Business_of_IT/OneCloud/AWS-Azure-AD-SSO-Plugin.pdf)
requires configuration, at least once, before it can be used. You can configure
it for all AWS CLI profiles on a workstation or for a single profile. The
examples provided in this section illustrate configuration for a single profile.

To configure the plugin issue the command:

```bash
$ aws-azure-login --configure --profile foo
```

During configuration of the plugin you will need to supply the following
information:

- Azure Tenant ID
  - Enter the value `36da45f1-dd2c-4d1f-af13-5abe46b99921`
  - This value is shared across all Deloitte employees
- Azure App ID URI
  - Enter the value https://signin.aws.amazon.com/saml#123456789012
  - Please replace the target AWS account ID for the number 123456789012 in the
    URL above
- Stay logged in leave this blank
- Default Role Arn leave this blank
- Default Session Duration leave this blank

#### Using The Plugin

When using the AWS AD SSO Plugin for the first time on a workstation, it is
recommended to first attempt to access the AWS account using the AWS console.
This will prove out general network connectivity and the ability of your
elevated credentials to access the account.

After correctly configuring the plugin on a workstation, the plugin must be used
each time AWS CLI or programming language SDK access is required to the AWS
account containing the SW Factory Platform deployment. After a single execution
of the following command, access will remain in place until the temporary
credentials expire.

```bash
$ aws-azure-login --mode gui --profile foo
```

The command above provisions temporary credentials, via AWS' IAM STS, placing
them in the `.aws/credentials` file. In the case of the example command above, a
new `access key`, `secret access key`, and `token` will be placed in the
credentials file for the profile named `foo`. These credentials are temporary,
lasting a number of hours. The last step (before the command routes to IAM for
temporary credential provisioning) allows you to specify, via the command line,
how many hours you would like the temporary credentials to remain valid.

##### Windows 10 Tips

- If you are experiencing difficulties with cut and paste operations into a
  PowerShell or Cmd shell, try a right mouse click immediately following a
  failed paste operation
- To use the Azure AD SSO Plugin you will need invoke it from a PowerShell or
  Cmd shell that is run by the Windows 10 user that was automatically created on
  your workstation when you installed the plugin. This user’s name matches the
  username of the AD credentials that were created when you used the MAC Tool to
  request the elevated permission levels necessary to access an AWS account. The
  following steps will help you launch a PowerShell run by the Windows 10 user
  with elevated permission levels
  - In the Windows 10 search bar / input region (i.e., lower left hand corner of
    UI), type in `PowerShell`
  - Right click on the PowerShell icon and then select `Open file location`
  - In the resulting window hold down the shift key, right click on the
    PowerShell shortcut, and select the `Run as different user`
  - In the resulting security pop-up dialogue, provide the username for the
    local Windows 10 user provisioned when you installed the plugin. For the
    password, supply the temporary / daily password that you retrieved from the
    Secrets Server, which is a component of the Azure AD Access Model.
- The AWS CLI is automatically configured to use the environmental variable
  named `AWS_PROFILE`. By setting this variable you can avoid the need to
  repeatedly provide the `--profile <profile name>` command line option.
  Remember that once you set an environmental variable you will need to bring up
  a new PowerShell or Cmd Shell in order to pick up new settings.
- Assuming default Windows 10 settings, you will have to temporarily lower the
  script execution security level settings In order to invoke the Azure AD SSO
  Plugin. After you are finished executing the plugin you should restore the
  script execution security levels.
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

##### Mac/Linux Specific Tips

- Node Version Manager is actively supported for Mac/Linux environments and is
  highly recommended for installing `node` and `npm` to the acquiring of the
  `aws-azure-login` package.
- Debug mode is set with `DEBUG=aws-azure-login`

## Normal Operation

### System Generated Messages

A SW Factory Platform deployment will automatically notify interested
individuals of important system events at the time that the events occur.
Notification takes the form of SMS messaging and / or email messaging that
provide informative information on a wide variety of conditions (e.g., EC2
instance disk utilization exceeds threshold.)

The detection of events and the automated transmission of messages are achieved
using a combination of AWS CloudWatch Alarms and ELK Alerts. The _System
Administrator_, utilizing both systems, will maintain the list of events that
can be detected as well as the list of individuals that desire event
notification messages.

**Related Links:**

- [What is Amazon SNS? - Amazon Simple Notification Service](https://docs.aws.amazon.com/sns/latest/dg/welcome.html)
- [SES](https://aws.amazon.com/ses/getting-started/)

### Backups

Normal operations for most _Platform Applications_ involves periodically backing
up application state information. Such backups help minimize information loss in
the event of unexpected shutdown / failures of the application itself or of the
infrastructure that the application runs on.

Generally, more complex applications provide integrated “state saving”
functionality. It is not uncommon for less complicated applications to not
integrate “state saving” functionality into the application itself as performing
a backup is an obvious and straightforward process (e.g., copy a data file[s]
over to a backup location.)

The _System Administrator_ will need to ensure that backups occur on all
_Platform Applications_ on regular basis. Backups should occur at a frequency
that minimizes the potential for loss of state information yet does not
introduce an unwarranted processing burden / strain on the infrastructure. All
backups must be automated and success / failure of a backup operation must be
logged appropriately (e.g., CloudWatch Logs / ELK.) Even though the results of
automated backups are logged, the _System Administrator_ should still perform
daily spot checks for the presence of normal backup activity across all
_Platform Applications_. This involves verifying the presence of expected files
in expected locations and of the expected sizes.

#### Platform Applications with Integrated Backup Functionality

The following Platform Applications provide inherent support for backing up
application state information:

- Vault
  - [Vault Data Backup Standard Procedure | Vault - HashiCorp Learn](https://learn.hashicorp.com/tutorials/vault/sop-backup)
- openSCAP
  - [Administering Red Hat Satellite Red Hat Satellite 6.9 | Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_satellite/6.9/html-single/administering_red_hat_satellite/index)
- Elastic Search
  - [Back up a cluster’s data | Elasticsearch Guide [7.16] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/backup-cluster-data.html)
- Log Stash
  - [Snapshot and restore | Elasticsearch Guide [7.16] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html)
- Gitlab
  - [Back up and restore GitLab | GitLab](https://docs.gitlab.com/ee/raketasks/backup_restore.html)

#### Platform Applications without Integrated Backup Functionality

The following _Platform Applications_ do not inherently support backing up
application state information. It is left to the _System Administrator_ to
determine the best means perform backup and restore operations for these
applications:

- Jenkins
  - [Backing-up/Restoring Jenkins](https://www.jenkins.io/doc/book/system-administration/backing-up/)
- SonarQube
  - [Backup and Restore | SonarQube Docs](https://docs.sonarqube.org/latest/instance-administration/backup-restore/)
- Nexus
  - [Backup and Restore](https://help.sonatype.com/repomanager3/backup-and-restore)

### Aggregating System Logs and Metrics

Modern software application packages generate system log messages, as do special
purpose applications such as operating systems (e.g., Linux). Individual public
cloud services (e.g., AWS' EC2) generate system log messages and some of the
more infrastructure-aligned services additionally generate metrics. Some
services can be configured to generate additional, specialty system log messages
(e.g., S3 access logs.) The AWS platform provides default integrations between
AWS services and CloudWatch Logs making CloudWatch Logs the centralized
destination for system log messages and metrics. Some AWS services offer
additional, specialty logging features such as S3 Access Logs and VPC Flow Logs.

#### Metrics

A metric can be defined as a measurement of a specific aspect of a system.
Metrics, measured at regular intervals, can provide incredibly valuable insights
into a system. Metrics are often used as input to a rules engine that
automatically takes action (e.g., generate alert messaging) upon detecting a
specific condition (e.g., metric value above / below a defined threshold.) Given
a sufficient number of consecutive individual measurements, metrics can greatly
assist with the manual detection of system trends. Metrics are often associated
with detailed infrastructure measurements (e.g., CPU utilization, network
latency), however, they can also be used to measure higher-level, application
behaviors (e.g., number of end-user requests that fail to process correctly.)

The _System Administrator_ is responsible for ensuring that the SW Factory
Platform’s metrics are centrally collected and processed.

**Related Links:**

- [Using Amazon CloudWatch metrics - Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html)
- [AWS services that publish CloudWatch metrics - Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html)
- [List the available CloudWatch metrics for your instances - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html)

#### System Logs and ELK

ELK (Elasticsearch, Logstash, Kibana) is used to aggregate, process, and manage
all of the SW Factory Platform’s metric messages and system logging messages. It
is also used to collect, process, and manage metrics and system log messages for
the _Deployed Applications_ that run on the platform.

Elasticsearch is an industry standard tool for parsing and searching through
structured and unstructured data generated by a variety of tools. Logstash is a
log message aggregator capable of scraping / collecting logs from a variety of
sources (stdout, file system folders, or io streams.) Kibana provides data
visualization across the collection of aggregated data. It is capable of passing
queries to Elasticsearch and displaying the results.

##### Filebeat

Filebeat is a lightweight log aggregator that is setup to forward logs exported
into S3 from CloudWatch. Filebeat observes changes that take place in S3
indicating that new logs have been shipped. When it detects this change it will
automatically forward the difference in logs into LogStash to ensure that there
is parity between the ELK stack and what is taking place in AWS S3 bucket.
Filebeat is also a good tool for detecting and aggregating logs within a service
mesh and could be used for the Deployed Application as well.

**Related Links:**

- [Filebeat: Lightweight Log Analysis & Elasticsearch](https://www.elastic.co/beats/filebeat)
- [The ELK Stack: From the Creators of Elasticsearch](https://www.elastic.co/what-is/elk-stack)
- [Elastic Stack and Product Documentation | Elastic](https://www.elastic.co/guide/index.html)
- [Configure Filebeat | Filebeat Reference [7.16] | Elastic](https://www.elastic.co/guide/en/beats/filebeat/current/configuring-howto-filebeat.html)

#### AWS System Logs and Metrics

AWS services generate messages that can be easily aggregated in CloudWatch Logs:
system logs, metrics, and additional logs (e.g., access logs.)

##### CloudTrail

SSM logs - AWS Systems Manager Agent (SSM Agent) writes information about
executions, commands, scheduled actions, errors, and health statuses to log
files on each instance. You can view log files by manually connecting to an
instance, or you can automatically send logs to Amazon CloudWatch Logs.

##### System Logs with AWS CloudWatch

Amazon’s CloudWatch service is a log aggregation, storage, and searching
solution provided by Amazon for native and 3rd party services. CloudWatch logs
can be grouped for logical separation and then displayed within the CloudWatch
dashboard. Logs can also be exported into a variety of display, parsing, and
storage solutions native to AWS as well as third party services like the ELK
stack.

A component leveraged to aggregate logs off of native and 3rd party resources
into CloudWatch is called the CloudWatch agent. The CloudWatch agent is
leveraged by the Platform to aggregate logs off the EC2 deployed instances into
the cloud service. This component is setup by default on all instances deployed
by the platform and requires that each instance is given a role with proper
authorization to leverage CloudWatch.

##### VPC Flow Logs

VPC Flow Logs is an enabled service for an clear view of what is taking place
with traffic within a deployed VPC. It is important to note that these logs are
more provided to determine and debug issues that a _System Administrator_ may
come across and are less related to application specific reasons, but can be
used to help diagnose those kinds of issues. VPC Flow Logs can be stored within
CloudWatch or exported into S3 which can then be pushed into LogStash or other
3rd party sources.

- Diagnosing security groups.
- Monitoring all inbound and within AWS ecosystem outbound traffic that is
  related to your instance.
- Determine the direction of the traffic to and from the network interfaces.

##### Access Logs for Application Load Balancers (ALB)

The entry point for the _Deployed Application_ is handled by a AWS Application
Load Balancer with a Amazon issued certificated (AWS ACM) to handle end-to-end
encryption associated with the ALB. Amazon’s ALBs have a togglable feature
called Access Logs to provide detailed logging from traffic interacting with
with the load balancer. Access logs contain information pertaining to the time
of the request, latencies, paths, and responses which can help diagnose traffic
related issues and give extra visibility into the platform. Access Logs are
exported and compressed into a defined and already created AWS S3 bucket for
storage.

##### CloudWatch Events & Alerts

When irregularities are reported within CloudWatch it is important to find ways
to report these anomalies as fast as possible to prevent downtime. CloudWatch
provides multiple automated solutions for handling these situations and a big
part of this functionality is handled by CloudWatch alerts and events. The
overview is that an alert can be created that looks for a case or expression
that could indicate an issue has occurred. Once this alert has been triggered,
in best cases an event has been created to be dispatched to communicate this
issue or in a best case resolve this issue automatically by leveraging an event.
Events can trigger a number of other AWS services to resolve and correct the
issue. A typical case could be where CloudWatch could parse an error within its
aggregated logs based on a defined alert. This alert could then trigger a AWS
service to notify a _System Administrator_ on this alert via an email (AWS SES),
or text message (AWS SNS). To learn more about how AWS can help in resolving
real time issues consult the following links below.

**Related Links**

- [Logging IP traffic with VPC Flow Logs - Amazon Virtual Private Cloud](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)
- [Collecting metrics and logs from Amazon EC2 instances and on-premises servers with the CloudWatch agent - Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html)
- [What is Amazon CloudWatch? - Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)
- [What Is Amazon CloudWatch Events? - Amazon CloudWatch Events](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/WhatIsCloudWatchEvents.html)
- [AWS::CloudWatch::Alarm - AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cw-alarm.html)
- [Access logs for your Application Load Balancer - Elastic Load Balancing](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html)

### IaC & Configuration Administration

#### Overview

The technique of automatically provisioning infrastructure is often referred to
as Infrastructure as Code (IaC) is closely aligned to the industry term
“orchestration.” Orchestration can be defined as the automated creation,
placement, and configuration of infrastructure components (e.g., networking,
servers.) The technique of automatically installing, configuring, and
maintaining resources (typically applications hosted on servers) is commonly
referred to as “configuration management.” Software development organizations
seldom confine their offerings to a single IT category / technology. Therefore,
most orchestration tools offer some configuration management functionality and
most configuration management tools offer a degree of orchestration
functionality.

For deployment and operation of a SW Factory Platform, Terraform is used for
orchestration and Ansible is used for configuration management.

#### Terraform

The AWS infrastructure components of a SW Factory Platform deployment are
provisioned using Terraform. On the rare occasion that a _System Administrator_
finds the need to engage with this infrastructure, Terraform should be used to
do so. Directly modifying the AWS infrastructure, without using Terraform to
makes changes, will introduce “state drift” between Terraform’s perception of
the AWS infrastructure and the AWS Infrastructure's actual state.

During the second step of the SW Factory Platform’s deployment process, a _Cloud
Architect / Cloud Engineer_ executes Terraform commands, locally on a
workstation, to provision the platform’s AWS infrastructure. The state file
supporting these Terraform commands resides in an S3 bucket contained within the
same AWS account that the platform is deployed into. Successful execution of
Terraform commands on a workstation against the platform’s AWS infrastructure
requires the presence of the Terraform scripts (i.e., part of the SW Factory
Platform Deployment Bundle), Terraform configuration for the remote S3 backend,
and AWS suitable AWS security credentials. A _System Administrator_ seeking to
access the platform’s AWS infrastructure should work through a _Cloud Architect
/ Cloud Engineer_.

While using Terraform to engage with the platform’s AWS infrastructure, state
file commands (e.g., terraform state list) followed by a | grep "search string"
(i.e., Linux) or a | findstr "search string" (i.e., Windows) can prove useful.
Additionally, all AWS infrastructure components that support a SW Factory
Platform deployment are given meaningful values for their Name resource tag.

**Related Links:**

- [Inspect State](https://www.terraform.io/docs/cli/state/inspect.html)
- [Tagging AWS resources - AWS General Reference](https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html)
- [Terraform State Recovery](https://www.terraform.io/docs/cli/state/recover.html)
- [Terraform S3 Backend](https://www.terraform.io/docs/language/settings/backends/s3.html)

#### Ansible

The _Platform Applications_ are installed and configured on the SW Factory
Platform’s servers using Ansible. On the rare occasion that a System
Administrator needs to engage with a _Platform Application_, Ansible should be
used to do so.

During the third and final step of the SW Factory Platform’s deployment process,
a _Cloud Architect / Cloud Engineer_ executes Ansible commands, locally on a
workstation, to install and to configure the _Platform Applications_. Successful
execution of the Ansible Playbooks on a workstation requires the workstation to
contain the private key, from the asymmetric key pair provisioned during the
platform’s deployment process, and the Ansible Playbooks (i.e., part of the SW
Factory Platform Deployment Bundle.) Additionally, the bastion server,
provisioned during the platform’s deployment process, must still be available so
that the local execution of the Ansible Playbooks can route to the platform’s
EC2 servers. A _System Administrator_ seeking to engage with a platform’s
_Platform Applications_ should work through a _Cloud Architect / Cloud
Engineer_.

There is no supported install for Ansible on Windows. One possible workaround
for this would be to install WSL2 on your workstation and then use a Linux
prompt provided by WSL2 to execute Ansible commands.

**Related Links:**

- [Indexes of all modules and plugins — Ansible Documentation](https://docs.ansible.com/ansible/latest/collections/all_plugins.html)
- [Learning Ansible basics](https://www.redhat.com/en/topics/automation/learning-ansible-tutorial#ansible-playbooks)

## Administrative Tasks

### OS Update/Patches, Application Updates, Security Patches

SW Factory Platform deployments that remain operational for more than a few days
will require administration of the platform’s EC2 instances as well as the
_Platform Applications_ that run on these instances. The System Administrator
should attempt to carry out as much of this administration (e.g., OS patches,
security patches, application updates) as possible using the AWS Systems Manager
(SSM) service. To facilitate this, all of the platform’s EC2 instances are
instrumented with the SSM agent during deployment of the platform. Within an AWS
account, all EC2 instances instrumented with the SSM agent can be easily
administered without having to log onto each server individually.

If possible, the _System Administrator_ should update _Platform Applications_
using a standard package manager (e.g., yum or apt-get). If a _Platform
Application_ can be updated using a standard package manager, the application
update should use the package manager via SSM.

If no standard package manager supports updating the _Platform Application_, an
Ansible Playbook should be used to update the application. Successful execution
of an Ansible Playbooks on a workstation requires the workstation to contain the
private key, from the asymmetric key pair provisioned during the platform’s
deployment process, and the Ansible Playbooks (i.e., part of the SW Factory
Platform Deployment Bundle.) Additionally, the bastion server provisioned during
the platform’s deployment process must still be available for the local
execution of the Ansible Playbooks to route through in order to reach the
platform’s EC2 servers. A _System Administrator_ seeking to engage with a
_Platform Application_ should work through a _Cloud Architect / Cloud Engineer_.

**Related Links:**

- [AWS Systems Manager Node Management - AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-instances-and-nodes.html)
- [AWS Systems Manager Patch Manager - AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-patch.html)
- [SSM Agent version 3.0 - AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent-v3.html)

### Identity and Access Management

One of the _System Administrator’s_ responsibilities is the management of
individual access to the _Platform Applications_ contained within a SW Factory
Platform deployment. This access is managed by provisioning users within RHEL
Identity Manager IdM (aka IPA) and assigning appropriate access levels to each
user. The _System Administrator_ is responsible for managing both users and
their access levels. The individual access enabled by the IdM supports
_Application Developers_ accessing _Platform Applications_ as well as _Platform
Applications_ accessing other _Platform Applications_.

Passwords, access tokens, and other security-related, sensitive data is stored
in HashiCorp Vault. The deployment of a SW Factory Platform will place IdM
credentials in Vault, enabling the initial login to the IdM server so that
subsequent users can be provisioned.

**Related Links:**

- [About - FreeIPA](https://www.freeipa.org/page/About#What_is_FreeIPA.3F)

### AWS Service Quotas

The _System Administrator_ should be aware of the number of AWS resources
deployed within the AWS account relative to AWS service quota limits. Concerns
of exceeding service quota limits should be raised to a _Cloud Architect / Cloud
Engineer_.

If you would like to take inventory of the number of AWS Resources currently
deployed in an AWS account you can run the following AWS CLI command, after
ensuring that the AWS Config Service is enabled. By default the AWS Config
service is not enabled on new AWS accounts, but it is enabled by default for AWS
accounts controlled by Deloitte OneCloud.

```bash
$ aws configservice get-discovered-resource-counts --profile <AWS CLI profile> --output table --region <region>
```

The AWS Trusted Advisor is another source you can use to obtain useful
information about AWS quota limits. You can find a Service Limits section in the
Trusted Advisor Dashboard section of the AWS Console.

**Related Links:**

- [AWS service quotas - AWS General Reference](https://docs.aws.amazon.com/general/latest/gr/aws_service_limits.html)

### Rebooting Servers

Proactively rebooting servers, on an ad hoc or scheduled basis, is an
established system administration technique. In general, this technique is much
more useful for Windows servers than Unix/Linux servers. This technique should
only be employed in a responsible manner. For example, careful planning must
take place for the resulting server down time, especially for production servers
that are client-facing or revenue-generating. Automated and / or scheduled
reboots of EC2 instances can be accomplished in several different ways (e.g.,
SSM, EventsBridge, CloudWatch Alarms.)

**Related Links:**

- [Create alarms to stop, terminate, reboot, or recover an EC2 instance - Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/UsingAlarmActions.html)
- [Scheduled events for your instances - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/monitoring-instances-status-check_sched.html)
- [CloudWatch](https://aws.amazon.com/premiumsupport/knowledge-center/start-stop-lambda-cloudwatch/)
- [Reboot your instance - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-reboot.html)

## Abnormal Operations

The _System Administrator’s_ duties include regular inspection of different,
critical aspects of the SW Factory Platform. This involves validating evidence
of normal operation (e.g., normal processing of system log, normal _Platform
Application_ backup) and proactively detecting anomalies (e.g., unexpectedly
high projected monthly costs).

In addition to regular manual inspections, the _System Administrator_ will need
to respond to automated alerts, generated by the platform itself, as well
communication from individuals (e.g., _Application Developer_) that have
detected an issue with one or more of the platform’s components. The _System
Administrator_ does not support _Deployed Applications_ nor interact with
_Application Users_.

In all but the most basic incidents, the _System Administrator_ will perform an
initial assessment, collect relevant information, and then engage the _Cloud
Architect / Cloud Engineer_ to resolve the incident.

### CloudWatch Alarms

The AWS CloudWatch service provides the Alarm feature which is capable of
automatically monitoring system logs and metrics to detect alarm conditions
(e.g., presence of an ERROR level system log message or a metric value exceeding
a defined threshold.) A CloudWatch Alarm can be configured to integrate with a
wide range of AWS services. This enables practically any action desired (e.g.,
distribute alert messages, invoke a function) to be taken once an alarm
condition is detected.

**Related Links:**

- [Viewing available metrics - Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/viewing_metrics_with_cloudwatch.html)
- [Using Amazon CloudWatch alarms - Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)

### ELK Alerts

ELK provides the ELK Alerts feature, which is very similar to AWS CloudWatch
Alarms. As CloudWatch Alarms is an AWS platform native tool, it offers deep
integrations to a wide variety of AWS services, enabling a wide range of action
to be taken once an alarm state is detected. ELK Alerts provides Connectors to
facilitate integration with entities, external to ELK, that take action once an
alarm is detected. Connectors collect and store the information required to
integrate ELK Alerts to a third party services.

**Related Links:**

- [Alerting | Kibana Guide [7.16] | Elastic](https://www.elastic.co/guide/en/kibana/current/alerting-getting-started.html)
- [Watcher | Kibana Guide [7.16] | Elastic](https://www.elastic.co/guide/en/kibana/current/watcher-ui.html)
