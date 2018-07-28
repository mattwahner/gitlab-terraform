ufw:
  pkg:
    - latest

ufw-whitelist-openssh:
  cmd.wait:
    - name: ufw allow OpenSSH
    - watch:
      - pkg: ufw

ufw-whitelist-http:
  cmd.wait:
    - name: ufw allow http
    - watch:
      - pkg: ufw

ufw-whitelist-https:
  cmd.wait:
    - name: ufw allow https
    - watch:
      - pkg: ufw

ufw-whitelist-4505:
  cmd.wait:
    - name: ufw allow 4505
    - watch:
      - pkg: ufw

ufw-whitelist-4506:
  cmd.wait:
    - name: ufw allow 4506
    - watch:
      - pkg: ufw

ufw-enable:
  cmd.wait:
    - name: ufw enable
    - watch:
      - cmd: ufw-whitelist-openssh
