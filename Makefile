.PHONY: push 

IMAGE_PREFIX ?= weops-next

KEYCLOAK_VERSION ?= 23.0.5
ELASTICSEARCH_VERSION ?= 8.11.4

push:
	git add . && codegpt commit . && git push

build-keycloak:
	cd support-files/keycloak && \
	docker build -t ${IMAGE_PREFIX}/keycloak:${KEYCLOAK_VERSION} .

build-elasticsearch:
	cd support-files/elasticsearch && \
	docker build -t ${IMAGE_PREFIX}/elasticsearch:${ELASTICSEARCH_VERSION} .

build:
	build-keycloak
	build-elasticsearch

pull-image:
	docker pull bitnami/kafka:3.6.1
	docker pull victoriametrics/victoria-metrics:v1.106.1
	docker pull postgres:15
	docker pull telegraf:1.29.4
	docker pull prom/snmp-exporter:v0.26.0
	docker pull bitnami/node-exporter:1.8.2
	docker pull bitnami/kube-state-metrics:2.13.0
	docker pull etherfurnace/cadvisor
	docker pull greatsql/greatsql:8.0.32-26
	docker pull dkron/dkron:4.0.0

release-arm:
	rm -Rf ./dist/arm
	mkdir -p ./dist/arm	
	
	docker save ${IMAGE_PREFIX}/keycloak:${KEYCLOAK_VERSION} | gzip > ./dist/arm/keycloak.tar.gz
	docker save ${IMAGE_PREFIX}/elasticsearch:${ELASTICSEARCH_VERSION} | gzip > ./dist/arm/elasticsearch.tar.gz
	docker save bitnami/kafka:3.6.1 | gzip > ./dist/arm/kafka.tar.gz
	docker save victoriametrics/victoria-metrics:v1.106.1 | gzip > ./dist/arm/victoria-metrics.tar.gz
	docker save postgres:15 | gzip > ./dist/arm/postgres.tar.gz
	docker save telegraf:1.29.4 | gzip > ./dist/arm/telegraf.tar.gz
	docker save prom/snmp-exporter:v0.26.0 | gzip > ./dist/arm/snmp-exporter.tar.gz
	docker save greatsql/greatsql:8.0.32-26 | gzip > ./dist/arm/greatsql.tar.gz
	docker save bitnami/node-exporter:1.8.2 | gzip > ./dist/arm/node-exporter.tar.gz
	docker save bitnami/kube-state-metrics:2.13.0 | gzip > ./dist/arm/kube-state-metrics.tar.gz
	docker save etherfurnace/cadvisor | gzip > ./dist/arm/cadvisor.tar.gz
	docker save dkron/dkron:4.0.0 | gzip > ./dist/arm/dkron.tar.gz
	du -sh ./dist/arm/
