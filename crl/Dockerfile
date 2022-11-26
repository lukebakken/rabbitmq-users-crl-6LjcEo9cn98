# syntax=docker/dockerfile:1
FROM python:3-alpine
WORKDIR /app
COPY basic.crl .
EXPOSE 8000
CMD ["-m", "http.server", "8000"]
ENTRYPOINT ["python"]
