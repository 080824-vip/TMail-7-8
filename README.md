
# Hướng dẫn cài đặt TMail v7.8 trên VPS Debian 11

## Bước 1: Cập nhật hệ thống
Trước tiên, hãy cập nhật hệ thống của bạn:
```bash
sudo apt update && sudo apt upgrade -y
```

## Bước 2: Cài đặt các yêu cầu hệ thống
Cài đặt các phần mở rộng PHP và các gói cần thiết:
```bash
sudo apt install -y php8.1 php8.1-mysql php8.1-openssl php8.1-pdo php8.1-mbstring php8.1-tokenizer php8.1-xml php8.1-ctype php8.1-json php8.1-bcmath php8.1-imap php8.1-iconv php8.1-zip php8.1-fileinfo
```

## Bước 3: Cài đặt Composer
Cài đặt Composer để quản lý các gói PHP:
```bash
sudo apt install -y composer
```

## Bước 4: Tải về và giải nén TMail v7.8 Nulled
Tải về tệp TMail v7.8 Nulled và giải nén vào thư mục trên máy chủ của bạn:
```bash
wget [link tải về TMail v7.8 Nulled]
unzip tmail-v7.8-nulled.zip -d /var/www/tmail
cd /var/www/tmail
```

## Bước 5: Cấu hình cơ sở dữ liệu
Tạo một cơ sở dữ liệu MySQL mới cho TMail:
```sql
CREATE DATABASE tmail_db;
CREATE USER 'tmail_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON tmail_db.* TO 'tmail_user'@'localhost';
FLUSH PRIVILEGES;
```

## Bước 6: Cấu hình tệp .env
Sao chép tệp `.env.example` thành `.env` và chỉnh sửa các thông tin cấu hình cần thiết:
```bash
cp .env.example .env
nano .env
```

## Bước 7: Cài đặt các gói PHP cần thiết
Chạy lệnh sau để cài đặt các gói PHP cần thiết:
```bash
composer install
```

## Bước 8: Chạy các lệnh migrate và seed
Chạy các lệnh sau để tạo các bảng cơ sở dữ liệu và thêm dữ liệu mẫu:
```bash
php artisan migrate
php artisan db:seed
```

## Bước 9: Thiết lập quyền truy cập
Thiết lập quyền truy cập cho các thư mục `storage` và `bootstrap/cache`:
```bash
chmod -R 775 storage
chmod -R 775 bootstrap/cache
```

## Bước 10: Khởi động máy chủ
Khởi động máy chủ bằng lệnh sau:
```bash
php artisan serve --host=0.0.0.0 --port=8000
```

Bây giờ bạn có thể truy cập TMail tại địa chỉ `http://your_server_ip:8000`.

## Video hướng dẫn
Bạn có thể tham khảo video hướng dẫn gốc tại liên kết sau: [Video hướng dẫn cài đặt TMail](https://www.youtube.com/watch?v=2sBYzkJQ24s&feature=youtu.be)
