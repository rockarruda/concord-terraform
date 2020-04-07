# Outputs:
# rds_db_arn = arn:aws:rds:us-east-2:213470952269:db:concord-testing
# rds_db_endpoint = concord-testing.czsgc27u5gij.us-east-2.rds.amazonaws.com:5432
# rds_db_host = concord-testing.czsgc27u5gij.us-east-2.rds.amazonaws.com
# rds_postgres_database_name = concord
# rds_postgres_port = 5432
# rds_postgres_username = concord

rds_db_arn="$(cat terraform-outputs.json | jq -r .rds_db_arn.value)"
rds_db_endpoint="$(cat terraform-outputs.json | jq -r .rds_db_endpoint.value)"
rds_db_host="$(cat terraform-outputs.json | jq -r .rds_db_host.value)"
rds_postgres_database_name="$(cat terraform-outputs.json | jq -r .rds_postgres_database_name.value)"
rds_postgres_port="$(cat terraform-outputs.json | jq -r .rds_postgres_port.value)"
rds_postgres_username="$(cat terraform-outputs.json | jq -r .rds_postgres_username.value)"
rds_postgres_password="$(cat terraform.tfvars.json | jq -r .rds_postgres_password)"

@test "Validate outputs of Terraform 'RDS Postgres' module" {
  run bash -c "cat terraform-outputs.json | jq -r '${elements}'"
  [ "$status" -eq 0 ]
  [ "$rds_db_arn" != "" ]
  [ "$rds_db_endpoint" != "" ]
  [ "$rds_postgres_database_name" = "concord" ]
  [ "$rds_postgres_port" = "5432" ]
  [ "$rds_postgres_username" = "concord" ]
}

@test "Test connectivity to provisioned RDS Postgres" {
  run bash ./terraform-connect.sh
  [ "${lines[0]}" = "${rds_db_host}:${rds_postgres_port} - accepting connections" ]
}
