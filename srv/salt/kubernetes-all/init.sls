docker-repo:
  pkgrepo.managed:
    - humanname: Docker Repo
    - name: deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable
    - key_url: https://download.docker.com/linux/ubuntu/gpg

docker-ce:
  pkg:
    - installed
    - require:
      - pkgrepo: docker-repo

kubernetes-repo:
  pkgrepo.managed:
    - humanname: Kubernetes Repo
    - name: deb http://apt.kubernetes.io/ kubernetes-xenial main
    - key_url: https://packages.cloud.google.com/apt/doc/apt-key.gpg

kubelet:
  pkg:
    - installed
    - require:
      - pkgrepo: kubernetes-repo

kubeadm:
  pkg:
    - installed
    - require:
      - pkgrepo: kubernetes-repo

apt-transport-https:
  pkg:
    - installed