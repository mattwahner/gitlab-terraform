
resource "digitalocean_droplet" "master" {

    image = "ubuntu-16-04-x64"
    name = "master"
    region = "nyc3"
    size = "4gb"
    ssh_keys = [
        "${var.ssh_fingerprint}"
    ]

    connection {
        user = "root"
        type = "ssh"
        private_key = "${file(var.private_key)}"
        timeout = "2m"
    }

    provisioner "file" {
        source = "./srv"
        destination = "/"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get -y update",
            "sudo apt-get -y upgrade",
            "cd /tmp",
            "curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com",
            "sudo sh ./bootstrap-salt.sh -M -A localhost"
        ]
    }

    provisioner "file" {
        source = "${var.public_key}"
        destination = "/srv/salt/sandman-user/id_rsa.pub"
    }

}

resource "digitalocean_droplet" "kubernetes-cluster" {

    count = 2
    image = "ubuntu-16-04-x64"
    name = "kubernetes-worker-${count.index}"
    region = "nyc3"
    size = "1gb"
    depends_on = ["digitalocean_droplet.master"]
    ssh_keys = [
        "${var.ssh_fingerprint}"
    ]

    connection {
        user = "root"
        type = "ssh"
        private_key = "${file(var.private_key)}"
        timeout = "2m"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get -y update",
            "sudo apt-get -y upgrade",
            "cd /tmp",
            "curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com",
            "sudo sh ./bootstrap-salt.sh -A ${digitalocean_droplet.master.ipv4_address} -i kubernetes-worker-${count.index}"
        ]
    }

}

resource "null_resource" "salt-provision" {

    depends_on = ["digitalocean_droplet.kubernetes-cluster"]
    
    connection {
        host = "${digitalocean_droplet.master.ipv4_address}"
        user = "root"
        type = "ssh"
        private_key = "${file(var.private_key)}"
        timeout = "2m"
    }

    provisioner "remote-exec" {
        inline = [
            "yes | sudo salt-key -A",
            "sleep 10"
        ]
    }
    
}

resource "null_resource" "salt-worker-roles" {

    depends_on = ["null_resource.salt-provision"]
    count = 2

    connection {
        host = "${digitalocean_droplet.master.ipv4_address}"
        user = "root"
        type = "ssh"
        private_key = "${file(var.private_key)}"
        timeout = "2m"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo salt kubernetes-worker-${count.index} grains.append roles kubernetes-worker"
        ]
    }

}

resource "null_resource" "salt-master-roles" {

    depends_on = ["null_resource.salt-worker-roles"]

    connection {
        host = "${digitalocean_droplet.master.ipv4_address}"
        user = "root"
        type = "ssh"
        private_key = "${file(var.private_key)}"
        timeout = "2m"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo salt master grains.append roles master"
        ]
    }

}

resource "null_resource" "salt-highstate" {

    depends_on = ["null_resource.salt-master-roles"]

    connection {
        host = "${digitalocean_droplet.master.ipv4_address}"
        user = "root"
        type = "ssh"
        private_key = "${file(var.private_key)}"
        timeout = "2m"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo salt -G 'roles:master' state.apply",
            "sudo salt -G 'roles:kubernetes-worker' state.apply",
            "sudo salt -G 'roles:firewall' state.apply"
        ]
    }
    
}

resource "digitalocean_record" "mattwahner-cname" {
    domain = "mattwahner.com"
    type = "CNAME"
    name = "*"
    value = "@"
    ttl = 43200
}

resource "digitalocean_record" "mattwahner-domain" {
    domain = "mattwahner.com"
    type = "A"
    name = "@"
    value = "${digitalocean_droplet.master.ipv4_address}"
    ttl = 300
}

resource "digitalocean_record" "mattwahner-domain-www" {
    domain = "mattwahner.com"
    type = "A"
    name = "www"
    value = "${digitalocean_droplet.master.ipv4_address}"
    ttl = 300
}

resource "digitalocean_record" "mattwahner-domain-master" {
    domain = "mattwahner.com"
    type = "A"
    name = "master"
    value = "${digitalocean_droplet.master.ipv4_address}"
    ttl = 300
}

resource "digitalocean_record" "mattwahner-domain-kw" {
    count = 2
    domain = "mattwahner.com"
    type = "A"
    name = "kw${count.index}"
    value = "${element(digitalocean_droplet.kubernetes-cluster.*.ipv4_address, count.index)}"
    ttl = 300
}

resource "digitalocean_record" "salt-domain" {
    domain = "mattwahner.com"
    type = "A"
    name = "salt"
    value = "${digitalocean_droplet.master.ipv4_address}"
    ttl = 300
}

resource "digitalocean_record" "gitlab-domain" {
    domain = "mattwahner.com"
    type = "A"
    name = "gitlab"
    value = "${digitalocean_droplet.master.ipv4_address}"
    ttl = 300
}
