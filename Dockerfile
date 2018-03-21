FROM node:latest as ui
RUN npm install -g gulp browserify babelify
COPY ui/package.json /tmp/
COPY ui/semantic.json /tmp/
RUN cd /tmp && npm install && \
    mkdir -p /usr/src/app/ui && \
    cp -rf /tmp/node_modules /usr/src/app/ui/
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN cd ui/node_modules/semantic-ui && gulp install
RUN cp -f ui/semantic.theme.config ui/semantic/src/theme.config && \
    mkdir -p ui/semantic/src/themes/app && \
    cp -rf ui/semantic.theme/* ui/semantic/src/themes/app
RUN cd ui/semantic && gulp build

FROM golang:alpine as app
RUN apk add -U build-base
COPY . /go/src/app
WORKDIR /go/src/app
RUN go build -a -v -tags 'netgo' -ldflags '-w -linkmode external -extldflags -static' -o docker-demo .

FROM openjdk:8-jre-alpine
MAINTAINER "Shankar <calshankar@icloud.com>"
LABEL application=demoApp

# Install system dependencies
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update --no-cache bash curl confd@testing && \
    mkdir -p /templates

# Title check by confd
ENV TITLE_ENABLED=true

COPY static /static
COPY --from=ui /usr/src/app/ui/semantic/dist/semantic.min.css static/dist/semantic.min.css
COPY --from=ui /usr/src/app/ui/semantic/dist/semantic.min.js static/dist/semantic.min.js
COPY --from=ui /usr/src/app/ui/semantic/dist/themes/default/assets static/dist/themes/default/
COPY --from=app /go/src/app/docker-demo /bin/docker-demo
COPY entrypoint.sh /bin/entrypoint.sh
COPY etc/confd /etc/confd
EXPOSE 8080
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["/bin/docker-demo"]