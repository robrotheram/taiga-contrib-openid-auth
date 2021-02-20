ifndef CIRCLE_BRANCH
override CIRCLE_BRANCH = latest
endif

all: clean test build

build: build-front build-back

build-front:
	cd front && npm install && npm run build
	docker build docker/front -t robrotheram/taiga-front-openid:$(CIRCLE_BRANCH)
	docker build docker/front -t robrotheram/taiga-front-openid:latest

build-back:
	docker build docker/back -t robrotheram/taiga-back-openid:$(CIRCLE_BRANCH)
	docker build docker/back -t robrotheram/taiga-back-openid:latest
	
publish:
	docker push robrotheram/taiga-back-openid:$(CIRCLE_BRANCH)
	docker push robrotheram/taiga-back-openid:latest
	docker push robrotheram/taiga-front-openid:$(CIRCLE_BRANCH)
	docker push robrotheram/taiga-front-openid:latest