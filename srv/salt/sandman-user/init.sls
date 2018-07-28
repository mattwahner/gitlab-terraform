sandman:
  user.present:
    - fullname: sandman
    - shell: /bin/bash
    - home: /home/sandman
    - password: $1$8tc3v2/U$dHa39ZF92Q5srYv3PY0Ey1
    - groups:
      - sudo

sandman-auth:
  ssh_auth.present:
    - user: sandman
    - source: salt://sandman-user/id_rsa.pub
    - config: '%h/.ssh/authorized_keys'
    - require:
      - user: sandman