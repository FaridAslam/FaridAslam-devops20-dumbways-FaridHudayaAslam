# Tugas Jenkins

## CICD using JENKINS

Disini saya akan menginstall jenkins dengan menggunakan docker compose.

Langkah pertama yaitu buat folder baru bernama jenkins. Lalu masuk ke dalam folder tersebut dan buat file baru bernama docker-compose.yaml

```
mkdir jenkins; cd jenkins; nano docker-compose-jenkins.yaml
```

bisa juga di gabung di luar seperti docker.compose.yaml yg sudah dibuat sebelum nya.

Masukkan script ini kedalamnya:
```
version: '3.8'

services:
  jenkins:
    image: jenkins/jenkins:lts
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_data:/var/jenkins_home

volumes:
  jenkins_data:

```
Selanjutnya jalankan command berikut
```
docker compose up -d atau docker compose -f docker-compose-jenkins.yaml up -d
```
![image](./image/vimjenkins.png)

Jika sudah, cek apakah jenkins berjalan
```
docker compose ps -a
```

Akses servernya menggunakan browser dengan menggunakan port 8080, jika muncul seperti ini maka sudah berhasil

![image](./image/cek%20jenkins.png)

Selanjutnya, masuk ke bash dari jenkins

```
docker compose exec -it jenkins:(tag) bash
```

Lalu jalankan command berikut
```
cat /var/jenkins_home/secrets/initialAdminPassword
```
![image](./image/cat%20code%20jenkins.png)

Copy paste password tersebut ke browser tadi, lalu klik continue

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/5c0ad945-3cc6-4b33-ad69-d88c48a692ac)

Pilih yang ```install suggested plugins```

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/1e180de0-c7f7-4754-9e56-baf7aec64148)

Lalu tunggu sampai proses setup selesai

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/2e79aa31-cf42-436b-94e5-0febebce8bc8)

Selanjutnya, buat akun admin lalu Klik Save and Continue

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/cd25978a-0a2b-43d4-afcd-cbe9f286f8a3)

Proses setup selesai

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/2f508f22-d290-47e9-a501-e8bbc09b3d0a)



Selanjutnya, masuk ke cloudflare dan buat subdomain baru dengan mempointing ke ip webserver

![image](./image/cloudflare.png)

Di webserver, buat konfigurasi baru untuk subdomain jenkins

![image](./image/vim%20conf.png)

Masukkan script konfigurasi berikut

```
upstream jenkins {
  keepalive 32; # keepalive connections
  server 103.127.134.82:8080; # ip address + port server jenkins
}

# Required for Jenkins websocket agents
map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}

server {
  listen          80;       # Listen on port 80 for IPv4 requests
  listen 443 ssl;
  ssl_certificate /etc/letsencrypt/live/farid.studentdumbways.my.id/fullchain.pem; # lokasi ssl cert
  ssl_certificate_key /etc/letsencrypt/live/farid.studentdumbways.my.id/privkey.pem; # lokasi ssl cert

  server_name     pipeline.farid.studentdumbways.my.id;  # subdomain yang tadi

  # this is the jenkins web root directory
  # (mentioned in the output of "systemctl cat jenkins")
  root            /var/run/jenkins/war/;

  access_log      /var/log/nginx/jenkins.access.log;
  error_log       /var/log/nginx/jenkins.error.log;

  # pass through headers from Jenkins that Nginx considers invalid
  ignore_invalid_headers off;

  location ~ "^/static/[0-9a-fA-F]{8}\/(.*)$" {
    # rewrite all static files into requests to the root
    # E.g /static/12345678/css/something.css will become /css/something.css
    rewrite "^/static/[0-9a-fA-F]{8}\/(.*)" /$1 last;
  }

  location /userContent {
    # have nginx handle all the static requests to userContent folder
    # note : This is the $JENKINS_HOME dir
    root /var/lib/jenkins/;
    if (!-f $request_filename){
      # this file does not exist, might be a directory or a /**view** url
      rewrite (.*) /$1 last;
      break;
    }
    sendfile on;
  }

  location / {
      sendfile off;
      proxy_pass         http://jenkins;
      proxy_redirect     default;
      proxy_http_version 1.1;

      # Required for Jenkins websocket agents
      proxy_set_header   Connection        $connection_upgrade;
      proxy_set_header   Upgrade           $http_upgrade;

      proxy_set_header   Host              $http_host;
      proxy_set_header   X-Real-IP         $remote_addr;
      proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
      proxy_max_temp_file_size 0;

      #this is the maximum upload size
      client_max_body_size       10m;
      client_body_buffer_size    128k;

      proxy_connect_timeout      90;
      proxy_send_timeout         90;
      proxy_read_timeout         90;
      proxy_request_buffering    off; # Required for HTTP CLI commands
  }

}
```


