# hmpps-delius-iaps-shared-terraform

## Environments

**Delius-core-dev**: [readme](https://github.com/ministryofjustice/hmpps-delius-iaps-shared-terraform/tree/master/docs/delius-core-dev)

**Delius-mis-test**: [readme](https://github.com/ministryofjustice/hmpps-delius-iaps-shared-terraform/tree/master/docs/delius-mis-test)

Plan Stage

Note: 
These code examples use the 'tf' alias - see https://dsdmoj.atlassian.net/wiki/spaces/DAM/pages/2599420295/AWS+IAM+hmpps-security-access-terraform+environment+config for details on creating this alias.

```bash
AWS_PROFILE=hmpps_token ENVIRONMENT=delius-core-dev COMPONENT=common tg plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-core-dev COMPONENT=common tg plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-core-dev COMPONENT=iam tg plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-core-dev COMPONENT=security-groups tg plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-core-dev COMPONENT=rds tg plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-core-dev COMPONENT=ec2 tg plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-core-dev COMPONENT=monitoring tg plan

AWS_PROFILE=hmpps_token ENVIRONMENT=delius-core-dev COMPONENT=dashboards tg plan

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
