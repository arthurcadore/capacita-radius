CERT_DIR=./certs

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

generate-certs: clean-certs
	mkdir -p $(CERT_DIR)
	openssl genrsa -out $(CERT_DIR)/ca.key 4096
	openssl req -x509 -new -key $(CERT_DIR)/ca.key -out $(CERT_DIR)/ca.pem -days 3650 -subj "/CN=My-CA"

	openssl genrsa -out $(CERT_DIR)/server.key 2048
	openssl req -new -key $(CERT_DIR)/server.key -out $(CERT_DIR)/server.csr -subj "/CN=freeradius"
	openssl x509 -req -in $(CERT_DIR)/server.csr -CA $(CERT_DIR)/ca.pem -CAkey $(CERT_DIR)/ca.key -CAcreateserial -out $(CERT_DIR)/server.pem -days 365 -sha256
	rm -f $(CERT_DIR)/server.csr

	openssl genrsa -out $(CERT_DIR)/client.key 2048
	openssl req -new -key $(CERT_DIR)/client.key -out $(CERT_DIR)/client.csr -subj "/CN=capacitaclient"
	openssl x509 -req -in $(CERT_DIR)/client.csr -CA $(CERT_DIR)/ca.pem -CAkey $(CERT_DIR)/ca.key -CAcreateserial -out $(CERT_DIR)/client.pem -days 365 -sha256
	rm -f $(CERT_DIR)/client.csr

clean-certs:
	rm -f $(CERT_DIR)/*.key $(CERT_DIR)/*.pem $(CERT_DIR)/*.csr $(CERT_DIR)/*.srl