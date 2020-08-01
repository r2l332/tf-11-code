resource "digitalocean_droplet" "jenkins" {
  image              = "${var.image_id}"
  name               = "${var.drop_name}"
  region             = "${var.region}"
  size               = "${var.size_id}"
  ssh_keys           = ["${var.ssh_key_id}"]
  tags               = ["${var.droplet_tag}"]
  monitoring         = "${var.droplet_monitoring}"
  private_networking = "${var.priv_network}"
  user_data          = "${file("${path.module}/init/cloud-config")}"
}

output "jenkins_id" {
  value = "{digitalocean_droplet.jenkins.id}"
}
