FROM golang:1.24.5-alpine3.22 AS builder

WORKDIR /app

COPY . .

RUN apk add --no-cache \
    make libc6-compat libstdc++ && \
    make all

FROM alpine:3.22

ARG UID=1001
ARG GID=1001
ARG USER=evil

RUN addgroup -S -g ${GID} ${USER} && \
    adduser -S -u ${UID} -g ${USER} -s /bin/sh ${USER} && \
    apk add --no-cache \
    make libc6-compat libstdc++ ca-certificates tmux

COPY --from=builder --chown=${USER}:${USER} /app /home/${USER}

WORKDIR /home/${USER}

EXPOSE 53/udp 80 443

CMD ["tail", "-f", "/dev/null"]

USER evil

STOPSIGNAL SIGKILL
