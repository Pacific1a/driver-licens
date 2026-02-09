#!/bin/bash
# Быстрая настройка - скопируй всё это и выполни на сервере

# Обновление и установка nginx
apt update && apt install nginx certbot python3-certbot-nginx -y

# Создание директории
mkdir -p /var/www/driverlicens.online

# Конфигурация nginx
cat > /etc/nginx/sites-available/driverlicens.online << 'EOF'
server {
    listen 80;
    listen [::]:80;
    
    server_name driverlicens.online www.driverlicens.online;
    
    root /var/www/driverlicens.online;
    index index.html;
    
    access_log /var/log/nginx/driverlicens.access.log;
    error_log /var/log/nginx/driverlicens.error.log;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    gzip on;
    gzip_vary on;
    gzip_types text/plain text/css text/javascript application/json application/javascript text/xml application/xml;
    
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    server_tokens off;
}
EOF

# Активация конфига
ln -sf /etc/nginx/sites-available/driverlicens.online /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Проверка и перезагрузка
nginx -t && systemctl enable nginx && systemctl restart nginx

# Права
chmod -R 755 /var/www/driverlicens.online
chown -R www-data:www-data /var/www/driverlicens.online

echo "Сервер настроен! Теперь загрузи файлы через WinSCP в /var/www/driverlicens.online"
