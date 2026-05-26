#!/bin/bash

# =====================================================================
# CONFIGURACIÓN POST-INSTALACIÓN PARA KUBUNTU (Noble)
# Desarrollado y optimizado en conjunto.
# =====================================================================

# Detener el script si ocurre algún error inesperado
set -e

echo "====================================================================="
echo "   INICIANDO SCRIPT DE CONFIGURACIÓN Y OPTIMIZACIÓN DE KUBUNTU   "
echo "====================================================================="

# =====================================================================
# 0. PREPARACIÓN DEL SISTEMA Y ACTUALIZACIÓN INICIAL
# =====================================================================
echo -e "\n[+] Pasando lista e instalando herramientas esenciales..."
sudo apt update && sudo apt install curl unzip -y

echo -e "\n[+] Ejecutando actualización general del sistema (Upgrade)..."
sudo apt upgrade -y


# =====================================================================
# 1. CONFIGURACIÓN DE REPOSITORIOS Y LLAVES
# =====================================================================
echo -e "\n[+] Configurando repositorio oficial de Cloudflare WARP..."
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ noble main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list

echo -e "\n[+] Instalando soporte Flatpak y backend para Discover..."
sudo apt update && sudo apt install flatpak plasma-discover-backend-flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


# =====================================================================
# 2. INSTALACIÓN DE PAQUETES APT Y FUENTES EMPAQUETADAS
# =====================================================================
echo -e "\n[+] Instalando aplicaciones base, multimedia y drivers..."
sudo apt install \
    nvidia-driver-580 \
    nvidia-prime \
    unrar \
    rsgain \
    cloudflare-warp -y

echo -e "\n[+] Asegurando fuentes clásicas de Microsoft (Aceptando EULA)..."
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
sudo apt install ttf-mscorefonts-installer -y

echo -e "\n[+] Instalando fuentes de reemplazo métrico de Google/Ubuntu..."
sudo apt install fonts-croscore fonts-crosextra-carlito fonts-crosextra-caladea -y

# INYECCIÓN DESDE TU ARCHIVO COMPRIMIDO PROPIO
echo -e "\n[+] Procesando paquete de fuentes ClearType locales..."
if [ -f "./fuentes.tar.gz" ]; then
    echo "    -> Archivo 'fuentes.tar.gz' detectado. Extrayendo..."

    # 1. Crear zona temporal limpia
    mkdir -p /tmp/pack-fuentes

    # 2. Descomprimir el paquete dentro de la zona temporal
    tar -xzf ./fuentes.tar.gz -C /tmp/pack-fuentes/

    # 3. Asegurar el directorio del sistema y mover las fuentes
    sudo mkdir -p /usr/share/fonts/truetype/msttcorefonts
    sudo cp /tmp/pack-fuentes/*.ttf /tmp/pack-fuentes/*.TTF /usr/share/fonts/truetype/msttcorefonts/ 2>/dev/null || true

    # 4. Limpiar los archivos temporales de la memoria
    rm -rf /tmp/pack-fuentes
    echo "    -> ¡Fuentes empaquetadas inyectadas y residuos limpios con éxito!"
else
    echo "    ⚠️ ADVERTENCIA: No se encontró el archivo './fuentes.tar.gz' al lado del script."
    echo "    Se omitirá la inyección automática de Calibri/Aptos."
fi


# =====================================================================
# 3. CONFIGURACIONES DEL SISTEMA Y LIMPIEZA
# =====================================================================
echo -e "\n[+] Configurando parámetro de audio en el GRUB..."
sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/ { /snd_intel_dspcfg.dsp_driver=1/! s/"$/ snd_intel_dspcfg.dsp_driver=1"/ }' /etc/default/grub
sudo update-grub

echo -e "\n[+] Configurando el Touchpad (Tap-to-click) para KDE Plasma..."
kwriteconfig5 --file kservicerc --group Mouse --key TouchpadTapToClick true

# Comenzar siempre con una sesión vacía (evita que la laptop se quede colgada al apagar)
kwriteconfig5 --file ksmserverrc --group General --key loginMode emptySession

echo -e "\n[+] Removiendo paquetería de oficina e interfaz no deseada..."
sudo apt purge libreoffice* elisa haruna -y
sudo apt autoremove -y


# =====================================================================
# 4. REFRESCO DE CACHÉ Y VERIFICACIÓN
# =====================================================================
echo -e "\n[+] Actualizando la caché global de fuentes del sistema..."
sudo fc-cache -f

echo "====================================================================="
echo "   CONFIGURACIÓN COMPLETADA CON ÉXITO   "
echo "====================================================================="
echo "Verificación rápida de fuentes:"
if fc-list : family | grep -i "calibri" > /dev/null; then
    echo " -> Calibri: INSTALADA CON ÉXITO"
else
    echo " -> Calibri: No detectada"
fi

if fc-list : family | grep -i "aptos" > /dev/null; then
    echo " -> Aptos: INSTALADA CON ÉXITO"
else
    echo " -> Aptos: No detectada"
fi
echo "====================================================================="
echo "Recomendación: Reinicia el sistema para cargar el nuevo driver"
echo "de video y los parámetros de audio del GRUB de manera limpia."
echo "====================================================================="
