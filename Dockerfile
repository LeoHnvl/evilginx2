FROM golang:1.22-alpine3.21 AS builder

WORKDIR /app

COPY . .

RUN apk add --no-cache make && \
    make build

FROM golang:1.22-alpine3.21 AS evil

WORKDIR /app

VOLUME [ "/app/config" ]

COPY --from=builder /app/build /app/build
COPY --from=builder /app/phishlets /app/phishlets
COPY --from=builder /app/redirectors /app/redirectors
COPY --from=builder /app/docker-entrypoint.sh /app/docker-entrypoint.sh

EXPOSE 443

RUN apk add --no-cache libc6-compat && \
    chmod +x /app/build/evilginx && \
    chmod +x /app/docker-entrypoint.sh

ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
