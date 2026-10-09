module "network" {
  source = "../../modules/network"

  environment = var.environment
  region      = var.region
  cidr_vpc    = var.cidr_vpc
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr

}

module "identity" {
  source = "../../modules/identity"

  environment      = var.environment
  data_bucket_name = var.data_bucket_name
}