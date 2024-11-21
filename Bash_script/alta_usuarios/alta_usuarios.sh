#!/bin/bash
clear

###############################
#
# Parametros:
#  - Lista de Usuarios a crear
#  - Usuario del cual se obtendra la clave
#
#  Tareas:
#  - Crear los usuarios segun la lista recibida en los grupos descriptos
#  - Los usuarios deberan de tener la misma clave que la del usuario pasado por parametro
#
###############################


LISTA=$1
USER_GET_HASH=$2
HASH=$(sudo grep $USER_GET_HASH /etc/shadow | awk -F ":" '{print $2}')
ANT_IFS=$IFS
IFS=$'\n'
for LINEA in `cat $LISTA | grep -v ^#`
do
    USUARIO=$(echo $LINEA | awk -F ',' '{print $1}')
    GRUPO=$(echo $LINEA | awk -F ',' '{print $2}')
    PATH_HOME=$(echo $LINEA | awk -F ',' '{print $3}')
    sudo groupadd $GRUPO
    sudo useradd -m -s /bin/bash -d $PATH_HOME -g $GRUPO $USUARIO
done
IFS=$ANT_IFS
