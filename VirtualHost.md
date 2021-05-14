# VirtualHost

## mkdir
```
mkdir /var/www/creataria.de
mkdir /var/www/creataria.de/forum
mkdir /var/www/cloud.creataria.de
mkdir /var/www/root.creataria.de
mkdir /var/log/apache2/creataria.de/
```

## dissite / rm
```
a2dissite 000-default.conf
a2dissite 000-default-le-ssl
rm /etc/apache2/sites-available/*
```

## vitualhost
```
nano /etc/apache2/sites-available/000-default.conf
```

```
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/.default
	<Directory /var/www/.default>
		Options FollowSymLinks
		AllowOverride All
	</Directory>
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
#	<IfModule mod_ssl.c>
#		<IfModule mod_rewrite.c>
#			RewriteEngine On
#			RewriteRule ^(.*)$ https://creataria.de/ [R=301,L]
#		</IfModule>
#	</IfModule>
</VirtualHost>

<IfModule mod_ssl.c>
	<VirtualHost *:443>
		ServerAdmin webmaster@localhost
		DocumentRoot /var/www/.default
		<Directory /var/www/.default>
			Options FollowSymLinks
			AllowOverride All
		</Directory>
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined
		SSLEngine on
		Include /etc/letsencrypt/options-ssl-apache.conf
		SSLCertificateFile /etc/letsencrypt/live/creataria.de/fullchain.pem
		SSLCertificateKeyFile /etc/letsencrypt/live/creataria.de/privkey.pem
#		<IfModule mod_rewrite.c>
#			RewriteEngine On
#			RewriteRule ^(.*)$ https://creataria.de/ [R=301,L]
#		</IfModule>
	</VirtualHost>
</IfModule>
```

```
nano /etc/apache2/sites-available/001-creataria.de.conf
```

```
<VirtualHost *:80>
	ServerAdmin webmaster@creataria.de
	ServerName creataria.de
	ServerAlias www.creataria.de
	DocumentRoot /var/www/creataria.de
	<Directory /var/www/creataria.de>
		Options FollowSymLinks
		AllowOverride All
	</Directory>
	ErrorLog ${APACHE_LOG_DIR}/creataria.de/error.log
	CustomLog ${APACHE_LOG_DIR}/creataria.de/access.log combined
	<IfModule mod_ssl.c>
		<IfModule mod_rewrite.c>
			RewriteEngine on
			RewriteCond %{SERVER_NAME} =creataria.de [OR]
			RewriteCond %{SERVER_NAME} =www.creataria.de
			RewriteRule ^(.*)$ https://%{SERVER_NAME}%{REQUEST_URI} [R=301,L]
		</IfModule>
	</IfModule>
</VirtualHost>

<IfModule mod_ssl.c>
	<VirtualHost *:443>
		ServerAdmin webmaster@creataria.de
		ServerName creataria.de
		ServerAlias www.creataria.de
		DocumentRoot /var/www/creataria.de
		<Directory /var/www/creataria.de>
			Options FollowSymLinks
			AllowOverride All
		</Directory>
		ErrorLog ${APACHE_LOG_DIR}/creataria.de/error.log
		CustomLog ${APACHE_LOG_DIR}/creataria.de/access.log combined
		SSLEngine on
		Include /etc/letsencrypt/options-ssl-apache.conf
		SSLCertificateFile /etc/letsencrypt/live/creataria.de/fullchain.pem
		SSLCertificateKeyFile /etc/letsencrypt/live/creataria.de/privkey.pem
	</VirtualHost>
</IfModule>
```

```
nano /etc/apache2/sites-available/002-forum.creataria.de.conf
```

```
<VirtualHost *:80>
	ServerAdmin webmaster@creataria.de
	ServerName forum.creataria.de
	ServerAlias www.forum.creataria.de
	DocumentRoot /var/www/creataria.de/forum
	<Directory /var/www/creataria.de/forum>
		Options FollowSymLinks
		AllowOverride All
	</Directory>
	ErrorLog ${APACHE_LOG_DIR}/creataria.de/error.log
	CustomLog ${APACHE_LOG_DIR}/creataria.de/access.log combined
	<IfModule mod_ssl.c>
		<IfModule mod_rewrite.c>
			RewriteEngine on
			RewriteCond %{SERVER_NAME} =forum.creataria.de [OR]
			RewriteCond %{SERVER_NAME} =www.forum.creataria.de
			RewriteRule ^(.*)$ https://%{SERVER_NAME}%{REQUEST_URI} [R=301,L]
		</IfModule>
	</IfModule>
</VirtualHost>

<IfModule mod_ssl.c>
	<VirtualHost *:443>
		ServerAdmin webmaster@creataria.de
		ServerName forum.creataria.de
		ServerAlias www.forum.creataria.de
		DocumentRoot /var/www/creataria.de/forum
		<Directory /var/www/creataria.de/forum>
			Options FollowSymLinks
			AllowOverride All
		</Directory>
		ErrorLog ${APACHE_LOG_DIR}/creataria.de/error.log
		CustomLog ${APACHE_LOG_DIR}/creataria.de/access.log combined
		SSLEngine on
		Include /etc/letsencrypt/options-ssl-apache.conf
		SSLCertificateFile /etc/letsencrypt/live/creataria.de/fullchain.pem
		SSLCertificateKeyFile /etc/letsencrypt/live/creataria.de/privkey.pem
	</VirtualHost>
</IfModule>
```

