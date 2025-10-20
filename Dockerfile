ARG ALPINE_VERSION=3.17.3
FROM alpine:$ALPINE_VERSION

ARG OPENCONTAINERS_IMAGE_VERSION
ARG OPENCONTAINERS_IMAGE_CREATED

LABEL \
    "org.opencontainers.image.title"="Dynu DDNS Updater" \
    "org.opencontainers.image.description"="Docker image that provides periodic update requests for the DDNS records of your www.dynu.com account." \
    "org.opencontainers.image.url"="https://github.com/iamryusei/dynu-ddns-updater" \
    "org.opencontainers.image.documentation"="https://github.com/iamryusei/dynu-ddns-updater/blob/master/README.md" \
    "org.opencontainers.image.source"="https://github.com/iamryusei/dynu-ddns-updater/blob/master/Dockerfile" \
    "org.opencontainers.image.version"="$OPENCONTAINERS_IMAGE_VERSION" \
    "org.opencontainers.image.created"="$OPENCONTAINERS_IMAGE_CREATED" \
    "org.opencontainers.image.authors"="Leonardo Spaccini <leonardo.spaccini.gtr@gmail.com>" \
    "org.opencontainers.image.licenses"="Unlicense"

RUN set -x \
    # create unpriviledged user and group that will be used to run the "update-dynu-ddns.sh" script...
    && addgroup -g 1001 workers \
    && adduser -D -u 1001 -G workers worker \
    # remove default root crontab to avoid pollution of logs...
    && rm -rf /etc/periodic \
    && rm -f /etc/crontabs/root

COPY --chown=root:root --chmod=444 ./source/crontabs/worker /etc/crontabs/worker
COPY --chown=root:root --chmod=555 ./source/scripts /home/worker/

ENTRYPOINT [ "/home/worker/docker-entrypoint.sh" ]
CMD \
    echo "Dynu DDNS Updater - Starting crond..." \
    && crond -f -L /dev/stdout -l $CROND_LOG_LEVEL
