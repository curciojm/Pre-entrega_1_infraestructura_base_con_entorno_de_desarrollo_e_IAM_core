terraform {
  backend "s3" {
    bucket         = "juan-terraform-state-2026"
    key            = "Pre-entrega_1_infraestructura_base_con_entorno_de_desarrollo_e_IAM_core/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}