ufw:
  pkg:
    - installed

{% if salt['grains.get']('ufwsetup') != 'complete' %}

ufw-whitelist-openssh:
  cmd.run:
    - name: ufw allow OpenSSH
    - require:
      - pkg: ufw

ufw-whitelist-http:
  cmd.run:
    - name: ufw allow http
    - require:
      - pkg: ufw

ufw-whitelist-https:
  cmd.run:
    - name: ufw allow https
    - require:
      - pkg: ufw

ufw-whitelist-4505:
  cmd.run:
    - name: ufw allow 4505
    - require:
      - pkg: ufw

ufw-whitelist-4506:
  cmd.run:
    - name: ufw allow 4506
    - require:
      - pkg: ufw

ufw-whitelist-5000:
  cmd.run:
    - name: ufw allow 5000
    - require:
      - pkg: ufw

ufw-whitelist-8000:
  cmd.run:
    - name: ufw allow 8000
    - require:
      - pkg: ufw

ufw-enable:
  cmd.run:
    - name: ufw enable
    - require:
      - cmd: ufw-whitelist-openssh

finish-ufw:
  grains.present:
    - name: ufwsetup
    - value: complete
    - require:
      - cmd: ufw-whitelist-openssh
      - cmd: ufw-whitelist-http
      - cmd: ufw-whitelist-https
      - cmd: ufw-whitelist-4505
      - cmd: ufw-whitelist-4506
      - cmd: ufw-whitelist-8000
      - cmd: ufw-whitelist-5000

{% endif %}
