variable "domain_name" {
  description = "The domain purchased at the registrar, e.g. pulseops-app.online"
  type        = string
}

variable "elastic_ip" {
  description = "The EC2 instance's public IP, from the ecs module — the A record points here"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}