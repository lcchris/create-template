#!/usr/bin/env bash
#
#Create vmtemplate for CentOS6.
#
#===============
#REMOVE SOFTWARE
#===============
yum remove -y dracut* *firmware* selinux* system-config* iptables-ipv6 efibootmgr iwl* ibus desktop-file-utils sound-theme-freedesktop fontconfig cups* wqy* *gnome* *icon*

#===========
#CLEAN UP OS
#===========
logrotate -f /etc/logrotate.conf &>/dev/null
cat /dev/null > /var/log/audit/audit.log &>/dev/null
cat /dev/null > /var/log/wtmp &>/dev/null
rm /usr/share/man -rf &>/dev/null
rm /usr/share/doc -rf &>/dev/null
rm /usr/share/info -rf &>/dev/null
rm /tmp/* -rf &>/dev/null
rm /var/tmp/* -rf &>/dev/null
rm /var/cache/yum/* -rf &>/dev/null
rm /sbin/sln -rf &>/dev/null
rm /etc/rpm/macros.imgcreate -rf &>/dev/null
rm /etc/udev/rules.d/70* -rf &>/dev/null
rm /var/lib/dhclient/* -rf &>/dev/null
rm /etc/ssh/*key* -rf &>/dev/null
rm /var/log/*-* -rf &>/dev/null
rm /var/log/*.gz -rf &>/dev/null
rm /etc/yum.repos.d/*.repo -rf &>/dev/null
find / -name "*.jpg"|xargs rm -rf
find / -name "*.png"|xargs rm -rf

#===============
#DISABLE SERVICE
#===============
chkconfig mdmonitor off
chkconfig netconsole off
chkconfig netfs off
chkconfig restorecond off
chkconfig saslauthd off
chkconfig udev-post off

#================
#CLEAN UP TOMCAT6
#================
/usr/sbin/tomcat6 stop 0
rm /var/log/tomcat6/* -rf &>/dev/null
rm /usr/share/java/tomcat6/temp/* -rf &>/dev/null
rm /usr/share/java/tomcat6/work/* -rf &>/dev/null

#=================
#CLEAN UP GEOAGENT
#=================
kill -9 $(ps aux|grep "/opt/geoagent/bin/geoagent"|grep -v "grep"|awk '{print $2}')
rm /opt/geoagent/log -rf &>/dev/null

#===================
#CREATE VERSION INFO
#===================
echo "TEMPLATE_BUILD_TIME=$(date +%Y%m%d%H%M)">>/BUILDING
echo "ORACLE_JDK_VERSION=$(rpm -qa|grep "^jdk"|awk -F '-' '{print $2}')">>/BUILDING
echo "APACHE_TOMCAT_VERSION=$(tomcat6 version|grep "Server version:"|awk -F ': ' '{print $2}'|awk -F '/' '{print $2}')">>/BUILDING
echo "OPERATIONPROXY_VERSION=$(rpm -qa|grep "geostack-operationproxy")">>/BUILDING
echo "GEOAGENT_VERSION=$(cat /opt/geoagent/Version|grep "^VERSION"|awk -F "=" '{print $2}')">>/BUILDING
echo "GEOGLOBE_VERSION=$(rpm -qa|grep "geoglobe_server-jdk_expansion")">>/BUILDING
#geosmarter_version=
echo "#####">>/BUILDING

#==========================
#CLEAN UP OPERATION RECORDS
#==========================
yum clean all
:>~/.bash_history
history -c
#poweroff
