include:
  - kubernetes-all

{% if salt['grains.get']('kubesetup') != 'complete' %}

join-cluster:
  cmd.run:
    - name: {{ salt['mine.get']('master', 'join-command')['master'] }}
    - require:
      - sls: kubernetes-all

finish-join:
  grains.present:
    - name: kubesetup
    - value: complete
    - require:
      - cmd: join-cluster

{% endif %}
