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

module "cloud-instrument" {
  source     = "../modules/Cloud-Instrument"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-job-manager" {
  source     = "../modules/Cloud-Job-Manager"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-kubernetes" {
  source     = "../modules/Cloud-Kubernetes"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-organization" {
  source     = "../modules/Cloud-Organization"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-platform-frontend" {
  source     = "../modules/Cloud-Platform-Frontend"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-terraform-commons" {
  source     = "../modules/Cloud-Terraform-Commons"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "cloud-spotter-data-ingestion" {
  source     = "../modules/Cloud-Spotter-Data-Ingestion"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}

module "compbio-knowledgebase" {
  source     = "../modules/Compbio-Knowledgebase"
  account_id = var.account_id
  env        = var.env
  tags       = var.tags
}
