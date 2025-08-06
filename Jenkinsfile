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
                            ssh -o StrictHostKeyChecking=no "$TEST_SERVER" <<EOF
                            if [ ! -d /tmp/projCert ]; then
                                git clone $REPO_URL /tmp/projCert
                            else
                                cd /tmp/projCert && git pull
                            fi

                            cd /tmp/projCert

                            sudo docker build -t php-webapp .
                            sudo docker stop php-webapp || true
                            sudo docker rm php-webapp || true
                            sudo docker run -d --name php-webapp -p 80:80 php-webapp
                        EOF
                            """
                        }
                    } catch (err) {
                        echo "Deployment failed — cleaning up container..."
                        sshagent(['test-server-ssh']) {
                            sh """
                            ssh -o StrictHostKeyChecking=no \$TEST_SERVER 'bash -s' <<'ENDSSH'
                                docker stop php-webapp || true
                                docker rm php-webapp || true
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
