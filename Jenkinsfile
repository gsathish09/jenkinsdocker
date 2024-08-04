pipeline {
    agent none

    tools{
        jdk 'myjava' // in global tool configuration of jenkins we have installed java of the specific version
        maven 'mymaven'
    }

    parameters{
         
        string(name:'Env',defaultValue:'Test',description:'version to deploy')
        booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])
    
    }
    environment{
        DEV_SERVER='ec2-user@172.31.36.146'
        IMAGE_NAME='sathishgunasekaran/java-mvn-privaterepos:$BUILD_NUMBER'
        DEPLOY_SERVER='ec2-user@172.31.42.92'
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                echo "Compiling the Code in ${params.Env}"
                sh "mvn compile"
                
            }
        }
        stage('UnitTest') {
            agent any
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps {
              
                echo 'Test the Code'
                sh "mvn test"
            }
            
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }


        stage('Dockerize and push the image') {
            agent any
           steps {
                 script{
                sshagent(['slave2']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                echo "Dockerize the Code ${params.APPVERSION}"
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER} bash /home/ec2-user/server-script.sh"
                sh "ssh ${DEV_SERVER} sudo docker build -t ${IMAGE_NAME} ."
                sh "ssh ${DEV_SERVER} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                sh "ssh ${DEV_SERVER} sudo docker push ${IMAGE_NAME}"
                    }
            }
        }
    }
        }

        stage('Provision the server with TF'){
            environment{
                AWS_ACCESS_KEY_ID = credentials("jenkins_aws_access_key_id") // 'jenkins_aws_access_key_id is the credential name that is given in jenkins credentials manager'
                AWS_SECRET_ACCESS_KEY=credentials("jenkins_aws_secret_access_key")
            }
            agent any
            steps{
                script{
                    echo "RUN the TF code"
                    dir('terraform'){
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                     EC2_PUBLIC_IP=sh(
                        script: "terraform output ec2-ip",
                        returnStdout:true
                     ).trim()    
                    }
                }
            }
        }
        



        stage('Deploy on EC2 instance created by TF') {
        agent any
           steps {
                script{
                echo "Deploying on the instance"
                echo "${EC2_PUBLIC_IP}"    
                sshagent(['slave2']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                //echo "Dockerize the Code ${params.APPVERSION}"
                //sh "scp -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} docker login -u ${USERNAME} -p ${PASSWORD}"
                sh "ssh ec2-user@${EC2_PUBLIC_IP} docker run -itd -p 8080:8080 ${IMAGE_NAME}"
                //sh "ssh ${DEV_SERVER} sudo docker push ${IMAGE_NAME}"
                    }
            }
        }
    }
        }



    //     stage('Dockerize and push the image') {
    //         agent any
    //        steps {
    //              script{
    //             sshagent(['slave2']) {
    //             withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
    //             echo "Dockerize the Code ${params.APPVERSION}"
    //             sh "scp -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER}:/home/ec2-user"
    //             sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER} bash /home/ec2-user/server-script.sh"
    //             sh "ssh ${DEV_SERVER} sudo docker build -t ${IMAGE_NAME} ."
    //             sh "ssh ${DEV_SERVER} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
    //             sh "ssh ${DEV_SERVER} sudo docker push ${IMAGE_NAME}"
    //                 }
    //         }
    //     }
    // }
    //     }

    //      stage('Run the docker image') {
    //         agent any
    //         // input{
    //         //     message "Select the version to deploy"
    //         //     ok "Version Selected"
    //         //     parameters{
    //         //         choice(name:'NEWAPP',choices:['1.1','1.2','1.3'])
    //         //     }
            
    //         // }
    //         steps {
    //              script{
    //             sshagent(['slave2']) {
    //             withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
    //             echo "Run the docker container"
    //             sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} sudo yum install docker -y"
    //            sh "ssh ${DEPLOY_SERVER} sudo systemctl start docker"
    //            sh "ssh ${DEPLOY_SERVER} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
    //            sh "ssh ${DEPLOY_SERVER} sudo docker run -itd -p 8080:8080 ${IMAGE_NAME}"
    //                 }
    //         }
    //     }
    // }
    //     }
        
    //     stage('RUN K8S MANIFEST'){
    //         agent any
    //            steps{
    //             script{
    //                 echo "Run the k8s manifest file"
    //                 sh 'envsubst < k8s-manifests/java-mvn-app.yaml | sudo kubectl apply -f -'
    //             }
    //            } 
    //     }

    // }


}
}

