load terraform

@test "Validate outputs of Terraform 'eks-roles-policies' module" {
  assertTerraformOutputNotEmpty ".vpc_id.value"
  assertTerraformOutputEquals "concord-testing" ".vpc.value.tags.Name"
  assertTerraformOutputNotEmpty '.["nat-eips"].value["us-east-2a"].id'
  assertTerraformOutputNotEmpty '.["nat-gw"].value["us-east-2a"].id'
  assertTerraformOutputNotEmpty '.["public_subnets"].value["us-east-2a"].id'
  assertTerraformOutputNotEmpty '.["privat_subnets"].value["us-east-2a"].id'
  assertTerraformOutputNotEmpty '.["eks-service-role"].value.arn'
  assertTerraformOutputEquals "concord-testing-eks-service-node-role" '.["eks-service-role"].value.id'
  assertTerraformOutputNotEmpty '.["eks-worker-node-instance-profile"].value.arn'
  assertTerraformOutputEquals "concord-testing-eks-worker-node-profile" '.["eks-worker-node-instance-profile"].value.id'
  assertTerraformOutputNotEmpty '.["eks-worker-node-role"].value.arn'
  assertTerraformOutputEquals "concord-testing-eks-worker-node-role" '.["eks-worker-node-role"].value.id'
  assertTerraformOutputNotEmpty '.["iam-role"].value.arn'
  assertTerraformOutputEquals "concord-testing" '.["iam-role"].value.id'
  assertTerraformOutputNotEmpty '.["instance-profile"].value.arn'
  assertTerraformOutputEquals "concord-testing" '.["instance-profile"].value.id'
}
