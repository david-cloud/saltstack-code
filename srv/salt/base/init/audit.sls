user-audit:
  file.append:
    - name: /etc/bashrc
    - text:
      - export PROMPT_COMMAND='{ msg=$(history 1 | { read x y; echo $y; });logger "[euid=$(whoami)]":$(who am i):[`pwd`]# "$msg"; }'
