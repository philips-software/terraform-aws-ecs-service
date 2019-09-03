variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "project" {
  description = "Project identifier"
  type        = string
  default     = "test"
}

variable "key_name" {
  type = string
}

variable "ssh_key_file_ecs" {
  default = "generated/id_rsa.pub"
}

variable "service_name" {
  default = "test"
}

variable "dns_name" {
}

