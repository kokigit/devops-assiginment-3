pipeline {
    agent any
    stages {
        stage ('Maven BUILD') {
          steps {
            script {
              def server = Artifactory.server "jfrog-artifactory"
              def buildInfo = Artifactory.newBuildInfo()
              buildInfo.env.capture = true
              def rtMaven = Artifactory.newMavenBuild()
              rtMaven.opts = "-Denv=dev"
              rtMaven.tool = "Maven 3.6"
              rtMaven.deployer releaseRepo:'libs-release-local', snapshotRepo:'libs-snapshot-local', server: server
              rtMaven.resolver releaseRepo:'libs-release', snapshotRepo:'libs-snapshot', server: server
              rtMaven.run pom: 'simple_web_app/pom.xml', goals: 'clean install', buildInfo: buildInfo
              buildInfo.retention maxBuilds: 5, maxDays: 3, deleteBuildArtifacts: true
              server.publishBuildInfo buildInfo
            }
          }
        }
        stage ('Docker BUILD') {
          steps {

            script {
              checkout scm
              def customImage = docker.build("kokigit/repo:simple_web_app_${env.BUILD_ID}")
              docker.withRegistry("https://registry.hub.docker.com", 'docker-hub') {
                    customImage.push()
                    customImage.push('latest')
              }
            }
          }
          post {
                success {
                  echo 'pipeline success'
                }
                failure {
                    emailext body: 'Jenkins BUILD success', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "Jenkins BUILD-${env.BUILD_ID} email"                  
                }
          }
        }
    }
}