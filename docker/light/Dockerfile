FROM alpine:3.3

RUN apk add --update bash && \
    rm -rf /var/cache/apk/*

ADD https://raw.githubusercontent.com/arpinum-oss/shebang-unit/v1.2.0/releases/shebang-unit /app/shebang-unit
RUN chmod +x /app/shebang-unit

RUN mkdir /src
VOLUME /src
WORKDIR /src

ENTRYPOINT ["/app/shebang-unit"]

CMD ["."]
