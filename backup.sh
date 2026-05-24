#!/bin/bash

# 1. Definimos el nombre del archivo con la fecha y hora exacta
FECHA=$(date +%Y-%m-%d_%H-%M-%S)
NOMBRE_ARCHIVO="backup_cms_$FECHA.tar.gz"

# 2. Mostramos un mensaje por pantalla
echo "Iniciando copia de seguridad del CMS..."

# 3. Comprimimos las carpetas de datos y los archivos clave
tar -czvf ../mis_backups/$NOMBRE_ARCHIVO datos_mysql datos_wordpress .env docker-compose.yml

# 4. Confirmación de éxito
if [[ $? -eq 0 ]]; then
    echo "¡Backup completado con éxito! Guardado en: ../mis_backups/$NOMBRE_ARCHIVO"
else
    echo "Error: No se ha podido realizar el backup en: ../mis_backups/$NOMBRE_ARCHIVO"
fi