pipeline {
    agent any
    stages {
        stage('Initialize Git POLL SCM Feature') {
            steps {
                //enable remote triggers
                script {
                    properties([[$class: 'GithubProjectProperty', displayName: '', projectUrlStr: 'https://github.com/tejnal0999/Tej_Industry_Grade_Project1.git/'], pipelineTriggers([pollSCM('*/5 * * * * ')])])
                }
            }
        }

	    stage('Git project checkout') {
           steps {
               git branch: 'main', url: 'https://github.com/tejnal0999/Tej_Industry_Grade_Project1.git'
           }
        }

        stage('Compile') {
            steps {
                sh  'mvn compile'
            }
        }


        stage('UnitTesting') {
            steps{
                sh 'mvn test'
            }
            post{
                success{
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Build Application') {
            steps {
                sh 'mvn clean install'
            }
            post {
                success {
                    echo "Now Archiving the Artifacts...."
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }
	    stage('Clean Existing Images and Stop and remove Running container') {
            steps {
		        catchError (buildResult:'SUCCESS', stageResult: 'FAILURE') {
			        sh "docker images"
			        sh "docker container ls"
                    sh "docker container stop edurekaapp"
			        sh "docker rm -f edurekaapp"
			        sh "docker image rm -f tejnal/edurekaapp"
		        }
            }
        }
        stage('Docker Build and Tag') {
           steps {
                sh 'docker build -t edurekaapp:latest .'
                sh 'docker tag edurekaapp tejnal/edurekaapp:latest'
           }
        }

        stage('Publish image to Docker Hub') {

            steps {
                withDockerRegistry([ credentialsId: "dockerHub", url: "" ]) {
                    sh  'docker push tejnal/edurekaapp:latest'
                }
            }
        }

        stage('Run Docker container') {
            steps {
                sh "docker run --name edurekaapp -d -p 9090:8080 tejnal/edurekaapp"
            }
        }
    }
}