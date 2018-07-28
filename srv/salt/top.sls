base:
  'roles:master':
    - match: grain
    - master
    - gitlab
    - sandman-user
    - kubernetes-master
  'roles:kubernetes-worker':
    - match: grain
    - sandman-user
    - kubernetes-worker
