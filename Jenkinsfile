pipeline {
    agent any
    tools { 
        maven 'Maven 3.6' 
        jdk 'JDK 8' 
    }
    stages {
        stage ('Initialize') {
            steps {
                checkout scm
            }
        }
        stage ('Build') {
          steps {
            script {
              def server = Artifactory.server "jfrog-artifactory"
              def buildInfo = Artifactory.newBuildInfo()
              buildInfo.env.capture = true
              def rtMaven = Artifactory.newMavenBuild()
              rtMaven.tool = 'Maven 3.6'
              rtMaven.opts = "-Denv=dev"
              rtMaven.deployer releaseRepo:'libs-release-local', snapshotRepo:'libs-snapshot-local', server: server
              rtMaven.resolver releaseRepo:'libs-release', snapshotRepo:'libs-snapshot', server: server
              rtMaven.run pom: 'simple_web_app/pom.xml', goals: 'clean install', buildInfo: buildInfo
              buildInfo.retention maxBuilds: 5, maxDays: 3, deleteBuildArtifacts: true
              server.publishBuildInfo buildInfo 
            }
          }
          post {
                success {
                    emailext body: 'Jenkins BUILD success', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Jenkins BUILD email'
                }
          }
        }
    }
}