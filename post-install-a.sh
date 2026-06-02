#!/bin/bash

# =====================================================================
# CONFIGURACIÓN POST-INSTALACIÓN PARA KUBUNTU (Noble)
# Versión Optimizada Ultra-Rápida (Tira Única)
# =====================================================================

# Detener el script si ocurre algún error inesperado
set -e


# =====================================================================
# 1. FASE DE LIMPIEZA INICIAL (TIERRA ARRASADA)
# =====================================================================
echo -e "\n🧹 Purgando programas no deseados y rastros de Firefox Snap..."
# Remover paquetería de oficina, reproductores nativos y el cascarón de Firefox
sudo apt purge -y firefox libreoffice* elisa haruna

# Eliminar el contenedor Snap de Firefox y sus carpetas de residuos
sudo snap remove firefox 2>/dev/null || true
sudo rm -rf /var/snap/firefox /common/firefox ~/snap/firefox

# ¡La primera gran barrida gracias a tu observación!
echo -e "\n🗑️ Eliminando dependencias huérfanas de los programas purgados..."
sudo apt autoremove -y


# =====================================================================
# 2. ARQUITECTURA Y DIRECTORIOS BASE
# =====================================================================
echo -e "\n⚙️ Configurando soporte de 32 bits y directorios..."
sudo dpkg --add-architecture i386
sudo install -d /etc/apt/keyrings


# =====================================================================
# 3. AGREGACIÓN DE REPOSITORIOS, LLAVES Y PRIORIDADES (SIN UPDATES)
# =====================================================================
echo -e "\n📦 Inyectando llaves y fuentes de repositorios..."

# A. Cloudflare WARP
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ noble main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list > /dev/null

# B. Mozilla Firefox (.deb Nativo)
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt/mozilla l10n-amd64" | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null

# Apt Pinning para Firefox (Bloqueo estricto contra Snap)
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000

Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1
' | sudo tee /etc/apt/preferences.d/mozilla > /dev/null

# C. WineHQ Stable
wget -q -O - https://dl.winehq.org/wine-builds/winehq.key | sudo tee /etc/apt/keyrings/winehq-archive.key > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/ubuntu/ noble main" | sudo tee /etc/apt/sources.list.d/winehq.list > /dev/null

# D. Audacious PPA (Panda Jim)
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ubuntuhandbook1/apps


# =====================================================================
# 4. EL GRAN UPDATE Y UPGRADE GLOBAL
# =====================================================================
echo -e "\n🔄 Sincronizando el nuevo arsenal con internet de un solo viaje..."
sudo apt update
sudo apt upgrade -y


# =====================================================================
# 5. LA GRAN INSTALACIÓN UNIFICADA
# =====================================================================
echo -e "\n🚀 Instalando todo el software del búnker en un solo comando..."
sudo apt install -y --install-recommends \
    curl \
    unzip \
    unrar \
    firefox \
    firefox-l10n-es-es \
    flatpak \
    plasma-discover-backend-flatpak \
    winehq-stable \
    audacious \
    audacious-plugins \
    nvidia-driver-580 \
    nvidia-prime \
    rsgain \
    cloudflare-warp

# Configurar Flathub para Discover
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


# =====================================================================
# 6. FUENTES TIPOGRÁFICAS
# =====================================================================
echo -e "\n🔤 Configurando fuentes del sistema..."

# Fuentes Clásicas de Microsoft (Aceptando el contrato EULA a ciegas)
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
sudo apt install ttf-mscorefonts-installer -y

# Fuentes de reemplazo métrico y compatibilidad
sudo apt install fonts-croscore fonts-crosextra-carlito fonts-crosextra-caladea -y

# Inyección local desde tu comprimido fuentes.tar.gz
if [ -f "./fuentes.tar.gz" ]; then
    echo "    -> Archivo 'fuentes.tar.gz' detectado. Extrayendo..."
    mkdir -p /tmp/pack-fuentes
    tar -xzf ./fuentes.tar.gz -C /tmp/pack-fuentes/
    sudo mkdir -p /usr/share/fonts/truetype/msttcorefonts
    sudo cp /tmp/pack-fuentes/*.ttf /tmp/pack-fuentes/*.TTF /usr/share/fonts/truetype/msttcorefonts/ 2>/dev/null || true
    rm -rf /tmp/pack-fuentes
    echo "    -> ¡Fuentes locales inyectadas!"
else
    echo "    ⚠️ ADVERTENCIA: './fuentes.tar.gz' no detectado. Se omitirá Calibri/Aptos."
fi


# =====================================================================
# 7. AJUSTES DEL SISTEMA, PURGA Y LIMPIEZA
# =====================================================================
echo -e "\n🛠️ Aplicando cirugías del sistema y eliminando software no deseado..."

# Configuración del GRUB para el driver de audio Intel
sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/ { /snd_intel_dspcfg.dsp_driver=1/! s/"$/ snd_intel_dspcfg.dsp_driver=1"/ }' /etc/default/grub
sudo update-grub

# Ajustes de usuario para KDE Plasma (Touchpad y Sesión Vacía)
kwriteconfig5 --file kservicerc --group Mouse --key TouchpadTapToClick true
kwriteconfig5 --file ksmserverrc --group General --key loginMode emptySession

# Actualizar la caché de fuentes
sudo fc-cache -f


# =====================================================================
# 8. VERIFICACIÓN FINAL
# =====================================================================
echo "====================================================================="
echo "    CONFIGURACIÓN COMPLETADA CON ÉXITO     "
echo "====================================================================="
echo "Verificación rápida de fuentes:"
fc-list : family | grep -i "calibri" > /dev/null && echo " -> Calibri: INSTALADA CON ÉXITO" || echo " -> Calibri: No detectada"
fc-list : family | grep -i "aptos" > /dev/null && echo " -> Aptos: INSTALADA CON ÉXITO" || echo " -> Aptos: No detectada"
echo "====================================================================="
echo "Recomendación: Reinicia el sistema para cargar el nuevo driver"
echo "de video y los parámetros de audio del GRUB de manera limpia."
echo "====================================================================="
