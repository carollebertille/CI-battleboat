Deployment of Bttleboat application
Context
Deployment of Battleboat application through the CI/CD Pipeline with security measures
Tools
Cloud: AWS, (EC2, EKS)
Container Engine: Docker
Source Code Management: Github
Scheduling: Jenkins
Security: Haolint, Sonarqube and Snyk
Notification: Slack
Continuous delivery: ArgoCD
#### Infrastructure
We wanted to reproduce an enterprise-type infrastructure with 3 servers and EKS

A master server Jenkins scheduling build jobs, monitor the slave
A build server(slave) to build our docker images, tests, and scan images
EKS  to deploy our web application which can be consumed of production.
Sonarqube server: Static Code Analysis
Snyk: scan docker images
Choice and description of tools
Terraform infrastructure as code tool used to automate infrastructure in cloud provider. it will help to prvision 3 servers(jenkins,nodebuild and sonarqube) and EKS
Jenkins is an open-source automation server that facilitates continuous integration (CI) and continuous delivery (CD) of software projects. It enables developers to automate various stages of the software development lifecycle, including building, testing, and deploying applications
Using Docker to containerize hello world application
Dockerhub: registry to store docker imges
Snyk is a popular developer-first security platform that helps developers find and fix vulnerabilities in their open-source dependencies and container images.Here are some key
Dependency scanning
Container image scanning
Fix suggestions and remediation
Slack collaborative platform used to notify us of the state of the pipeline
SonarQube is an open-source platform developed by SonarSource for continuous inspection of code quality. SonarQube does static code analysis, which provides a detailed report of bugs, code smells, vulnerabilities, code duplications.
### Installation tools
Install Terraform on Windows or linux: https://www.terraform.io/downloads.html
Create Google account: https://cloud.google.com/docs/get-started
install jenkins https://www.jenkins.io/doc/book/installing/linux/
install sonarqube https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/install-the-server/
create snyk account https://snyk.io/
Create dockerhub account: https://hub.docker.com/

Automate infrastructure with terraform (Jenkins and sonarqube server, EKS) the code is here https://github.com/carolledevops/Helloworld.git

