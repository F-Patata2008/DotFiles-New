### **1. Preinstalación**

**1.1. Descargar la ISO de Arch Linux**
Ve a la [página oficial de descargas de Arch Linux](https://archlinux.org/download/) y obtén la imagen ISO más reciente.

**1.2. Crear un USB Booteable**
Usa una herramienta como [Rufus](https://rufus.ie/) o [balenaEtcher](https://www.balena.io/etcher/) para "flashear" el archivo ISO en una unidad USB.

**1.3. Arrancar en el Entorno Live**
Conecta el USB en tu computadora y arráncala. Puede que necesites presionar una tecla especial (como F2, F12, DEL) durante el inicio para entrar en la configuración de la BIOS/UEFI y seleccionar el USB como dispositivo de arranque. En el menú de Arch Linux, elige la primera opción.

**1.4. Establecer la Distribución del Teclado**
Por defecto, el teclado está en inglés (US). Para cambiarlo al layout latinoamericano especificado, ejecuta:
`loadkeys la-latin1`

**1.5. Verificar el Modo de Arranque**
Esta guía es para el modo UEFI. Confirma que has arrancado en este modo con el siguiente comando. Si aparece una lista de archivos, estás en modo UEFI.
`ls /sys/firmware/efi/efivars`

**1.6. Conectarse a Internet**
*   **Ethernet (cable):** Debería funcionar automáticamente.
*   **Wi-Fi:** Usa la herramienta `iwctl`.
    1.  Inicia la consola interactiva: `iwctl`
    2.  Lista tus dispositivos: `device list`
    3.  Escanea redes (reemplaza `<dispositivo>`): `station <dispositivo> scan`
    4.  Lista las redes encontradas: `station <dispositivo> get-networks`
    5.  Conéctate a tu red (reemplaza `<SSID>`): `station <dispositivo> connect "<SSID>"`
    6.  Ingresa tu contraseña cuando te lo pida y luego sal con `exit`.

**1.7. Actualizar el Reloj del Sistema**
Sincroniza el reloj para evitar problemas con la verificación de paquetes.
`timedatectl set-ntp true`

### **2. Particionado del Disco con `cfdisk`**

Crearemos solo dos particiones: una para el arranque EFI y otra grande que contendrá toda nuestra configuración LVM.

**2.1. Identificar el Disco**
Usa `lsblk` para ver el nombre del disco en el que vas a instalar el sistema (ej. `/dev/sda`, `/dev/nvme0n1`).

**2.2. Particionar el Disco**
Inicia `cfdisk` en tu disco de destino.
`cfdisk /dev/sdX`

Se te pedirá que elijas un tipo de etiqueta (label type). Selecciona **gpt**.

Usa las flechas del teclado y la tecla `Enter` para navegar en la interfaz de `cfdisk`.

1.  **Crear la Partición del Sistema EFI:**
    *   Selecciona `[ New ]` (Nuevo).
    *   Ingresa un tamaño de partición de `512M` y presiona `Enter`.
    *   Selecciona `[ Type ]` (Tipo) y elige `EFI System`.

2.  **Crear la Partición LVM:**
    *   Muévete al espacio libre restante.
    *   Selecciona `[ New ]`.
    *   Presiona `Enter` para aceptar el tamaño por defecto (usará todo el espacio restante).
    *   Selecciona `[ Type ]` y elige `Linux LVM`.

3.  **Escribir Cambios y Salir:**
    *   Revisa que tu esquema de particiones sea correcto (una partición EFI de 512M y una LVM grande).
    *   Selecciona `[ Write ]` (Escribir). Escribe `yes` para confirmar.
    *   Selecciona `[ Quit ]` (Salir).

### **3. Configuración de LVM**

Ahora crearemos nuestros volúmenes lógicos (equivalentes a particiones flexibles) dentro del contenedor LVM que acabamos de crear (ej. `/dev/sdX2`).

1.  **Crear Volumen Físico (PV):** `pvcreate /dev/sdX2`
2.  **Crear Grupo de Volúmenes (VG):** `vgcreate ArchVG /dev/sdX2`
3.  **Crear Volúmenes Lógicos (LV):**
    *   **Volumen Swap (Intercambio):** `lvcreate -L 16G ArchVG -n swap`
    *   **Volumen para Backups:** `lvcreate -L 100G ArchVG -n backup`
    *   **Volumen Raíz (root):** `lvcreate -L 50G ArchVG -n root`
    *   **Volumen Home (personal):** `lvcreate -l 100%FREE ArchVG -n home` (usa todo el espacio restante).

### **4. Formateo y Montaje**

**4.1. Formatear los Sistemas de Archivos**
*   **Partición EFI** (ej. `/dev/sdX1`): `mkfs.fat -F32 /dev/sdX1`
*   **Volumen Raíz:** `mkfs.ext4 /dev/ArchVG/root`
*   **Volumen Home:** `mkfs.ext4 /dev/ArchVG/home`
*   **Volumen de Backup:** `mkfs.ext4 /dev/ArchVG/backup`
*   **Inicializar Swap:** `mkswap /dev/ArchVG/swap`

**4.2. Montar los Sistemas de Archivos**
*   **Montar Raíz:** `mount /dev/ArchVG/root /mnt`
*   **Crear y Montar Boot:** `mkdir -p /mnt/boot` y luego `mount /dev/sdX1 /mnt/boot`
*   **Crear y Montar Home:** `mkdir -p /mnt/home` y luego `mount /dev/ArchVG/home /mnt/home`
*   **Activar Swap:** `swapon /dev/ArchVG/swap`
    *(Nota: No montamos el volumen de backup ahora, Timeshift se encargará de ello más tarde).*

### **5. Instalación del Sistema Base**

**5.1. Instalar Paquetes Esenciales con `pacstrap`**
Este comando instala el sistema base, el kernel, firmware, herramientas LVM, Neovim, git y el gestor de redes en tu nuevo sistema.
`pacstrap /mnt base linux linux-firmware lvm2 neovim git networkmanager`

**5.2. Generar el `fstab`**
Este archivo le dice al sistema cómo montar sus particiones al arrancar.
`genfstab -U /mnt >> /mnt/etc/fstab`

### **6. Configuración del Sistema (dentro del Chroot)**

**6.1. Entrar al Chroot**
Ahora "entramos" en nuestro nuevo sistema para configurarlo desde adentro.
`arch-chroot /mnt`

**6.2. Establecer la Zona Horaria**
Configura la zona horaria para Santiago de Chile.
`ln -sf /usr/share/zoneinfo/America/Santiago /etc/localtime`
`hwclock --systohc`

**6.3. Configurar Idioma y Teclado**
1.  Abre `/etc/locale.gen` con un editor (`nvim` o `nano`) y descomenta las líneas `en_US.UTF-8 UTF-8` y `es_CL.UTF-8 UTF-8`.
2.  Genera los locales ejecutando: `locale-gen`
3.  Establece el idioma del sistema: `echo "LANG=en_US.UTF-8" > /etc/locale.conf`
4.  Establece el mapa de teclado de forma permanente: `echo "KEYMAP=la-latin1" > /etc/vconsole.conf`

**6.4. Configurar la Red**
*   Dale un nombre a tu equipo: `echo "arch-hypr" > /etc/hostname`
*   Habilita el servicio de red para que inicie con el sistema: `systemctl enable NetworkManager`

**6.5. Establecer Contraseña de Root**
Define una contraseña segura para el superusuario.
`passwd`

**6.6. Crear una Cuenta de Usuario**
Reemplaza `tu_usuario` con el nombre que prefieras.
`useradd -m -G wheel tu_usuario`
`passwd tu_usuario`
Ahora, concede permisos de administrador a tu usuario ejecutando `visudo` y descomentando la línea: `%wheel ALL=(ALL:ALL) ALL`.

**6.7. Configurar el Initramfs para LVM (Paso Crítico)**
Esto permite que el sistema detecte tus volúmenes LVM durante el arranque.
1.  Abre el archivo de configuración: `nvim /etc/mkinitcpio.conf`
2.  En la línea `HOOKS=(...)`, añade `lvm2` entre `block` y `filesystems`. El orden es importante.
    `HOOKS=(base udev autodetect modconf block lvm2 filesystems keyboard fsck)`
3.  Guarda el archivo y regenera la imagen de arranque: `mkinitcpio -P`

**6.8. Instalar y Configurar el Gestor de Arranque (GRUB)**
1.  Instala los paquetes: `pacman -S grub efibootmgr`
2.  Instala GRUB en la partición EFI: `grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH`
3.  Genera el archivo de configuración de GRUB: `grub-mkconfig -o /boot/grub/grub.cfg`

### **7. Instalación del Entorno Gráfico y Hyprland**

**7.1. Instalar Controladores Gráficos**
*   **Intel:** `pacman -S vulkan-intel`
*   **AMD/ATI:** `pacman -S vulkan-radeon`
*   **NVIDIA:** `pacman -S nvidia nvidia-utils`

**7.2. Instalar Hyprland, GDM y Utilidades**
`pacman -S gdm hyprland kitty waybar wofi ttf-font-awesome`

**7.3. Habilitar GDM (Gestor de Inicio de Sesión Gráfico)**
`systemctl enable gdm`

### **8. Finalización y Reinicio**

**8.1. Salir del Chroot y Desmontar**
*   Sal del entorno chroot: `exit`
*   Desmonta las particiones de forma segura: `umount -R /mnt`
*   Reinicia el sistema: `reboot`

**8.2. Primer Arranque**
Retira el USB de instalación. Tu PC debería arrancar y mostrar la pantalla de inicio de sesión de GDM. Antes de ingresar tu contraseña, haz clic en el ícono de engranaje (usualmente en una esquina) y selecciona la sesión "Hyprland".

### **9. Post-instalación: Configurar Timeshift**

**9.1. Instalar Timeshift**
Abre una terminal (como Kitty) e instala Timeshift.
`sudo pacman -S timeshift`

**9.2. Configurar Timeshift**
1.  Inicia el asistente de configuración: `sudo timeshift-launcher`
2.  **Tipo de Instantánea:** Selecciona **RSYNC** y haz clic en Siguiente.
3.  **Ubicación de la Instantánea:** Timeshift escaneará los volúmenes. Selecciona tu volumen LVM de 100GB para backups (se identificará como `/dev/mapper/ArchVG-backup` o similar).
4.  **Niveles de Instantáneas:** Configura un horario para las copias de seguridad automáticas si lo deseas.
5.  Haz clic en **Finalizar**.

¡Listo! Ya tienes un sistema Arch Linux completamente funcional, modular con LVM, y configurado exactamente como lo pediste.
