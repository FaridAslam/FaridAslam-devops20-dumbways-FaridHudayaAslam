pipeline {
   agent any
   environment{
       credential = 'vm'
       server = 'farid18@103.127.134.82'
       directory = '/home/farid18/housy-backend'
       branch = 'main'
       service = 'backend'
       tag = 'latest'
       image = 'faridaslam/backendhousy-baru'
   }
   stages {
       stage('Pull code dari repository'){
         steps {
            sshagent([credential]) {
                sh '''ssh -o StrictHostKeyChecking=no ${server} << EOF
                cd ${directory}
                git pull origin ${branch}
                exit
                EOF'''
               }
           }
       }
       stage('Building application') {
         steps {
            sshagent([credential]) {
                sh '''ssh -o StrictHostKeyChecking=no ${server} << EOF
                cd ${directory}
                docker build -t ${image}:${tag} .
                exit
                EOF'''
               }
           }
       }
       stage('Testing application') {
         steps {
            sshagent([credential]) {
                sh '''ssh -o StrictHostKeyChecking=no ${server} << EOF
                cd ${directory}
                docker run --name test_be -p 5000:5000 -d ${image}:${tag}
                wget --spider localhost:5000
                docker stop test_be
                docker rm test_be
                exit
                EOF'''
               }
           }
       }
       stage('Deploy aplikasi on top docker'){
         steps {
            sshagent([credential]) {
                sh '''ssh -o StrictHostKeyChecking=no ${server} << EOF
                sed -i '22c\\ image: ${image}:${tag}' docker-compose.yaml
                docker compose up -d
                cd ${directory}
                exit
                EOF'''
               }
           }
       }
       stage('Push image to docker hub'){
         steps {
            sshagent([credential]) {
                sh '''ssh -o StrictHostKeyChecking=no ${server} << EOF
                cd ${directory}
                docker push ${image}:${tag}
                exit
                EOF'''
               }
           }
       }
       stage('send notification to discord'){
         steps {
            discordSend description: "backend-team1 notify", footer: "team1 notify", link:
env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "https://discord.com/api/webhooks/1240153059674423326/XjUW5UpIS4XJoCmyK-6amPN7Ap3H_cfgKf2L2-SpsHmGv1fx3g-Kr6Xg0BnWYeVP_ZYB"
             } 
          }
       }
    }
