#!/bin/bash

# 1. Verificar si se pasó un argumento
if [ -z "$1" ]; then
    echo "❌ Error: Debes indicar la carpeta."
    echo "Uso: ./dump_config.sh <ruta_de_carpeta>"
    echo "Ejemplo: ./dump_config.sh ~/.config/nvim"
    exit 1
fi

# 2. Definir rutas
TARGET_DIR="${1%/}" # Elimina el slash final si existe
DIR_NAME=$(basename "$TARGET_DIR")
OUTPUT_FILE="$TARGET_DIR/DUMP_${DIR_NAME}.md"

# 3. Verificar que la carpeta existe
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: La carpeta '$TARGET_DIR' no existe."
    exit 1
fi

# 4. Crear/Limpiar el archivo de salida
echo "==================================================================" > "$OUTPUT_FILE"
echo " DUMP DE CONFIGURACIÓN: $TARGET_DIR" >> "$OUTPUT_FILE"
echo " Fecha: $(date)" >> "$OUTPUT_FILE"
echo "==================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "📂 Escaneando: $TARGET_DIR"
echo "📄 Guardando en: $OUTPUT_FILE"

# 5. Buscar archivos y procesar
# Ignoramos: .git, el propio archivo de salida, imágenes comunes y lazy-lock
find "$TARGET_DIR" -type f \
    -not -path '*/.git/*' \
    -not -path '*/node_modules/*' \
    -not -name "$(basename "$OUTPUT_FILE")" \
    -not -name "lazy-lock.json" \
    -not -name "*.png" \
    -not -name "*.jpg" \
    -not -name "*.jpeg" \
    -not -name "*.ico" \
    -not -name "*.woff2" \
    -not -name "*.pdf" \
    | sort | while read -r file; do

    # Verificamos si es un archivo de texto (para evitar binarios raros)
    if file "$file" | grep -q "text"; then
        # Formato bonito en el TXT
        echo "" >> "$OUTPUT_FILE"
        echo "################################################################################" >> "$OUTPUT_FILE"
        echo "ARCHIVO: $file" >> "$OUTPUT_FILE"
        echo "################################################################################" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"

        # Volcar contenido
        cat "$file" >> "$OUTPUT_FILE"
    fi
done

echo "✅ ¡Listo! Archivo creado en:"
echo "   $OUTPUT_FILE"
