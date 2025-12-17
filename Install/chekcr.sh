#!/bin/bash

# Directorios
DOTFILES_DIR="$HOME/Dotfiles"
OUTPUT_FILE="$HOME/Dotfiles/dotfiles_content.txt"
OUTPUT_FILENAME=$(basename "$OUTPUT_FILE")

# Check if directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Error: Directory $DOTFILES_DIR does not exist."
  exit 1
fi

# Limpiar archivo de salida
> "$OUTPUT_FILE"

echo "Generando reporte en $OUTPUT_FILE..."

# Find mejorado:
# 1. Usa -prune para ignorar carpetas enteras eficientemente.
# 2. Excluye explícitamente el archivo de salida.
# 3. Usa -print0 para manejar nombres de archivo con espacios.

find "$DOTFILES_DIR" \
  \( \
     -path "*/.git" -o \
     -path "*/ohmyzsh" -o \
     -path "*/Wallpapers" -o \
     -path "*/Install/system-files/boot" -o \
     -path "*/Install/system-files/usr/share" \
  \) -prune \
  -o -type f \
  -not -name "$OUTPUT_FILENAME" \
  -not -name "push.log" \
  -not -name "*.png" \
  -not -name "*.jpg" \
  -not -name "*.otf" \
  -not -name "*.ttf" \
  -print0 | while IFS= read -r -d '' file; do

    # Chequeo extra: Si el archivo es binario (imágenes, ejecutables), saltarlo.
    # Si no tienes 'file' instalado, puedes borrar este bloque if/fi, pero es recomendable.
    if file "$file" | grep -qE 'image|data|font'; then
        continue
    fi

    # Calcular ruta relativa
    relative_path=${file#$DOTFILES_DIR/}

    # Escribir al archivo
    echo "=========================================" >> "$OUTPUT_FILE"
    echo "File: $relative_path" >> "$OUTPUT_FILE"
    echo "=========================================" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    cat "$file" >> "$OUTPUT_FILE"

    echo "" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    echo "Procesado: $relative_path"
done

echo "¡Listo! Todo guardado en $OUTPUT_FILE"
