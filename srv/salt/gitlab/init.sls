ca-certificates:
  pkg:
    - installed

curl:
  pkg:
    - installed

openssh-server:
  pkg:
    - installed

gitlab-repo:
  pkgrepo.managed:
    - humanname: GitLab Repo
    - name: deb https://packages.gitlab.com/gitlab/gitlab-ce/ubuntu/ xenial main
    - key_url: https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey
    - require:
      - pkg: ca-certificates
      - pkg: curl
      - pkg: openssh-server

gitlab-repo-src:
  pkgrepo.managed:
    - humanname: GitLab src Repo
    - name: deb-src https://packages.gitlab.com/gitlab/gitlab-ce/ubuntu/ xenial main
    - key_url: https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey
    - require:
      - pkg: ca-certificates
      - pkg: curl
      - pkg: openssh-server

gitlab-ce:
  pkg:
    - installed
    - require:
      - pkgrepo: gitlab-repo
      - pkgrepo: gitlab-repo-src

/etc/gitlab/gitlab.rb:
  file.managed:
    - source: salt://gitlab/gitlab.rb
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: gitlab-ce

gitlab-reconfigure:
  cmd.wait:
    - name: gitlab-ctl reconfigure
    - watch:
      - file: /etc/gitlab/gitlab.rb

/etc/cron.daily/gitlab-le:
  file.managed:
    - source: salt://gitlab/gitlab-le
    - user: root
    - group: root
    - mode: 755
    - require:
      - cmd: gitlab-reconfigure
