# Ubuntu 20.04

## update
```
apt update
apt upgrade
apt full-upgrade
apt autoremove
```

## unattended-upgrades
```
apt install unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
nano /etc/apt/apt.conf.d/50unattended-upgrades
nano /etc/apt/apt.conf.d/20auto-upgrades
unattended-upgrades --dry-run
```

## key authentication
```
ssh-keygen -t rsa -b 4096
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
nano /etc/ssh/sshd_config
```
*PasswordAuthentication no*
```
sudo systemctl restart ssh
passwd -l root
```

## firewall
```
ufw allow ssh
ufw enable
ufw status numbered
```

## fail2ban
```
apt install fail2ban -y
systemctl status fail2ban
cp /etc/fail2ban/jail.{conf,local}
nano /etc/fail2ban/jail.local
```
*[DEFAULT]\
ignoreip = 127.0.0.1/8 ::1\
bantime = -1\
findtime = 15min\
maxretry = 1*
```
systemctl restart fail2ban
```
```
fail2ban-client status sshd
```
