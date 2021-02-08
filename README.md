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


## GitHub Actions

An action to delete the branch after merge has been added.
Also an action that will tag when branch is merged to master
See https://github.com/anothrNick/github-tag-action

```
Bumping

Manual Bumping: Any commit message that includes #major, #minor, or #patch will trigger the respective version bump. If two or more are present, the highest-ranking one will take precedence.

Automatic Bumping: If no #major, #minor or #patch tag is contained in the commit messages, it will bump whichever DEFAULT_BUMP is set to (which is minor by default).

Note: This action will not bump the tag if the HEAD commit has already been tagged.
```
