# https://github.com/elastic/logstash-docker
FROM docker.elastic.co/logstash/logstash-oss:6.2.2
COPY ./config/logstash.yml /usr/share/logstash/config/logstash.yml
COPY ./pipeline /usr/share/logstash/pipeline
# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json
