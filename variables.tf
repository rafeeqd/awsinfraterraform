variable "amiid" {
  type    = list(string)
  default = ["ami-0022f774911c1d690"]
}

variable "subnetid1" {
  type    = string
  default = "vpc-03ffa41cdbf517d19"

}

variable "cidr" {
  type    = list(string)
  default = ["10.0.1.0/28"]
}