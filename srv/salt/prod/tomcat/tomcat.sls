jdk-install:
  cmd.run:
    - name: yum -y install java
    - unless: java -version

tomcat-install:
  file.managed:
    - name: /data/softwares/apache-tomcat-8.0.53.tar.gz
    - source: salt://tomcat/apache-tomcat-8.0.53.tar.gz
    - unless: test -f /data/softwares/apache-tomcat-8.0.53.tar.gz
  cmd.run:
    - name: cd /data/softwares/ && tar xf /data/softwares/apache-tomcat-8.0.53.tar.gz && mv /data/softwares/apache-tomcat-8.0.53 /data/application/tomcat
    - require:
      - cmd: jdk-install

server-file-replace:
  file.managed:
    - name: /data/application/tomcat/conf/server.xml
    - source: salt://tomcat/server.xml
    - require:
      - cmd: tomcat-install

catalina-file-replace:
  file.managed:
    - name: /data/application/tomcat/bin/catalina.sh
    - source: salt://tomcat/catalina.sh
    - require:
      - cmd: tomcat-install
    - template: jinja
    - defaults:
      ip: {{ grains['ip4_interfaces']['enp3s0'][0] }}

service-start:
  cmd.run:
    - name: /data/application/tomcat/bin/startup.sh
    - require:
      - file: catalina-file-replace
