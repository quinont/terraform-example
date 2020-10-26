# Ejemplo simple

Hola, en este ejemplo se creara una vm en GCP, a su vez esta vm va a tener una simple app de python flask que se ejecutara como un startup script de la misma.

Aparte de la app, la vm tiene configurado un usuario para poder acceder desde ssh.

**NOTA** Todo este ejemplo fue realizado sobre linux.

## Setup

Como primera medida tenemos que tener terraform instalado, [como instalar lo podemos buscar desde la pagina oficial](https://www.terraform.io/downloads.html)


Nota: Cuando se genero este ejemplo se ocupo la version v0.13.5.


Posterior a esto, tenemos que generar una cuenta de servicio con permisos de owner en el proyecto que vamos a estar trabajando, esto es posible desde la consola web de gcp, o mediante los siguientes comandos de gcloud.

Primero tomamos el proyecto:

```
export mi_proyecto=$(gcloud config get-value project)
```

Creando la cuenta de servicio:

```
gcloud projects add-iam-policy-binding --member="serviceAccount:terraform@${mi_proyecto}.iam.gserviceaccount.com" --role="roles/owner"
```

Despues tenemos que darle permisos a esta cuenta (en este caso le vamos a dar permisos de owner)

```
gcloud projects add-iam-policy-binding ${mi_proyecto} --member="serviceAccount:terraform@${mi_proyecto}.iam.gserviceaccount.com" --role="roles/owner"
```


Creamos una key:
```
gcloud iam service-accounts keys create ~/key.json --iam-account terraform@${mi_proyecto}.iam.gserviceaccount.com
```


seteamos la siguiente variable de entorno:
```
export GOOGLE_APPLICATION_CREDENTIALS="~/key.json"
```

Aparte seteamos una variable de proyecto para que pueda ocupar terraform
```
export TF_VAR_project="${mi_proyecto}"
```

## Ejecutando Terraform

Con todo esto ya estamos listos para poder correr terraform:

```
terraform init
```

luego revisamos el plan:

```
terraform plan
```

Al final ejecutamos el apply:
```
terraform apply
```

## Probando todo

Para probar simplemente tenemos que hacer una llamda al servicio que se levanto en la ip publica con el puerto 5000.
```
curl $(terraform output ip):5000
```

Si nos queremos conectar a la instancia tenemos que ejecutar el ssh de la siguiente manera.
```
ssh -i private_key -l usuario $(terraform output ip)
```


## Clean up

Para limpiar la infraestructura con terraform corremos el siguiente comando:
```
terraform destroy
```

Para borrar la Cuenta de Servicio:
```
gcloud iam service-accounts delete terrafrom@${mi_proyecto}.iam.gserviceaccount.com
```

