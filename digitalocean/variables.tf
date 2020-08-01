##############
# DROPLET VARS
##############

variable "region" {
  # region for deployment
  default = "NONE"
}

variable "ssh_key_id" {
  # ssh key id for droplet 
  default = "NONE"
}

variable "image_id" {
  # image id this can be found by simple curl to DO API
  default = "NONE"
}

variable "size_id" {
  # size of droplet
  default = "NONE"
}

variable "drop_name" {
  # name of droplet
  default = "NONE"
}

variable "priv_network" {
  # bolean value for private network creation
  default = "true"
}

variable "droplet_tag" {
  # tag assignment
  default = "NONE"
}

variable "droplet_monitoring" {
  # bolean value for droplet monitoring
  default = "true"
}

