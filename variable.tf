#####################################################################
# EC2 Web Server VARIABLES
#####################################################################

variable "INSTANCE_TYPE" {}
variable "KEY_NAME" {}
variable "SECURITY_GROUP" {type="list"}
variable "IAM_INSTANCE_PROFILE" {}
variable "SUBNET_ID" {}
variable "INSTANCE_USERNAME" {}
variable "INSTANCE_PASSWORD" {}