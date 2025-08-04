FROM golang:1.24.5-alpine3.22 AS builder

WORKDIR /app

COPY . .

RUN apk add --no-cache \
    make libc6-compat libstdc++ && \
    make all

FROM alpine:3.22

RUN apk add --no-cache \
    make libc6-compat libstdc++ ca-certificates

COPY --from=builder /app /app

WORKDIR /app

EXPOSE 53/udp 80 443

CMD ["sh", "-c", "./evilginx -developer"]
