#!/bin/bash

# Actualizar los paquetes
sudo apt update -y

# Instalar Docker si no está instalado
if ! command -v docker &> /dev/null; then
    echo "Instalando Docker..."
    sudo apt install -y docker
fi

# Iniciar Docker si no está en ejecución
sudo systemctl enable --now docker

# Comprobar el estado de Docker
sudo systemctl status docker

# Ejecutar un contenedor de ejemplo
docker run -d -p 80:80 kennethreitz/httpbin

# Instalar Docker Compose si no está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "Instalando Docker Compose..."
    sudo apt install -y docker-compose
fi

# Dentro de la carpeta del proyecto, ejecutar docker-compose
if [ -d "docker" ]; then
    cd docker
    sudo docker-compose up -d
else
    echo "Directorio 'docker' no encontrado."
fi

# Crear el grupo 'docker' si no existe y añadir al usuario actual
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi
sudo usermod -a -G docker $(whoami)

# Construir la imagen personalizada
docker build -t tp-div_314_grupo_dinamita .

#------------subir al doker hub
#docker login
#
#docker tag tp-div_314_grupo_dinamita handresnaza/tp-div_314_grupo_dinamita
#docker push handresnaza/tp-div_314_grupo_dinamita
