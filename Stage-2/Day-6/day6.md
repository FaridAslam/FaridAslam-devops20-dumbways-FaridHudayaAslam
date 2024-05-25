# Day 8 (Challenge Task)
Challenge Task: Terraform

1.  Dengan mendaftar akun free tier AWS/GCP/Azure, buatlah Infrastructre dengan terraform menggunakan registry yang sudah ada. (spec menyesuaikan saja dengan free tier yang di dapatkan)

## Step by step
### Mendaftar akun aws-freetier
![enter image description here](./images/1.png)
### Terraform environment
Menggunakan dokumentasi resmi aws di terraform registry :
 https://registry.terraform.io/providers/hashicorp/aws/latest/docs
 ![txt](./images/2.png)

 pertama-tama cari IAM di aws
![txt](./images/3.png)

lalu klik user dan create user
![txt](./images/4.png)

centang ini saja
![txt](./images/5.png)
![txt](./images/6.png)

jika sudah terbuat lalu klik user yg sudah dibuat
![txt](./images/7.png)

masukkan access key
![txt](./images/8.png)

pilih CLI
![txt](./images/9.png)

beri nama
![txt](./images/10.png)

salin kode accsess nya
![txt](./images/11.png)

lalu cari EC2
![txt](./images/12.png)

PILIH launch instance di sebelah kanan
![txt](./images/13.png)

lalu salin ami untuk kebutuhan file main.tf kita nanti nya
![txt](./images/14.png)

Membuat file `main.tf`
![txt](./images/Untitled.jpeg)

### Excecution
1. Jika sudah membuat file nya kita init terlebih dahulu
	`terraform init`
![enter image description here](./images/init.png)
2. lalu masukkan command Terraform plan
`terraform plan`
![enter image description here](./images/plan.png)
3. dan kita apply jika sudah benar semua nya
`terraform apply`
![enter image description here](./images/aooly.png)

### Hasilnya
![enter image description here](./images/hasil.png)
jika sudah berhasil, kita masuk ke server yg sudah dibuat tersebut, lalu klik security, edit inbounds security grup dan atur menjadi ssh, dan pilih ipv4, lalu pilih 0.0.0.0 untuk mengakses di segala ip.
![enter image description here](./images/security.png)
![enter image description here](./images/sshkeysibound.png)
![enter image description here](./images/cliresult.png)