#!/bin/bash

###############################################################
#              StimpMate installation script                  #
#                                                             #
# Author:   Michael K Schumacher (Github: @mkschu)            #
# Email:    michael@mkschumacher.com                          #
# Created:  8 June 2017 02:35 UTC                             #
# Modified: 8 June 2017 04:04 UTC                             #
#							      #
# This script is written to install the StimpMate web app on  #
# a *nix-based server, and will not be tested on every single #
# kernel or distro. View the documentation for further infor- #
# mation on setup or alternatives.                            #
#							      #
# The script will need to be run by somebody with su privile- #
# ges, but should NOT be run as root. Commands that require   #
# elevated privileges will seek them independently. You don't #
# want a Rails app owned by root.			      #
###############################################################


#-------------------------
# Check for prerequisites
#-------------------------
OP_SYS=$(uname -o)
if [ "$OP_SYS" != "GNU/Linux" ] ; then
    echo "Your operating system is not supported."
    echo "This script is only written for Linux systems"
    exit 1
fi

RUBY_VER=$(ruby -v)
if [ "$RUBY_VER" = "" ] ; then
    echo "You need to install Ruby before you can install StimpMate"
    exit 1
fi

RAILS_VER=$(rails -v)
if [ "$RAILS_VER" = "" ] ; then
    echo "You need to install Rails before you can install StimpMate"
    exit 1
fi

MYSQL_VER=$(mysql --version)
if [ "$MYSQL_VER" = "" ] ; then
    echo "You need a MySQL/MariaDB server installed to use StimpMate"
    exit 1
fi

PYTHON_VER=$(python -c 'import sys; print(sys.version_info[0])')
if [ "$PYTHON_VER" = 3 ] ; then
    PYTHON2_VER=$(python2 -c 'import sys; print(sys.version_info[0])')
    if [ "$PYTHON2_VER" = "" ] ; then
        echo "WARNING: Python 3 may cause problems with matplotlib!"
	echo "Python 2.7 is recommended at this time."
    fi
elif [ "$PYTHON_VER" = "" ] ; then
    echo "You need to have python installed to use the graphing features."
    echo "Python 2.7 is the recommened version due to matplotlib"
    echo "compatibility issues with Python 3"
fi


#------------------------------------------------------
# Set the app's source & build directories and enduser
#------------------------------------------------------
SRC_DIR=$(pwd)
TARGET_DIR="/var/www/public_html"
ENDUSER=$(echo "$USER")


#--------------------------------------------
# Create new MySQL db and automated app user
#--------------------------------------------
DB_NAME="stimpMate"
DB_USER="schuRailsApp"
DB_PASSWD="schuLutions!"

mysql -uroot -p -e "CREATE DATABASE ${DB_NAME};"
mysql -uroot -p -e "CREATE USER ${DB_USER};"
mysql -uroot -p -e "GRANT ALL PRIVILEGES ON ${DB_NAME} TO ${DB_USER} IDENTIFIED BY ${DB_PASSWD};"
mysql -uroot -p -e "FLUSH PRIVILEGES;"


#----------------------------------------------------
# Check for build dir existence and write permission
# Create and modify ownership if necessary
#----------------------------------------------------
[ -d "$TARGET_DIR" ] || su -c 'mkdir "$TARGET_DIR"' root
[ -w "$TARGET_DIR" ] || su -c 'chown "$ENDUSER" "$TARGET_DIR"'  root


#----------------------------------------------------------
# Move to the target directory to begin building Rails app
#----------------------------------------------------------
cd $TARGET_DIR
[ -d "stimpMate" ] || rails new stimpMate -d mysql
cd stimpMate
bundle install


#-------------------------------------------------------------------
# Set the directory for Python scripts to draw graphs, if installed
#-------------------------------------------------------------------
if [ "$PYTHON_VER" != "" ] ; then
    PYTHON_DIR="/var/www/public_html/stimpMate/pythonscripts"
    mkdir "$PYTHON_DIR"
else
    echo "Skipping Python folder, since Python is not installed."
fi


#---------------------------------------------------------
# Copy base Rails app files from src to new app directory
#---------------------------------------------------------
