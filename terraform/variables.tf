variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix used to name resources and tag them"
  type        = string
  default     = "secure-workload"
}

variable "allowed_ingress_cidr" {
  description = "49.37.36.60/32"
  type        = string
}

variable "image_tag" {
  description = "Tag of the image in ECR to deploy"
  type        = string
  default     = "v2"
}

variable "github_repository" {
  description = "GitHub repo allowed to deploy, in the form owner/name (case-sensitive)"
  type        = string
}

variable "github_oidc_subject" {
  description = "Exact OIDC subject claim GitHub sends for the main branch"
  type        = string
}