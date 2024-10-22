FROM ubuntu:latest

RUN apt-get -y update
RUN apt-get -y update --fix-missing
RUN apt-get -y upgrade

RUN apt-get install -y sudo \
    wget \
    traceroute

RUN apt-get install -y -qq \
    libcatalyst-view-json-perl \
    libjson-xs-perl \
    cpanminus

RUN cpanm --install --force Net::Ping
RUN cpanm --install --force Net::IP
RUN cpanm --install --force File::Basename
RUN cpanm --install --force Log::Log4perl

# clean
RUN apt-get clean

COPY .  /usr/src/best_hoster_location
WORKDIR /usr/src/best_hoster_location


CMD [ "perl", "./best_hoster_location.pl" ]