# TODO

The 00-data.tf is used by several of the modules except for the vpc module, not sure if we live with this exception and remove it from being used in the vpc module or let each module state it's data requirement for a vpc

- The duration doesn't take into account the fixture setup time
- Add support for post hooks: provision and ec2 compute with a root volume set to delete on compute termination. We gather the volume id during the test and then after the compute is terminated make sure the volume has been deleted
