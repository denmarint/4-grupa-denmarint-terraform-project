variable "owner" {
  description = "Name to be used on all the resources as owner tag"
  type        = string
  default     = "denmarint"
}
variable "vpc_env" {
  description = "Name of environment"
  type        = string
  default     = ""
}
variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  type        = string
  default     = "10.1.0.0/16"
}
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = [ "10.1.1.0/24" ]
}
variable "private_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = [ "10.1.11.0/24" ]
}
variable "sg_ssh_allow_cidr" {
  description = "A list of allowed SSH access addreses"
  type        = list(string)
  default     = [ "10.1.1.0/24" ]
}
variable "sg_web_allow_cidr" {
  description = "A list of allowed HTTP/S access addreses"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
