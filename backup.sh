#!/bin/bash
# ==========================================
# Script de Backup Nivel Producción
# ==========================================

# 1. Comprobación de seguridad (Obligar a usar sudo)
if [ "$EUID" -ne 0 ]; then
  echo "❌ Error Crítico: No tienes permisos suficientes."
  echo "👉 Debes ejecutar este script con superpoderes: sudo ./backup.sh"
  exit 1
fi

# 2. Variables de entorno
DIRECTORIO_BASE="/home/chiburruso/mi_cms"
FECHA=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVO_BACKUP="backup_cms_PRO_$FECHA.tar.gz"

echo "🚀 Iniciando Protocolo de Backup Seguro..."

# 3. Asegurar que estamos en la carpeta correcta
cd $DIRECTORIO_BASE

# 4. Congelación de motores (Para evitar corrupción de base de datos)
echo "⏸️  Congelando contenedores..."
docker compose stop

# 5. Compresión con privilegios absolutos (Captura el UID 999 y el UID 33 sin problemas)
echo "📦 Empaquetando la infraestructura en $ARCHIVO_BACKUP..."
tar -czvf $ARCHIVO_BACKUP datos_mysql datos_wordpress .env docker-compose.yml backup.sh

# 6. Reactivación de motores
echo "▶️  Reactivando contenedores..."
docker compose start

# 7. Devolverle la propiedad del archivo comprimido al usuario normal
# (Para que luego desde Windows puedas sacarlo con 'scp' sin que te dé Permission Denied)
chown chiburruso:chiburruso $ARCHIVO_BACKUP

echo "✅ Backup completado con éxito. El archivo está listo y asegurado."
echo "📁 Nombre del archivo: $ARCHIVO_BACKUP"