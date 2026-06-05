#!/bin/bash
echo "Instalando aplicaciones Flatpak..."
flatpak install flathub org.freac.freac -y
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub org.kde.haruna -y
flatpak install flathub org.gtk.Gtk3theme.Breeze-Dark//3.22 -y
echo "¡Aplicaciones instaladas con éxito!"
