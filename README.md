# Kubuntu Post-Installation Script (Noble)

Este es un script de automatización personal para configurar y optimizar una instalación limpia de **Kubuntu 24.04**. Está diseñado para acelerar el despliegue del sistema, configurar el hardware y dejar el entorno listo para producción.

## 💻 Hardware
- **Laptop:** HP Omen 15ce0xx.
- **GPU 1:** NVIDIA GeForce GTX 1050 Mobile.
- **GPU 2:** Intel HD Graphics 630.
- **CPU:** Intel i5-7300HQ (4) @ 3.500GHz.
- **Memoria:** 16 GB.
- **Unidad 1:** SSD M.2 Nvme 220 GB.
- **Unidad 2:** HDD 1 TB 7200 RPM.
- **Audio device:** Intel Corporation CM238 HD Audio

## 🧪 Escenario de Pruebas y Elección Final de la Distribución
A fin de instalar una distro Linux en mi laptop de trabajo, probé Fedora, Mint, CachyOS, Debian, Tuxedo, Kubuntu 26< Endeavour OS y por ultimo, Kubuntu 24. La decisión desde el principio era usar KDE Plasma. En la mayoría de los casos, se encontraron errores al intenetar configurar el entorno hibrido de GPU's. En todas las instalaciones, se uso el primer disco para el sistema operativo y programas. El segundo (en su totalidad) para el directorio home.

**Problemas encontrados:** Falla al conectar monitor externo via HDMI y fallo en activar la aceleracion grafica de Nvidia desde el navegador web (Wayland). Ausencia de cabezeras de kernel 7.x para Nvidia (Fedora/X11). En general, Wayland puede presentar fallos con la arquitectura hibrida de GPU's y requiere de mas configuraciones manuales para conseguir un funcionamiento optimo. El audio, en algunos casos, se desactivaba luego de reiniciar el equipo.  

## 🚀 Características del Script
- **Actualización:** Automatiza el refresco de repositorios y el upgrade del sistema.
- **Drivers:** Instala controladores oficiales de NVIDIA y configuraciones PRIME.
- **Tipografías:** Inyecta de forma local y offline fuentes ClearType modernas (Calibri, Aptos de Office 365) evitando enlaces caídos de internet.
- **Software:**
    - Configura Flatpak (Flathub) e instala las últimas versiones de Haruna, Fre:ac, OnlyOffice y KolourPaint
    - Configura e instala WARP desde los repositorios de Cloudflare
    - Configura e instala Firefox desde los servidores de Mozilla
    - Instala el normalizador de audio `rsgain`
    - Remueve bloatware (LibreOffice, Elisa, Haruna (versión nativa obsoleta))
    - Instala Wine desde los repositorios WineHQ
    - Crea una instancia adicional en el menú para Firefox corriendo con Nvidia (icono azul)
- **Audio:** Se agrega el modulo de sonido al grub para forzar la detección.
- **Tweaks de Sistema:** Activa el *Tap-to-click* en el Touchpad y fuerza el apagado limpio mediante sesión vacía en KDE Plasma.

## 🛠️ Modo de Uso

1. Clona este repositorio o descarga el script `post-install.sh` junto con la imagen firefox-azul.png.
2. Coloca tu archivo comprimido `fuentes.tar.gz` (con tus fuentes `.ttf` en la raíz del comprimido) exactamente al lado del script.
3. Abre una terminal en la carpeta y otorga permisos de ejecución:
   ```bash
   chmod +x post-install.sh
4. Ejecuta el script:
   ```bash
   ./post-install.sh
5. Listo! Equipo configurado y optimizado!
