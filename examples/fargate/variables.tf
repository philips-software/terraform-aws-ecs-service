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
