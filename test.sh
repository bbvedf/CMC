#!/bin/bash

# Rutas a los archivos de configuración y credenciales
VPN_CONFIG="/home/bbvedf/nl-free-34.protonvpn.udp.ovpn"
CRED_FILE="/home/bbvedf/credenciales.txt"

# Función para verificar si la VPN está activa
check_vpn() {
    if ip link show tun0 > /dev/null 2>&1; then
        return 0  # VPN activa
    else
        return 1  # VPN no activa
    fi
}

# 1. Arrancar la VPN
echo "Activando Proton VPN..."
sudo openvpn --config "$VPN_CONFIG" --auth-user-pass "$CRED_FILE" --daemon  # Ejecuta en segundo plano

# Esperar a que la VPN se conecte
sleep 5

# Verificar si la VPN está activa
if check_vpn; then
    echo "VPN activada correctamente."
else
    echo "Error al activar la VPN. Abortando..."
    sudo killall openvpn  # Mata el proceso si falla
    exit 1
fi

# 2. Hacer el resto de cosas (sustituye esto por tus comandos)
echo "Realizando tareas con la VPN activa..."

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
echo "Desactivando Proton VPN..."
sudo killall openvpn  # Termina todos los procesos de OpenVPN

# Verificar que la VPN se haya cerrado
sleep 2
if ! check_vpn; then
    echo "VPN cerrada correctamente."
else
    echo "Error al cerrar la VPN."
    exit 1
fi

echo "Script finalizado."
