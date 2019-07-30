#!/bin/bash
# author: baemawu@gmail.com
# name:  二进制自动安装 docker
# ver: docker-18.06.3-ce


# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install MySQL"
    exit 1
fi


echo -e "\n0.目录创建"
down_dir="/data/down"
app_dir="/usr/local/docker/bin"

CheckDir(){
	if [ ! -d "$1" ]; then
        mkdir -p $1
  	fi
}
CheckDir $down_dir
CheckDir $app_dir


echo -e "\n1.下载部署"
cd $down_dir
wget https://mirror.tuna.tsinghua.edu.cn/docker-ce/linux/static/stable/x86_64/docker-18.06.3-ce.tgz
tar -xvf docker-18.06.3-ce.tgz
mv docker/* /usr/local/docker/bin/
ln -s /usr/local/docker/bin/docker /usr/local/bin/

echo -e "\n2.环境变量"
echo "export PATH=\"\$PATH:/usr/local/docker/bin\"" >> /etc/profile
source /etc/profile


echo -e "\n3.服务配置"
cat > docker.service <<"EOF"
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io

[Service]
Environment="PATH=/usr/local/docker/bin:/bin:/sbin:/usr/bin:/usr/sbin"
EnvironmentFile=-/run/flannel/docker
ExecStart=/usr/local/docker/bin/dockerd --log-level=error $DOCKER_NETWORK_OPTIONS
ExecReload=/bin/kill -s HUP $MAINPID
Restart=on-failure
RestartSec=5
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
cp docker.service  /etc/systemd/system/docker.service
cat > //data/docker << "EOF"
{
    "data-root": "/data/docker",
    "hosts": ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2376"],
}
EOF
if [ ! -d "/data/docker" ];then
    printf "\033[31mdocker数据目录不存在,请挂载数据目录,脚本退出\033[0m\n"
fi
echo -e "\n4.启动服务"
systemctl daemon-reload
systemctl restart docker
systemctl enable docker
