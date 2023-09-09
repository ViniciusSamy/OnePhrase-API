resource "aws_eip" "api" {
  instance = aws_instance.api.id
  domain   = "vpc"
}

resource "aws_instance" "api" {
  ami             = "ami-053b0d53c279acc90" 
  instance_type   = "t2.micro" 
  key_name        = aws_key_pair.onephrase_key.key_name  
  #security_groups = [ aws_security_group.api.id ]
  vpc_security_group_ids = [ aws_security_group.api.id  ]
  subnet_id       = aws_subnet.private.id

  tags = {
    Name = "NodeAPI - OnePhrase"  
  }

    user_data       = <<-EOF
                        #!/bin/bash
                        sudo apt-get update
                        sudo apt-get install -y git

                        # Docker instalations
                        sudo apt-get update
                        sudo apt-get install ca-certificates curl gnupg
                        sudo install -m 0755 -d /etc/apt/keyrings
                        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                        sudo chmod a+r /etc/apt/keyrings/docker.gpg
                        echo \
                          "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                          "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
                          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                        sudo apt-get update
                        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

                        git clone https://github.com/ViniciusSamy/OnePhrase-API.git
                        cd OnePhrase-API/onephrase
                        chmod +x build.sh
                        ./build.sh
                        sudo docker run -d -p ${var.ports["api"]}:3000 --name api-onephrase api-onephrase
                      EOF
}