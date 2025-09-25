FROM golang:1-bookworm AS builder

ARG DERPER_VERSION=main

RUN go install tailscale.com/cmd/derper@${DERPER_VERSION}


FROM debian:bookworm-slim

ENV DERPER_CERTS=/etc/derper/certs
ENV DERPER_IP=127.0.0.1

COPY --from=builder /go/bin/derper /derper

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

#Derper Web Ports
EXPOSE 80
EXPOSE 443/tcp
#STUN
EXPOSE 3478/udp

ENTRYPOINT [ "/docker-entrypoint.sh" ]