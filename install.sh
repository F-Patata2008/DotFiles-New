#!/bin/bash

# ====================================================================
# SCRIPT DE INSTALACIÓN DE DOTFILES PARA ARCH LINUX
#
# Este script se encarga de instalar todas las dependencias necesarias
# (pacman y yay), configurar temas y repositorios personales, y luego
# utiliza GNU Stow para crear enlaces simbólicos de tus archivos.
# ====================================================================

# --------------------------------------------------------------------
# FASE 1: INSTALACIÓN DE DEPENDENCIAS DEL SISTEMA (PACMAN)
# --------------------------------------------------------------------

echo "--------------------------------------------------------"
echo "FASE 1: Instalando dependencias del sistema (pacman)..."
echo "--------------------------------------------------------"
echo ""

# Lista de paquetes que se instalarán con pacman.
# Se usa --needed para no reinstalar paquetes que ya existen.
PACMAN_PACKAGES="
    hyprland
    swaync
    swayosd
    hyprland-polkit-agent
    zathura
    zathura-pdf-mupdf
    ufw
    brightnessctl
    stow
    power-profiles-daemon
    plymouth
    texlive
    texlive-langenglish
    texlive-langspanish
    git
    python-pip
    opencv
    strace
    rofi
    swayidle
    kitty
    neovim
    gnome-calendar
    gnome-calculator
    kdeconnect
    discord
    bluez
    bluez-utils
    eog
    evince
    nautilus
    gimp
    spotify
    steam
    autojump
    usbutils
    tree-sitter
    tree-sitter-cli
    nodejs
    npm
    i3
    i3lock
    i3status
    xorg-xinit
    xorg
    gnome-system-monitor
    hyprshot
    fprintd
    biber
    nerd-fonts-jetbrains-mono
    gcc
    g++
    zsh
"

echo "Instalando paquetes de pacman..."
sudo pacman -Syu --needed $PACMAN_PACKAGES

# --------------------------------------------------------------------
# FASE 2: INSTALACIÓN DE DEPENDENCIAS DEL AUR (YAY)
# --------------------------------------------------------------------

echo ""
echo "--------------------------------------------------------"
echo "FASE 2: Instalando dependencias del AUR (yay)..."
echo "--------------------------------------------------------"
echo ""

# Se añade 'yay' como gestor de paquetes de AUR para herramientas específicas.
# Este paso es manual porque 'yay' no está en los repositorios de Arch.
if ! command -v yay &> /dev/null
then
    echo "Para continuar, se necesita instalar yay. Sigue las instrucciones."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
else
    echo "Yay ya está instalado. Continuando..."
fi

# Lista de paquetes del AUR.
AUR_PACKAGES="
    clipse-git
    swaync-git
    modrinth-app-bin
    libfprint-goodixtls-55x4
"

if [ -n "$AUR_PACKAGES" ]; then
    echo ""
    echo "Instalando paquetes del AUR con yay..."
    yay -S --needed $AUR_PACKAGES
else
    echo ""
    echo "No hay paquetes del AUR para instalar. Omitiendo este paso."
fi

# --------------------------------------------------------------------
# FASE 3: ACTUALIZAR SUBMÓDULOS DE GIT
# --------------------------------------------------------------------

echo ""
echo "--------------------------------------------------------"
echo "FASE 3: Actualizando submódulos de Git (oh-my-zsh)..."
echo "--------------------------------------------------------"
echo ""

# Este comando se debe ejecutar desde la raíz del repositorio de dotfiles
git submodule update --init --recursive
echo "  ✔️ Submódulos de Git actualizados."

# --------------------------------------------------------------------
# FASE 4: INSTALACIÓN DE POWERLEVEL10K (Siguiendo la instalación oficial)
# --------------------------------------------------------------------

echo ""
echo "--------------------------------------------------------"
echo "FASE 4: Instalando el tema Powerlevel10k para Oh My Zsh..."
echo "--------------------------------------------------------"
echo ""

# Crear el directorio para los temas personalizados si no existe
P10K_DIR="ohmyzsh/.oh-my-zsh/custom/themes"
mkdir -p "$P10K_DIR"

