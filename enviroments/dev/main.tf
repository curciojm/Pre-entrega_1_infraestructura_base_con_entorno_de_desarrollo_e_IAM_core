# Levanta los modulos
module "network" {
  source = "../../modules/network"

  environment = var.environment
  region      = var.region
  cidr_vpc    = var.cidr_vpc
}

module "identity" {
  source = "../../modules/identity"

  environment      = var.environment
  data_bucket_name = var.data_bucket_name
}