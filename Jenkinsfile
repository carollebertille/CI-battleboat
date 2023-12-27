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
            choices: ['DEV', 'QA','SANDBOX', 'PROD'], 
            name: 'Environment'
          )
        string(
            defaultValue: '0.0.0',
            name: 'tag',
            description: '''Please enter dev image tag to be used''',
         )
    }
    environment {
        IMAGE_NAME = "battleboat"
        DOCKERHUB_ID = "edennolan2021"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    stages {
        stage('SonarQube analysis') {
           when{  
            expression {
              params.Environment == 'DEV' }
              }
               agent {
                 docker {
                 image 'sonarsource/sonar-scanner-cli:4.8'
                 }
             }
               environment {
                 CI = 'true'
                  scannerHome='/opt/sonar-scanner'
            }
             steps{
               withSonarQubeEnv('Sonar') {
                 sh "${scannerHome}/bin/sonar-scanner"
                }
              }
            }

        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true }
            }
        }
        stage('Build image') {
           when{  
            expression {
              params.Environment == 'DEV' }
              }
            steps {
                script {
                    sh '''
                     docker build -t ${DOCKERHUB_ID}/$IMAGE_NAME:$tag .
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
                    SCAN_RESULT=$(docker run --rm -e SNYK_TOKEN=$SNYK_TOKEN -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/app snyk/snyk:docker snyk test --docker $DOCKERHUB_ID/$IMAGE_NAME:$dev_tag --json ||  if [ $? -gt "1" ];then echo -e "Warning, you must see scan result \n" ;  false; elif [ $? -eq "0" ]; then   echo "PASS : Nothing to Do"; elif [ $? -eq "1" ]; then   echo "Warning, passing with something to do";  else false; fi)
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
         stage('Package DEV') {
           when{  
            expression {
              params.Environment == 'DEV' }
              }
            steps {
                script {
                    sh '''
                        docker push $DOCKERHUB_ID/$IMAGE_NAME:$tag
                      '''
                }
            }
        }
         stage('Pull and tag image QA') {
           when{  
            expression {
              params.Environment == 'QA' }
              }
            steps {
                script {
                    sh '''
                        docker pull $DOCKERHUB_ID/$IMAGE_NAME:$tag
                        docker tag $DOCKERHUB_ID/$IMAGE_NAME:$dev_tag $DOCKERHUB_ID/$IMAGE_NAME:$tag-1
                        
                      '''
                }
            }
        }
         stage('Pull and tag image SANDBOX') {
           when{  
            expression {
              params.Environment == 'SANDBOX' }
              }
            steps {
                script {
                    sh '''
                        docker pull $DOCKERHUB_ID/$IMAGE_NAME:$qa_tag
                        docker tag $DOCKERHUB_ID/$IMAGE_NAME:$qa_tag $DOCKERHUB_ID/$IMAGE_NAME:$tag-2
                        
                        
                      '''
                }
            }
        }
        /*stage('Pull and tag image PROD') {
           when{  
            expression {
              params.Environment == 'PROD' }
              }
            steps {
                script {
                    sh '''
                        docker pull $DOCKERHUB_ID/$IMAGE_NAME:$sandbox_tag
                        docker tag $DOCKERHUB_ID/$IMAGE_NAME:$sandbox_tag $DOCKERHUB_ID/$IMAGE_NAME:$prod_tag
                        
                      '''
                }
            }
        }
        stage('Update DEV manifest') {
         when{  
            expression {
              params.Environment == 'DEV' }
              }
            steps {
              sh '''
                git clone git@github.com:carollebertille/deployment-battleboat.git
                git config --global user.email 'carolle.matchum@yahoo.com' && git config --global user.name 'carollebertille'
                cd ./overlays/dev/battleboat && kustomize edit set image $DOCKERHUB_ID/$IMAGE_NAME:$dev_tag
                git commit -am 'Publish new dev release' && git push
              '''
            }
        }
       stage('Update QA manifest') {
          when{  
            expression {
              params.Environment == 'QA' }
              }
            steps {
                sh '''
                git clone git@github.com:carollebertille/deployment-battleboat.git
                git config --global user.email 'carolle.matchum@yahoo.com' && git config --global user.name 'carollebertille'
                cd ./overlays/dev/battleboat && kustomize edit set image $DOCKERHUB_ID/$IMAGE_NAME:$qa_tag
                git commit -am 'Publish new dev release' && git push
              '''
            }
        } 
        stage('Update sandbox manifest') {
          when{  
            expression {
              params.Environment == 'SANDBOX' }
              }
            steps {
                sh '''
                git clone git@github.com:carollebertille/deployment-battleboat.git
                git config --global user.email 'carolle.matchum@yahoo.com' && git config --global user.name 'carollebertille'
                cd ./overlays/dev/battleboat && kustomize edit set image $DOCKERHUB_ID/$IMAGE_NAME:$sandbox_tag
                git commit -am 'Publish new dev release' && git push
              '''
            }
        }
        stage('Update PROD manifest') {
          when{  
            expression {
              params.Environment == 'PROD' }
              }
            steps {
                sh '''
                git clone git@github.com:carollebertille/deployment-battleboat.git
                git config --global user.email 'carolle.matchum@yahoo.com' && git config --global user.name 'carollebertille'
                cd ./overlays/dev/battleboat && kustomize edit set image $DOCKERHUB_ID/$IMAGE_NAME:$prod_tag
                git commit -am 'Publish new dev release' && git push
              '''
            }
        }
        stage('Argocd') {
            steps {
                sh "Wait for argocd"
            }
        }*/
        

 }
 post {
    always {
       script {
         /* Use slackNotifier.groovy from shared library and provide current build result as parameter */
         clean
         slackNotifier currentBuild.result
     }
    }
    }  
}