# Clonar el repositorio de Powerlevel10k en el directorio de temas de Oh My Zsh
# Se utiliza 'cd' para moverse al directorio de P10K antes de clonar
if [ -d "$P10K_DIR/powerlevel10k" ]; then
    echo "  -> El repositorio de Powerlevel10k ya existe. No se clonará de nuevo."
else
    echo "  ➡️ Clonando repositorio de Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR/powerlevel10k"
    echo "  ✔️ Powerlevel10k instalado correctamente."
fi

# --------------------------------------------------------------------
# FASE 5: INSTALACIÓN DE TEMAS ADICIONALES
# --------------------------------------------------------------------

echo ""
echo "--------------------------------------------------------"
echo "FASE 5: Instalando temas adicionales (Plymouth y GRUB)"
echo "--------------------------------------------------------"
echo ""

# Instalar tema de Plymouth
echo "-> Instalando tema de Plymouth: Minecraft-Theme"
git clone https://github.com/nikp123/minecraft-plymouth-theme.git
cd minecraft-plymouth-theme
sudo ./install.sh
cd ..
rm -rf minecraft-plymouth-theme
echo "  ✔️ Tema de Plymouth instalado. Por favor, ejecuta 'sudo plymouth-set-default-theme -R minecraft-theme' para activarlo."
echo ""

# Instalar tema de GRUB
echo "-> Instalando tema de GRUB: Minegrub-Theme"
git clone https://github.com/Lxtharia/minegrub-theme.git
cd minegrub-theme
sudo ./install.sh
cd ..
rm -rf minegrub-theme
echo "  ✔️ Tema de GRUB instalado. Por favor, revisa /etc/default/grub y ejecuta 'sudo grub-mkconfig -o /boot/grub/grub.cfg' si es necesario."
echo ""

# --------------------------------------------------------------------
# FASE 6: INSTALACIÓN DEL FIRMWARE PARA LECTOR DE HUELLAS GOODIX
# --------------------------------------------------------------------

echo ""
echo "--------------------------------------------------------"
echo "FASE 6: Instalando firmware para lector de huellas Goodix"
echo "--------------------------------------------------------"
echo ""

# El script requiere Python 3.10 o superior.
PYTHON_VERSION=$(python3 --version 2>/dev/null | awk '{print $2}')
if [[ -z "$PYTHON_VERSION" || "$(echo -e "3.10\n$PYTHON_VERSION" | sort -V | head -n1)" != "3.10" ]]; then
    echo "  ❌ ERROR: Se requiere Python 3.10 o superior. La versión detectada es: $PYTHON_VERSION"
    echo "     Por favor, actualiza tu versión de Python y vuelve a ejecutar el script."
    exit 1
fi

echo "  ✔️ Versión de Python (>= 3.10) detectada: $PYTHON_VERSION"

# Clonar el repositorio y configurar el entorno virtual
git clone --recurse-submodules https://github.com/goodix-fp-linux-dev/goodix-fp-dump.git
cd goodix-fp-dump
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Obtener la ID del dispositivo del usuario
echo ""
echo "  ❗ ATENCIÓN: Necesitamos la ID de tu lector de huellas."
echo "     A continuación, se listará la información de tu dispositivo."
echo "     Por favor, busca la línea que dice 'idProduct' y anota el valor."
echo "     Ejemplo: 'idProduct            0x55b4'"
echo ""
sudo lsusb -vd "27c6:" | grep "idProduct"

read -p "Ingresa el ID de tu dispositivo (ej: 55b4): " DEVICE_ID

# Ejecutar el script para instalar el firmware
echo ""
echo "  ➡️ Ejecutando script para instalar el firmware (ingresa tu contraseña si se solicita)..."
sudo python3 run_5110.py --id $DEVICE_ID

# Limpiar el directorio temporal
echo ""
echo "  ✔️ Instalación del firmware completada."
deactivate
cd ..
rm -rf goodix-fp-dump

# --------------------------------------------------------------------
# FASE 7: CLONANDO REPOSITORIOS PERSONALES
# --------------------------------------------------------------------

echo ""
echo "--------------------------------------------------------"
echo "FASE 7: Clonando repositorios personales"
echo "--------------------------------------------------------"
echo ""

