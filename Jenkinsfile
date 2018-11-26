#!/usr/bin/env groovy

pipeline {
    agent {
        docker {
            label 'docker && !canary'
            image 'docker.artifactory.ai.cba/build/docker:17.06.1-ce'
            args  '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage ('lint') {
            steps { sh 'make lint' }
        }
        stage('build') {
            environment { DOCKER_BUILD_ARGS = '--pull --no-cache' }
            steps { sh 'make build' }
        }
        stage('release') {
            when { branch 'master' }
            environment {
                HOME = "${WORKSPACE}"
                DOCKER_REGISTRY = 'docker.artifactory.ai.cba'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'ARTIFACTORY-CI',
                                 usernameVariable: 'DOCKER_USER',
                                 passwordVariable: 'DOCKER_PASSWORD') ]) {
                    sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} ${DOCKER_REGISTRY}"
                    sh 'make release'
                }
                withCredentials([file(credentialsId: 'GHE-NETRC', variable: 'NETRC')]) {
                    sh 'git config user.name "Jenkins CI"'
                    sh 'git config user.email "noreply@jenkins.ai.cba"'
                    sh "cp ${NETRC} ${HOME}/.netrc"
                    sh 'make release-pages'
                }
            }
            post { always { sh 'rm -f $HOME/.netrc' } }
        }
    }
    post {
        always { sh 'make clean' }
    }
}
