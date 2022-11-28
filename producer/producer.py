# -*- coding: utf-8 -*-
import datetime
import logging
import pickle
import pika
import pika.credentials
import random
import ssl
import time

LOG_FORMAT = (
    "%(levelname) -10s %(asctime)s %(name) -30s %(funcName) "
    "-35s %(lineno) -5d: %(message)s"
)
LOGGER = logging.getLogger(__name__)

logging.basicConfig(level=logging.INFO, format=LOG_FORMAT)


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
        certfile="./client_rmq0_certificate.pem",
        keyfile="./client_rmq0_key.pem",
    )

    credentials = pika.credentials.ExternalCredentials()
    parameters = pika.ConnectionParameters(
        host="rmq0", credentials=credentials, ssl_options=pika.SSLOptions(context)
    )
    connection = pika.BlockingConnection(parameters)
    channel = connection.channel()

    channel.queue_declare(
        queue=queue_name, auto_delete=False, durable=True, exclusive=False
    )

    try:
        messageCounter = 0
        props = pika.BasicProperties(content_type="text/plain")
        while True:
            burstSize = random.randrange(10)
            for _ in range(burstSize):
                messageCounter = messageCounter + 1
                t = time.time()
                tp = pickle.dumps(t)
                channel.basic_publish(
                    exchange="", routing_key=queue_name, body=tp, properties=props
                )
                sendTime = datetime.datetime.fromtimestamp(t)
                LOGGER.info("PRODUCER sent message %d at %s", messageCounter, sendTime)
            connection.process_data_events(5)
    except KeyboardInterrupt:
        channel.close()
        connection.close()


if __name__ == "__main__":
    main()
