# syntax=docker/dockerfile:1
FROM python:3-alpine
WORKDIR /app
ENV PYTHON_RUNNING_IN_CONTAINER=true
RUN python -m pip install --upgrade pip pipenv
COPY Pipfile* .
RUN pipenv install
COPY consumer.py .
ENTRYPOINT ["pipenv", "run", "main"]
