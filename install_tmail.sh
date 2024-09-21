#!/bin/bash

# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Gỡ bỏ các phiên bản PHP không tương thích (nếu có)
sudo apt remove -y php8.1* 

# Cài đặt PHP 7.4 và các gói cần thiết
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php7.4 php7.4-mysql php7.4-cli php7.4-common php7.4-opcache php7.4-readline php7.4-curl php7.4-xml php7.4-mbstring php7.4-zip php7.4-bcmath php7.4-intl php7.4-gd php7.4-imap php7.4-soap php7.4-ldap php7.4-redis php7.4-sqlite3 php7.4-pgsql php7.4-memcached php7.4-mongodb php7.4-uuid php7.4-xdebug php7.4-dev php7.4-fpm php7.4-json composer unzip wget mariadb-server

# Cấu hình allow_url_fopen
sudo sed -i 's/;allow_url_fopen = On/allow_url_fopen = On/' /etc/php/7.4/cli/php.ini

# Xóa các tệp và thư mục hiện có
sudo rm -rf /var/www/tmail

# Tạo thư mục mới
sudo mkdir -p /var/www/tmail

# Tải về và kiểm tra tệp ZIP
wget http://69.28.88.79/tmail-multi-domain-temporary-email-system.zip -O tmail-v7.8-nulled.zip
if ! unzip -tq tmail-v7.8-nulled.zip; then
    echo "Tệp ZIP không hợp lệ hoặc bị hỏng. Vui lòng kiểm tra lại liên kết tải về."
    exit 1
fi

# Giải nén tệp ZIP
unzip tmail-v7.8-nulled.zip -d /var/www/tmail
cd /var/www/tmail

# Kiểm tra sự tồn tại của .env.example trước khi sao chép
if [ ! -f ".env.example" ]; then
    echo ".env.example not found! Creating .env file manually."

    # Tạo tệp .env với thông tin cơ sở dữ liệu mặc định
    cat <<EOL > .env
DB_DATABASE=tmail_db
DB_USERNAME=honglee
DB_PASSWORD=k3E\.UW{EA34
EOL

    echo ".env file created with default settings."
else
    # Nếu .env.example tồn tại, sao chép nó vào .env
    cp .env.example .env || { echo ".env.example not found!"; exit 1; }
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

# Cập nhật thông tin trong tệp .env nếu cần thiết (nếu đã tạo)
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
