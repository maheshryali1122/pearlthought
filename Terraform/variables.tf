variable "vpccidr" {
    type = string
}
variable "subnettagnames" {
    type = list(string)
}
variable "availabilityzone" {
    type = list(string)
}