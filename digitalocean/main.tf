#######################################
# Set the DO token inside a shell 
# environment variable, as so...
# export DIGITALOCEAN_TOKEN="API token"
#######################################

provider "digitalocean" {
}

#################################
# Generate a module for building 
# the Droplet.
#################################

module "droplet" {
  source             = "./droplet"
  ssh_key_id         = "${var.ssh_key_id}"
  region             = "${var.region}"
  image_id           = "${var.image_id}"
  size_id            = "${var.size_id}"
  priv_network       = "${var.priv_network}"
  drop_name          = "${var.drop_name}"
  droplet_monitoring = "${var.droplet_monitoring}"
  droplet_tag        = "${var.droplet_tag}"
}
