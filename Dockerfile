FROM alpine:3.10 AS dep_stage

RUN apk --no-cache add python3 openssl

FROM dep_stage as virtualenv

RUN apk --no-cache add py3-virtualenv gcc python3-dev openssl-dev libffi-dev musl-dev

RUN virtualenv /opt/certbot && \
    . /opt/certbot/bin/activate && \
    pip install certbot

# apk del py-virtualenv gcc python-dev openssl-dev libffi-dev musl-dev

FROM dep_stage

COPY --from=virtualenv /opt/certbot /opt/certbot

RUN apk --no-cache add python openssl dcron

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 443

CMD ["crond"]