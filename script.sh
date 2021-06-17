#!/bin/bash -u

# ***********************************
#
# Reference :
# https://github.com/jplew/SyncDB/blob/master/syncdb
#************************************

# Variables
PROJECT_DIR=$(basename `pwd`)
PROJECT_EXTRA_IDENTIFIER="docker"
PROJECT_NAME=${PROJECT_DIR}-${PROJECT_EXTRA_IDENTIFIER}

# Date placeholders
today=$(date +"%y%m%d")
now=$(date +"%y%m%d-%H%M")


# directory
WPDIR="src"
LOCAL_DB_DIR="db"
LOCAL_SQL_DIR=$LOCAL_DB_DIR/sql

# Database Information
DB_NAME=${PROJECT_DIR}_db
DB_USER="root"
DB_PASSWORD="root"
DB_HOST=$(docker exec -it ${PROJECT_NAME}_db hostname)
DB_PORT=3306
DB_COLLATE="utf8_default_ci"



# ====================================
#  FUNCTIONS
# ====================================

# ---------------------------------------------------------
# update_config ()
# This function to update wp-config.php
# ---------------------------------------------------------
update_config () {
   # check if the file exists in app_directory
   # if not exists, check for sample file and copy
   # update config file
   
}

