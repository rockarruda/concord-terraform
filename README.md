# Concord Terraform

General purpose Terraform that is utilized by the Terraform pre-processor task.

## Running Tests

### Requirements

You require a `~/.concord/profile` that is a symlink to a file, or a file with an `AWS` stanza. If you've used the Concord Starter then you likely have a `Concord` stanza as well but it's the `AWS` settings that matter here below:

```
# ------------------------------------------------------------------------------
# Concord
# ------------------------------------------------------------------------------
CONCORD_VERSION=1.44.0
CONCORD_ORGANIZATION=starburstdata
CONCORD_DOCKER_NAMESPACE=walmartlabs
CONCORD_HOST_PORT=localhost:8080
CONCORD_API_TOKEN=<???>
CONCORD_ACCOUNT="experimentation"
CONCORD_USER="automation"
CONCORD_REGION="us-east-2"

# ------------------------------------------------------------------------------
# AWS
# ------------------------------------------------------------------------------
AWS_ACCOUNT="${CONCORD_ACCOUNT}"
AWS_USER="${CONCORD_USER}"
AWS_REGION="${CONCORD_REGION}"
AWS_CREDENTIALS="$HOME/.aws/credentials"
AWS_PROFILE="${AWS_ACCOUNT}-${AWS_USER}"
AWS_KEYPAIR="${AWS_USER}"
AWS_PEM="${AWS_ACCOUNT}-${AWS_USER}-${AWS_REGION}.pem"
```

For running the tests

You require an `$HOME/.aws/credentials` file that has a stanza that corresponds the the `AWS_PROFILE` above as those are the credentials that will be used to connect to AWS:

```
[default]
aws_access_key_id = <???>
aws_secret_access_key = <???>

[experimentation-automation]
aws_access_key_id = <???>
aws_secret_access_key = <???>
```
You require a `$HOME/.concord/${AWS_ACCOUNT}-${AWS_USER}-${AWS_REGION}.pem` file that will be used to make `ssh` connections to the compute created as part of the test. So with our configuration you would specifically need a `experimentation-automation-us-east-2.pem` file.

You can run an individual test using:

```
./test.sh -m <module>
```

To run the test for the `ec2` module you would run:

```
./test.sh -m ec2
```

And you would get something like:

```
 Module ec2 ............... OK (52s)
```

To run all the tests for all modules you would run:

```
./test.sh -a
```

And you would get something like the following:

```
Module asg ............... OK (3m 23s)
Module dynamodb .......... OK (1m 4s)
Module ec2 ............... OK (2m 14s)
Module eks ............... OK (4m 12s)
Module id ................ OK (27s)
Module instance-profile .. OK (44s)
Module launch-template ... OK (28s)
Module rds-postgres ...... OK (9m 22s)
Module s3 ................ OK (54s)
Module vpc ............... OK (3m 38s)
```

### Debugging

To enable `set -eox pipefail` you can use the `-d | --debug` option. To run all the tests with debugging turned on you would run:

```
./test.sh -a -d
```
