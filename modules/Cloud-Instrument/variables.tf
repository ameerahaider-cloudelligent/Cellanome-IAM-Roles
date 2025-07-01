variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "env" {
  description = "AWS account env"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the IAM role"
  type        = map(string)
  default     = {}
}