Simpan lalu reload webserver nginx
```
docker compose exec webserver nginx -s reload
```

Selanjutnya ke jenkins -> Manage Jenkins -> System

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/62dce9ce-7098-4a5b-96f8-3d1ece1fb687)

Pastikan di bagian ```Jeknins URL``` sudah sesuai. Lalu Apply & Save.

![image](./image/locationjenkins.png)

Selanjutnya ke Plugins -> Available Plugins -> cari ```SSH Agent``` -> Install

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/bcc039c2-2e55-455b-8a25-4a6c1895cbce)

Jika terdapat error, Install ulang pluginnya sampai berhasil. Dan pastikan ceklist pada ```Restart Jenkins when installation is complete...```

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/e6a2300f-3be2-4602-afe4-21c599eea567)

Satu lagi install Plugin ```Discord Notifier```. Caranya sama seperti tadi.

Kembali ke Manage Jenkins -> Credentials

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/c802ddb5-5ca2-4615-b860-66c2ef8f04b5)

Lalu pilih ```Add Credentials```

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/98f47676-3fb7-4461-915c-c4c3e0adcfa1)

- Pada bagian Kind, pilih ```SSH Username with private key```.
- Pada bagian ID, masukan id yang nantinya akan dipakai pada file Jenkinsfile.
- Pada bagian Username, masukkan username dari server backend.

![image](./image/sshidjenkins.png)

- Pada bagian Privat Key, Klik ```Enter Directly``` Lalu klik ```Add```. Masukkan privat key dari server backend.

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/3229f231-b365-4333-b4cd-26664b981b09)

Jika sukses, akan tampil seperti ini.

![image](./image/globalsshjenkins.png)

Masuk ke github, lalu tambahkan Public key dari ssh tadi.
Ke Settings -> SSH and GPG keys -> New SSH Key.

![image](./image/sshgithub.png)

Masukkan Public keynya lalu klik ```Add SSH Key```.

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/8ef840b7-1fed-435d-a9ab-555896be1fac)

Jika sudah, tes koneksi ke github.
```ssh -T git@github.com```

![image](./image/ceksshgithub.png)

Selanjutnya buat repository baru di github.

Jika sudah dibuat, jalankan command berikut.
```
git config --global user.email "alamat email" && git config --global user.name "username github"
```
![image](./image/gitconfig.png)


Selanjutnya pergi ke folder wayshub-backend dan buat file baru dengan nama Jenkinsfile. Berikut adalah isi dari file Jenkinsfile. Silahkan edit sesuai kebutuhan
```
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

```

Jika sudah simpan dan jalankan command berikut, sesuaikan dengan nama branch dan repository yang barusan dibuat.
```
git remote set-url branch git-repo && git add .
```
![image](./image/gitremote.png)

```
git commit -m "chore: Adding Jenkins and Docker" && git push origin main
```
Cek kembali repository tadi.

![image](./image/repogithub.png)

Ke Dashboard Jenkins. Klik ```New Item```.

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/255a215b-84b3-4aeb-bb1a-4308ab6dccc7)

Masukkan nama yang diinginkan, lalu pilih yang ```Pipeline``` -> Klik OK.

![image](./image/newitemjenkins.png)

Ceklist pada bagian ```GitHub hook triger for GITScm polling.```

Scroll kebawah,
- Pada bagian Definition ganti menjadi ```Pipeline script from SCM```
- Pada bagian SCM ganti menjadi ```Git```
- Pada bagian Repository, masukkan alamat repository tadi.
- Pada bagian Credentials, pilih credentials yang barusan dibuat.

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/13996710-afae-4361-83ed-62a3909f230a)

Scroll kebawah lagi, Sesuaikan untuk branch dan Script path.

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/97ea377d-493f-4668-8dba-1fc392407a59)

Jika sudah, coba untuk menjalankannya dengan klik ```Build Now```.

![image](https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/eec0fc0f-87d0-468f-8842-29a34797c279)

Jika sukses tanpa error, akan tampil seperti ini, jika ada error cek kembali file ```Jenkinsfile``` tadi.

![image](./image/hasil%20jenkins.png)


Selanjutnya ke github repository tadi, lalu Klik ```Settings```.

Ke bagian Webhook -> Add webhook.

Masukkan Payload URL dengan alamat URL dari jenkins + ditambah ```/github-webhook```. Lalu klik Add Webhook.

![image](./image/webhook.png)

Jika sudah, coba buat perubahan pada backend dan push kembali ke github.

Lalu cek lagi di jenkins, maka proses build sudah otomatis berjalan ketika user push ke github.
