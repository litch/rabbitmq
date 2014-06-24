FROM ubuntu:latest
MAINTAINER Justin Litchfield <litch@me.com>

# Reduce output from debconf
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get install -y wget
RUN wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc -O /tmp/rabbitmq-signing-key-public.asc
RUN apt-key add /tmp/rabbitmq-signing-key-public.asc
RUN apt-get -y update

RUN apt-get install -y rabbitmq-server
RUN rabbitmq-plugins enable rabbitmq_management

# For RabbitMQ and RabbitMQ Admin
EXPOSE 5672 15672

RUN echo "NODENAME=rabbit@localhost" > /etc/rabbitmq/rabbitmq-env.conf
ENV RABBITMQ_SERVER_START_ARGS -eval error_logger:tty(true).
ADD rabbitmq-server /usr/lib/rabbitmq/lib/rabbitmq_server-3.3.4/sbin/rabbitmq-server 
RUN chmod +x /usr/lib/rabbitmq/lib/rabbitmq_server-3.3.4/sbin/rabbitmq-server

RUN /usr/sbin/rabbitmq-server -detached && sleep 5 && rabbitmqctl add_user bunnyuser 0a9jaoeuhe0aoeujm09aoeushtnount && rabbitmqctl add_user bunny-admin 0a9j1239aujmla0aoeuaoeuau9shtnount && rabbitmqctl set_user_tags bunny-admin administrator && rabbitmqctl set_permissions -p / bunnyuser ".*" ".*" ".*"

ENTRYPOINT ["/usr/sbin/rabbitmq-server"]
