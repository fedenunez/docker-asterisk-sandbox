FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install -y wget build-essential subversion vim 


WORKDIR /usr/src/
RUN wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz

RUN tar zxf asterisk-18-current.tar.gz
RUN cd asterisk-18.*/; bash contrib/scripts/get_mp3_source.sh; bash contrib/scripts/install_prereq install

RUN apt-get install -f libopus-dev libopus0

RUN cd asterisk-18.*/;\
  ./configure ;\
   make menuselect.makeopts

RUN cd asterisk-18.*/;\
      menuselect/menuselect --disable BUILD_NATIVE \
      --enable format_mp3 \
      --enable codec_opus \
      --disable-category MENUSELECT_MOH \
      --disable-category MENUSELECT_EXTRA_SOUNDS \
      menuselect.makeopts
RUN cd asterisk-18.*/;\
      make && make install && make samples && ldconfig && \
      ### Backup original conf files
      cp -ra /etc/asterisk/ /etc/asterisk.original/  

### Clean up files
RUN apt-get -y autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /usr/src/*

EXPOSE 5060 5061

VOLUME /etc/asterisk /var/lib/asterisk /var/spool/asterisk

# Place all your custom config in the etc/ folder
ADD etc/ /etc/

CMD ["asterisk", "-f"]
