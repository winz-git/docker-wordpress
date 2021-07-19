.PHONY: echo
.DEFAULT_GOAL:=list

include .env

PROJECT := ${PROJECT_NAME}
IMAGE_EXITED := $(shell docker ps -q -f 'status=exited')
IMAGE_DANGLING := $(shell docker images -q -f "dangling=true")
PARAM_DATETIME := $(shell date +%Y%m%d%H%M)
TODAY := $(shell date +%Y%m%d)
DB_HOST := $(shell docker exec -it ${PROJECT_NAME}_db hostname)
TABLE_PREFIX := $(shell docker exec -it ${PROJECT_NAME}_phpfpm wp db prefix --allow-root)


build: stop
	@docker-compose build --force-rm --no-cache

start:
	@docker-compose up -d

stop:
	@docker-compose stop

down:
	@docker-compose down --remove-orphans

clean:	stop
	@docker-compose rm

clean-images:
	docker images -q | xargs ${PROJECT} rmi

list:
	@docker-compose ps

logs:
	@docker-compose logs -f

wp-download:
	@docker exec -it ${PROJECT_NAME}_phpfpm wp core download --skip-themes=twentynineteen,twentytwenty,twentytwentyone --skip-plugins --allow-root

wp-setup: create-host start wp-config

wp-config: wp-download
	@echo "Getting database hostname"
	@echo "db_host:${DB_HOST:-db}"
	@echo "copy wp-config.php"
	@docker exec -it ${PROJECT_NAME}_phpfpm cp wp-config-sample.php wp-config.php
	@echo "Using wp config set, since our phpfpm don't have mysql"
	@echo "Setting DB_NAME"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp config set DB_NAME ${MYSQL_DATABASE} --allow-root
	@echo "Setting DB_HOST"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp config set DB_HOST ${DB_HOST:-db}:3306 --allow-root
	@echo "Setting DB_USER"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp config set DB_USER root --allow-root
	@echo "Setting DB_PASSWORD"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp config set DB_PASSWORD ${MYSQL_ROOT_PASSWORD} --allow-root
	@echo "Setting table_prefix"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp config set table_prefix ${TABLE_PREFIX} --allow-root

wp-replace-url:
	@echo "Replace url..."
	@docker exec -it ${PROJECT_NAME}_phpfpm wp search-replace ${SOURCE_URL} ${TARGET_URL} --all-tables --report-changed-only --allow-root
	@echo "Replace Path..."
	@docker exec -it ${PROJECT_NAME}_phpfpm wp search-replace ${SOURCE_PATH} ${TARGET_PATH} --all-tables --report-changed-only --allow-root

docker-restart:
	@echo "Docker Restart - phpfpm..."
	@docker restart ${PROJECT_NAME}_phpfpm
	@echo "Docker Restart - web..."
	@docker restart ${PROJECT_NAME}_web

db-restore:
	cat ${SQL_FULL_PATH} | docker exec -i ${PROJECT_NAME}_db /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE}

db-backup:
	@echo "create backup folder today"
	mkdir -p ${BACKUP_PATH}/${TODAY}
	@echo "Executing mysqldump..."
	@docker exec -i ${PROJECT_NAME}_db sh -c 'exec mysqldump -uroot -p"${MYSQL_ROOT_PASSWORD}" ${MYSQL_DATABASE}' > ${BACKUP_TODAY}/${BACKUP_SQL_FILE}

create-host:
	./scripts/manage-etc-hosts.sh add 127.0.0.1 ${TARGET_URL}

remove-host:
	./scripts/manage-etc-hosts.sh remove 127.0.0.1 ${TARGET_URL}


dump_db:
ifdef PARAM_DATETIME
	@echo "param_date: ${PARAM_DATETIME}"
endif

free-space:
ifneq ($(strip $(IMAGE_EXITED)),)
	@echo "Remove images with status `exited`"
	docker rm ${IMAGE_EXITED}
	@echo "Done!"
endif
ifneq ($(strip $(IMAGE_DANGLING)),)
	@echo "Remove images with status `dangling=true`"
	docker rmi ${IMAGE_DANGLING}
	@echo "Done!"
endif
