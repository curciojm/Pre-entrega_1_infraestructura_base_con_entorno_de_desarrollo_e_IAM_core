# vpc: función principal es definir cómo se conectan y se aíslan los recursos
# proporciona el entorno de red para los recursos que trabajan con esos datos
resource "aws_vpc" "main" {
  cidr_block = var.cidr_vpc

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}
# una subred permite dividir la red de la VPC en segmentos con distintas funciones y reglas de acceso
# permite aislarla del acceso de internet
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.environment}-private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.environment}-private-2"
  }
}
# Si el tráfico sale de esta subnet y tiene determinado destino, ¿por dónde tiene que ir?
# es una tabla de reglas de trafico
# Destino              →   Siguiente destino
# ────────────────────────────────────────────
# 10.0.0.0/16          →   local
# S3                    →   Gateway Endpoint
# 0.0.0.0/0             →   NAT Gateway 

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-private-rt"
  }
}
# EL ID SIRVE PARA IMPORTAR A OTROS MODULOS
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id # SE CONSTRUYE LO QUE LUEGO SE VA A USAR PARA IMPORTAR
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}
# VPC Endpoint es una puerta/conexión privada entre tu VPC y un servicio de AWS como S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private.id
  ]

  tags = {
    Name = "${var.environment}-s3-endpoint"
  }
}