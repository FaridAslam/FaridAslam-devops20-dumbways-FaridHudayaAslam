# DAILY TASK - DAY 2 - WEEK 2

## CICD Using GitlabCI

Login ke akun gitlab, lalu pilih Group -> New group

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/8e573c71-21f8-464e-9a7c-3994b2da66af" width="50%" />

Pada bagian group name isi nama yang diinginkan, dan pastikan Visibility level adalah ```Public```.

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/61ef371f-15b8-4ae0-8b74-2013422cdcca" width="50%" />

Selanjutnya, bisa sesuaikan dengan kebutuhan...

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/84421989-9a2e-4fad-8a65-8ce60781adc8" width="50%" />

Jika sudah terbuat, buat project baru dengan mengklik ```Create new project```.

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/58cebef9-88d8-478f-bae1-fe9bbb615e13" width="50%" />

Pilih ```Create blank project```.

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/ca4978e6-29d1-4ddd-8aa3-4c6c2a861cfb" width="50%" />

Project name isi nama project yang nantinya akan dijadikan sebagai alamat repository. Dan pada bagian ```Visibility Level``` pastikan ganti ke ```Public```.

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/58e28ca4-3217-48d4-9772-7d37dc0b8cf3" width="50%" />

Jika sudah dibuat, maka akan muncul seperti ini.

<img src=images/muncul.png/>

Selanjutnya Klik ```Preferences```.

<img src=images/pref.png/>

Lalu Klik ```SSH Keys``` -> ```Add new key```

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/0eebe32d-2cf9-415e-bbec-02d3b2146cce" width="50%" />

Disini masukkan public key dari server frontend.

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/0201e7e6-8f51-4c6c-87df-575b413c98b7" width="50%" />

Jika sudah, masuk ke server frontend dan lakukan test koneksi ssh.
```
ssh -T git@gitlab.com
```
<img src=images/cekssh.png/>

Selanjutnya masuk ke folder dimana server frontend berada.

<img src=images/masukdir.png/>

Jalankan command berikut. Sesuaikan username dan emailnya.
```
git config --global user.name "Team 2" && git config --global user.email "email@gmail.com"
```

Jika sudah, Lakukan initialisasi dan push ke gitlab repository.
```
git init && git remote add origin git@gitlab.com:your_group/your_repo.git && git add . && git commit -m "Initial commit" && git push origin main
```

Cek kembali repository yang barusan dibuat.

<img src=images/cekdir.png/>

Kembali lagi ke directory server frontend, lalu buat file dengan nama ```.gitlab-ci.yml```

<img src=images/vimgitlab.png/>

Kemudian, masukkan script berikut. Sesuaikan dengan keperluan.
```
stages:
  - pull
  - build
  - test
  - deploy
  - push
variables:
  GIT_REPOSITORY: "https://gitlab.com/faridaslam1/frontendfarid.git"
  GIT_BRANCH: "main"

pull:
  stage: pull
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - mkdir -p ~/.ssh
    - echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
    - chmod 600 ~/.ssh/id_rsa
  script:
    - ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $USERNAME@$BUILD_HOST "
       cd $WORKDIR &&
       git pull"

build:
  stage: build
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - mkdir -p ~/.ssh
    - echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
    - chmod 600 ~/.ssh/id_rsa
  script:
    - ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $USERNAME@$BUILD_HOST "
        cd $WORKDIR &&
        docker build -t $DOCKER_IMAGE . "
  dependencies:
    - pull

test:
  stage: test
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - mkdir -p ~/.ssh
    - echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
    - chmod 600 ~/.ssh/id_rsa
  script:
    - ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $USERNAME@$BUILD_HOST "
        docker run -d -p 3005:3000 --name testconn $DOCKER_IMAGE &&
        if wget -q --spider http://127.0.0.1:3005/; then echo 'Website up'; else echo 'Website down'; fi &&
        docker stop testconn &&
        docker rm testconn"


deploy:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - mkdir -p ~/.ssh
    - echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
    - chmod 600 ~/.ssh/id_rsa
  script:
    - ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $USERNAME@$BUILD_HOST "
        cd $DEPLOY_DIR &&
        docker compose -f docker-compose-frontend.yaml down &&
        docker compose -f docker-compose-frontend.yaml up -d"
  dependencies:
    - build
```

Jika sudah disimpan.

Selanjutnya Login ke ```Docker Hub```. Lalu buat repository baru.

<img src=images/sign.png/>

Masukkan nama repository dan pastikan Visibility ```Public```.

<img src=images/create.png/>

Jika sudah dibuat, kembali ke gitlab -> Settings -> CI/CD -> Variables -> Expand -> Add Variable.

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/6d638848-cb7d-4461-aa05-b83fc74f66af" width="50%" />

Masukkan semua variable yang dibutuhkan.

<img src=images/var.png/>

Berikut adalah variable yang dibutuhkan.

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/a6409c40-54dc-4500-b8f6-fecdf8e4c707" width="60%" />

Jika sudah, kembali ke server frontend lalu push perubahan ke repository.

Cek di gitlab -> Build -> Pipelines.

<img src=images/pipeline.png/>

Nanti akan berjalan secara otomatis.

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/343648ac-c315-4e5c-9599-a37810753854" width="70%" />

Jika proses sudah selesai tanpa error maka akan tampil seperti ini.

<img src=images/cekberhasil.png/>

Selanjutnya pergi ke Settings -> Integrations -> Cari Discord Notifications -> Configure.

<img src="https://github.com/fadil05me/devops20-dumbways-AhmadFadillah/assets/45775729/1b3c7c70-41e2-4cc3-b843-dc75f7a62e94" width="70%" />

Pastikan ```Enable Integration``` terceklist. Dan semua terceklist kecuali dipaling bawah.

<img src=images/discord.png/>