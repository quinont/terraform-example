variable "network_vpc" {
  type        = string
  description = "VPC donde se va a desplegar la instancia"
  default     = "default"
}

variable "project" {
  type        = string
  description = "Proyecto a deployar toda la infra"
}
