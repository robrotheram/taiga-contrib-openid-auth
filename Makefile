ifndef CIRCLE_BRANCH
override CIRCLE_BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
endif

ifndef CIRCLE_TAG
override CIRCLE_TAG = latest
endif



all: clean test build

build: build-front build-back

build-front:
	cd front && npm install && npm run build
	docker build docker/front -t robrotheram/taiga-front-openid:$(CIRCLE_TAG)  --build-arg RELEASE=$(CIRCLE_BRANCH) --build-arg TAIGA_VERSION=$(CIRCLE_TAG)

build-back:
	docker build docker/back -t robrotheram/taiga-back-openid:$(CIRCLE_TAG)  --no-cache --build-arg RELEASE=$(CIRCLE_BRANCH) --build-arg TAIGA_VERSION=$(CIRCLE_TAG)
	docker build docker/back -t robrotheram/taiga-back-openid:latest --no-cache --build-arg RELEASE=$(CIRCLE_BRANCH)
	
publish:
	docker push robrotheram/taiga-back-openid:$(CIRCLE_TAG)
	docker push robrotheram/taiga-back-openid:latest
	docker push robrotheram/taiga-front-openid:$(CIRCLE_TAG)
	docker push robrotheram/taiga-front-openid:latest