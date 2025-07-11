all: stop start

start:
	docker compose up & 

stop: 
	docker compose down
