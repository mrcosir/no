#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

clear;
# Logo 	******************************************************************
CopyrightLogo='
                        CentOS6.x  OpenVPN-2.3.10 云免服务器                                  
                         Powered by 沔县聂人狂 2015-2016                     
                                All Rights Reserved                  
                                                                            
                                                    by 聂人狂               
==========================================================================';
echo "$CopyrightLogo";
echo "请按回车执行安装"
read
echo 
# sbwml
echo "正在进行部署环境..."
sleep 3
service httpd stop >/dev/null
yum -y remove httpd >/dev/null

if [ $version == "6" ];then
if [ $(getconf WORD_BIT) = '32' ];then
wget https://raw.github.com/mu228/no/master/32-epel-release-6-8.noarch.rpm
rpm -ivh 32-epel-release-6-8.noarch.rpm
else
wget https://raw.github.com/mu228/no/master/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm
fi
fi
yum update -y
# OpenVPN Installing ****************************************************************************
iptables -F
service iptables save
service iptables restart
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -A INPUT -p TCP --dport 3389 -j ACCEPT
iptables -A INPUT -p TCP --dport 80 -j ACCEPT
iptables -A INPUT -p TCP --dport 22 -j ACCEPT
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
service iptables save
# OpenVPN Installing ****************************************************************************
setenforce 0
cd /etc/
rm -rf ./sysctl.conf
wget https://raw.github.com/mu228/no/master/sysctl.conf
chmod 0755 ./sysctl.conf
sysctl -p
# OpenVPN Installing ****************************************************************************
echo "正在安装环境..."
sleep 3
yum install -y curl wget squid openssl openssl-devel lzo lzo-devel pam pam-devel automake pkgconfig
yum install -y openvpn
# OpenVPN Installing ****************************************************************************
cd /etc/openvpn/
rm -rf ./server.conf
wget https://raw.github.com/mu228/no/master/server.conf
chmod 0755 ./server.conf
cd /etc/squid/
rm -f ./squid.conf
wget https://raw.github.com/mu228/no/master/squid.conf
chmod 0755 /etc/squid/squid.conf
squid -z
squid -s
chkconfig squid on
# OpenVPN Installing ****************************************************************************
cd /etc/openvpn/
wget https://raw.github.com/mu228/no/master/EasyRSA-2.2.2.tar.gz
tar -zxvf EasyRSA-2.2.2.tar.gz
cd /etc/openvpn/easy-rsa/
source vars
./clean-all
clear
echo "以下操作请根据提示键入 y 确认..."
sleep 3
echo -e "nnnnnnnn" | ./build-ca
echo -e "nnnnnnnnnn" | ./build-key-server server && echo -e "nnnnnnnnnn" | ./build-key client-name
./build-ca
./build-key-server centos
./build-key me
./build-dh
# OpenVPN Installing ****************************************************************************
service openvpn start
chkconfig openvpn on
# OpenVPN Installing ****************************************************************************
cp /etc/openvpn/easy-rsa/keys/{ca.crt,me.{crt,key}} /home/
cd /home/
wget https://raw.github.com/mu228/no/master/onlyme.ovpn
tar -zcvf openvpn.tar.gz ./{onlyme.ovpn,ca.crt,me.{crt,key}}
rm -rf ./{onlyme.ovpn,ca.crt,me.{crt,key}}
# OpenVPN Installing ****************************************************************************
echo "正在创建下载链接："
echo 
sleep 2
echo '=========================================================================='
echo 
curl --upload-file ./openvpn.tar.gz https://transfer.sh/openvpn.tar.gz
echo 
echo "上传成功："
echo "请复制https://链接到浏览器下载配置文件"
echo 
echo '=========================================================================='
echo
Client='
                               OpenVPN-2.3.10 安装完毕                                
                         Powered by 沔县聂人狂 2015-2016                     
                                 All Rights Reserved                  
                                                                            
==========================================================================';
echo "$Client";

