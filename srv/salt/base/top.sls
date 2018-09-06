base:
  '*':
    - init.env_init

prod:
  '*':
    - zabbix-agent.zabbix-agent
    - nginx.nginx
    - mysql.mysql
    - tomcat.tomcat
