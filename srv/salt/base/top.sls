base:
  '*':
    - init.env_init

prod:
  '*':
    - zabbix-agent.zabbix-agent
