# Template repo for Terraform modules

This repository contains my template for creating Terraform modules, yes even my
root modules. This template is based on the best practices I have learned and
the
[HashiCorp style guide](https://developer.hashicorp.com/terraform/language/style).

## Tools that I use

I use a wide array of tools to make things easier for me.

- [1Password](https://1password.com/): Password and Secret storage
  - `brew install 1password`
- [1Password - CLI](https://1password.com/downloads/command-line/): Allows for
  access to 1Password via environment variables and shell scripts.
  - `brew install 1password-cli`
- [Direnv](https://direnv.net/): Manages dynamic environment variables based on
  the directory.
  - `brew install direnv`
- [Task](https://taskfile.dev/): Replacement for GNU make. Uses YAML files.
  - `brew install go-task`
- [Terraform](https://www.terraform.io/downloads.html): Kind of the whole point
  here 😄
  - `brew install hashicorp/tap/terraform`
- [git](https://git-scm.com/downloads): Another obvious one 😃
  - `brew install git`
- [pre-commit](https://pre-commit.com/): Provides a method for running scripts
  and other tools during the `git commit` process.
  - `brew install pre-commit`
- [trufflehog](https://github.com/trufflesecurity/trufflehog): Scans your git
  repo for committed secrets 😱.
  - `brew install trufflesecurity/trufflehog/trufflehog`
- [autotag](https://github.com/pantheon-systems/autotag): Automatically creates
  git tags based on the commit message. Used to create semantic version tags in
  GitHub Actions pipeline. (Not installed locally, but you could)
  - `brew install pantheon-systems/autotag/autotag`

### Tools needed for the Pre-commit hooks that I use

All of these tools can be used standalone, but I use them as part of the git
commit process.

- [terraform-docs](https://github.com/terraform-docs/terraform-docs):
  Dynamically updates your README.md with information on the inputs, outputs,
  and requirements of your module.
  - `brew install terraform-docs`
- [infracost](https://github.com/infracost/infracost): Gives you a cost estimate
  for the cloud resources your module would deploy.
  - `brew install infracost`
- [jq](https://github.com/stedolan/jq): A lightweight and flexible command-line
  JSON processor. required for `terraform_validate` with
  `--retry-once-with-cleanup` flag, and for `infracost_breakdown` hook.
  - `brew install jq`
- [TFLint](https://github.com/terraform-linters/tflint): A Terraform linter that
  checks for best practices and errors in your Terraform code.
  - `brew install tflint`
- One or more of these terraform security scanning tools
  - [checkov](https://github.com/bridgecrewio/checkov)
    - `brew install checkov`
  - [terrascan](https://github.com/tenable/terrascan)
    - `brew install terrascan`
  - [TFSec](https://tfsec.dev)
    - `brew install tfsec`

### Miscellaneous tools

- [tfvars](https://github.com/shihanng/tfvar): This tool helps you manage
  Terraform variables. It allows you to store Terraform variables in a central
  location, and it also provides a way to encrypt Terraform variables.
- [inframap](https://github.com/cycloidio/inframap): Inframap is a tool that can
  be used to visualize your Terraform infrastructure. It reads your tfstate or
  HCL to generate a graph specific for each provider, showing only the resources
  that are most important/relevant.
- [driftctl](https://github.com/cloudskiff/driftctl): driftctl detects
  infrastructure drift by comparing actual resources with Terraform
  configuration, identifying changes or drift in attributes.
- [Terraspace](https://github.com/boltops-tools/terraspace): Terraspace is a
  framework that simplifies the development and deployment of Terraform
  infrastructure, offering automated module generation and integrated testing.
- [Terraform Compliance](https://github.com/terraform-compliance/cli): Terraform
  Compliance is a security and compliance scanner for Terraform code, allowing
  you to define and verify policies as code.

### Terraform Maintenance tools

Here are a couple of tools I use to help with managing Terraform versions.

- [TFSwitch](https://tfswitch.warrensbox.com/): Used to switch the version of
  terraform installed based on the directory you are in or the version
  constraint in your terraform code.
  - `brew install warrensbox/tap/tfswitch`
- [tfupdate](https://github.com/minamijoyo/tfupdate): Used to update the version
  constraints in your terraform code for core, providers and modules.
  - `brew install tfupdate`

### Code Editor

I use [Visual Studio Code](https://code.visualstudio.com/) as my code editor. I
have included my settings and extensions in the .vscode directory, so they
should be automatically installed when you open the project. They are also
listed below.

#### Extensions

I use the following extensions for VS Code.

- [HashiCorp HCL](https://marketplace.visualstudio.com/items?itemName=HashiCorp.HCL)
- [HashiCorp Sentinel](https://marketplace.visualstudio.com/items?itemName=HashiCorp.sentinel)
- [HashiCorp Terraform](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- [indent-rainbow](https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow)
- [Indented Block Highlighting](https://marketplace.visualstudio.com/items?itemName=byi8220.indented-block-highlighting)
- [Multiple cursor case preserve](https://marketplace.visualstudio.com/items?itemName=Cardinal90.multi-cursor-case-preserve)

#### Settings

I use the following settings for VS Code.

```json
{
  "[sentinel]": {
    "editor.defaultFormatter": "hashicorp.terraform"
  },
  "[terraform]": {
    "editor.defaultFormatter": "hashicorp.terraform"
  },
  "[tfvars]": {
    "editor.defaultFormatter": "hashicorp.terraform"
  },
  "editor.bracketPairColorization.enabled": true,
  "editor.formatOnSave": true,
  "editor.rulers": [
    {
      "color": "#A5FF90",
      "column": 80
    },
    {
      "color": "#FF628C",
      "column": 100
    }
  ],
  "editor.tabCompletion": "on",
  "editor.tabSize": 2,
  "files.associations": {
    "*.hcl": "terraform",
    "*.nomad": "terraform",
    "*.policy": "sentinel"
  },
  "terraform.indexing": {
    "delay": 500,
    "enabled": false,
    "exclude": [".terraform/**/*", "**/.terraform/**/*"],
    "liveIndexing": false
  },
  "terraform.languageServer.enable": true
}
```

## Example config files

I've included example config files for some of the tools.

`direnv`: Rename `.envrc.example` to `.envrc` and update.

`pre-commit`: Review `.pre-commit-config.yaml` to enable/disable hooks.

`terraform-docs`: Review `.terraform-docs.yml` to adjust document formatting
options.

`TFLint`: Review `.tflint.hcl`

`Task`: Review `Taskfile.yaml` and or remove tasks.

`Terraform`: Rename `terraform.tfvars.example` to `terraform.tfvars` and update.

## Terraform Docs Dynamic section

Everything above this should be removed and replaced with your module
description.

The following two lines specify where the `terraform-docs` dynamic content will
be placed.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| google | ~>4.55 |
| hcp | ~>0.54 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
