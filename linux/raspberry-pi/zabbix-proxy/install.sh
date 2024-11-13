#!/bin/bash

# Ensure the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Step 1: Update package list
apt update

# Step 2: Set timezone
timedatectl set-timezone Europe/Prague

# Step 3: Download debian-upgrade.sh and set executable permissions
curl -o /root/debian-upgrade.sh https://raw.githubusercontent.com/MartinHajducik/jsemit/refs/heads/main/linux/general-linux/debian-upgrade.sh?token=GHSAT0AAAAAACXJTY4LTLO47G2ZW7W6I3LWZZUY4GQ
chmod +x /root/debian-upgrade.sh

# Step 4: Add cron job for daily upgrade
(crontab -l ; echo "0 3 * * * /root/debian-upgrade.sh >/dev/null 2>&1") | crontab -

# Step 5: Install required packages with non-interactive mode for postfix
export DEBIAN_FRONTEND=noninteractive
apt-get -y install vim neofetch ccze nmap sysstat net-tools chrony tree boxes xdotool unclutter sed tmux cockpit duf rsync htop rsyslog jq gawk bind9-host bind9-dnsutils wtype postfix

# Step 6: Enable and disable specific services
systemctl enable --now sysstat.service cockpit.service
systemctl disable --now cups.service postfix.service

# Step 7: Create a welcome message
cat << '_EOF' > /etc/profile.d/zz-welcome.sh
echo -e "\nZabbix\nPROXY/AGENT2/SQLite3/\nhttps://github.com/MartinHajducik/jsemit" | boxes -d dog -a c -s 80
neofetch
echo -e "Server Raspberry-PI - $HOSTNAME\n\n$(date)" | boxes -d parchment -a c -s 80
duf --only local
_EOF

# Step 8: Define bash aliases
cat << '_EOF' > ~/.bash_aliases
alias remove-comments="grep -v -E '^(#|$|[[:space:]])'"
alias meuip='curl -s http://ipinfo.io/json/ | jq'
_EOF

# Step 9: Customize bash prompt and history settings
cat << '_EOF' >> ~/.bashrc
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%F %T "
export TERM=xterm

PS1='\[\e[1;31m\]\342\224\214\342\224\200\[\e[1;31m\][\[\e[1;33m\]\u\[\e[1;37m\]@\[\e[1;36m\]\h\[\e[1;31m\]]\[\e[1;31m\]\342\224\200\[\e[1;31m\][\[\e[1;33m\]\w\[\e[1;31m\]]\[\e[1;31m\]\342\224\200[\[\e[1;37m\]\d \t\[\e[1;31m\]]\n\[\e[1;31m\]\342\224\224\342\224\200\342\224\200\342\225\274\[\e[1;37m\] \$ \[\e[0m\]'
_EOF

# Step 10: Configure vim settings
cat << '_EOF' >> /root/.vimrc
source $VIMRUNTIME/defaults.vim
set mouse-=a
_EOF

# Step 11: Install and configure fail2ban
apt-get -y install fail2ban

cat << '_EOF' > /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = 127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16
bantime  = 3h
findtime  = 1h
maxretry = 2

[sshd]
enabled = true
_EOF

systemctl enable --now fail2ban.service

# Step 12: Install Zabbix Agent and Proxy
wget https://repo.zabbix.com/zabbix/7.0/raspbian/pool/main/z/zabbix-release/zabbix-release_7.0-2+debian12_all.deb
dpkg -i zabbix-release_7.0-2+debian12_all.deb
apt update
apt install -y zabbix-get zabbix-sender zabbix-agent2 zabbix-agent2-plugin-* zabbix-proxy-sqlite3

# Step 13: Backup Zabbix configuration files
cp /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf.orig
cp /etc/zabbix/zabbix_proxy.conf /etc/zabbix/zabbix_proxy.conf.orig

# Step 14: Configure Zabbix Agent
cat << '_EOF' > /etc/zabbix/zabbix_agent2.conf
PidFile=/var/run/zabbix/zabbix_agent2.pid
LogFile=/var/log/zabbix/zabbix_agent2.log
LogFileSize=0
Timeout=30
Server=127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
TLSConnect=psk
TLSAccept=unencrypted,psk
TLSPSKIdentity=PSK $(hostname -s)
TLSPSKFile=/etc/zabbix/zabbix_secret_key.psk
AllowKey=system.run[*]
Plugins.SystemRun.LogRemoteCommands=1
ControlSocket=/run/zabbix/agent.sock
Include=/etc/zabbix/zabbix_agent2.d/*.conf
Include=./zabbix_agent2.d/plugins.d/*.conf
_EOF

# Step 15: Configure Zabbix Proxy
cat << '_EOF' > /etc/zabbix/zabbix_proxy.conf
Server=0.0.0.0/0
LogFile=/var/log/zabbix/zabbix_proxy.log
EnableRemoteCommands=1
LogRemoteCommands=1
LogFileSize=0
PidFile=/run/zabbix/zabbix_proxy.pid
SocketDir=/run/zabbix
DBName=/tmp/zabbix_proxy.db
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=PSK $(hostname -s)
TLSPSKFile=/etc/zabbix/zabbix_proxy.psk
_EOF

# Step 16: Generate PSK keys and restart Zabbix services
openssl rand -hex 32 > /etc/zabbix/zabbix_secret_key.psk
openssl rand -hex 32 > /etc/zabbix/zabbix_proxy.psk
systemctl enable --now zabbix-agent2.service
systemctl restart zabbix-agent2.service

# Step 17: Print generated PSK keys and TLSPSKIdentity
echo "Zabbix Agent PSK Key ( You have to configure it on ZABBIX AGENT ENCRYPTION TAB TOGETHER WITH PSK IDENTITY ):"
cat /etc/zabbix/zabbix_secret_key.psk
echo "Zabbix Proxy PSK Key ( You have to configure it on ZABBIX PROXY ENCRYPTION TAB TOGETHER WITH PSK IDENTITY ):"
cat /etc/zabbix/zabbix_proxy.psk
echo "TLSPSKIdentity: PSK $(hostname -s)"

# Step 18: Enable Zabbix user as sudoer without password
cat << '_EOF' > /etc/sudoers.d/zabbix-nopasswd
zabbix ALL=(ALL) NOPASSWD: ALL
_EOF
