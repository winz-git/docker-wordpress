.PHONY: echo
.DEFAULT_GOAL:=list

include .env

PROJECT := ${PROJECT_NAME}
IMAGE_EXITED := $(shell docker ps -q -f 'status=exited')
IMAGE_DANGLING := $(shell docker images -q -f "dangling=true")
PARAM_DATETIME := $(shell date +%Y%m%d%H%M)
DB_HOST := $(shell docker exec -it ${PROJECT_NAME}_db hostname)



build: stop
	@docker-compose -p ${PROJECT} build --force-rm --no-cache

start:
	@docker-compose -p ${PROJECT} up -d

stop:
	@docker-compose -p ${PROJECT} stop

down:
	@docker-compose -p ${PROJECT} down --remove-orphans

clean:	stop
	@docker-compose -p ${PROJECT} rm

clean-images:
	docker images -q | xargs ${PROJECT} rmi

list:
	@docker-compose -p ${PROJECT} ps

logs:
	@docker-compose -p ${PROJECT} logs -f

wp-download:
	@docker exec -it ${PROJECT_NAME}_phpfpm wp core download --skip-themes --skip-plugins --allow-root

wp-config: create-host wp-download
	@echo "Getting database hostname"
	@echo "db_host:${DB_HOST}"
	@echo "copy wp-config.php"
	@docker exec -it ${PROJECT_NAME}_phpfpm cp wp-config-sample.php wp-config.php
	@echo "Using wp config set, since our phpfpm don't have mysql"
	@echo "Setting DB_NAME"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp config set DB_NAME ${MYSQL_DATABASE} --allow-root
	@echo "Setting DB_HOST"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp config set DB_HOST ${DB_HOST}:3306 --allow-root
	@echo "Setting DB_USER"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp config set DB_USER root --allow-root
	@echo "Setting DB_PASSWORD"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp config set DB_PASSWORD ${MYSQL_ROOT_PASSWORD} --allow-root
	@echo "Setting table_prefix"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp config set table_prefix wppd_ --allow-root

wp-replace-url:
	@echo "replace url"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp search-replace ${SOURCE_URL} ${TARGET_URL} --all-tables --report-changed-only --allow-root
	@echo "Replace Path"
	@docker exec -it ${PROJECT_NAME}_phpfpm wp search-replace ${SOURCE_PATH} ${TARGET_PATH} --all-tables --report-changed-only --allow-root

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
