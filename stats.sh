#!/bin/bash

Uso(){
	echo "Uso: ./stats.sh  -d <directorio datos> [-h]"
	echo "-d: directorio donde están los datos a procesar."
	exit 1
}

if [ $# != 1 ]; then
	Uso
fi

while getopts "d:h" opcion; do
	case "$opcion" in
		d)
			dataIn=$OPTARG
			;;
		h)
			Uso
			;;
		*)
			Uso
			;;
	esac
done

busquedaDir = $1

if [ ! -e $busquedaDir ]; then
        echo "Directorio $1 no existe"
        exit
fi


