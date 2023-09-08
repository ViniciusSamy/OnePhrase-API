variable "region" {
    description = "Region in AWS"
    type = string
    default = "us-east-1"
}

#------------NETWORK------------#
variable "network_prefix" {
    description = "Prefix used in Name tag of VPCs, Subnets and Gateways"
    type = string
    default = "Onephrase"
}

variable cidr {
    description = "CIDR of VPC, public subnet and private subnet"
    type = map
    default = {
        "vpc"       = "10.0.0.0/16",
        "sub_pub"   = "10.0.1.0/24",
        "sub_pub_2" = "10.0.3.0/24",
        "sub_priv"  = "10.0.2.0/24"
    }
}

variable ports {
    description = "Ports used by NGinX and API"
    type = map
    default = {
        "nginx" = "80",
        "api"   = "3000"
    }
}

variable keypair_path {
    description = "Local path to .pub ssh key used to connect to EC2 instances"
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable api_servername {
    description = "Servername to used for API"
    type = string
    default = "onephrase.viniciussamy.tech"
}

variable "certificate_arn" {
    description = "ARN of certificate used by load balancer for SSL"
    type = string
    default = "arn:aws:acm:us-east-1:179401021699:certificate/1dbc02e5-2a18-41c7-b3ba-ce2bbfea8640"
}