git clone https://github.com/F-Patata2008/Apunte.git ~/Apunte
git clone https://github.com/F-Patata2008/Arduino-Codes.git ~/Arduino-Codes
git clone https://github.com/F-Patata2008/Progra.git ~/Progra
echo "  ✔️ Repositorios clonados correctamente en tu directorio personal."

# --------------------------------------------------------------------
# FASE 8: APLICANDO DOTFILES CON GNU STOW Y CONFIGURANDO PERMISOS
# --------------------------------------------------------------------

echo ""
echo "--------------------------------------------------------"
echo "FASE 8: Aplicando dotfiles con GNU Stow y configurando permisos"
echo "--------------------------------------------------------"
echo ""

# Lista de todos los paquetes de Stow
PACKAGES="fastfetch hypr kitty nvim ohmyzsh rofi swaylock swaync wal waybar zsh i3"

# Función para stowing seguro
safe_stow() {
    package=$1
    echo "Procesando paquete: $package"
    stow "$package"
    if [ $? -eq 0 ]; then
        echo "  ✔️ Paquete '$package' stowed correctamente."
    else
        echo "  ❌ Error al stowing '$package'. Puede que haya conflictos."
        echo "     Por favor, revisa manualmente el directorio de destino y elimina/mueve archivos conflictivos."
        echo "     Ejemplo: mv ~/.config/$package ~/.config/$package.bak"
        echo "     O usa 'stow --adopt $package' con precaución si sabes lo que haces."
        exit 1
    fi
}

# Iterar sobre cada paquete y aplicar stow
for p in $PACKAGES; do
    safe_stow "$p"
done

# Configurar permisos para el usuario actual
echo ""
echo "-> Añadiendo el usuario actual al grupo 'input' para permisos de hardware..."
sudo usermod -aG input $(whoami)
echo "  ✔️ Usuario añadido al grupo 'input'."

# --------------------------------------------------------------------
# FASE 9: CONFIGURACIÓN DE ZSH COMO SHELL PREDETERMINADA
# --------------------------------------------------------------------

echo ""
echo "--------------------------------------------------------"
echo "FASE 9: Configurando Zsh como shell predeterminada"
echo "--------------------------------------------------------"
echo ""

# Verificar si el shell actual es Zsh
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "-> El shell actual no es Zsh. Cambiando a Zsh..."
    # Se utiliza 'chsh' para cambiar el shell del usuario actual
    chsh -s /bin/zsh
    echo "  ✔️ Shell cambiada a Zsh. Deberás cerrar sesión y volver a entrar para que el cambio surta efecto."
else
    echo "  ✔️ El shell predeterminado ya es Zsh. No se necesita hacer cambios."
fi

# --------------------------------------------------------------------
# FASE 10: PASOS POST-INSTALACIÓN
# --------------------------------------------------------------------

echo ""
echo "--------------------------------------------------------"
echo "FASE 10: Pasos de configuración post-instalación"
echo "--------------------------------------------------------"
echo ""

# Preguntar si el usuario quiere ejecutar los comandos
read -p "¿Quieres ejecutar 'wal -R' para aplicar los colores del fondo de pantalla? (y/n): " wal_choice
if [[ "$wal_choice" =~ ^[Yy]$ ]]; then
    wal -R
    echo "  ✔️ Colores de Pywal aplicados."
else
    echo "  -> Omitiendo 'wal -R'."
fi

echo ""
echo "--------------------------------------------------------"
echo "¡Instalación de dotfiles completada!"
echo "--------------------------------------------------------"
echo ""
echo "Pasos adicionales importantes:"
echo "1. **Reinicia tu sistema o cierra sesión** para que los cambios de los grupos y el entorno surtan efecto, y para que Zsh sea tu shell predeterminada."
echo "2. Para configurar tu `prompt`, abre una nueva terminal Zsh y ejecuta 'p10k configure'."
echo "3. Ejecuta 'sudo plymouth-set-default-theme -R minecraft-theme' para activar el tema de Plymouth."
echo "4. Revisa /etc/default/grub y ejecuta 'sudo grub-mkconfig -o /boot/grub/grub.cfg' si es necesario."
echo ""
echo "¡Disfruta tu nuevo entorno!"

