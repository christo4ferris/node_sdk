all: docker
docker: Dockerfile app.js
	docker build -t fabric-sdk .
