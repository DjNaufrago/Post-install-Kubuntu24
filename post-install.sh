#!/bin/bash

# =====================================================================
# CONFIGURACIÓN POST-INSTALACIÓN PARA KUBUNTU (Noble 24.04)
# Versión Optimizada Ultra-Rápida (Tira Única) - Edición Plasma 5 (X11)
# =====================================================================

# Detener el script si ocurre algún error inesperado
set -e


# =====================================================================
# 0. INSTALACIÓN DE PRE-REQUISITOS ESENCIALES
# =====================================================================
echo -e "\n🛠️ Instalando herramientas de red críticas (curl/wget)..."
sudo apt update
sudo apt install -y curl wget


# =====================================================================
# 1. FASE DE LIMPIEZA INICIAL (TIERRA ARRASADA)
# =====================================================================
echo -e "\n🧹 Purgando programas no deseados y rastros de Firefox Snap..."
# Remover paquetería de oficina, reproductores nativos y el cascarón de Firefox
sudo apt purge -y firefox libreoffice* elisa haruna

# Eliminar el contenedor Snap de Firefox y sus carpetas de residuos
sudo snap remove firefox 2>/dev/null || true
sudo rm -rf /var/snap/firefox /common/firefox ~/snap/firefox

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


# =====================================================================
# 4. EL GRAN UPDATE Y UPGRADE GLOBAL
# =====================================================================
echo -e "\n🔄 Sincronizando el nuevo arsenal con internet de un solo viaje..."
sudo apt update
sudo apt upgrade -y


# =====================================================================
# 5. LA GRAN INSTALACIÓN UNIFICADA (APT Y FLATPAK)
# =====================================================================
echo -e "\n🚀 Instalando todo el software base vía APT..."
sudo apt install -y --install-recommends \
    rar \
    unzip \
    unrar \
    firefox \
    firefox-l10n-es-es \
    flatpak \
    plasma-discover-backend-flatpak \
    winehq-stable \
    nvidia-driver-580 \
    nvidia-prime \
    rsgain \
    cloudflare-warp

# Configurar Flathub en el sistema
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# ---------------------------------------------------------------------
# PARCHE DE ENTORNO EN CALIENTE PARA FLATPAK
# ---------------------------------------------------------------------
echo -e "\n🧪 Inyectando variables de entorno Flatpak en caliente..."
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}:${HOME}/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share"
# ---------------------------------------------------------------------

echo -e "\n📦 Desplegando batallón de aplicaciones Flatpak..."
flatpak install flathub org.freac.freac -y
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub org.kde.haruna -y
flatpak install flathub org.fooyin.fooyin -y
flatpak install flathub org.kde.kolourpaint -y
flatpak install flathub org.gtk.Gtk3theme.Breeze-Dark//3.22 -y


# =====================================================================
# 6. CONFIGURACION DUAL PARA FIREFOX CON NVIDIA
# =====================================================================
echo -e "\n🦊 Configurando los motores de Firefox (Normal y Nvidia)..."

DIR_ACTUAL="${BASH_SOURCE%/*}"

mkdir -p ~/.local/share/icons/hicolor/128x128/apps/
cp "$DIR_ACTUAL/firefox-azul.png" ~/.local/share/icons/hicolor/128x128/apps/lnz-ff-azul.png 2>/dev/null || echo -e "⚠️  ¡Alerta: No se encontró firefox-azul.png en la carpeta del script!"

mkdir -p ~/.local/share/applications/

echo -e "  └─ 🛠️  Forjando lanzador Firefox Nvidia..."
echo '[Desktop Entry]
Version=1.0
Name=Firefox (Nvidia)
Comment=Navegador Web con Gráfica Dedicada
Exec=env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia firefox --class FirefoxNvidia %u
Icon=lnz-ff-azul
Terminal=false
Type=Application
Categories=Network;WebBrowser;
StartupWMClass=FirefoxNvidia' | tee ~/.local/share/applications/firefox-nvidia.desktop > /dev/null

