terraform {
  backend "s3" {
    bucket         = "juan-terraform-state-2026"
    key            = "Pre-entrega_1_infraestructura_base_con_entorno_de_desarrollo_e_IAM_core/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Bucket de ESTADO que va a ser la memoria del servicio
# El terraform.tfstate es como la memoria de Terraform sobre los recursos que administra, todo el SERVICIO

# La VPC y su ID.

# Las subredes y sus IDs.

# La tabla de rutas.

# El endpoint de S3.

# Los roles y políticas IAM.

# Terraform necesita guardar un archivo llamado terraform.tfstate en un bucket

# Por eso tenemos este esquema:
# - Terraform administra la infraestructura.
# - S3 guarda el estado de Terraform.
# - Otro bucket S3 puede guardar los datos de nuestra aplicación.
# - IAM determina qué permisos tiene cada rol sobre esos recursos.

# Bucket (S3)
# Es un contenedor de objetos, como archivos CSV, JSON, imágenes o modelos.
# Pensalo como un depósito de archivos.

# Shard (Kinesis)
# Es una partición de un flujo de datos que permite distribuir la lectura y el procesamiento de registros.
# Pensalo como un carril dentro de una cinta transportadora de datos.


# Shard: partición de un flujo de registros en Kinesis.

# Bucket: contenedor de objetos almacenados en S3.

# Flink: puede leer datos de Kinesis y escribirlos en S3.

# Kinesis: recibe y transmite datos continuamente.

# Shards: dividen el flujo de Kinesis para distribuir los registros y la capacidad de procesamiento.

# Flink: consume los datos, los transforma, calcula métricas o filtra registros.

# S3 (buckets): almacena datos y resultados de manera persistente.