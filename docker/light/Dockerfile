FROM alpine:3.1

RUN apk add --update bash && \
    rm -rf /var/cache/apk/*

ADD https://raw.githubusercontent.com/arpinum-oss/shebang-unit/master/releases/shebang-unit /app/shebang-unit
RUN chmod +x /app/shebang-unit

RUN mkdir /src
VOLUME /src
WORKDIR /src

CMD "/app/shebang-unit" "${SBU_OPTS}" "."
