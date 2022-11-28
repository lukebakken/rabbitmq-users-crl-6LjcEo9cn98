.PHONY: clean

clean:
	cd tls-gen && git clean -xffd
	rm -vf $(CURDIR)/rmq0/certs/*.pem
	rm -vf $(CURDIR)/rmq1/certs/*.pem
	rm -vf $(CURDIR)/producer/*.pem
	rm -vf $(CURDIR)/consumer/*.pem

tls-gen/basic/result/server_localhost_certificate.pem:
	cd tls-gen/basic && $(MAKE) CN=localhost

tls-gen/basic/result/server_rmq0_certificate.pem:
	cd tls-gen/basic && $(MAKE) CN=rmq0 gen-server gen-client
	cp -vf tls-gen/basic/result/ca_certificate.pem producer
	cp -vf tls-gen/basic/result/client_rmq0_certificate.pem producer
	cp -vf tls-gen/basic/result/client_rmq0_key.pem producer
	cp -vf tls-gen/basic/result/ca_certificate.pem rmq0/certs
	cp -vf tls-gen/basic/result/server_rmq0_certificate.pem rmq0/certs
	cp -vf tls-gen/basic/result/server_rmq0_key.pem rmq0/certs

tls-gen/basic/result/server_rmq1_certificate.pem:
	cd tls-gen/basic && $(MAKE) CN=rmq1 gen-server gen-client
	cp -vf tls-gen/basic/result/ca_certificate.pem consumer
	cp -vf tls-gen/basic/result/client_rmq1_certificate.pem consumer
	cp -vf tls-gen/basic/result/client_rmq1_key.pem consumer
	cp -vf tls-gen/basic/result/ca_certificate.pem rmq1/certs
	cp -vf tls-gen/basic/result/server_rmq1_certificate.pem rmq1/certs
	cp -vf tls-gen/basic/result/server_rmq1_key.pem rmq1/certs

tls-gen/basic/result/basic.crl.pem:
	cd tls-gen/basic && $(MAKE) gen-crl
	cp -vf tls-gen/basic/result/basic.crl crl

rmq0-certificates: base-certificates tls-gen/basic/result/server_rmq0_certificate.pem
rmq1-certificates: base-certificates tls-gen/basic/result/server_rmq1_certificate.pem
base-certificates: tls-gen/basic/result/server_localhost_certificate.pem
crl: tls-gen/basic/result/basic.crl.pem
certs: base-certificates rmq0-certificates rmq1-certificates crl
