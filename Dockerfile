FROM ubuntu
MAINTAINER carolle
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nginx git

EXPOSE 80


RUN rm -rf /var/www/html/*
COPY ./battleboat_files/ /var/www/html/
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
