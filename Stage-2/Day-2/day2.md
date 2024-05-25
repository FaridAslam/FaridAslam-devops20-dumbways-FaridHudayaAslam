# Manage Database & Setup Backend

- pertama tama kita login ke biznetgio nya, lalu pilih server tempat untuk mendeploy database backend dan mysqlnya, lalu klik open console

![Alt text](./images/appserverbiznetlogin.png)

lalu jalankan ssh -i (ssh) user@ip

![Alt text](./images/login%20ssh%20appserver.png)

## Instalasi dan konfigurasi database MySql

sebelum install mysql, kita update dan upgrade terlebih dahulu

        sudo apt update; sudo apt upgrade

  - Install MySql menggunakan command berikut
  
        sudo apt install mysql*

![Alt text](./images/install%20mysql.png)


  - Jalankan secure installation mysql

![Alt text](./images/secure%20mysql%20install.png)

  - Buka mysql sebagai root dan buat user baru
  - Beri privilege pada user baru
  - Buat database baru menggunakan user yang sudah dibuat

![Alt text](./images/Screenshot%20from%202024-05-07%2018-08-41.png)

  - Buka direktori `/etc/mysql/mysql.conf.d/mysqld.cnf`

        sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

    Ubah `bind-address` dan `mysqlx-bind-address` menjadi seperti ini
        
        bind-address: 0.0.0.0
        mysqlx-bind-address: 0.0.0.0
        
![Alt text](./images/mysqld.conf.png)
     
  - Restart service mysql

        sudo systemctl restart mysql     

## Setup aplikasi backend

  - Clone aplikasi dumbflix

        git clone https://github.com/dumbwaysdev/dumbflix-backend.git

![Alt text](./images/gitclone%20dumbflix.png)

  - Install sequelize

        npm install sequelize-cli

![alt text](./images/npmisequelize.png)

  - sebelum installsequelize kita Install node versi 14 terlebih dahulu menggunakan nvm (curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash)
  - lalu ketik nvm i 14
  - dan ketik exec bash

  - Build aplikasi backend

![alt text](./images/npm%20i.png)

  - Build dan edit pm2 ecosystem file

![alt text](./images/pm2%20init%20simple.png)

![alt text](./images/konfigurasi%20init%20simple.png)

  - Edit file `config.json`

![alt text](./images/sudo%20nano%20config.png)

![alt text](./images/konfigurasi%20configjson.png)

  - Migrate isi database aplikasi ke database server menggunakan sequelize

![alt text](./images/sequlize%20migrate.png)

  - Cek apakah database sudah berhasil di migrate

![alt text](./images/cek%20mysql%20migrate.png)

  - Kembali dan jalankan aplikasi melalui pm2

![alt text](./images/pm2%20start%20eco.png)

  - Buka browser dan ketikkan alamat aplikasi

![alt text](./images/cek%20di%20website.png)

  - Membuat konfigurasi reverse proxy

![alt text](./images/sudo%20nano%20api%20farid%20nginx.png)

![alt text](./images/konfigurasi%20api%20farid%20nginx.png)

  - Buat domain baru di cloudflare

![alt text](./images/cloudflare%20buat.png)

  - Coba akses domain yang sudah dibuat di browser
  - disini perlu untuk mendeploy ssl certificate menggunakan certbot agar domain bisa terkoneksi dengan aman

![alt text](./images/cek%20apifaridwebsite.png)

  - Install certbot
  - Jalankan certbot dan konfigurasi certbot 

![alt text](./images/install%20certbot.png)

  - Restart nginx

  - Buka kembali aplikasi backend melalui web browser

![alt text](./images/cek%20apifaridwebsite.png)

## Integrasi aplikasi frontend dan backend

  - Masuk ke direktori aplikasi frontend dan edit file `src/config/api.js`

![alt text](./images/nano%20srcconfig.png)
![alt text](./images/konfigurasi%20front%20end.png)

  - Buka aplikasi dan register user baru

![alt text](./images/cek%20sudah%20apa%20belum.png)

  - Jika berhasil maka akan muncul profile seperti ini

![alt text](./images/tadaaaaaaaa.png)
