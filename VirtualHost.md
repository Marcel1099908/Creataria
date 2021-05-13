# VirtualHost

## /var/www/*
```
mkdir /var/www/creataria.de [OR] mkdir /var/www/www.creataria.de [OR] /var/www/XXX
mkdir /var/www/cloud.creataria.de
mkdir /var/www/root.creataria.de
```

## dissite
```
a2dissite 000-default.conf
a2dissite 000-default-le-ssl
systemctl reload apache2
```

## vitualhost
```
nano /etc/apache2/sites-available/default.conf
```

```
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html
	<Directory /var/www/html>
		Options FollowSymLinks
		AllowOverride All
	</Directory>
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

```
nano /etc/apache2/sites-available/creataria.conf
```

```
# creataria.de
<VirtualHost *:80>
	ServerAdmin webmaster@creataria.de
	ServerName creataria.de
	ServerAlias www.creataria.de
	DocumentRoot /var/www/creataria.de
	<Directory /var/www/creataria.de>
		Options FollowSymLinks
		AllowOverride All
	</Directory>
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
	<IfModule mod_ssl.c>
		<IfModule mod_rewrite.c>
			RewriteEngine on
			RewriteCond %{SERVER_NAME} =creataria.de [OR]
			RewriteCond %{SERVER_NAME} =www.creataria.de
			RewriteRule ^(.*)$ https://%{SERVER_NAME}%{REQUEST_URI} [L,R=301]
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
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined
		SSLEngine on
		SSLCertificateFile /etc/letsencrypt/live/creataria.de/fullchain.pem
		SSLCertificateKeyFile /etc/letsencrypt/live/creataria.de/privkey.pem
	</VirtualHost>
</IfModule>

# forum.creataria.de
<VirtualHost *:80>
	ServerAdmin webmaster@creataria.de
	ServerName forum.creataria.de
	ServerAlias www.forum.creataria.de
	DocumentRoot /var/www/creataria.de/forum
	<Directory /var/www/root.creataria.de>
		Options FollowSymLinks
		AllowOverride All
	</Directory>
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
	<IfModule mod_ssl.c>
		<IfModule mod_rewrite.c>
			RewriteEngine on
			RewriteCond %{SERVER_NAME} =forum.creataria.de [OR]
			RewriteCond %{SERVER_NAME} =www.forum.creataria.de
			RewriteRule ^(.*)$ https://%{SERVER_NAME}%{REQUEST_URI} [L,R=301]
		</IfModule>
	</IfModule>
</VirtualHost>

<IfModule mod_ssl.c>
	<VirtualHost *:443>
		ServerAdmin webmaster@creataria.de
		ServerName forum.creataria.de
		ServerAlias www.forum.creataria.de
		DocumentRoot /var/www/creataria.de/forum
		<Directory /var/www/root.creataria.de>
			Options FollowSymLinks
			AllowOverride All
		</Directory>
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined
		SSLEngine on
		SSLCertificateFile /etc/letsencrypt/live/creataria.de/fullchain.pem
		SSLCertificateKeyFile /etc/letsencrypt/live/creataria.de/privkey.pem
	</VirtualHost>
</IfModule>

# cloud.creataria.de
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
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
	<IfModule mod_ssl.c>
		<IfModule mod_rewrite.c>
			RewriteEngine on
			RewriteCond %{SERVER_NAME} =cloud.creataria.de [OR]
			RewriteCond %{SERVER_NAME} =www.cloud.creataria.de
			RewriteRule ^(.*)$ https://%{SERVER_NAME}%{REQUEST_URI} [L,R=301]
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
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined
		SSLEngine on
		SSLCertificateFile /etc/letsencrypt/live/creataria.de/fullchain.pem
		SSLCertificateKeyFile /etc/letsencrypt/live/creataria.de/privkey.pem
	</VirtualHost>
</IfModule>

# root.creataria.de
<VirtualHost *:80>
	ServerAdmin webmaster@creataria.de
	ServerName root.creataria.de
	ServerAlias www.root.creataria.de
	DocumentRoot /var/www/root.creataria.de
	<Directory /var/www/root.creataria.de>
		Options FollowSymLinks
		AllowOverride All
	</Directory>
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
	<IfModule mod_ssl.c>
		<IfModule mod_rewrite.c>
			RewriteEngine on
			RewriteCond %{SERVER_NAME} =root.creataria.de [OR]
			RewriteCond %{SERVER_NAME} =www.root.creataria.de
			RewriteRule ^(.*)$ https://%{SERVER_NAME}%{REQUEST_URI} [L,R=301]
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
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined
		SSLEngine on
		SSLCertificateFile /etc/letsencrypt/live/creataria.de/fullchain.pem
		SSLCertificateKeyFile /etc/letsencrypt/live/creataria.de/privkey.pem
	</VirtualHost>
</IfModule>
```

## ensite
```
a2ensite default
a2ensite legends-of-blood
systemctl reload apache2
```

## expand domain
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
