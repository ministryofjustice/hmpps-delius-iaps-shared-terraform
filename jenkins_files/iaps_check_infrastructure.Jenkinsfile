def project = [:]
project.config    = 'hmpps-env-configs'
project.iaps     = 'hmpps-delius-iaps-shared-terraform'

// Parameters required for job
// parameters:
//     choice:
//       name: 'environment_name'
//       description: 'Environment name.'

def prepare_env() {
    sh '''
    #!/usr/env/bin bash
    docker pull mojdigitalstudio/hmpps-terraform-builder:latest
    '''
}

def plan_submodule(config_dir, env_name, git_project_dir, submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        echo "TF PLAN for ${env_name} | ${submodule_name} - component from git project ${git_project_dir}"
        set +e
        cp -R -n "${config_dir}" "${git_project_dir}/env_configs"
        cd "${git_project_dir}"
        docker run --rm \
            -v `pwd`:/home/tools/data \
            -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder \
            bash -c "\
                source env_configs/${env_name}/${env_name}.properties; \
                cd ${submodule_name}; \
                if [ -d .terraform ]; then rm -rf .terraform; fi; sleep 5; \
                terragrunt init; \
                terragrunt plan > tf.plan.out; \
                exitcode=\\\"\\\$?\\\"; \
                cat tf.plan.out; \
                if [ \\\"\\\$exitcode\\\" == '1' ]; then exit 1; fi; \
                parse-terraform-plan -i tf.plan.out | jq '.changedResources[] | (.action != \\\"update\\\") or (.changedAttributes | to_entries | map(.key != \\\"tags.source-hash\\\") | reduce .[] as \\\$item (false; . or \\\$item))' | jq -e -s 'reduce .[] as \\\$item (false; . or \\\$item) == false'" \
            || exitcode="\$?"; \
            echo "\$exitcode" > plan_ret; \
            if [ "\$exitcode" == '1' ]; then exit 1; else exit 0; fi
        set -e
        """
        return readFile("${git_project_dir}/plan_ret").trim()
    }
}

pipeline {

    agent { label "jenkins_slave" }

    stages {

        stage('setup') {
            steps {
                dir( project.config ) {
                  git url: 'git@github.com:ministryofjustice/' + project.config, branch: env.GIT_BRANCH, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }
                dir( project.iaps ) {
                  checkout scm
                }
                prepare_env()
            }
        }

        stage('Plan IAPS Common')        { steps { script {plan_submodule(project.config, environment_name, project.dcore, 'common')}}}
        
        stage('Plan IAPS IAM & Security Groups') {
          parallel {
            stage('Plan IAPS IAM')        { steps { script {plan_submodule(project.config, environment_name, project.dcore, 'iam')}}}
            stage('Plan IAPS Security Groups')        { steps { script {plan_submodule(project.config, environment_name, project.dcore, 'security-groups')}}}
            }
        }

        stage('Plan IAPS EC2 & RDS') {
          parallel {
            stage('Plan IAPS EC2')        { steps { script {plan_submodule(project.config, environment_name, project.dcore, 'ec2')}}}
            stage('Plan IAPS RDS')        { steps { script {plan_submodule(project.config, environment_name, project.dcore, 'rds')}}}
            }
        }
    }

    post {
        always {
            deleteDir()

        }
    }

}