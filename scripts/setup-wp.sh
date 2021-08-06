#!/usr/bin/env bash

set -u

#*************************************
# better if the user is a sudoer
#
#*************************************

# Variables
# load env
source ./.env

#*************************************
# functions
#*************************************


backup_remote() {
	echo "Backup remote" 
}

transfer_files() {
	echo "Transfering files"
}

install_wp-cli() {
	echo "installing wp-cli"
}

backup_code() {
	echo "create directory for today at backup..."
	mkdir -p ${BACKUP_TODAY}
	echo "change directory to wp-content.."
	cd src/wp-content/
	echo "current working directory ${PWD}"
	echo "checking if themes already exists"
	backup_dir="../../backup"
	theme_file="$backup_dir/${TODAY}/themes.tar.gz"
	echo "backup_dir:$backup_dir, $theme_file"
	if [ -f "$theme_file" ]
	then mv "$theme_file" "$theme_file-$(date +%H%M%S)"
	fi
	echo "archiving themes ..."
	tar_result=$(tar -czf ../../backup/${TODAY}/themes.tar.gz themes/)
	echo ${tar_result}
	echo "checking if uploads already exists"
	upload_file="$backup_dir/${TODAY}/uploads.tar.gz"
	if [ -f "$upload_file" ]
	then mv "$upload_file" "$upload_file-$(date +%H%M%S)"
	fi
	echo "archiving uploads ..."
	tar_result=$(tar -czf ../../backup/${TODAY}/uploads.tar.gz uploads/)
	echo ${tar_result}
	echo "checking if plugins already exists"
	plugins_file="$backup_dir/${TODAY}/plugins.tar.gz"
	if [ -f "$plugins_file" ]
	then mv "$plugins_file" "$plugins_file-$(date +%H%M%S)"
	fi
	echo "archiving plugins ..."
	tar_result=$(tar -czf ../../backup/${TODAY}/plugins.tar.gz plugins/)
	echo ${tar_result}
}

backup_code
