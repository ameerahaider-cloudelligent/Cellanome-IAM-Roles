module "cloud-networking" {
  source     = "../modules/Cloud-Networking-Role"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "analysis-service" {
  source     = "../modules/Analysis-Service"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cellanome-test-data" {
  source     = "../modules/Cellanome-Test-Data"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-agent" {
  source     = "../modules/Cloud-Agent"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-annotations" {
  source     = "../modules/Cloud-Annotations"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-appsync" {
  source     = "../modules/Cloud-AppSync"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-audit" {
  source     = "../modules/Cloud-Audit"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-CDN" {
  source     = "../modules/Cloud-CDN"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-cost-estimate" {
  source     = "../modules/Cloud-Cost-Estimate"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}
module "cloud-events-documentation" {
  source     = "../modules/Cloud-Events-Documentation"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