echo -e "  └─ 🛠️  Forjando lanzador Firefox Normal..."
echo '[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox (Normal)
GenericName=Navegador web
Comment=Navegador rápido y privado
Exec=firefox %u
Icon=firefox
Terminal=false
StartupWMClass=firefox
StartupNotify=true
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=application/json;application/pdf;application/rdf+xml;application/rss+xml;application/x-xpinstall;application/xhtml+xml;application/xml;audio/flac;audio/ogg;audio/webm;image/avif;image/gif;image/jpeg;image/png;image/svg+xml;image/webp;text/html;text/xml;video/ogg;video/webm;x-scheme-handler/chrome;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/mailto;
Actions=new-window;new-private-window;open-profile-manager;

[Desktop Action new-window]
Exec=firefox --new-window %u
Name=Nueva ventana

[Desktop Action new-private-window]
Exec=firefox --private-window %u
Name=Nueva ventana privada

[Desktop Action open-profile-manager]
Exec=firefox --ProfileManager
Name=Abrir administrador de perfiles' | tee ~/.local/share/applications/firefox.desktop > /dev/null

rm -f ~/.local/share/applications/firefox-2.desktop

echo -e "  └─ 🧹 Purgando cachés y reiniciando el entorno gráfico en caliente..."
rm -f ~/.cache/menus/* && rm -f ~/.cache/ksycoca5_*
XDG_DATA_DIRS="$XDG_DATA_DIRS" kbuildsycoca5 --noincremental > /dev/null 2>&1
qdbus org.kde.KWin /KWin reconfigure > /dev/null 2>&1

echo -e "✨ ¡Entorno de Firefox optimizado y listo para la acción!"


# =====================================================================
# 7. FUENTES TIPOGRÁFICAS
# =====================================================================
echo -e "\n🔤 Configurando fuentes del sistema..."

echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
sudo apt install ttf-mscorefonts-installer -y

sudo apt install fonts-croscore fonts-crosextra-carlito fonts-crosextra-caladea -y

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
# 8. AJUSTES DEL SISTEMA, PURGA Y LIMPIEZA
# =====================================================================
echo -e "\n🛠️ Aplicando cirugías del sistema..."

sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/ { /snd_intel_dspcfg.dsp_driver=1/! s/.$/ snd_intel_dspcfg.dsp_driver=1&/ }' /etc/default/grub
sudo update-grub

kwriteconfig5 --file kservicerc --group Mouse --key TouchpadTapToClick true
kwriteconfig5 --file ksmserverrc --group General --key loginMode emptySession

sudo fc-cache -f


# =====================================================================
# 9. VERIFICACIÓN FINAL Y RECORDATORIOS
# =====================================================================
echo "====================================================================="
echo "    CONFIGURACIÓN COMPLETADA CON ÉXITO     "
echo "====================================================================="
echo "Verificación rápida de fuentes:"
fc-list : family | grep -i "calibri" > /dev/null && echo " -> Calibri: INSTALADA CON ÉXITO" || echo " -> Calibri: No detectada"
fc-list : family | grep -i "aptos" > /dev/null && echo " -> Aptos: INSTALADA CON ÉXITO" || echo " -> Aptos: No detectada"
echo "====================================================================="
echo "🦊 RECORDATORIO IMPORTANTE PARA FIREFOX:"
echo " Al abrir el navegador, entra en 'about:config' y activa:"
echo "  1. gfx.webrender.all = true"
echo "  2. media.hardware-video-decoding.force-enabled = true"
echo "====================================================================="
echo "Recomendación: ¡Reinicia el sistema completo ahora!"
echo " Esto cargará el driver Nvidia, el audio en el GRUB y asentará"
echo " de forma permanente las rutas de Flatpak en los menús de KDE."
echo "====================================================================="
