#!/bin/sh
# Habilitar la salida inmediata en caso de error
set -e
trap 'echo "Error en la línea ${LINENO}: falló el comando: $(sed "${LINENO}q;d" "$0")" >&2' ERR

# Copiar el archivo de configuración a /tmp para que sea writable
cp /config/rclone/rclone.conf /tmp/rclone.conf
export RCLONE_CONFIG=/tmp/rclone.conf
export RCLONE_CONFIG_IS_FROZEN=1

# Variables configurables
REMOTE="overleaf"                  # Nombre del remote en rclone (modifícalo según necesites)
BACKUP_DIR="OverleafBackups"       # Carpeta base en OneDrive para los backups
LOCAL_PATH="/data"                 # Carpeta local a respaldar (montada en /data)
SLEEP_TIME=21600                   # Intervalo entre backups en segundos

# Opciones para excluir ficheros intermedios de LaTeX (se preservan los PDF)
EXCLUDE_OPTS="--exclude *.aux --exclude *.log --exclude *.fls --exclude *.fdb_latexmk --exclude *.bcf --exclude *.bbl --exclude *.blg --exclude *.synctex.gz --exclude *.acn --exclude *.out --exclude *.stdout --exclude *.glo --exclude *.ist --exclude *.run.xml --exclude *ERROR"

# Definir la ruta remota para 'latest'
LATEST_REMOTE="$REMOTE:$BACKUP_DIR/latest"

while true; do
  echo "---------------------------------"
  echo "Inicio de backup: $(date)"
  
  # Si no existe la carpeta "latest" en OneDrive, se crea la primera copia completa.
  if ! rclone lsd "$LATEST_REMOTE" >/dev/null 2>&1; then
    echo "No se encontró 'latest'. Creando la primera copia completa..."
    rclone sync "$LOCAL_PATH" "$LATEST_REMOTE" --progress $EXCLUDE_OPTS
    echo "Copia inicial completada."
  else
    # Comparar la carpeta local con 'latest' sin que set -e detenga el script
    set +e
    rclone check "$LOCAL_PATH" "$LATEST_REMOTE" --one-way $EXCLUDE_OPTS
    RET=$?
    set -e
    if [ $RET -eq 0 ]; then
      echo "No hay cambios. No se crea un nuevo snapshot."
    elif [ $RET -eq 1 ]; then
      echo "Cambios detectados. Creando nuevo snapshot..."
      TIMESTAMP=$(date +%Y%m%d_%H%M%S)
      SNAPSHOT_REMOTE="$REMOTE:$BACKUP_DIR/$TIMESTAMP"
      rclone sync "$LOCAL_PATH" "$SNAPSHOT_REMOTE" --progress $EXCLUDE_OPTS
      # Actualizamos "latest": borramos el contenido anterior y copiamos el nuevo snapshot
      rclone purge "$LATEST_REMOTE"
      rclone copy "$SNAPSHOT_REMOTE" "$LATEST_REMOTE" --progress $EXCLUDE_OPTS
      echo "Snapshot creado en: $SNAPSHOT_REMOTE"
      echo "La carpeta 'latest' ha sido actualizada."
    else
      echo "Error al comparar (código: $RET)"
      exit 1
    fi
  fi

  echo "Backup finalizado: $(date)"
  echo "Esperando $SLEEP_TIME segundos para el próximo backup..."
  sleep $SLEEP_TIME
done
