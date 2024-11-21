 #!/bin/bash


if ! sudo lvdisplay /dev/vg_temp/lv_docker > /dev/null 2>&1; then
    sudo lvcreate -L 2.5G -n lv_docker vg_temp
else
    echo "lv_docker ya existe"
fi



# Crear particiones en los discos (5GB, 3GB, 2GB)
echo "Creando particiones..."

# Crear partición en /dev/sdc de 5GB
sudo fdisk /dev/sdc <<EOF
n
p
1

+5G
t
8e
w
EOF

# Crear partición en /dev/sdd de 3GB
sudo fdisk /dev/sdd <<EOF
n
p
1

+3G
t
8e
w
EOF

# Crear partición en /dev/sde de 2GB
sudo fdisk /dev/sde <<EOF
n
p
1

+2G
t
8e
w
EOF

# Crear volúmenes físicos (PV) sobre las particiones creadas
echo "Creando volúmenes físicos (PV)..."
sudo pvcreate /dev/sdc1 /dev/sdd1 /dev/sde1

# Crear un grupo de volúmenes (VG) llamado vg_temp
echo "Creando grupo de volúmenes (VG) llamado vg_temp..."
sudo vgcreate vg_temp /dev/sdc1 /dev/sdd1 /dev/sde1

# Crear los volúmenes lógicos (LV)
echo "Creando volúmenes lógicos (LV)..."
sudo lvcreate -L 1G -n lv_workareas vg_temp
sudo lvcreate -L 2.5G -n lv_swap vg_temp
sudo lvcreate -L 2.5G -n lv_docker vg_temp

# Formatear y montar los volúmenes lógicos

# Formatear lv_docker con ext4 y montar en /var/lib/docker
echo "Formateando y montando lv_docker en /var/lib/docker..."
sudo mkfs.ext4 /dev/vg_temp/lv_docker
sudo mkdir -p /var/lib/docker
sudo mount /dev/vg_temp/lv_docker /var/lib/docker

# Formatear lv_workareas con ext4 y montar en /work
echo "Formateando y montando lv_workareas en /work..."
sudo mkfs.ext4 /dev/vg_temp/lv_workareas
sudo mkdir -p /work
sudo mount /dev/vg_temp/lv_workareas /work

# Configurar lv_swap como swap
echo "Configurando lv_swap como swap..."
sudo mkswap /dev/vg_temp/lv_swap
sudo swapon /dev/vg_temp/lv_swap

# Agregar las configuraciones al archivo /etc/fstab para montajes automáticos
echo "Agregando configuraciones a /etc/fstab..."

# Agregar lv_docker a fstab
echo "/dev/vg_temp/lv_docker /var/lib/docker ext4 defaults 0 2" | sudo tee -a /etc/fstab

# Agregar lv_workareas a fstab
echo "/dev/vg_temp/lv_workareas /work ext4 defaults 0 2" | sudo tee -a /etc/fstab

# Agregar lv_swap a fstab para swap
echo "/dev/vg_temp/lv_swap none swap sw 0 0" | sudo tee -a /etc/fstab

# Verificar la creación de los volúmenes y su montaje
echo "Verificando la configuración..."
sudo lvdisplay
sudo vgdisplay
df -h

echo "Configuración completada."

