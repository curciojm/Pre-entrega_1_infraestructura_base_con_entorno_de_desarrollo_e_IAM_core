# outputs.tf define qué valores de un módulo querés exponer hacia afuera para que puedan ser utilizados por el módulo padre/entorno

output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}