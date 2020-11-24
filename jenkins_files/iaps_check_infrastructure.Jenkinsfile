def project = [:]
project.config    = 'hmpps-env-configs'
project.iaps     = 'hmpps-delius-iaps-shared-terraform'

// Parameters required for job
// parameters:
//     choice:
//       name: 'environment_name'
//       description: 'Environment name.'
//     string:
//       name: 'CONFIG_BRANCH'
//       description: 'Target Branch for hmpps-env-configs'

def prepare_env() {
    sh '''
    #!/usr/env/bin bash
    docker pull mojdigitalstudio/hmpps-terraform-builder-0-11-14:latest
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
            -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder-0-11-14:latest \
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

    agent { label "jenkins_agent" }

    parameters {
        string(name: 'CONFIG_BRANCH', description: 'Target Branch for hmpps-env-configs', defaultValue: 'master')
    }

    stages {

        stage('setup') {
            steps {
                slackSend(message: "Build started on \"${environment_name}\" - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL.replace(':8080','')}|Open>)")

                dir( project.config ) {
                  git url: 'git@github.com:ministryofjustice/' + project.config, branch: env.CONFIG_BRANCH, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }
                dir( project.iaps ) {
                  checkout scm
                }
                prepare_env()
            }
        }

        stage('Check IAPS Common') { steps { catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
            script {plan_submodule(project.config, environment_name, project.iaps, 'common')}}}
        }
        stage('IAM & Security Groups') {
            parallel {
                stage('Check IAPS IAM') { steps { catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {plan_submodule(project.config, environment_name, project.iaps, 'iam')}}}
                }
                stage('Check IAPS Security Groups') { steps { catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {plan_submodule(project.config, environment_name, project.iaps, 'security-groups')}}}
                }
            }
        }
        stage('EC2 & RDS') {
            parallel {
                stage('Check IAPS EC2') { steps { catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {plan_submodule(project.config, environment_name, project.iaps, 'ec2')}}}
                }
                stage('Check IAPS RDS') { steps { catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {plan_submodule(project.config, environment_name, project.iaps, 'rds')}}}
                }
            }
        }
        stage('Dashboards') {
            steps { 
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        plan_submodule(project.config, environment_name, project.iaps, 'dashboards')
                    }
                }
            }
        }

        stage('Monitoring') {
            steps { 
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        plan_submodule(project.config, environment_name, project.iaps, 'monitoring')
                    }
                }
            }
        }
    }

    post {
        always {
            deleteDir()
        }
        success {
            slackSend(message: "Build completed on \"${environment_name}\" - ${env.JOB_NAME} ${env.BUILD_NUMBER} ", color: 'good')
        }
        failure {
            slackSend(message: "Build failed on \"${environment_name}\" - ${env.JOB_NAME} ${env.BUILD_NUMBER} ", color: 'danger')
        }
    }

}
