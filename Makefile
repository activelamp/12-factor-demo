SHELL := /usr/bin/env bash

####################
## Stack Commands ##
####################

setup: bundle-install pull-images pull-dependencies

setup-build: rebuild pull-dependencies

rebuild: bundle-install build

bundle-install:
	bundle install --path .bundle/gems

start:
	bundle exec docker-sync-stack start

start-services:
	docker-compose -f docker-compose.yml -f docker-compose-dev.yml up

start-sync:
	bundle exec docker-sync start --foreground

clean:
	bundle exec docker-sync-stack clean

pull-images:
	docker-compose pull

push-images:
	docker-compose push

pull-dependencies:

build:
	docker-compose build

#########################
## Individual Commands ##
#########################

