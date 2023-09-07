variable "region" {
    description = "Region in AWS"
    type = string
    default = "us-east-1"
}

#------------NETWORK------------#
variable "network_prefix" {
    description = "Prefix used in Name tag of VPCs, Subnets and Gateways"
    type = string
    default = "TremDeTI"
}

variable cidr {
    description = "CIDR of VPC, public subnet and private subnet"
    type = map
    default = {
        "vpc"       = "10.0.0.0/16",
        "sub_pub"   = "10.0.1.0/24",
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