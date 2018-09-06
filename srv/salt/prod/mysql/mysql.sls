mysql-install:
  file.managed:
    - name: /data/softwares/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz
    - source: salt://mysql/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz
    - unless: test -f /data/softwares/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz
  cmd.run:
    - name: yum -y install libaio && cd /data/softwares && tar xf mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz && mv mysql-5.7.22-linux-glibc2.12-x86_64 /data/application/mysql && cd /data/application/mysql && groupadd mysql && useradd -r -g mysql -s /bin/false mysql && mkdir mysql-files && chmod 750 mysql-files && chown -R mysql.mysql . && bin/mysqld --initialize --user=mysql --basedir=/data/application/mysql --datadir=/data/application/mysql/data &> passwd.txt &

my-file-replace:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://mysql/my.cnf

mysqld-file-replace:
  file.managed:
    - name: /etc/init.d/mysqld
    - source: salt://mysql/mysqld
    - mode: 755
  cmd.run:
    - name: ln -s /data/application/mysql/bin/* /usr/bin/ && chkconfig --add mysqld && chkconfig mysqld on

service-mysql-start:
  cmd.run:
    - name: nohup service mysqld start &> mysql.log
    - require:
      - file: mysqld-file-replace
