FROM ubuntu:20.04
LABEL maintainer="carolle"
RUN apt-get update && \
   DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        nginx=1.18.0-6ubuntu14.5 && \
    rm -rf /var/www/html/*
EXPOSE 80
COPY ./battleboat_files/ /var/www/html/
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]

