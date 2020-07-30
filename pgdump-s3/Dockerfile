FROM postgres:11.7-alpine
MAINTAINER Leo <leo@gmail.com>

RUN apk add --no-cache py2-pip && pip install awscli && mkdir /backup && mkdir /bk

ENV AWS_DEFAULT_REGION=us-east-1

COPY pgdump-s3/entrypoint.sh /usr/local/bin/entrypoint
COPY pgdump-s3/backup.sh /usr/local/bin/backup
COPY pgdump-s3/pguri.py /usr/local/bin/pguri

VOLUME /backup

CMD /usr/local/bin/entrypoint
