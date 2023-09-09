resource "aws_eip" "nginx" {
  instance = aws_instance.nginx.id
  domain   = "vpc"
}

resource "aws_instance" "nginx" {
  ami             = "ami-053b0d53c279acc90" 
  instance_type   = "t2.micro" 
  key_name        = aws_key_pair.onephrase_key.key_name  
  #security_groups = [ aws_security_group.nginx.id ]
  vpc_security_group_ids = [ aws_security_group.nginx.id ]
  subnet_id       = aws_subnet.private.id

  tags = {
    Name = "NGinxProxy - OnePhrase"  
  }



  user_data       = <<-EOF
                    #!/bin/bash
                    sudo apt-get update
                    sudo apt-get install -y git nginx
                    git clone https://github.com/ViniciusSamy/OnePhrase-API.git
                    cd OnePhrase-API/nginx/sites
                
                    
                    sed -i "s/SERVER_NAME_HERE/${var.api_servername}/g"  '02-onephrase.conf'
                    sed -i "s/API_IP_HERE/${aws_instance.api.private_ip}/g"   '02-onephrase.conf'
                    sed -i "s/API_PORT_HERE/${var.ports["api"]}/g"  '02-onephrase.conf'
                    
                    for file in *.conf; do
                      sudo cp $file /etc/nginx/sites-available/
                      filepath=/etc/nginx/sites-available/$file
                      sudo ln -s "$filepath" "/etc/nginx/sites-enabled/$file"
                    done
                    sudo rm /etc/nginx/sites-enabled/default
                    
                    sudo systemctl start nginx
                    sudo systemctl enable nginx
                    sudo systemctl restart nginx
                    EOF
}