pipeline{
    agent { label 'testserver'}
    stages('Deploy a PHP application'){
        stage('Build a Docker Image'){
            steps{
               sh 'docker build -t divyame91/mylearnings24:phpwebapp .'
            }
        }
        stage('Run Docker Container'){
            steps{
                sh 'docker run -dit --name php -p 80:80 divyame91/mylearnings24:phpwebapp'
            }
        }
    }
     post {
        failure {
            steps {
                echo "Job failed. Cleaning up non-running Docker containers..."
                sh 'docker container prune -f'
            }
        }
}
}
