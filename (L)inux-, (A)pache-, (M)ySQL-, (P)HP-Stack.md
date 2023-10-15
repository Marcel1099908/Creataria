## (L)inux-, (A)pache-, (M)ySQL-, (P)HP-Stack

## Installing Apache2
```
apt install apache2
```

## Installing Certbot/SSL-certificate
```
apt install certbot python3-certbot-apache
```
```
certbot --apache -d legends-of-blood.de -d www.legends-of-blood.de
```

certbot certonly --manual   --preferred-challenges=dns   --email webmaster@hh-hausanschluss.de   --server https://acme-v02.api.letsencrypt.org/directory   --agree-tos   --manual-public-ip-logging-ok   -d hh-hausanschluss.de -d *.hh-hausanschluss.de


## Installing MySQL
```
apt install mysql-server
sudo mysql_secure_installation
```

```
mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'password';
FLUSH PRIVILEGES;
SELECT user,authentication_string,plugin,host FROM mysql.user;
exit
```

## Installing PHP
```
apt install php libapache2-mod-php php-mysql
```
```
systemctl restart apache2
```

## Installing phpMyAdmin
```
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl
```
```
phpenmod mbstring
```
```
systemctl restart apache2
```
