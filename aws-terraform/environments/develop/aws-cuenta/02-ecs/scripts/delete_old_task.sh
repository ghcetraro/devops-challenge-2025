#!/bin/bash

set -e

# Verifica que se haya pasado un argumento
if [ "$#" -ne 1 ]; then
  echo "Uso: $0 <nombre_de_la_familia>"
  exit 1
fi

FAMILY_NAME=$1

# Obtener las definiciones de tarea para la familia especificada
echo "Obteniendo definiciones de tarea para la familia: $FAMILY_NAME..."

TASK_DEFINITIONS=$(aws ecs list-task-definitions --family-prefix $FAMILY_NAME --query "taskDefinitionArns" --output text)

if [ -z "$TASK_DEFINITIONS" ]; then
  echo "No se encontraron definiciones de tarea para la familia: $FAMILY_NAME"
  exit 0
fi

# Obtener la última definición de tarea (la más reciente)
LATEST_TASK_DEFINITION=$(echo "$TASK_DEFINITIONS" | tr "\t" "\n" | sort | tail -n 1)

echo "La definición de tarea más reciente es: $LATEST_TASK_DEFINITION"

# Borrar las definiciones de tarea antiguas
for TASK_DEFINITION in $TASK_DEFINITIONS; do
  if [ "$TASK_DEFINITION" != "$LATEST_TASK_DEFINITION" ]; then
    echo "Borrando la definición de tarea: $TASK_DEFINITION..."
    aws ecs deregister-task-definition --task-definition $TASK_DEFINITION
  fi
done

echo "Borrado completo de definiciones de tarea antiguas."
