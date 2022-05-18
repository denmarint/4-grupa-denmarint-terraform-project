variable "owner" {
  description = "Name to be used on all the resources as owner tag"
  type        = string
  default     = "denmarint"
}
variable "ec2_env" {
  description = "Name of environment"
  type        = string
  default     = ""
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = ""
}
variable "subnet_id" {
  description = "Subnet ID"
  type        = string
  default     = ""
}
variable "private_ip" {
  description = "Private IP address"
  type        = list(string)
  default     = [ "" ]
}