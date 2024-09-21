
#!/bin/bash

# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Cài đặt các yêu cầu hệ thống
sudo apt install -y php8.2 php8.2-mysql php8.2-openssl php8.2-pdo php8.2-mbstring php8.2-tokenizer php8.2-xml php8.2-ctype php8.2-json php8.2-bcmath php8.2-imap php8.2-iconv php8.2-zip php8.2-fileinfo composer unzip wget

# Cấu hình allow_url_fopen
sudo sed -i 's/;allow_url_fopen = On/allow_url_fopen = On/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/;allow_url_fopen = On/allow_url_fopen = On/' /etc/php/8.2/apache2/php.ini

# Tải về và giải nén TMail v7.8 Nulled
wget https://www.dropbox.com/t/Ell4ahrNasMwgHf2 -O tmail-v7.8-nulled.zip
unzip tmail-v7.8-nulled.zip -d /var/www/tmail
cd /var/www/tmail

# Cấu hình cơ sở dữ liệu
DB_NAME="tmail_db"
DB_USER="tmail_user"
DB_PASS="your_password"

sudo mysql -e "CREATE DATABASE $DB_NAME;"
sudo mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Cấu hình tệp .env
cp .env.example .env
sed -i "s/DB_DATABASE=homestead/DB_DATABASE=$DB_NAME/" .env
sed -i "s/DB_USERNAME=homestead/DB_USERNAME=$DB_USER/" .env
sed -i "s/DB_PASSWORD=secret/DB_PASSWORD=$DB_PASS/" .env

# Cài đặt các gói PHP cần thiết
composer install

# Chạy các lệnh migrate và seed
php artisan migrate
php artisan db:seed

# Thiết lập quyền truy cập
chmod -R 775 storage
chmod -R 775 bootstrap/cache

# Khởi động máy chủ
php artisan serve --host=0.0.0.0 --port=8000
