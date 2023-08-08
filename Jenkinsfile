pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        ECR_REPOSITORY = '832031329569.dkr.ecr.us-east-1.amazonaws.com/sprints-ecr'
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t final-project /var/lib/jenkins/workspace/final-project/'
                sh "docker tag final-project $ECR_REPOSITORY:$BUILD_NUMBER"
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'aws-cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_REPOSITORY"
                        sh "docker push $ECR_REPOSITORY:$BUILD_NUMBER"
                    }
                }
            }
        }
        
        stage('Deployment Stage') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'aws-cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh "aws eks --region us-east-1 update-kubeconfig --name my-eks-cluster"
                        sh "sed -i 's|<IMAGE-NAME>|$ECR_REPOSITORY:$BUILD_NUMBER|g' /var/lib/jenkins/workspace/final-project/deployment-flaskapp.yml"
                        try {
                            sh "kubectl create configmap mysql-queries-configmap --from-file=/var/lib/jenkins/workspace/final-project/MySQL_Queries/BucketList.sql"
                            echo "ConfigMap 'mysql-queries-configmap' created successfully."
                        } catch (Exception e) {
                            echo "ConfigMap 'mysql-queries-configmap' already exists: ${e.getMessage()}"
                        }
                        
                    sh "kubectl apply -f /var/lib/jenkins/workspace/final-project/mysql-configmap.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/final-project/mysql-secret.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/final-project/mysql-statefulset.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/final-project/mysql-service.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/final-project/deployment-flaskapp.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/final-project/service-app.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/final-project/ingress.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/final-project/mysql-pv.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/final-project/mysql-pvc.yml"
                    }
                }
            }
        }
    }
}