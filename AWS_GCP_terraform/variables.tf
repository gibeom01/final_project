variable "region" {
  default = "ap-northeast-2"
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["ap-northeast-2a", 
  "ap-northeast-2c"]
}

variable "ec2_name" {
  description = "ec2_name"
  type        = list(string)
  default     = [
    "basion_host",
    "deverloper"
    ]
}

variable "cluster_name" {
  description = "cluster_name"
  type        = list(string)
  default     = [
    "mysqldb",
    "tomcatwas"
    ]
}

variable "cluster_version" {
  description = <<EOT
cluster_version
EOT
  type        = string
  default     = "1.30"
}

variable "vpc_cidr" {
  description = "vpc_cidr_range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "sub_cidr" {
  description = "sub_cidr_range"
  type        = list(string)
  default     = [
    "10.0.10.0/24",
    "10.0.20.0/24",
    "10.0.30.0/24",
    "10.0.40.0/24",
    "10.0.50.0/24",
    "10.0.60.0/24"
    ]
}

variable "vpc_name" {
  description = "vpc_name"
  type        = string
  default     = "SEC-PRD-VPC"
}

variable "mysql_private_domain" {
  type    = string
  default = "mysql-private-domain"
}

variable "pnoun" {
  type    = string
  default = "project-name"
}

variable "pub_sg" {
  type    = string
  default = "PUB-SG"
}

variable "pri_sg" {
  type    = string
  default = "PRI-SG"
}

variable "pri_rds_sg" {
  type    = string
  default = "PRI-RDS-SG"
}

variable "AWS_PROFILE" {
  description = "AWS profile to use"
  default     = "default"
}

variable "gcp_zone" {
  default = "asia-northeast3-a"
}

variable "gcp_ubuntu_image" {
  default = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
}

variable "gcp_service_account_email" {
  default = "635009463326-compute@developer.gserviceaccount.com"
}

variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "deep-thought-440807-g3"
}

variable "gcp_user_email" {
  description = "User email for IAM bindings"
  type        = string
  default     = "rlqja7638@gmail.com"
}

variable "gcp_expiration_date" {
  description = "IAM condition expiration date"
  type        = string
  default     = "2025-01-01T00:00:00Z"
}
