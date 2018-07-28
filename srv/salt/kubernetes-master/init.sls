include:
  - kubernetes-all

kubectl:
  pkg:
    - installed
    - require:
      - sls: kubernetes-all

{% if salt['grains.get']('kubesetup') != 'complete' %}

init-cluster:
  cmd.run:
    - name: kubeadm init --pod-network-cidr=10.244.0.0/16
    - require:
      - pkg: kubectl

/home/sandman/.kube:
  file.directory:
    - user: sandman
    - dir_mode: 755
    - file_mode: 644

/home/sandman/.kube/config:
  file.copy:
    - source: /etc/kubernetes/admin.conf
    - user: sandman
    - require:
      - file: /home/sandman/.kube

install-pod-network:
  cmd.run:
    - name: kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
    - runas: sandman
    - require:
      - file: /home/sandman/.kube/config

refresh-pillar:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: master
    - require:
      - cmd: install-pod-network

update-mine:
  salt.function:
    - name: mine.update
    - tgt: master
    - require:
      - salt: refresh-pillar

finish-cluster:
  grains.present:
    - name: kubesetup
    - value: complete
    - require:
      - salt: update-mine

{% endif %}
