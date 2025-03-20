variable "default_region" {
  type        = string
  description = "default region"
  default     = "asia-southeast1"
}

variable "project_id" {
  type        = string
  description = "project id"
}

variable "zone1" {
  type        = string
  description = "application zone 1"
}

variable "instance_type" {
  type        = string
  description = "GKE node instance type"
}

variable "nodes_count" {
  type        = number
  description = "GKE number of nodes"
}

variable "project_name" {
  type        = string
  description = "Application project name"
}

variable "environment" {
  type        = string
  description = "Environment"
}
