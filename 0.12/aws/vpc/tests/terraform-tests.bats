load terraform

@test "Validate outputs of Terraform 'vpc' module" {
  assertTerraformOutputNotEmpty ".vpc_id.value"
  assertTerraformOutputEquals "concord-testing-vpc" ".vpc.value.tags.Name"
  assertTerraformOutputNotEmpty '.["nat-eips"].value["us-east-2a"].id'
  assertTerraformOutputNotEmpty '.["nat-gw"].value["us-east-2a"].id'
  assertTerraformOutputNotEmpty '.["public_subnets"].value["us-east-2a"].id'
  assertTerraformOutputNotEmpty '.["privat_subnets"].value["us-east-2a"].id'
}
