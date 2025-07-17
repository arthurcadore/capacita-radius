all: stop start

start:
	docker compose up & 

stop: 
	docker compose down

clean: stop
	docker ps -a -q | xargs -r docker stop
	docker ps -a -q | xargs -r docker rm
	docker images -q | xargs -r docker rmi -f
	docker volume ls -q | xargs -r docker volume rm

generate-certs:
    openssl req -x509 -newkey rsa:4096 -keyout ./certs/server.key -out ./certs/server.pem -days 365 -nodes -subj "/CN=freeradius"