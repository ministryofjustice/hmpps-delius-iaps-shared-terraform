# hmpps-delius-iaps-shared-terraform

## Environments

**Delius-core-dev**: [readme](https://github.com/ministryofjustice/hmpps-delius-iaps-shared-terraform/tree/master/docs/delius-core-dev)

**Delius-mis-test**: [readme](https://github.com/ministryofjustice/hmpps-delius-iaps-shared-terraform/tree/master/docs/delius-mis-test)

Plan Stage

```bash
AWS_PROFILE=hmpps_token ENVIRONMENT=delius-stage COMPONENT=common ./run.sh plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-stage COMPONENT=iam ./run.sh plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-stage COMPONENT=security-groups ./run.sh plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-stage COMPONENT=rds ./run.sh plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-stage COMPONENT=ec2 ./run.sh plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-stage COMPONENT=monitoring ./run.sh plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-stage COMPONENT=dashboards ./run.sh plan

```