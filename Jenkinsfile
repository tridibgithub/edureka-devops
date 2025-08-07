pipeline {
    agent any

    environment {
        TEST_SERVER = 'edureka@172.31.11.34'
        REPO_URL = 'https://github.com/anjali-kumari-ops/projCert.git'
    }

    stages {
        stage('Job 1: Install Puppet Agent') {
            steps {
                sshagent(['test-server-ssh']) {
                    sh """
ssh -o StrictHostKeyChecking=no \$TEST_SERVER 'bash -s' <<'ENDSSH'
wget https://apt.puppet.com/puppet6-release-bionic.deb
sudo dpkg -i puppet6-release-bionic.deb
sudo apt update
sudo apt install puppet-agent -y
ENDSSH
                    """
                }
            }
        }

        stage('Job 2: Install Docker via Ansible') {
            steps {
                sh '''
ansible-playbook ansible/install_docker.yml -i ansible/inventory
                '''
            }
        }

        stage('Job 3: Deploy PHP App in Docker') {
            steps {
                script {
                    try {
                        sshagent(['test-server-ssh']) {
                            sh """
ssh -o StrictHostKeyChecking=no "$TEST_SERVER" <<'EOF'
set -e

if [ ! -d /home/edureka/projCert ]; then
    git clone $REPO_URL /home/edureka/projCert
else
    cd /home/edureka/projCert && git pull
fi

cd /home/edureka/projCert

# Rename DockerFile to Dockerfile if needed
if [ -f DockerFile ]; then
    mv DockerFile Dockerfile
fi

echo "🛠️ Building Docker image..."
sudo docker build -t php-webapp .

echo "📦 Checking available Docker images:"
sudo docker images | grep php-webapp

echo "🧹 Cleaning up old container (if any)..."
sudo docker stop php-webapp || true
sudo docker rm php-webapp || true

echo "🚀 Running new container..."
sudo docker run -d --name php-webapp -p 80:80 php-webapp
EOF
                            """
                        }
                    } catch (err) {
                        echo "❌ Deployment failed — cleaning up container..."
                        sshagent(['test-server-ssh']) {
                            sh """
ssh -o StrictHostKeyChecking=no \$TEST_SERVER 'bash -s' <<'ENDSSH'
sudo docker stop php-webapp || true
sudo docker rm php-webapp || true
ENDSSH
                            """
                        }
                        error("Job 3 failed and container deleted.")
                    }
                }
            }
        }
    }
}
