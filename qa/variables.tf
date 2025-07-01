variable "account_id" {
  description = "The AWS account ID for the OIDC provider and resources"
  type        = string
}

variable "env" {
  description = "AWS account env"
  type        = string
}
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
