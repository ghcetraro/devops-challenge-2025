# devops-challenge-2025

## descripcion

	para este ejemplo se uso:
		- ecr
		- ecs
		- rds postgres

	se usaron estas herramientas porque requerian menos trabajo para configurar para este desafio, si se habria usado kubernetes requeria muchas mas configuraciones (terraform, helm, etc)

	imagenes de docker:

		se crearon dos:

			.- una con todos los componentes solicitados
			.- otra que en 2 pasos permite compilar imagenes de docker java

## terraform

	Para mas facil instalacion y administracion se creo un terraform separado por aplicaciones, cada uno con su backend (s3 y dynamodb). 
	Los mismos se encuentran enumerados como se deben instalar

	Para este ejemplo uso profiles, pero se pueden sacar y usar aws keys

	ejemplo:

		terraform init
		terraform plan
		terraform apply

## como configurar el profile

	nano ~/.aws

		[profile devops]
		sso_start_url=https://devops.awsapps.com/start/
		sso_region=us-east-1
		sso_account_id=1234567890
		sso_role_name=AdministratorAccess
		region=us-east-1
		output=json

## recursos

	vpc -- generador de la red
	
	ssh -- generador de ssh para usar para todas las maquinas virtuales que se cree a futuro
	
	bases de datos:
		-- por una lado se creo el motor
		-- por otro lado se crean las bases

	ecs:
		-- se creo un servicio de aws ecs, que publica una aplicacion solo con un hola mundo
		-- se creo un loadbalancer que publica por url cada servicio de ecs
		-- se creo los registro de route53 para la aplicacion

	jumper:
		-- como la base de datos es privada, se creo un jumper que atraves de un tunerl ssh permite deployar y conectarse a la misma
