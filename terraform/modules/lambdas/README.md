<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.

## Usage
Basic usage of this module is as follows:

```hcl
  module "example" {
      	 source  = "<module-path>"
      
	 # Required variables
      	 lambda_config  = 
      	 lambda_roles_config  = 
      
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
| [aws_iam_role.lambda_permissions_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_permissions_assignment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.lambda_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [archive_file.lambda_code_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

  ## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags to apply to all resources. | `map(string)` | <pre>{<br>  "Environment": "default-environment",<br>  "Owner": "default-owner",<br>  "Project_Name": "default-project",<br>  "Sub_Project_Name": "default-subproject",<br>  "map-migrated": "default-migrated"<br>}</pre> | no |
| <a name="input_lambda_config"></a> [lambda\_config](#input\_lambda\_config) | n/a | <pre>map(object({<br>    function_name      = string<br>    description        = string<br>    handler            = string<br>    runtime            = string<br>    memory_size        = number<br>    timeout            = number<br>    env_variables      = map(string)<br>    needs_layer        = bool<br>    s3_bucket          = string<br>    s3_key             = string<br>    layer_name         = string<br>    subnet_ids         = list(string)<br>    security_group_ids = list(string)<br>    type               = string<br>    source_dir         = string<br>    output_path        = string<br>  }))</pre> | n/a | yes |
| <a name="input_lambda_roles_config"></a> [lambda\_roles\_config](#input\_lambda\_roles\_config) | n/a | <pre>map(object({<br>    name                    = string<br>    policie_name            = string<br>    description             = string<br>    assume_role_policy_path = string<br>    policy_path             = string<br>    policy_maps             = map(string)<br>  }))</pre> | n/a | yes |

  ## Outputs

No outputs.
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->