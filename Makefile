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
	# Gera a CA
	openssl genrsa -out $(CERT_DIR)/ca.key 4096
	openssl req -x509 -new -key $(CERT_DIR)/ca.key -out $(CERT_DIR)/ca.pem -days 3650 -subj "/CN=My-CA"

	# Gera chave e CSR do servidor
	openssl genrsa -out $(CERT_DIR)/server.key 2048
	openssl req -new -key $(CERT_DIR)/server.key -out $(CERT_DIR)/server.csr -subj "/CN=freeradius"

	# Assina o certificado do servidor com a CA
	openssl x509 -req -in $(CERT_DIR)/server.csr -CA $(CERT_DIR)/ca.pem -CAkey $(CERT_DIR)/ca.key -CAcreateserial -out $(CERT_DIR)/server.pem -days 365 -sha256

	# Remove o CSR após uso
	rm -f $(CERT_DIR)/server.csr

clean-certs:
	rm -f $(CERT_DIR)/server.key $(CERT_DIR)/server.pem $(CERT_DIR)/server.csr
	rm -f $(CERT_DIR)/ca.key $(CERT_DIR)/ca.pem $(CERT_DIR)/ca.srl