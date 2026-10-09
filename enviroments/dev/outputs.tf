output "vpc_id" {
  description = "ID de la VPC del entorno de desarrollo."
  value       = module.network.vpc_id
}

output "private_subnet_ids" {
  description = "IDs de las subredes privadas."
  value       = module.network.private_subnet_ids
}

output "streaming_processor_role_arn" {
  description = "ARN del rol de ejecución de Flink."
  value       = module.identity.streaming_processor_role_arn
}

output "audit_role_arn" {
  description = "ARN del rol de auditoría."
  value       = module.identity.audit_role_arn
}