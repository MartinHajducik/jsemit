# Debian Upgrade Script
#!/bin/bash

# Simulates a dnf -y upgrade --refresh
#
# 02/Mar/2022 - jarbas.junior@gmail.com - Initial implementation
#

export PATH="/usr/sbin:/usr/bin:$HOME/bin"

# If this script is already running then do nothing.
pidof -x -o %PPID $0 > /dev/null && echo "Script $0 still in execution..." && exit

# Some global variables
#
BASENAME=`basename $0 .Sh`
DIRNAME=`dirname $0`

# Data e Hora Local
DATAHORA=`date +%Y%m%d-%H%M%S`

# Dia da semana (dom, seg, ...)
DDS=`date +%a`

# Get the hostname
HOSTNAME=`hostname -f`

# Server IP (eth0 ou ens192)
IP=`hostname --all-ip-addresses | awk '{ print $1 }'`

# Temp file name
FILE_LOG="/tmp/$BASENAME.log"

# Enable cancel with ^C, etc..
# See more in http://www.ibm.com/developerworks/aix/library/au-usingtraps/
trap _abort 1 2 3 15
#------------------------------------------
# Inform about then cancel
_abort()
{ # BEGIN _abort
       echo "!!! $0 CANCEL by user.">&2
       exit 1
} # END _abort

{
echo "Begin Execution: `date`"

echo -e "
========== Global Variables ====================================
SCRIPTNAME......: [$0]
BASENAME........: [$BASENAME]
DIRNAME.........: [$DIRNAME]
HOSTNAME........: [$HOSTNAME]
IP..............: [$IP]
DATAHORA........: [$DATAHORA]
FILE_LOG........: [$FILE_LOG]
================================================================
"

# https://www.cyberciti.biz/faq/explain-debian_frontend-apt-get-variable-for-ubuntu-debian/

export NEEDRESTART_MODE=a
export DEBIAN_FRONTEND=noninteractive
## Questions that you really, really need to see (or else). ##
export DEBIAN_PRIORITY=critical

echo "========== apt-get update ================================================="
apt-get -qy update
echo "========== apt-get upgrade -y ============================================="
apt-get -qy upgrade -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold"
echo "========== apt-get dist-upgrade -y ========================================"
apt-get -qy dist-upgrade
echo "========== apt-get autoremove -y =========================================="
apt-get -qy autoremove
echo "========== apt-get clean all =============================================="
apt-get -qy clean all
echo "==========================================================================="

echo "END: `date`"

} 2>&1 | tee ${FILE_LOG}