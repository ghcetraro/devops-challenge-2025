import psycopg2
import boto3
from botocore.exceptions import ClientError
import random
import string

# Función para generar una contraseña aleatoria
def generar_contraseña(longitud=12):
    caracteres = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(caracteres) for _ in range(longitud))

# Función para cambiar la contraseña en PostgreSQL
def cambiar_contraseña_postgres(db_params, nueva_contraseña):
    with psycopg2.connect(**db_params) as conn:
        with conn.cursor() as cursor:
            cursor.execute(f"ALTER USER {db_params['user']} WITH PASSWORD %s;", (nueva_contraseña,))
            conn.commit()
            print(f"Se ha cambiado la contraseña del usuario: {db_params['user']} para la base de datos: {db_params['dbname']}")

# Función para actualizar la contraseña en AWS Secrets Manager
def actualizar_secret(secret_name, nueva_contraseña):
    session = boto3.session.Session()
    client = session.client('secretsmanager')

    try:
        client.update_secret(SecretId=secret_name, SecretString=nueva_contraseña)
        print(f"Se ha actualizado el secreto para: {secret_name}")
    except ClientError as e:
        print(f"Error al actualizar el secreto: {e}")

# Función para leer el archivo de configuración
def leer_configuracion(archivo):
    configuraciones = {}
    with open(archivo, 'r') as f:
        for linea in f:
            partes = linea.strip().split(',')
            if len(partes) == 4:
                db_name, user, current_password, secret_name = partes
                configuraciones[db_name] = {
                    'user': user,
                    'password': current_password,
                    'secret_name': secret_name
                }
    return configuraciones

def main():
    # Leer configuraciones desde el archivo
    configuraciones = leer_configuracion('config.txt')

    for db_name, config in configuraciones.items():
        # Crear parámetros de conexión
        db_params = {
            'dbname': db_name,
            'user': config['user'],
            'password': config['password'],
            'host': 'localhost',  # Cambiar si la base de datos está en otro servidor
            'port': '5432'        # Cambiar si usas un puerto diferente
        }

        # Generar una nueva contraseña
        nueva_contraseña = generar_contraseña()

        # Cambiar la contraseña en PostgreSQL
        cambiar_contraseña_postgres(db_params, nueva_contraseña)

        # Actualizar la contraseña en Secrets Manager
        actualizar_secret(config['secret_name'], nueva_contraseña)

if __name__ == "__main__":
    main()