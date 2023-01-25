variable "REGION" {
    type = string
    default = "us-east-1"
}

variable "TFC_ORG" {
    type = string
    default = "hashicoop"
} 

variable "TFC_WORKSPACE_NAME" {
    type = string
}

variable "TFC_NETWORK_WORKSPACE" {
    type = string
    default = "aws-base"
}