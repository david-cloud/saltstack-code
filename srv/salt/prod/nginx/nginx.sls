nginx-install:
  file.managed:
    - name: /data/softwares/nginx-1.12.2.tar.gz
    - source: salt://nginx/nginx-1.12.2.tar.gz
    - unless: test -f /data/softwares/nginx-1.12.2.tar.gz
  cmd.run:
    - name: yum -y install gcc gcc-c++  ncurses-devel libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel autoconf pcre-devel libtool-libs freetype-devel gd zlib-devel  zip unzip wget crontabs file bison cmake patch mlocate flex diffutils automake make readline-devel glibc-devel glibc-static glib2-devel bzip2-devel gettext-devel libcap-devel logrotate ntp libmcrypt-devel && groupadd nginx && useradd -s /sbin/nologin -g nginx -M nginx && cd /data/softwares && tar xf nginx-1.12.2.tar.gz && cd nginx-1.12.2 && ./configure --user=nginx --group=nginx --prefix=/data/application/nginx/ --with-http_ssl_module --with-http_realip_module --with-http_gzip_static_module --with-http_stub_status_module --with-http_flv_module --with-stream --with-pcre && make && make install
    - unless: test -d /data/application/nginx

nginx-conf:
  file.managed:
    - name: /data/application/nginx/conf/nginx.conf
    - source: salt://nginx/nginx.conf
    - require:
      - cmd: nginx-install

nginx-service-conf:
  file.managed:
    - name: /usr/lib/systemd/system/nginx.service
    - source: salt://nginx/nginx.service
    - unless: test -f /usr/lib/systemd/system/nginx.service
    - require:
      - cmd: nginx-install
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: nginx-conf
