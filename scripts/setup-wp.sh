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
	echo "archiving themes ..."
	tar -czf ../../backup/${TODAY}/themes.tar.gz themes/
	echo "archiving uploads ..."
	tar -czf ../../backup/${TODAY}/uploads.tar.gz uploads/
	echo "archiving plugins ..."
	tar -czf ../../backup/${TODAY}/plugins.tar.gz plugins/
}

backup_code
