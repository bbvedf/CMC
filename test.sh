#!/bin/bash

# Rutas a los archivos de configuración y credenciales
CRED_FILE="/home/bbvedf/credenciales.txt"

# Función para verificar si la VPN está activa
# Pendiente 

# 1. Arrancar la VPN
# Pendiente

# 2. Hacer el resto de cosas (sustituye esto por tus comandos)
# Pendiente

# Archivo que contiene la lista de monedas (una por línea)
coin_file="coins.txt"

# Encabezados
echo "===="
echo "===="
echo "symbol;current_price_usd;price_change_24h;price_change_7d;price_change_14d;price_change_30d;price_change_1y"

# Leer cada moneda desde el archivo
while IFS= read -r coin; do
    # Hacer la solicitud a la API
    response=$(curl -s "https://api.coingecko.com/api/v3/coins/$coin?localization=false")

    # Usar jq para extraer y formatear los datos
    echo "$response" | jq -r '"\(.symbol);\(.market_data.current_price.usd);\(.market_data.price_change_percentage_24h);\(.market_data.price_change_percentage_7d);\(.market_data.price_change_percentage_14d);\(.market_data.price_change_percentage_30d);\(.market_data.price_change_percentage_1y)"'

    sleep 12 # Pausa en segundos entre cada solicitud
done < "$coin_file"

echo "===="
echo "===="

# 3. Cerrar la VPN
# Pendiente
