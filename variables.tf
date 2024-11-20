# variables.tf

variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-private-eks-cluster"
}
