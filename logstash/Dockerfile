FROM docker.elastic.co/logstash/logstash-oss:7.1.0

COPY ./logstash/logstash.conf /etc/logstash/conf.d/

CMD logstash -f /etc/logstash/conf.d/logstash.conf