```
nano /etc/apache2/sites-available/003-cloud.creataria.de.conf
```

```
<VirtualHost *:80>
	ServerAdmin webmaster@creataria.de
	ServerName cloud.creataria.de
	ServerAlias www.cloud.creataria.de
	DocumentRoot /var/www/cloud.creataria.de
	<Directory /var/www/cloud.creataria.de>
		Options FollowSymLinks
		AllowOverride All
	</Directory>
	<IfModule mod_headers.c>
			Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains preload”
	</IfModule>
	ErrorLog ${APACHE_LOG_DIR}/creataria.de/error.log
	CustomLog ${APACHE_LOG_DIR}/creataria.de/access.log combined
	<IfModule mod_ssl.c>
		<IfModule mod_rewrite.c>
			RewriteEngine on
			RewriteCond %{SERVER_NAME} =cloud.creataria.de [OR]
			RewriteCond %{SERVER_NAME} =www.cloud.creataria.de
			RewriteRule ^(.*)$ https://%{SERVER_NAME}%{REQUEST_URI} [R=301,L]
		</IfModule>
	</IfModule>
</VirtualHost>

<IfModule mod_ssl.c>
	<VirtualHost *:443>
		ServerAdmin webmaster@creataria.de
		ServerName cloud.creataria.de
		ServerAlias www.cloud.creataria.de
		DocumentRoot /var/www/cloud.creataria.de
		<Directory /var/www/cloud.creataria.de>
			Options FollowSymLinks
			AllowOverride All
		</Directory>
		<IfModule mod_headers.c>
			Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains preload”
		</IfModule>
		ErrorLog ${APACHE_LOG_DIR}/creataria.de/error.log
		CustomLog ${APACHE_LOG_DIR}/creataria.de/access.log combined
		SSLEngine on
		Include /etc/letsencrypt/options-ssl-apache.conf
		SSLCertificateFile /etc/letsencrypt/live/creataria.de/fullchain.pem
		SSLCertificateKeyFile /etc/letsencrypt/live/creataria.de/privkey.pem
	</VirtualHost>
</IfModule>
```

```
nano /etc/apache2/sites-available/004-root.creataria.de.conf
```

```
<VirtualHost *:80>
	ServerAdmin webmaster@creataria.de
	ServerName root.creataria.de
	ServerAlias www.root.creataria.de
	DocumentRoot /var/www/root.creataria.de
	<Directory /var/www/root.creataria.de>
		Options FollowSymLinks
		AllowOverride All
	</Directory>
	ErrorLog ${APACHE_LOG_DIR}/creataria.de/error.log
	CustomLog ${APACHE_LOG_DIR}/creataria.de/access.log combined
	<IfModule mod_ssl.c>
		<IfModule mod_rewrite.c>
			RewriteEngine on
			RewriteCond %{SERVER_NAME} =root.creataria.de [OR]
			RewriteCond %{SERVER_NAME} =www.root.creataria.de
			RewriteRule ^(.*)$ https://%{SERVER_NAME}%{REQUEST_URI} [R=301,L]
		</IfModule>
	</IfModule>
</VirtualHost>

<IfModule mod_ssl.c>
	<VirtualHost *:443>
		ServerAdmin webmaster@creataria.de
		ServerName root.creataria.de
		ServerAlias www.root.creataria.de
		DocumentRoot /var/www/root.creataria.de
		<Directory /var/www/root.creataria.de>
			Options FollowSymLinks
			AllowOverride All
		</Directory>
		ErrorLog ${APACHE_LOG_DIR}/creataria.de/error.log
		CustomLog ${APACHE_LOG_DIR}/creataria.de/access.log combined
		SSLEngine on
		Include /etc/letsencrypt/options-ssl-apache.conf
		SSLCertificateFile /etc/letsencrypt/live/creataria.de/fullchain.pem
		SSLCertificateKeyFile /etc/letsencrypt/live/creataria.de/privkey.pem
	</VirtualHost>
</IfModule>
```

## htaccess

```
nano /var/www/.default/.htaccess
```

```
RewriteEngine On
RewriteRule ^(.*)$ https://creataria.de/ [R=301,L]
```

## ensite
```
a2ensite 000-default
a2ensite 001-creataria.de
a2ensite 002-forum.creataria.de
a2ensite 003-cloud.creataria.de
a2ensite 004-root.creataria.de
```

```
systemctl reload apache2
```

## certbot

1 - No Redirection

```
certbot --expand \
  -d creataria.de \
  -d www.creataria.de \
  -d forum.creataria.de \
  -d www.forum.creataria.de \
  -d cloud.creataria.de \
  -d www.cloud.creataria.de \
  -d root.creataria.de \
  -d www.root.creataria.de
```
