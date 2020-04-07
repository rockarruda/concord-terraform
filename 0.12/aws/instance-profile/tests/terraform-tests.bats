instance_profile_arn="$(cat terraform-outputs.json | jq -r .instance_profile.value.arn)"
instance_profile_id="$(cat terraform-outputs.json | jq -r .instance_profile.value.id)"

@test "Validate outputs of Terraform 'Instance Profile' module" {
  [ "$instance_profile_arn" != "" ]
  [ "$instance_profile_id" = "concord-testing-instance-profile" ]
}
