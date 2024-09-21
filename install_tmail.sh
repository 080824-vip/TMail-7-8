#!/bin/bash

# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Kiểm tra phiên bản PHP hiện tại
PHP_VERSION=$(php -v | grep -oP 'PHP \K[0-9]+\.[0-9]+')

if [[ "$PHP_VERSION" != "8.2" ]]; then
    echo "Phiên bản PHP hiện tại là $PHP_VERSION. Gỡ bỏ phiên bản cũ và cài đặt PHP 8.2..."
    
    # Gỡ bỏ các phiên bản PHP không tương thích (nếu có)
    sudo apt remove -y php* 

    # Cài đặt PHP 8.2 và các gói cần thiết
    sudo apt install -y software-properties-common
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update
    sudo apt install -y php8.2 php8.2-mysql php8.2-cli php8.2-common php8.2-opcache php8.2-readline php8.2-curl php8.2-xml php8.2-mbstring php8.2-zip php8.2-bcmath php8.2-intl php8.2-gd php8.2-imap php8.2-soap php8.2-ldap php8.2-redis php8.2-sqlite3 php8.2-pgsql php8.2-memcached php8.2-mongodb php8.2-uuid php8.2-xdebug php8.2-dev php8.2-fpm php8.2-json composer unzip wget mariadb-server
else
    echo "Phiên bản PHP hiện tại là 8.2, không cần thay đổi."
fi

# Cấu hình allow_url_fopen
sudo sed -i 's/;allow_url_fopen = On/allow_url_fopen = On/' /etc/php/8.2/cli/php.ini

# Xóa các tệp và thư mục hiện có
sudo rm -rf /var/www/tmail

# Tạo thư mục mới
sudo mkdir -p /var/www/tmail

# Tải về và kiểm tra tệp ZIP
wget http://69.28.88.79/TMAIL/tmail7-8-1.zip -O tmail-v7.8-nulled.zip
if ! unzip -tq tmail-v7.8-nulled.zip; then
    echo "Tệp ZIP không hợp lệ hoặc bị hỏng. Vui lòng kiểm tra lại liên kết tải về."
    exit 1
fi

# Giải nén tệp ZIP
unzip tmail-v7.8-nulled.zip -d /var/www/tmail
cd /var/www/tmail

# Kiểm tra sự tồn tại của .env.example trước khi sao chép
if [ ! -f ".env.example" ]; then
    echo ".env.example not found! Please create a .env file manually."
    echo "You can use the following template:"
    echo "DB_DATABASE=tmail_db"
    echo "DB_USERNAME=honglee"
    echo "DB_PASSWORD=k3E\\.UW{EA34"
    exit 1
fi

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
cp .env.example .env || { echo ".env.example not found!"; exit 1; }
sed -i "s/DB_DATABASE=homestead/DB_DATABASE=$DB_NAME/" .env
sed -i "s/DB_USERNAME=homestead/DB_USERNAME=$DB_USER/" .env
sed -i "s/DB_PASSWORD=secret/DB_PASSWORD=$DB_PASS/" .env

# Cài đặt các gói PHP cần thiết bằng Composer, kiểm tra sự tồn tại của composer.json trước khi chạy lệnh này.
if [ ! -f "composer.json" ]; then
    echo "composer.json not found! Please check the extracted files."
    exit 1
fi

composer install --no-interaction

# Chạy các lệnh migrate và seed, kiểm tra sự tồn tại của tệp artisan.
if [ ! -f "artisan" ]; then
    echo "artisan file not found! Please check the extracted files."
    exit 1
fi

php artisan migrate --force
php artisan db:seed --force

# Tạo các thư mục cần thiết nếu chưa tồn tại và thiết lập quyền truy cập
mkdir -p storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# Khởi động máy chủ Laravel
php artisan serve --host=0.0.0.0 --port=8000 &

# Xuất thông tin đăng nhập vào tệp thongtindangnhap.txt
echo "Tên đăng nhập: $DB_USER" > /var/www/tmail/thongtindangnhap.txt
echo "Mật khẩu: $DB_PASS" >> /var/www/tmail/thongtindangnhap.txt

echo "Cài đặt hoàn tất! Thông tin đăng nhập đã được lưu trong thongtindangnhap.txt."
