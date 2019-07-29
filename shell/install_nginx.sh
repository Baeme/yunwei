#!/bin/bash

#@ baemawu@gmail.com

function yum_depend(){
     ## //安装yum依赖包
    yum install -y gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel
    printf "%-25s\033[32myum依赖安装成功\033[0m\n"
}

function compile_install_nginx(){
    ## // 编译安装nginx
    compile_dir="/opt/soft"
    useradd www -s /sbin/nologin
    if [ ! -d ${compile_dir} ];then
        mkdir -p ${compile_dir} | tee -a /root/init.log
    fi
    cd ${compile_dir} && wget -q https://nginx.org/download/nginx-1.16.0.tar.gz
    tar xf nginx-1.16.0.tar.gz && cd nginx-1.16.0
    ./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_v2_module && make && make install
    /usr/local/nginx/sbin/nginx -V && printf "%-25s\033[32mNginx安装成功\033[0m\n" || printf "%-25s\033[32mNgxin安装失败\033[0m\n"
}
function configure_nginx(){
    ## 修改Nginx启动用户及systemd去启动Nginx
    #cp /usr/local/nginx/conf/nginx.conf{,.bak}
    mkdir -p /usr/local/nginx/conf/vhost
    cat > /usr/local/nginx/conf/nginx.conf << EOF
user www www;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

worker_rlimit_nofile 65535;
events {
    worker_connections 65535;
    multi_accept off;
}
http {
    log_format main '\$http_x_real_ip - \$remote_addr - \$remote_user [\$time_local] "\$request" '
                '\$status \$body_bytes_sent "\$http_referer" '
                '"\$http_user_agent" "\$http_x_forwarded_for" '
                '\$connection \$upstream_addr '
                 '\$upstream_response_time \$request_time';
    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   60;
    server_tokens off;
    server_names_hash_max_size 1024;
    server_names_hash_bucket_size 128;
    include             /usr/local/nginx/conf/mime.types;
    default_type        application/octet-stream;
    keepalive_requests 200;
    large_client_header_buffers 4 1024k;
    open_file_cache max=102400 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 1;
    client_header_timeout 15;
    client_body_timeout 15;
    reset_timedout_connection on;
    send_timeout 15;
    proxy_connect_timeout 5;
    proxy_read_timeout 60;
    proxy_send_timeout 5;
    proxy_buffer_size 64k;
    proxy_buffers   4 32k;
    proxy_busy_buffers_size 64k;
    proxy_temp_file_write_size 128k;
    gzip on;
    gzip_disable "msie6";
    fastcgi_buffers 8 4K;
    fastcgi_buffer_size  4K;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 2;
    gzip_buffers 4 32k;
    gzip_http_version 1.1;
    gzip_min_length 2k;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;
    include /usr/local/nginx/conf/vhost/*.conf;
}
EOF
   cat > /lib/systemd/system/nginx.service << EOF
[Unit]
Description=nginx
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s quit
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
   systemctl daemon-reload
   systemctl start nginx && printf "%-25s\033[32mNginx启动成功\033[0m\n" || printf "%-25s\033[31mNginx启动失败\033[0m\n"
   systemctl enable nginx >/dev/null 2>&1
}
yum_depend
compile_install_nginx
configure_nginx
