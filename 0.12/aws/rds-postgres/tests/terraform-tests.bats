load terraform

@test "Validate outputs of Terraform 'rds-postgres' module" {
  assertTerraformOutputNotEmpty ".rds_db_arn.value"
  assertTerraformOutputNotEmpty ".rds_db_endpoint.value"
  assertTerraformOutputEquals "concord" ".rds_postgres_database_name.value"
  assertTerraformOutputEquals "5432" ".rds_postgres_port.value"
}

@test "Test connectivity to provisioned RDS Postgres" {
  run bash ./terraform-connect.sh
  [ "${lines[0]}" = "${rds_db_host}:${rds_postgres_port} - accepting connections" ]
}
