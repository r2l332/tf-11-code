resource "aws_instance" "docker_web" {
  ami = "${var.amis}"
  instance_type = "${var.instance_type}"
  tags = {
    Name = "${var.ec2_name}"
  }
  subnet_id = "${var.uat_public_1_id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${var.customer_allow_ssh_id}"]
  key_name = "${var.key_name}"
  provisioner "remote-exec" {
    inline =  [
      "sudo apt-get update",
      "sudo apt-get install -y git curl",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable'",
      "sudo apt-get update",
      "apt-cache policy docker-ce",
      "sudo apt-get install -y docker-ce",
      "sudo usermod -aG docker ubuntu",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "git clone https://github.com/r2l332/docker-tf-aws.git && cd docker-tf-aws && sudo systemctl start docker && sudo docker-compose up -d",
    ]
    connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file(var.private_key_path)}"
    }
  }
}

resource "aws_eip" "docker_web" {
  instance = "${aws_instance.docker_web.id}"
  vpc = true
}

output "docker_web_id" {
  value = "${aws_eip.docker_web.id}"
}
