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
	echo $(CIRCLE_BRANCH)
	sudo docker build -f docker/front/Dockerfile --no-cache . -t jannefleischer/taiga-front-openid:$(CIRCLE_TAG)  --build-arg RELEASE=$(CIRCLE_BRANCH) --build-arg TAIGA_VERSION=$(CIRCLE_TAG)

build-back:
	sudo docker build -f docker/back/Dockerfile --no-cache . -t jannefleischer/taiga-back-openid:$(CIRCLE_TAG)  --build-arg RELEASE=$(CIRCLE_BRANCH) --build-arg TAIGA_VERSION=$(CIRCLE_TAG)

publish:
	sudo docker push jannefleischer/taiga-back-openid:$(CIRCLE_TAG)
	sudo docker push jannefleischer/taiga-front-openid:$(CIRCLE_TAG)
	
