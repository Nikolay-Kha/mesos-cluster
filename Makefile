OS                ?= ubuntu
DOCKER_IMAGE_NAME  = mesos_cluster_node
PWD                = $(shell pwd)

.PHONY: all clean start stop restart

all:
	docker build -t ${DOCKER_IMAGE_NAME} -f ${PWD}/docker/Dockerfile.${OS} ${PWD}/docker

clean:
	docker ps -a | grep erl_mesos_ | awk '{print $$1}' | xargs -I {} docker rm -f {}
	docker rmi -f ${DOCKER_IMAGE_NAME} | true
	docker network rm mesoscluster_app_net | true

start: all
	docker-compose -f ${PWD}/cluster.yml up -d

stop:
	docker-compose -f ${PWD}/cluster.yml kill
	docker-compose -f ${PWD}/cluster.yml rm -f --all

restart: stop start

