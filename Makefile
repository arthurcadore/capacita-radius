all: stop start

start: generate-certs
	docker compose up & 

stop: 
	docker compose down

clean: stop docker-cleanup clean-certs

docker-cleanup:
	docker ps -a -q | xargs -r docker stop
	docker ps -a -q | xargs -r docker rm
	docker images -q | xargs -r docker rmi -f
	docker volume ls -q | xargs -r docker volume rm

clean-certs:
	rm -rf ./certs/server.key ./certs/server.pem

generate-certs:
	openssl req -x509 -newkey rsa:4096 -keyout ./certs/server.key -out ./certs/server.pem -days 365 -nodes -subj "/CN=freeradius"