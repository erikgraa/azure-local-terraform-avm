# Building infrastructure on Azure Local with Azure Verified Modules for Terraform

This repository contains example code to build frastructure on Azure Local with Azure Verified Modules for Terraform.

## 🚀 Features

The example code includes creation of the following resources:
* Logical network(s)
* 1 Virtual Machine Image (the latest Windows Server 2025 Datacenter Azure Edition as of 31 December 2025)
* 1 Virtual Machine deployed with the above image

## 📄 Usage

### 1️⃣ Deploy with Terrraform locally

1. Clone this repository.
2. Copy or rename the `terraform.auto.tfvars.example` file to `terraform.auto.tfvars` and change them according to the test environment.
3. Log in to Azure and run Terraform. The subscription ID can be sourced from the `ARM_SUBSCRIPTION_ID` environment variable.

```powershell
az login
$env:ARM_SUBSCRIPTION_ID = (az account list | ConvertFrom-Json).id
terraform init
terraform plan
terraform apply
```

### 📂 Outputs

Log in to the test machine with the the local administrator's username is `admin_user` and the random password from the following output:

```terraform
terraform output -raw azure-local-virtualmachineinstance-admin-password
```

## ✍ Blog post

See the related blog post at https://blog.graa.dev/AzureLocal-AVMTerraform.

## 👏 Contributions

Any contributions are welcome and appreciated!