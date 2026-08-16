# builder
FROM alpine:latest AS builder

ARG GIT_PROXY=https://gh.xmly.dev/
ARG ALPINE_REPO=https://mirrors.tuna.tsinghua.edu.cn/alpine

ARG SNAPRAID_CLI_VERSION=14.9
ARG SNAPRAID_DAEMON_VERSION=1.14

RUN sed -i "s#https\?://dl-cdn.alpinelinux.org/alpine#${ALPINE_REPO}#g" /etc/apk/repositories

#install neded tools for compilation
RUN apk --update add make g++ wget zip

RUN wget ${GIT_PROXY}https://github.com/amadvance/snapraid/releases/download/v${SNAPRAID_CLI_VERSION}/snapraid-${SNAPRAID_CLI_VERSION}.tar.gz && \
    tar xf snapraid-${SNAPRAID_CLI_VERSION}.tar.gz
RUN cd snapraid-${SNAPRAID_CLI_VERSION} && \
    ./configure && \
    make && make install && \
    cp snapraid.conf.example /etc/snapraid.conf

RUN wget ${GIT_PROXY}https://github.com/amadvance/snapraid-daemon/releases/download/v${SNAPRAID_DAEMON_VERSION}/snapraid-daemon-${SNAPRAID_DAEMON_VERSION}.tar.gz && \
    tar xf snapraid-daemon-${SNAPRAID_DAEMON_VERSION}.tar.gz
RUN cd snapraid-daemon-${SNAPRAID_DAEMON_VERSION} && \
    ./configure && \
    make && make install


#snapraid
FROM alpine:latest

ARG ALPINE_REPO=https://mirrors.tuna.tsinghua.edu.cn/alpine

RUN sed -i "s#https\?://dl-cdn.alpinelinux.org/alpine#${ALPINE_REPO}#g" /etc/apk/repositories && \
    apk add --no-cache smartmontools

COPY --from=builder /usr/local/bin/snapraid /usr/local/bin/snapraid
COPY --from=builder /usr/local/bin/snapraidd /usr/local/bin/snapraidd
COPY --from=builder /usr/local/share/snapraidd/commander.zip /usr/local/share/snapraidd/commander.zip

EXPOSE 7627
CMD ["snapraidd", "-f"]