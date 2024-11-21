#!/bin/bash

# Variables
DISK1="/dev/sdc"
DISK2="/dev/sdd"
DISK3="/dev/sde"

# Función para verificar si el disco tiene partición
check_partition() {
    PARTITION=$1
    if [ ! -b "$PARTITION" ]; then
        echo "Error: $PARTITION no existe."
        exit 1
    fi
}

# Función para verificar si la partición está montada
check_if_mounted() {
    MOUNTPOINT=$(mount | grep "$1")
    if [ ! -z "$MOUNTPOINT" ]; then
        echo "Error: $1 está montada, se debe desmontar antes de continuar."
        exit 1
    fi
}

# Verificar si las particiones existen y no están montadas
echo "Verificando particiones..."

# Verificar /dev/sdc1
check_partition "${DISK1}1"
check_if_mounted "${DISK1}1"

# Verificar /dev/sdd1
check_partition "${DISK2}1"
check_if_mounted "${DISK2}1"

# Verificar /dev/sde1
check_partition "${DISK3}1"
check_if_mounted "${DISK3}1"

# Recargar la tabla de particiones
echo "Recargando tabla de particiones..."
sudo partprobe

# Crear los volúmenes físicos (PV)
echo "Creando volúmenes físicos (PV)..."
sudo pvcreate "${DISK1}1"
sudo pvcreate "${DISK2}1"
sudo pvcreate "${DISK3}1"

# Crear grupo de volúmenes (VG)
echo "Creando grupo de volúmenes (VG)..."
sudo vgcreate vg_datos "${DISK1}1" "${DISK2}1" "${DISK3}1"

# Crear volúmenes lógicos (LV)
echo "Creando volúmenes lógicos (LV)..."
sudo lvcreate -L 512M -n lv_docker vg_datos
sudo lvcreate -L 1G -n lv_workareas vg_datos
sudo lvcreate -L 2.5G -n lv_swap vg_datos

# Formatear y montar volúmenes lógicos
echo "Formateando y montando volúmenes lógicos..."

# Formatear lv_docker
sudo mkfs.ext4 /dev/vg_datos/lv_docker
# Montar lv_docker
sudo mount /dev/vg_datos/lv_docker /var/lib/docker

# Formatear lv_workareas
sudo mkfs.ext4 /dev/vg_datos/lv_workareas
# Montar lv_workareas
sudo mount /dev/vg_datos/lv_workareas /work

# Configurar lv_swap como swap
sudo mkswap /dev/vg_datos/lv_swap
sudo swapon /dev/vg_datos/lv_swap

# Añadir a /etc/fstab para montajes automáticos
echo "/dev/vg_datos/lv_docker /var/lib/docker ext4 defaults 0 2" | sudo tee -a /etc/fstab
echo "/dev/vg_datos/lv_workareas /work ext4 defaults 0 2" | sudo tee -a /etc/fstab
echo "/dev/vg_datos/lv_swap none swap sw 0 0" | sudo tee -a /etc/fstab

# Verificación final
echo "Verificando la configuración LVM..."
sudo lvdisplay
sudo vgdisplay
sudo pvdisplay

echo "Configuración LVM completada correctamente."

