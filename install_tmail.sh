
#!/bin/bash

# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Gỡ bỏ các phiên bản PHP không tương thích
sudo apt remove -y php8.1 php8.1-mysql php8.1-cli php8.1-common php8.1-opcache php8.1-readline php8.1-curl php8.1-xml php8.1-mbstring php8.1-zip php8.1-bcmath php8.1-intl php8.1-gd php8.1-imap php8.1-soap php8.1-ldap php8.1-redis php8.1-sqlite3 php8.1-pgsql php8.1-memcached php8.1-mongodb php8.1-uuid php8.1-xdebug php8.1-dev php8.1-fpm php8.1-json php8.1-tokenizer php8.1-fileinfo php8.1-iconv

# Cài đặt các yêu cầu hệ thống
sudo apt install -y php php-mysql php-cli php-common php-opcache php-readline php-curl php-xml php-mbstring php-zip php-bcmath php-intl php-gd php-imap php-soap php-ldap php-redis php-sqlite3 php-pgsql php-memcached php-mongodb php-uuid php-xdebug php-dev php-fpm php-json php-tokenizer php-fileinfo php-iconv composer unzip wget mariadb-server

# Cấu hình allow_url_fopen
sudo sed -i 's/;allow_url_fopen = On/allow_url_fopen = On/' /etc/php/7.4/cli/php.ini
sudo sed -i 's/;allow_url_fopen = On/allow_url_fopen = On/' /etc/php/7.4/apache2/php.ini

# Tải về và giải nén TMail v7.8 Nulled
wget https://www.dropbox.com/t/Ell4ahrNasMwgHf2 -O tmail-v7.8-nulled.zip
unzip tmail-v7.8-nulled.zip -d /var/www/tmail
cd /var/www/tmail

# Cấu hình cơ sở dữ liệu
DB_NAME="tmail_db"
DB_USER="honglee"
DB_PASS="k3E\.UW{EA34"

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

# Xuất thông tin đăng nhập vào tệp thongtindangnhap.txt
echo "Tên đăng nhập: $DB_USER" > /var/www/tmail/thongtindangnhap.txt
echo "Mật khẩu: $DB_PASS" >> /var/www/tmail/thongtindangnhap.txt
