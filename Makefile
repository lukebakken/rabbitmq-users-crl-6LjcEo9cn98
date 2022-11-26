.PHONY: clean

clean:
	cd tls-gen && git clean -xffd

rabbitmq/certs/server_rabbitmq_certificate.pem: server-certificate
	cp -vf tls-gen/basic/result/ca_certificate.pem producer
	cp -vf tls-gen/basic/result/client_rabbitmq_certificate.pem producer
	cp -vf tls-gen/basic/result/ca_certificate.pem consumer
	cp -vf tls-gen/basic/result/client_rabbitmq_certificate.pem consumer
	cp -vf tls-gen/basic/result/ca_certificate.pem rmq/certs
	cp -vf tls-gen/basic/result/server_rabbitmq_certificate.pem rmq/certs
	cp -vf tls-gen/basic/result/server_rabbitmq_key.pem rmq/certs

tls-gen/basic/result/server_rabbitmq_certificate.pem:
	cd tls-gen/basic && $(MAKE) CN=rabbitmq

tls-gen/basic/result/basic.crl.pem:
	cd tls-gen/basic && $(MAKE) gen-crl
	cp -vf tls-gen/basic/result/basic.crl crl

server-certificate-rabbitmq: rabbitmq/certs/server_rabbitmq_certificate.pem
server-certificate: tls-gen/basic/result/server_rabbitmq_certificate.pem
crl: tls-gen/basic/result/basic.crl.pem
certs: server-certificate server-certificate-rabbitmq crl
