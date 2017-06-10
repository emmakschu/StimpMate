#!/bin/bash

###############################################################
#              StimpMate installation script                  #
#                                                             #
# Author:   Michael K Schumacher (Github: @mkschu)            #
# Email:    michael@mkschumacher.com                          #
# Created:  8 June 2017 02:35 UTC                             #
# Modified: 10 June 2017 01:46 UTC                            #
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
echo "Checking dependencies"

OP_SYS=`uname -o`
if [ "$OP_SYS" != "GNU/Linux" ] ; then
    echo "Your operating system is not supported."
    echo "This script is only written for Linux systems"
    exit 1
fi

RUBY_VER=`ruby -v`
if [ "$RUBY_VER" = "" ] ; then
    echo "You need to install Ruby before you can install StimpMate"
    exit 1
fi

RAILS_VER=`rails -v`
if [ "$RAILS_VER" = "" ] ; then
    echo "You need to install Rails before you can install StimpMate"
    exit 1
fi

MYSQL_VER=`mysql --version`
if [ "$MYSQL_VER" = "" ] ; then
    echo "You need a MySQL/MariaDB server installed to use StimpMate"
    exit 1
fi

HAS_PYTHON=1
PYTHON_VER=`python -c "import sys; print(sys.version_info[0])"`
if [ "$PYTHON_VER" = 3 ] ; then
    PYTHON2_VER=`python2 -c "import sys; print(sys.version_info[0])"`
    if [ "$PYTHON2_VER" = "" ] ; then
        echo "WARNING: Python 3 may cause problems with matplotlib!"
	echo "Python 2.7 is recommended at this time."
    fi
elif [ "$PYTHON_VER" = "" ] ; then
    echo "You need to have python installed to use the graphing features."
    echo "Python 2.7 is the recommened version due to matplotlib 
    	  compatibility issues in Python 3"
    echo "compatibility issues with Python 3"
    HAS_PYTHON=0
fi


#------------------------------------------------------
# Set the app's source & build directories and enduser
#------------------------------------------------------
SRC_DIR=$(pwd)
TARGET_DIR="/var/www/public_html"
ENDUSER=$(echo "$USER")


#------------------------------------
# Set up MySQL database and app user
#------------------------------------
echo "Setting up database; You will need to enter MySQL root password"
mysql -u root -p -e "CREATE DATABASE stimpMate;"
mysql stimpMate -u root -p -e "GRANT ALL PRIVILEGES ON stimpMate
	TO 'stimpMateApp'@localhost IDENTIFIED BY 'schuLutions';
	FLUSH PRIVILEGES;"
echo "Database and app user created"


#----------------------------------------------------
# Check for build dir existence and write permission
# Create and modify ownership if necessary
#----------------------------------------------------
[ -d "$TARGET_DIR" ] || sudo mkdir ${TARGET_DIR}
[ -w "$TARGET_DIR" ] || sudo chown ${ENDUSER} ${TARGET_DIR}


#----------------------------------------------------------
# Move to the target directory to begin building Rails app
#----------------------------------------------------------
cd "$TARGET_DIR"
[ -d "stimpMate" ] || rails new stimpMate -d mysql
cd stimpMate
bundle install


#---------------------------------------------------------
# Copy base Rails app files from src to new app directory
#---------------------------------------------------------
echo "Copying files from source directory"
cp -r  ${SRC_DIR}/src/* ${TARGET_DIR}/stimpMate/


#-------------------------------------------------------------------
# Set the directory for Python scripts to draw graphs, if installed
#-------------------------------------------------------------------
if [ "$PYTHON_VER" != "" ] ; then
    echo "Creating directory for Python scripts"
    PYTHON_DIR="/var/www/public_html/stimpMate/pythonscripts"
    mkdir "$PYTHON_DIR"
    echo "Copying Python scripts from source directory"
    cp -r ${SRC_DIR}/pythonscripts/* ${TARGET_DIR}/stimpMate/pythonscripts/
else
    echo "Skipping Python folder, since Python is not installed."
fi
