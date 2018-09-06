zabbix-agent-install:
  file.managed:
    - name: /etc/yum.repos.d/zabbix.repo
    - source: salt://zabbix-agent/zabbix.repo
    - unless: test -f /etc/yum.repos.d/zabbix.repo
  cmd.run:
    - name: yum -y install zabbix-agent
    - require:
      - file: zabbix-agent-install
    - unless: rpm -qa zabbix-agent

zabbix-conf-replace:
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://zabbix-agent/zabbix_agentd.conf
    - template: jinja
    - defaults:
      zabbix_server: {{ pillar['zabbix_agent']['zabbix_server'] }}
      host: {{ grains['ip4_interfaces']['enp3s0'][0] }}
    - require:
      - cmd: zabbix-agent-install
  service.running:
    - name: zabbix-agent
    - enable: True
    - restart: True
    - watch:
      - file: zabbix-conf-replace
    - require:
      - cmd: zabbix-agent-install
      - file: zabbix-conf-replace
