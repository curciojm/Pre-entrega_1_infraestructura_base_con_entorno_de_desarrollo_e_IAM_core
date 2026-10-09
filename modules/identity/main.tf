resource "aws_iam_role" "streaming_processor_role" {
  name = "${var.environment}-streaming-processor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "kinesisanalytics.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "streaming_processor_policy" {
  name = "${var.environment}-streaming-processor-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::${var.data_bucket_name}"

        Condition = {
          StringLike = {
            "s3:prefix" = [
              "datos/streaming",
              "datos/streaming/*"
            ]
          }
        }
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "arn:aws:s3:::${var.data_bucket_name}/datos/streaming/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "streaming_processor" {
  role       = aws_iam_role.streaming_processor_role.name
  policy_arn = aws_iam_policy.streaming_processor_policy.arn
}

resource "aws_iam_role" "audit_role" {
  name = "${var.environment}-audit-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy_attachment" "audit_readonly" {
  role       = aws_iam_role.audit_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# kinesis:DescribeStream
# Le permite consultar información sobre el stream.
# Por ejemplo:
# - nombre
# - estado
# - configuración
# - información de sus shards

# kinesis:ListShards
# Permite obtener los shards que tiene el stream.
# Un Kinesis Data Stream se divide internamente en shards

# kinesis:GetShardIterator
# Esta es un poco más interesante.
# Kinesis no funciona simplemente con:
# "Dame los datos del shard 2."

# Primero necesitás obtener un iterator, que es básicamente una referencia a desde qué posición del shard querés comenzar a leer.
# Por ejemplo:
# Shard 1

# [registro 1] [registro 2] [registro 3] [registro 4] [registro 5]
#                          ↑
#                          │
#                     iterator

# El iterator podría indicar:
# "Empezá a leer desde acá."

# Por eso:
# "Dame un punto de partida para leer este shard.

# kinesis:GetRecords
# Finalmente, esta es la operación que realmente permite obtener los registros.
# Una vez que Flink tiene el iterator:
# GetShardIterator
#        ↓
#    iterator
#        ↓
# GetRecords
#        ↓
#  registros

# Por ejemplo:
# {
#   "user_id": 123,
#   "event": "purchase"
# }

# {
#   "user_id": 456,
#   "event": "login"
# }

# Por eso:
# "Dame los registros que están disponibles desde esta posición


# Regla fundamental de IAM
# Por defecto:
# Todo está denegado.

# Una acción se permite únicamente si existe una policy que la permita y no hay un Deny que la bloquee.
# Por eso el enfoque de tu entrega es justamente mínimo privilegio: no darle al rol "Action": "*" sino solamente las acciones que realmente necesita Flink.