# -*- coding: utf-8 -*-
import datetime
import logging
import pickle
import pika
import ssl
import time

LOG_FORMAT = (
    "%(levelname) -10s %(asctime)s %(name) -30s %(funcName) "
    "-35s %(lineno) -5d: %(message)s"
)
LOGGER = logging.getLogger(__name__)

logging.basicConfig(level=logging.INFO, format=LOG_FORMAT)

messageCounter = 0


def on_message(chan, method_frame, _header_frame, body):
    global messageCounter
    received = datetime.datetime.now()
    sent = datetime.datetime.fromtimestamp(pickle.loads(body))
    delay = received - sent
    messageCounter = messageCounter + 1
    LOGGER.info(
        "CONSUMER received at %s, sent at %s - iteration %d, delay: %s",
        received,
        sent,
        messageCounter,
        delay,
    )
    chan.basic_ack(delivery_tag=method_frame.delivery_tag)


def maybe_delay():
    import ast
    import os

    env_container = os.getenv("PYTHON_RUNNING_IN_CONTAINER")
    if env_container:
        try:
            in_container = ast.literal_eval(env_container.title())
            if in_container:
                LOGGER.info("CONSUMER waiting 5 seconds to try initial connection")
                time.sleep(5)
        except ValueError:
            pass


def main():
    maybe_delay()

    queue_name = "hello"

    context = ssl.create_default_context()
    context.verify_mode = ssl.CERT_REQUIRED
    context.load_verify_locations(cafile="./ca_certificate.pem")
    context.load_cert_chain(
        certfile="./client_rabbitmq_certificate.pem",
        keyfile="./client_rabbitmq_key.pem",
    )

    credentials = pika.credentials.ExternalCredentials()
    parameters = pika.ConnectionParameters(
        host="rabbitmq", credentials=credentials, ssl_options=pika.SSLOptions(context)
    )
    connection = pika.BlockingConnection(parameters)
    channel = connection.channel()

    channel.queue_declare(
        queue=queue_name, auto_delete=False, durable=True, exclusive=False
    )

    channel.basic_consume(queue=queue_name, on_message_callback=on_message)

    try:
        channel.start_consuming()
    except KeyboardInterrupt:
        channel.stop_consuming()

    connection.close()


if __name__ == "__main__":
    main()
