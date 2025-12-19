#!/bin/bash

# Uso: ./smooth_sunset.sh on  (para activar)
#      ./smooth_sunset.sh off (para desactivar)

TARGET_TEMP=4000   # Temperatura objetivo (cálida)
NORMAL_TEMP=6500   # Temperatura normal
STEP=100           # Cuánto baja por paso (más bajo = más suave pero más CPU)
DELAY=0.01         # Velocidad de la animación

current=$(hyprsunset --current | awk '{print $1}') # (Esto es pseudo-código, hyprsunset no siempre reporta bien, asumimos estados)

if [ "$1" == "on" ]; then
    # Bucle para bajar de 6500 a 4000
    for (( i=$NORMAL_TEMP; i>=$TARGET_TEMP; i-=$STEP )); do
        hyprsunset -t $i
        sleep $DELAY
    done
elif [ "$1" == "off" ]; then
    # Bucle para subir de 4000 a 6500
    for (( i=$TARGET_TEMP; i<=$NORMAL_TEMP; i+=$STEP )); do
        hyprsunset -t $i
        sleep $DELAY
    done
    # Asegurar que quede apagado el filtro
    hyprsunset -i
fi
