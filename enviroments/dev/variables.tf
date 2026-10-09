variable "environment" {
  description = "Nombre del entorno de despliegue."
  type        = string
}

variable "region" {
  description = "Región de AWS donde se desplegará la infraestructura."
  type        = string
}

variable "cidr_vpc" {
  description = "Bloque CIDR asignado a la VPC."
  type        = string
}

variable "data_bucket_name" {
  description = "Nombre del bucket destinado a los datos del proyecto."
  type        = string
}