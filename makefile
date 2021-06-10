PROJECT := wordpress_dev
IMAGE_EXITED := $(shell docker ps -q -f 'status=exited')
IMAGE_DANGLING := $(shell docker images -q -f "dangling=true")
PARAM_DATETIME := $(shell date +%Y%m%d%H%M)

.PHONY: echo
.DEFAULT_GOAL:=list

build: stop
	@docker-compose -p ${PROJECT} build --force-rm --no-cache

up:
	@docker-compose -p ${PROJECT} up -d --remove-orphans

stop:
	@docker-compose -p ${PROJECT} stop

down:
	@docker-compose -p ${PROJECT} down --remove-orphans
clean:	stop
	@docker-compose -p ${PROJECT} rm amp-app memcache
clean-images:
	docker images -q | xargs ${PROJECT} rmi
list:
	@docker-compose -p ${PROJECT} ps
bash:
	@docker-compose -p ${PROJECT} exec amp-app /bin/bash
logs-pm:
	@docker exec -ti ${PROJECT} bash -c "pm2 logs"
logs:
	@docker-compose -p ${PROJECT} logs -f
dump_db:
ifdef PARAM_DATETIME
	@echo "param_date: "${PARAM_DATETIME}
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
