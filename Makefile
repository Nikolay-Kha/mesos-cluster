OS                ?= ubuntu
DOCKER_IMAGE_NAME  = mesos_cluster_node
PWD                = $(shell pwd)

.PHONY: all clean start stop restart

all:
	docker build -t ${DOCKER_IMAGE_NAME} -f ${PWD}/docker/Dockerfile.${OS} ${PWD}/docker

clean:
	docker rmi -f ${DOCKER_IMAGE_NAME} | true
	docker network rm erlmesoscluster_app_net | true

start: all
	docker-compose -f ${PWD}/cluster.yml up -d

stop:
	docker-compose -f ${PWD}/cluster.yml kill
	docker-compose -f ${PWD}/cluster.yml rm -f --all

restart: stop start

