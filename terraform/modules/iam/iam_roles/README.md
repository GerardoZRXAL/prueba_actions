<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.

## Usage
Basic usage of this module is as follows:

```hcl
  module "example" {
      	 source  = "<module-path>"
      
	 # Required variables
      	 roles_configurations  = 
      
	 # Optional variables
      	 default_tags  = {
  "Environment": "default-environment",
  "Owner": "default-owner",
  "Project_Name": "default-project",
  "Sub_Project_Name": "default-subproject",
  "map-migrated": "default-migrated"
}
    }
```
  ## Resources

| Name | Type |
|------|------|
| [aws_iam_role.permissions_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.permissions_assignment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

  ## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags to apply to all resources. | `map(string)` | <pre>{<br>  "Environment": "default-environment",<br>  "Owner": "default-owner",<br>  "Project_Name": "default-project",<br>  "Sub_Project_Name": "default-subproject",<br>  "map-migrated": "default-migrated"<br>}</pre> | no |
| <a name="input_roles_configurations"></a> [roles\_configurations](#input\_roles\_configurations) | n/a | <pre>map(object({<br>    name                    = string<br>    policie_name            = string<br>    description             = string<br>    assume_role_policy_path = string<br>    policy_path             = string<br>    policy_maps             = map(string)<br>  }))</pre> | n/a | yes |

  ## Outputs

No outputs.
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->