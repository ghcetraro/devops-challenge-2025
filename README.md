# devops-challenge-2025

## desafio

	Construir un proyecto en Terraform que permita crear una infraestructura en AWS que cumpla con los siguientes requisitos:  

	Crear un servicio de cómputo con SO Linux (EC2, ECS, EKS, etc…).  
	Crear un servicio de base de datos (RDS, DynamoDB, Aurora, etc …).  
	Crear políticas de seguridad para el acceso SSH (por ejemplo, restricción de IPs).  
	
	Construir una imagen de Docker con SO Linux y publicarla, la imagen debe contar con las siguientes especificaciones:  
		
		Instalar Git  
		Instalar Vs Code  
		Instalar Maven  
		Instalar PostgreSQL  
		Instalar Java JRE  
		Debe poder compilar proyectos NetCore  
		Debe poder compilar aplicaciones Java  
		Subir un servidor apache con un “hola mundo” o cualquier proyecto público  
		Montar la imagen de Docker creada en el servicio de computo elegido en el paso 1   

## NOTA:

	Debe haber conexión entre el Docker y el servicio de base de datos elegido.  
	Debe ser elaborado en una cuenta propia (debe explorar sus opciones).  
	Concedernos acceso a la imagen de Docker publicada.  
	Concedernos acceso a los archivos de Terraform creados.  
	Justificar por qué el tipo de servicio de cómputo y base de datos elegidos.  
	Es un plus cualquier configuración adicional realizada.  
	Explicarnos como la prueba sera ejecutado (Manualmente or con un pipeline).  
	Explique el uso y gestion del state file y donde esta almacenado.  
	Explique la gestion del archive .lock en Terraform para esta evaluación.  
	