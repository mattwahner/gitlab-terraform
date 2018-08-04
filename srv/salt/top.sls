base:
  'roles:master':
    - match: grain
    - gitlab
    - sandman-user
    - kubernetes-master
  'roles:kubernetes-worker':
    - match: grain
    - sandman-user
    - kubernetes-worker
