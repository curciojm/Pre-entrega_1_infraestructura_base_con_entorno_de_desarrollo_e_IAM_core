El init de terra se hace en el entorno que se va a usar. Los modulos se construyen afuera

En el caso de este ejercicio, ese entorno es dev.

En dev es que reutilizan los modulos como main.tf

servicios que agrego en role

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

Si el rol no autoriza acciones el que administre no puede hacer nada por default

Regla fundamental de IAM
Por defecto:
Todo está denegado.

Una acción se permite únicamente si existe una policy que la permita y no hay un Deny que la bloquee.
Por eso el enfoque de tu entrega es justamente mínimo privilegio: no darle al rol "Action": "*" sino solamente las acciones que realmente necesita Flink.

# Bucket (S3)
# Es un contenedor de objetos, como archivos CSV, JSON, imágenes o modelos.
# Pensalo como un depósito de archivos.

# Shard (Kinesis)
# Es una partición de un flujo de datos que permite distribuir la lectura y el procesamiento de registros.
# Pensalo como un carril dentro de una cinta transportadora de datos.