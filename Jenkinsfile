pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        ECR_REPOSITORY = '832031329569.dkr.ecr.us-east-1.amazonaws.com/sprints-ecr'
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t project_main /var/lib/jenkins/workspace/project_main/'
                sh "docker tag project_main $ECR_REPOSITORY:$BUILD_NUMBER"
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
                        sh "sed -i 's|<IMAGE-NAME>|$ECR_REPOSITORY:$BUILD_NUMBER|g' /var/lib/jenkins/workspace/project_main/deployment-flaskapp.yml"
                        try {
                            sh "kubectl create configmap mysql-queries-configmap --from-file=/var/lib/jenkins/workspace/project_main/MySQL_Queries/BucketList.sql"
                            echo "ConfigMap 'mysql-queries-configmap' created successfully."
                        } catch (Exception e) {
                            echo "ConfigMap 'mysql-queries-configmap' already exists: ${e.getMessage()}"
                        }
                        
                    sh "kubectl apply -f /var/lib/jenkins/workspace/project_main/mysql-configmap.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/project_main/mysql-secret.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/project_main/mysql-statefulset.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/project_main/mysql-service.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/project_main/deployment-flaskapp.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/project_main/service-app.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/project_main/ingress.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/project_main/mysql-pv.yml"
                    sh "kubectl apply -f /var/lib/jenkins/workspace/project_main/mysql-pvc.yml"
                    }
                }
            }
        }
    }
}
