# Deployment of Battleboat application through the CI/CD Pipeline with security measures

## 1. **Context**
   
   * Deployment of battleboat application through the CI / CD
   
   * Implementation of security measures
   
   * Notification system

## 2. **Tools**
       * AWS cloud: EC2, EKS                                     
       * Source Code Management: Github
       * Build Server: Jenkins 
       * Kustomize
       * Security: Haolint, Sonarqube and Snyk                                         
       * Notification: Slack
       * Continuous delivery: ArgoCD  
       
       
## 3. **Infrastructure**
We wanted to reproduce an enterprise-type infrastructure with 3 servers and EKS

- ** Master Jenkins server:**
A master server Jenkins scheduling build jobs, monitor the target server
- ** Build server:**
A build server(target server) to build our docker images, tests, and scan images
- ** Argocd:**
  Argo CD is an open-source declarative continuous delivery (CD) tool for Kubernetes. It helps automate the deployment of applications to Kubernetes clusters 
  while ensuring the desired state matches the actual state of the cluster. Argo CD uses Git repositories as the source of truth for declarative infrastructure 
  and application definitions.
- ** EKS Cluster:**
Amazon Elastic Kubernetes Service (Amazon EKS) is a managed Kubernetes service provided by Amazon Web Services (AWS). It simplifies the deployment, management, and scaling of containerized applications using Kubernetes on AWS infrastructure. 
- ** Sonarqube server:**
SonarQube is an open-source platform for continuous inspection of code quality

## 4. **Description of tools**
- Terraform infrastructure as code tool used to automate infrastructure in cloud provider. it will help to prvision 3 servers(jenkins,nodebuild and sonarqube) and EKS
- Jenkins is an open-source automation server that facilitates continuous integration (CI) and continuous delivery (CD) of software projects. It enables developers to automate various stages of the software development lifecycle, including building, testing, and deploying applications
- Docker is an open-source platform that automates the deployment, scaling, and management of applications in lightweight, portable containers.
- Dockerhub: registry to store docker imges
- Snyk is a popular developer-first security platform that helps developers find and fix vulnerabilities in their open-source dependencies and container 
  images.Here are some key
- Slack collaborative platform used to notify us of the state of the pipeline
- SonarQube is an open-source platform developed by SonarSource for continuous inspection of code quality. SonarQube does static code analysis, which provides a 
  detailed report of bugs, code smells, vulnerabilities, code duplications.
## 4. **Installation tools** 
- Install Terraform on Windows or linux: https://www.terraform.io/downloads.html
- Install jenkins https://www.jenkins.io/doc/book/installing/linux/
- Install sonarqube https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/install-the-server/
- Create snyk account https://snyk.io/
- Create dockerhub account: https://hub.docker.com/
- ArgoCD: https://argo-cd.readthedocs.io/en/stable/getting_started/
- Kustomize: https://kubectl.docs.kubernetes.io/installation/kustomize/

Automate infrastructure with terraform (Jenkins and sonarqube server, EKS) the code is here https://github.com/.git


### Keywords

```
Docker, Git, Github, Shared library, Jenkins, AWS, Dockerhub, Snyk, Slack, Pull Request, Merge Request, Argocd, Sonarqube, EKS cluster


## 4. **Workflow**

CI/CD pipeleine, we have 4 environments(dev, qa, prepro,pro) and each environment have the pipeline

In order to fully understand the workfow, let's take the following scenario:

- Developer makes a modification to the code from their workstation and pushes it on github

- Thanks to the webhook, the modification is received on the jenkins server and the build of the project can begin
Syntax checks will be done (unit tests) by haodolint on Dockerfile
