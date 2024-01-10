FROM ubuntu:latest
LABEL maintainer carolle
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx \
    rm -rf /var/www/html/*
EXPOSE 80
COPY ./battleboat_files/ /var/www/html/
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
