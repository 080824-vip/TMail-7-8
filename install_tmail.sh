
#!/bin/bash

# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Gỡ bỏ các phiên bản PHP không tương thích
sudo apt remove -y php8.1 php8.1-mysql php8.1-cli php8.1-common php8.1-opcache php8.1-readline php8.1-curl php8.1-xml php8.1-mbstring php8.1-zip php8.1-bcmath php8.1-intl php8.1-gd php8.1-imap php8.1-soap php8.1-ldap php8.1-redis php8.1-sqlite3 php8.1-pgsql php8.1-memcached php8.1-mongodb php8.1-uuid php8.1-xdebug php8.1-dev php8.1-fpm php8.1-json php8.1-tokenizer php8.1-fileinfo php8.1-iconv

# Cài đặt các yêu cầu hệ thống
sudo apt install -y php7.4 php7.4-mysql php7.4-cli php7.4-common php7.4-opcache php7.4-readline php7.4-curl php7.4-xml php7.4-mbstring php7.4-zip php7.4-bcmath php7.4-intl php7.4-gd php7.4-imap php7.4-soap php7.4-ldap php7.4-redis php7.4-sqlite3 php7.4-pgsql php7.4-memcached php7.4-mongodb php7.4-uuid php7.4-xdebug php7.4-dev php7.4-fpm php7.4-json php7.4-tokenizer php7.4-fileinfo php7.4-iconv composer unzip wget mariadb-server

# Cấu hình allow_url_fopen
sudo sed -i 's/;allow_url_fopen = On/allow_url_fopen = On/' /etc/php/7.4/cli/php.ini
sudo sed -i 's/;allow_url_fopen = On/allow_url_fopen = On/' /etc/php/7.4/apache2/php.ini

# Xóa các tệp và thư mục hiện có
sudo rm -rf /var/www/tmail

# Tải về và kiểm tra tệp ZIP
wget http://69.28.88.79/tmail-multi-domain-temporary-email-system.zip -O tmail-v7.8-nulled.zip
if ! unzip -tq tmail-v7.8-nulled.zip; then
    echo "Tệp ZIP không hợp lệ hoặc bị hỏng. Vui lòng kiểm tra lại liên kết tải về."
    exit 1
fi

# Giải nén tệp ZIP
unzip tmail-v7.8-nulled.zip -d /var/www/tmail
cd /var/www/tmail

# Cấu hình cơ sở dữ liệu
DB_NAME="tmail_db"
DB_USER="honglee"
DB_PASS="k3E\.UW{EA34"

# Xóa cơ sở dữ liệu và người dùng hiện có
sudo mariadb -e "DROP DATABASE IF EXISTS $DB_NAME;"
sudo mariadb -e "DROP USER IF EXISTS '$DB_USER'@'localhost';"

# Tạo cơ sở dữ liệu và người dùng mới
sudo mariadb -e "CREATE DATABASE $DB_NAME;"
sudo mariadb -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mariadb -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mariadb -e "FLUSH PRIVILEGES;"

# Cấu hình tệp .env
cp .env.example .env
sed -i "s/DB_DATABASE=homestead/DB_DATABASE=$DB_NAME/" .env
sed -i "s/DB_USERNAME=homestead/DB_USERNAME=$DB_USER/" .env
sed -i "s/DB_PASSWORD=secret/DB_PASSWORD=$DB_PASS/" .env

# Cài đặt các gói PHP cần thiết
composer install --no-interaction

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
