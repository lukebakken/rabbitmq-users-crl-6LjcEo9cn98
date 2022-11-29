FROM rabbitmq:3-management

COPY --chown=rabbitmq:rabbitmq --chmod=0400 erlang.cookie /var/lib/rabbitmq/.erlang.cookie
COPY --chown=rabbitmq:rabbitmq --chmod=0400 certs/*.pem /etc/rabbitmq/
COPY --chown=rabbitmq:rabbitmq definitions.json /etc/rabbitmq/
COPY --chown=rabbitmq:rabbitmq enabled_plugins /etc/rabbitmq/
COPY --chown=rabbitmq:rabbitmq rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
COPY --chown=rabbitmq:rabbitmq advanced.config /etc/rabbitmq/advanced.config

EXPOSE 4369 5671 5672 15691 15692 25672 35672-35682
