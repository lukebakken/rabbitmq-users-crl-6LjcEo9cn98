.PHONY: clean

clean:
	cd tls-gen && git clean -xffd

rabbitmq/certs/server_rabbitmq_certificate.pem: server-certificate
	cp -vf tls-gen/basic/result/ca_certificate.pem producer
	cp -vf tls-gen/basic/result/ca_certificate.pem consumer
	cp -vf tls-gen/basic/result/ca_certificate.pem rmq/certs
	cp -vf tls-gen/basic/result/server_rabbitmq_certificate.pem rmq/certs
	cp -vf tls-gen/basic/result/server_rabbitmq_key.pem rmq/certs

tls-gen/basic/result/server_rabbitmq_certificate.pem:
	cd tls-gen/basic && make CN=rabbitmq

server-certificate-rabbitmq: rabbitmq/certs/server_rabbitmq_certificate.pem
server-certificate: tls-gen/basic/result/server_rabbitmq_certificate.pem
certs: server-certificate server-certificate-rabbitmq 
