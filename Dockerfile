FROM alpine

RUN apk add jq imagemagick exiftool

COPY gphotos.sh work/