resource "aws_instance" "k8s-nodes" {
  ami       = "ami-054a31f1b3bf90920"
  instance_type = "t2.micro"
  count = 1

  tags = {
       Name = "Cluster ${count.index}"
  }  
}

resource "aws_security_group" "web-node" {
  name = "web-node"
  description = "Web Security Group"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        type = "k8s-security-group"
    }
}

resource "aws_network_interface_sg_attachment" "k8s_attachment" {
    count = 1
    security_group_id = aws_security_group.web-node.id
    network_interface_id = aws_instance.k8s-nodes[count.index].primary_network_interface_id
}
