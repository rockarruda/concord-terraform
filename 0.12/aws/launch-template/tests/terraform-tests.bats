launch_template_arn="$(cat terraform-outputs.json | jq -r .launch_template.value.arn)"
launch_template_name="$(cat terraform-outputs.json | jq -r .launch_template.value.name)"
launch_template_user_data="$(cat terraform-outputs.json | jq -r .launch_template.value.user_data)"


@test "Validate outputs of Terraform 'launch-template' module" {
  [ "$launch_template_arn" != "" ]
  [ "$launch_template_name" = "concord-testing" ]
  [ "$launch_template_user_data" != "" ]
}
