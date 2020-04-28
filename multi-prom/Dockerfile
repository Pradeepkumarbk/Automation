# ARG ARCH="amd64"
# ARG OS="linux"
# FROM quay.io/prometheus/busybox-${OS}-${ARCH}:latest
# LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"

# ARG ARCH="amd64"
# ARG OS="linux"
# COPY .build/${OS}-${ARCH}/prometheus        /bin/prometheus
# COPY .build/${OS}-${ARCH}/promtool          /bin/promtool
# COPY documentation/examples/prometheus.yml  /etc/prometheus/prometheus.yml
# COPY console_libraries/                     /usr/share/prometheus/console_libraries/
# COPY consoles/                              /usr/share/prometheus/consoles/
# COPY LICENSE                                /LICENSE
# COPY NOTICE                                 /NOTICE
# COPY npm_licenses.tar.bz2                   /npm_licenses.tar.bz2

# RUN ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/
# RUN mkdir -p /prometheus && \
#     chown -R nobody:nogroup etc/prometheus /prometheus

# USER       nobody 
# EXPOSE     9090
# VOLUME     [ "/prometheus" ]
# WORKDIR    /prometheus
# ENTRYPOINT [ "/bin/prometheus" ]
# ENV        CONTEXT_PATH /prometheus
# CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
#              "--storage.tsdb.path=/prometheus", \
#              "--web.console.libraries=/usr/share/prometheus/console_libraries", \
#              "--web.console.templates=/usr/share/prometheus/consoles" ]

FROM golang:1.13.0

RUN mkdir -p $GOPATH/src/github.com/prometheus
WORKDIR $GOPATH/src/github.com/prometheus
# RUN cd $GOPATH/src/github.com/prometheus
RUN git clone https://github.com/prometheus/prometheus.git
WORKDIR $GOPATH/src/github.com/prometheus/prometheus
Run apt-get update
# RUN apt-get install yarn -y
RUN apt-get install nodejs -y 
RUN apt-get install npm -y
RUN npm install --global yarn
# RUN apt-get install yarn -y
# RUN yarn --frozen-lockfile -y
RUN make build
RUN cp prometheus        /bin/prometheus
RUN cp promtool          /bin/promtool
RUN mkdir etc
RUN mkdir etc/prometheus
RUN cp documentation/examples/prometheus.yml  etc/prometheus/prometheus.yml
RUN mkdir usr
RUN mkdir usr/share
Run mkdir usr/share/prometheus
RUN cp -r console_libraries/                     usr/share/prometheus/console_libraries/
RUN cp -r consoles/                              usr/share/prometheus/consoles/
RUN cp LICENSE                                /LICENSE
RUN cp NOTICE                                 /NOTICE
# RUN cp npm_licenses.tar.bz2                   /npm_licenses.tar.bz2
RUN ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ etc/prometheus/
RUN mkdir -p /prometheus && \
    chown -R nobody:nogroup etc/prometheus /prometheus

USER       nobody 
EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
ENV        CONTEXT_PATH='prometheus' 
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus", \
             "--web.console.libraries=/usr/share/prometheus/console_libraries", \
             "--web.console.templates=/usr/share/prometheus/consoles" ]
