# Kubuntu Post-Installation Script (Noble)

Este es un script de automatización personal para configurar y optimizar una instalación limpia de **Kubuntu 24.04**. Está diseñado para acelerar el despliegue del sistema, configurar el hardware y dejar el entorno listo para producción.

## Hardware
- **Laptop:** HP Omen 15ce0xx.
- **GPU 1:** NVIDIA GeForce GTX 1050 Mobile.
- **GPU 2:** Intel HD Graphics 630.
- **CPU:** Intel i5-7300HQ (4) @ 3.500GHz.
- **Memoria:** 16 GB.
- **Unidad 1:** SSD M.2 Nvme 220 GB.
- **Unidad 2:** HDD 1 TB 7200 RPM.
- **Audio device:** Intel Corporation CM238 HD Audio

## 🚀 Características del Script
- **Actualización:** Automatiza el refresco de repositorios y el upgrade del sistema.
- **Drivers:** Instala controladores oficiales de NVIDIA y configuraciones PRIME.
- **Tipografías:** Inyecta de forma local y offline fuentes ClearType modernas (Calibri, Aptos de Office 365) evitando enlaces caídos de internet.
- **Software:** Configura Flatpak (Flathub), Cloudflare WARP, `rsgain` y remueve bloatware (LibreOffice, Elisa).
- **Tweaks de Sistema:** Activa el *Tap-to-click* en el Touchpad y fuerza el apagado limpio mediante sesión vacía en KDE Plasma.

## 🛠️ Modo de Uso

1. Clona este repositorio o descarga el script `post-install-a.sh` y `post-install-b.sh`.
2. Coloca tu archivo comprimido `fuentes.tar.gz` (con tus fuentes `.ttf` en la raíz del comprimido) exactamente al lado del script.
3. Abre una terminal en la carpeta y otorga permisos de ejecución:
   ```bash
   chmod +x post-install-a.sh
   chmod +x post-install-b.sh
5. Ejecuta el primer script:
   ```bash
   ./post-install-a.sh
6. Reinicia el equipo
7. Ejecuta el segundo script:
   ```bash
   ./post-install-b.sh
8. Listo! Equipo configurado y optimizado!
