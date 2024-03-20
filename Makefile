ifndef CIRCLE_BRANCH
override CIRCLE_BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
endif

ifndef CIRCLE_TAG
override CIRCLE_TAG = latest
endif

#!make
include .env
export $(shell sed 's/=.*//' .env)

testenv: 
	env

all: clean test build

build: build-front build-back

build-front:
	cd front && npm install && npm run build
	echo $(CIRCLE_BRANCH)
	sudo docker build -f docker/front/Dockerfile --no-cache . -t ${dockerhubrepofront}:$(CIRCLE_TAG)  --build-arg RELEASE=$(CIRCLE_BRANCH) --build-arg TAIGA_VERSION=$(CIRCLE_TAG)

build-back:
	sudo docker build -f docker/back/Dockerfile --no-cache . -t ${dockerhubrepoback}:$(CIRCLE_TAG)  --build-arg RELEASE=$(CIRCLE_BRANCH) --build-arg TAIGA_VERSION=$(CIRCLE_TAG)

publish:
	sudo docker push ${dockerhubrepofront}:$(CIRCLE_TAG)
	sudo docker push ${dockerhubrepoback}:$(CIRCLE_TAG)
