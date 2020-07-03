# TSSOO- Taller 01

Cristian Valencia Avila - cristian.valenciaa@alumnos.uv.cl


# 1. Introducción 
En el desarrollo del siguiente taller, se busca comprender la extracción de datos de una simulación de un presunto tsunami, con los cuales se pide realizar cálculos estadísticos  con la información presentada en las respectivas simulaciones. Estos cálculos pedidos se desarrollaran a través de un Script, siendo almacenados en sus respectivos archivos de texto.

# 2. Diseño de la Solución

El taller posee tres tareas específicamente, las cuales poseen ciertos tipos de datos dependiendo de la tarea. Para realizar lo pedido, se utilizará un script que entrega un archivo por cada tarea solicitada, con la información correspondiente. 
Como solución se presenta el siguiente modelado, el cual corresponde a una vista general del problema.

![Diagrama solución](http://imgfz.com/i/ewBi4Z0.png)


El script al ser ejecutado, busca los archivos de cada simulación realizada en el directorio correspondiente, donde ejecutará cada tarea recopilando la información solicitada, para luego hacer los cálculos pedidos y posteriormente guardarlos en  los archivos executionSummary.txt, Summary.txt y usePhone.txt, respectivamente.

### 2.1 Tarea 1 

En primer lugar se busca los archivos con el nombre de executionSummary-NNN.txt, para esto se utiliza el comando `find` , el cual buscará los archivos en el directorio ingresado, para esto se utiliza la siguiente linea de comando:

`exSummaryFile=(find $searchDir -name 'executionSummary-*.txt' -print | sort)`

Luego de encontrar los archivos requeridos, se procede a realizar el calculo del tiempo de la simulación y de la memoria utilizada, para esto se utilizo el un bucle para recorrer los datos captados por `exSummaryFile[*]` , donde los valores obtenidos se guardaran en unas variables temporales, para luego proceder a calcular los datos almacenados en dichas variables, para el tiempo total de la simulación se utiliza la siguiente sección de código:
```
tSimTotal=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumaTiempoTotal=0}{sumaTiempoTotal=$6+$7+$8;} END{print sumaTiempoTotal}')

printf "$tSimTotal \n" >> $tmpFile1

metricsTSim=$(cat $tmpFile1 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpFile1<min){min=$tmpFile1}; \

if($tmpFile1>max){max=$tmpFile1};\

total+=$tmpFile1; count+=1;\

} \

END { print total, total/count, min, max }')
```

Igualmente para la parte de la memoria utilizada con sus respectivas variables.

### 2.2 Tarea 2

En esta tarea se utilizarán los archivos Summary.txt, y al igual que en la tarea 1 se realizara una creación de archivos temporales en los cuales se guardaran los datos a utilizar para sus respectivos cálculos,  por lo que el bucle recorrerá el contenido de los archivos simulados. Donde los se realizo el mismo procedimiento para cada tipo de persona, calculando su promedio, mínimo y máximo, como por ejemplo la siguiente sección que realiza la parte de residentes:
```
tiempoEvacResidents=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotalR=0}{if($3==0)sumaTotalR+=$8} END{print sumaTotalR}')

printf "$tiempoEvacResidents \n" >> $tmpEvFile2

Residents=$(cat $tmpEvFile2 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile2<min){min=$tmpEvFile2};\

if($tmpEvFile2>max){max=$tmpEvFile2};\

total+=$tmpEvFile2; count+=1;\

}\

END {print total, total/count, min, max} ')
```
La variable `tiempoEvacResidents` es donde se asignara el contenido de los archivos del `Summary.txt` , para llevar a cabo los cálculos correspondientes.
Para cada tipo de persona el procedimiento es prácticamente el mismo, con la diferencia de las variables tomadas para ser procesadas.
