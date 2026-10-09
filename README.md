# Preentrega 1 — Infraestructura base con Terraform y AWS

## Descripción

Este proyecto implementa una infraestructura base en AWS para el entorno de desarrollo (`dev`) mediante Terraform. La configuración está organizada en módulos para separar los recursos de red de los recursos de identidad y acceso (IAM).

**Región de AWS:** `us-east-2` (Ohio).

## Estructura del proyecto

```text
.
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── identity/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── enviroments/
│   └── dev/
│       ├── backend.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
├── .gitignore
├── README.md
└── PLAN_OUTPUT.md
```

> El directorio se llama `enviroments/dev` en este repositorio.

## Requisitos previos

- Terraform instalado.
- AWS CLI instalado y configurado con credenciales que permitan administrar los recursos definidos.
- Bucket S3 `juan-terraform-state-2026` existente en la región `us-east-2`.
- Tabla DynamoDB `terraform-locks` existente en la región `us-east-2`.
- Bucket de datos `juan-terraform-data-2026` disponible en la cuenta de AWS.

El bucket S3 y la tabla DynamoDB utilizados para el backend remoto se crearon previamente, fuera de esta configuración de Terraform.

## Inicialización y despliegue

Ejecutar los siguientes comandos desde la raíz del repositorio:

```powershell
cd enviroments/dev
terraform init
terraform validate
terraform plan
terraform apply
```

- `terraform init`: inicializa el directorio de trabajo, configura el backend remoto y descarga los proveedores necesarios.
- `terraform validate`: verifica que la configuración sea válida.
- `terraform plan`: muestra los cambios que Terraform propone realizar, sin modificar la infraestructura.
- `terraform apply`: aplica los cambios después de solicitar confirmación.

Para consultar los outputs generados:

```powershell
terraform output
```

## Recursos creados

### Red — módulo `network`

| Recurso | Configuración |
|---|---|
| VPC | CIDR `10.0.0.0/16`, nombre `dev-vpc` |
| Subred privada 1 | CIDR `10.0.1.0/24`, zona `us-east-2a` |
| Subred privada 2 | CIDR `10.0.2.0/24`, zona `us-east-2b` |
| Tabla de rutas | Una tabla privada compartida por ambas subredes |
| Asociaciones de rutas | Una asociación por subred |
| VPC Gateway Endpoint | Endpoint para Amazon S3 asociado a la tabla de rutas privada |

No se definen un Internet Gateway ni un NAT Gateway. El Gateway Endpoint permite acceder a S3 a través de la red de AWS sin requerir una salida a Internet para ese tráfico. El acceso efectivo también depende de los permisos IAM y de las políticas aplicables.

### Identidad y acceso — módulo `identity`

| Recurso | Función |
|---|---|
| `dev-streaming-processor-role` | Rol de ejecución para Amazon Kinesis Data Analytics |
| `dev-streaming-processor-s3-policy` | Permite listar el prefijo `datos/streaming` del bucket `juan-terraform-data-2026` y leer y escribir objetos dentro de ese prefijo |
| Asociación de política S3 | Asocia la política de acceso a datos con el rol de procesamiento |
| `dev-audit-role` | Rol destinado a tareas de auditoría |
| Asociación de `ReadOnlyAccess` | Asocia la política administrada de lectura de AWS al rol de auditoría |

El rol de procesamiento tiene permisos `s3:ListBucket`, `s3:GetObject` y `s3:PutObject` limitados al bucket y al prefijo definidos en la configuración. El rol de auditoría utiliza la política administrada por AWS `ReadOnlyAccess`.

## Backend remoto

Terraform utiliza un backend remoto en Amazon S3 para almacenar el estado:

- **Bucket:** `juan-terraform-state-2026`
- **Clave:** `Pre-entrega_1_infraestructura_base_con_entorno_de_desarrollo_e_IAM_core/terraform.tfstate`
- **Región:** `us-east-2`
- **Bloqueo del estado:** tabla DynamoDB `terraform-locks`
- **Cifrado:** habilitado en la configuración del backend.

El estado registra los recursos administrados por Terraform y permite comparar la configuración con la infraestructura existente.

## Outputs

La configuración expone los siguientes valores:

- `vpc_id`: ID de la VPC.
- `private_subnet_ids`: IDs de las dos subredes privadas.
- `streaming_processor_role_arn`: ARN del rol de procesamiento.
- `audit_role_arn`: ARN del rol de auditoría.

## Destrucción de los recursos

Para revisar qué recursos se eliminarían y luego destruir la infraestructura administrada por Terraform:

```powershell
terraform plan -destroy
terraform destroy
```

Antes de confirmar la destrucción, revisar el plan que muestra Terraform. Estos comandos no eliminan el código del repositorio ni los recursos del backend que fueron creados fuera de esta configuración.

## Evidencia del plan

El archivo [`PLAN_OUTPUT.md`](PLAN_OUTPUT.md) contiene la salida del plan de Terraform correspondiente a esta preentrega.