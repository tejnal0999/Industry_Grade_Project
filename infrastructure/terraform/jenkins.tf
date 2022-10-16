resource "aws_instance" "jenkins-server" {
  ami             = var.jenkins_ami
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.jenkins_traffic.name]
  key_name        = "aws_kp"

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install java-openjdk11 -y",
      "sudo yum -y install wget",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum upgrade -y",
      "sudo yum install jenkins -y",
      "sudo systemctl enable jenkins",
      "sudo systemctl start jenkins",
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("key/aws_kp.pem")
  }
  tags = {
    "Name" = "Jenkins"
  }
}
