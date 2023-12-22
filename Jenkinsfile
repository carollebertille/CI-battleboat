@Library('jenkins-shared-library')_
pipeline {
    agent any 
    options {
        buildDiscarder(logRotator(numToKeepStr:'2'))
        disableConcurrentBuilds()
        timeout (time: 60, unit: 'MINUTES')
        timestamps()
      }
     parameters {
        choice(
            choices: ['DEV', 'SANDBOX', 'PROD'], 
            name: 'Environment'
          )
    }
    environment {
        IMAGE_NAME = "battleboat"
        DOCKERHUB_ID = "edennolan2021"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DEV_VERSION="0.0.${BUILD_NUMBER}"
        STAGE_VERSION="0.0.${BUILD_NUMBER}"
        RC_VERSION="1.0.${BUILD_NUMBER}"
    }
    stages {
        /*stage('SonarQube analysis') {
           when{  
            expression {
              params.Environment == 'DEV' }
              }
               environment {
                  scannerHome = tool 'Sonar'
               }
             steps {
                   script {
                       withSonarQubeEnv('SonarCloud') {
                          sh "${scannerHome}/bin/sonar-scanner"
                       }
                   }
            }
        }

        stage("Quality Gate") {
            steps {
                // Wait for the SonarQube quality gate
                waitForQualityGate abortPipeline: true
            }
        }*/
        stage('Build image') {
           when{  
            expression {
              params.Environment == 'DEV' }
              }
            steps {
                script {
                    sh '''
                     docker build -t ${DOCKERHUB_ID}/$IMAGE_NAME:$DEV_VERSION .
                    '''
                }
            }
        }
        /*stage('Scan Image with  SNYK') {
            agent any
            environment{
                SNYK_TOKEN = credentials('snyktoken')
            }
            steps {
                script{
                    sh '''
                    echo "Starting Image scan $DOCKERHUB_ID/$IMAGE_NAME:${BUILD_NUMBER} ..." 
                    echo There is Scan result : 
                    SCAN_RESULT=$(docker run --rm -e SNYK_TOKEN=$SNYK_TOKEN -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/app snyk/snyk:docker snyk test --docker $DOCKERHUB_ID/$IMAGE_NAME:${BUILD_NUMBER} --json ||  if [ $? -gt "1" ];then echo -e "Warning, you must see scan result \n" ;  false; elif [ $? -eq "0" ]; then   echo "PASS : Nothing to Do"; elif [ $? -eq "1" ]; then   echo "Warning, passing with something to do";  else false; fi)
                    echo "Scan ended"
                    '''
                }
            }
        }*/
        stage('Login Dockerhub') {
            steps {
                script {
                    sh '''
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_ID --password-stdin
                      '''
                }
            }
        }
         stage('Remove image in the local') {
           when{  
            expression {
              params.Environment == 'DEV' }
              }
            steps {
                script {
                    sh '''
                        docker push $DOCKERHUB_ID/$IMAGE_NAME:$DEV_VERSION
                      '''
                }
            }
        }
         stage('Package DEV') {
            steps {
                script {
                    sh '''
                        docker rmi $DOCKERHUB_ID/$IMAGE_NAME:$DEV_VERSION
                      '''
                }
            }
        }
         stage('Package SANDBOX') {
           when{  
            expression {
              params.Environment == 'SANDBOX' }
              }
            steps {
                script {
                    sh '''
                        docker pull $DOCKERHUB_ID/$IMAGE_NAME:$DEV_VERSION
                        docker tag $DOCKERHUB_ID/$IMAGE_NAME:$DEV_VERSION $DOCKERHUB_ID/$IMAGE_NAME:$STAGE_VERSION
                        docker push $DOCKERHUB_ID/$IMAGE_NAME:$STAGE_VERSION
                      '''
                }
            }
        }
        stage('Package PROD') {
           when{  
            expression {
              params.Environment == 'PROD' }
              }
            steps {
                script {
                    sh '''
                        docker pull $DOCKERHUB_ID/$IMAGE_NAME:$DEV_VERSION
                        docker tag $DOCKERHUB_ID/$IMAGE_NAME:$DEV_VERSION $DOCKERHUB_ID/$IMAGE_NAME:$RC_VERSION
                        docker push $DOCKERHUB_ID/$IMAGE_NAME:$RC_VERSION
                      '''
                }
            }
        }
        stage('Deploy DEV') {
            steps {
                git branch: 'main', url: 'git@github.com:carollebertille/deployment-battleboat.git'
                sh "git config --global user.email 'carolle.matchum@yahoo.com' && git config --global user.name 'carollebertille'"
                sh "git checkout main"
                sh "cd ./overlays/dev/battleboat && kustomize edit set image $DOCKERHUB_ID/$IMAGE_NAME:$DEV_VERSION"
                sh "git commit -am 'Publish new dev release' && git push origin main:main || echo 'no change'"
            }
        }
        stage('Deploy SANDBOX') {
            steps {
                sh "git checkout main"
                sh "cd ./overlays/sandbox/battleboat && kustomize edit set image $DOCKERHUB_ID/$IMAGE_NAME:$STAGE_VERSION"
                sh "git commit -am 'Publish new sandbox release' && git push origin main:main || echo 'no change'"
            }
        }
        stage('Deploy PROD') {
            steps {
                sh "git checkout main"
                sh "cd ./overlays/prod/battleboat && kustomize edit set image $DOCKERHUB_ID/$IMAGE_NAME:$RC_VERSION"
                sh "git commit -am 'Publish new sandbox release' && git push origin main:main || echo 'no change'"
            }
        }
        stage('Argocd') {
            steps {
                sh "Wait for argocd"
            }
        }
        

 }
}
