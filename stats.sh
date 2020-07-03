#!/bin/bash



Uso(){
	echo "Uso: ./stats.sh  -d <directorio datos> [-h]"
	echo "-d: directorio donde están los datos a procesar."
	exit
}

while getopts "d:h" opcion; do
	case ${opcion} in
		d)
			searchDir=$OPTARG
			;;
		h)
			Uso
			;;
		*)
			Uso
			;;
	esac
done

shift $((OPTIND -1))

if [ -z $searchDir ]; then
	Uso
fi

if [ ! -d $searchDir ]; then
	echo "$searchDir no es un directorio"
	exit
fi


#
#Parte 1
#Promedio del tiempo de simulación y memoria utilizada por el simulador
#
#	Salida: archivo metrics.txt, la cual tiene la siguiente
#		estructura.
#		tsimTotal:promedio:min:max
#		memUsed:promedio:min:max
#



	exSummaryFile=(`find $searchDir -name 'executionSummary-*.txt' -print | sort`)

	A_FinalP1="metrics.txt"

	tmpFile1="tSimTotal.txt"
	tmpFile2="memUt.txt"

	rm -f $A_FinalP1

	rm -f $tmpFile1
	rm -f $tmpFile2

	for i in ${exSummaryFile[*]};
	do
		tSimTotal=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumaTiempoTotal=0}{sumaTiempoTotal=$6+$7+$8;} END{print sumaTiempoTotal}')
		printf "$tSimTotal \n" >> $tmpFile1

		metricsTSim=$(cat $tmpFile1 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpFile1<min){min=$tmpFile1}; \
												if($tmpFile1>max){max=$tmpFile1};\
													total+=$tmpFile1; count+=1;\
													} \
													END { print total, total/count, min, max }')


		memUt=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumaMemoriaTotal=0}{sumaMemoriaTotal=$9;} END{print sumaMemoriaTotal}')
		printf "$memUt \n" >> $tmpFile2

		metricsMemoria=$(cat $tmpFile2 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpFile2<min){min=$tmpFile2}; \
                                                                                                if($tmpFile2>max){max=$tmpFile2};\
                                                                                                        total+=$tmpFile2; count+=1;\
                                                                                                        } \
                                                                                                        END { print total, total/count, min, max }')

	done

printf "tsimTotal:promedio:min:max\n" >> $A_FinalP1
printf "memUsed:promedio:min:max\n" >> $A_FinalP1
printf "%i : %i : %i : %i \n" $metricsTSim >> $A_FinalP1
printf "%i : %i : %i : %i \n" $metricsMemoria >> $A_FinalP1

rm -f $tmpFile1
rm -f $tmpFile2

#}


#
#PARTE 2
#
#Tiempo de evacuacion para los grupos de personas.
#
#	Salida: alls:promedio:min:max
#		residents:min:max
#		visitorsI:promedio:min:max
#		residents-G0:promedio:min:max
#		residents-G1:promedio:min:max
#		residents-G2:promedio:min:max
#		residents-G3:promedio:min:max
#		visitorsI-G0: promedio:min:max
#		visitorsI-G1: promedio:min:max
#		visitorsI-G2: promedio:min:max
#		visitorsI-G3: promedio:min:max
#



	summaryFile=(`find $searchDir -name 'summary-*.txt' -print | sort`)

	A_FinalP2="evacuation.txt"

	tmpEvFile1="tiempoEvacAll.txt"
	tmpEvFile2="tiempoEvacResidents.txt"
	tmpEvFile3="tiempoEvacVisitorsI.txt"

	tmpEvFile4="tiempoEvacResidentsG0.txt"
	tmpEvFile5="tiempoEvacResidentsG1.txt"
	tmpEvFile6="tiempoEvacResidentsG2.txt"
	tmpEvFile7="tiempoEvacResidentsG3.txt"

        tmpEvFile8="tiempoEvacVisitorsIG0.txt"
        tmpEvFile9="tiempoEvacVisitorsIG1.txt"
        tmpEvFile10="tiempoEvacVisitorsIG2.txt"
        tmpEvFile11="tiempoEvacVisitorsIG3.txt"



	rm -f $A_FinalP2
	rm -f $tmpEvFile1
	rm -f $tmpEvFile2
	rm -f $tmpEvFile3
        rm -f $tmpEvFile4
        rm -f $tmpEvFile5
        rm -f $tmpEvFile6
        rm -f $tmpEvFile7
        rm -f $tmpEvFile8
        rm -f $tmpEvFile9
        rm -f $tmpEvFile10
        rm -f $tmpEvFile11



	for i in ${summaryFile[*]};
	do
		tiempoEvacAll=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotal=0}{sumaTotal+=$8} END{print sumaTotal}')
		printf "$tiempoEvacAll \n" >> $tmpEvFile1

		All=$(cat $tmpEvFile1 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile1<min){min=$tmpEvFile1};\
                                                               if($tmpEvFile1>max){max=$tmpEvFile1};\
									total+=$tmpEvFile1; count+=1;\
                                                               		}\
                                                              		END {print total, total/count, min, max} ')

                tiempoEvacResidents=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotalR=0}{if($3==0)sumaTotalR+=$8} END{print sumaTotalR}')
                printf "$tiempoEvacResidents \n" >> $tmpEvFile2

                Residents=$(cat $tmpEvFile2 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile2<min){min=$tmpEvFile2};\
                                                               if($tmpEvFile2>max){max=$tmpEvFile2};\
                                                                        total+=$tmpEvFile2; count+=1;\
                                                                        }\
                                                                        END {print total, total/count, min, max} ')

                tiempoEvacVisitorsI=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotalVI=0}{if($3==1)sumaTotalVI+=$8} END{print sumaTotalVI}')
                printf "$tiempoEvacVisitorsI \n" >> $tmpEvFile3

                Visitors=$(cat $tmpEvFile3 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile3<min){min=$tmpEvFile3};\
                                                               if($tmpEvFile3>max){max=$tmpEvFile3};\
                                                                        total+=$tmpEvFile3; count+=1;\
                                                                        }\
                                                                        END {print total, total/count, min, max} ')

                tiempoEvacResidentsG0=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotalR0=0}{if($3==0 && $4==0)sumaTotalR0+=$8} END{print sumaTotalR0}')
                printf "$tiempoEvacResidentsG0 \n" >> $tmpEvFile4

#Grupos de residentes G0,G1,G2,G3

                ResidentsG0=$(cat $tmpEvFile4 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile4<min){min=$tmpEvFile4};\
                                                               if($tmpEvFile4>max){max=$tmpEvFile4};\
                                                                        total+=$tmpEvFile4; count+=1;\
                                                                        }\
                                                                        END {print total, total/count, min, max} ')



                tiempoEvacResidentsG1=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotalR1=0}{if($3==0 && $4==1)sumaTotalR1+=$8} END{print sumaTotalR1}')
                printf "$tiempoEvacResidentsG1 \n" >> $tmpEvFile5

                ResidentsG1=$(cat $tmpEvFile5 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile5<min){min=$tmpEvFile5};\
                                                               if($tmpEvFile5>max){max=$tmpEvFile5};\
                                                                        total+=$tmpEvFile5; count+=1;\
                                                                        }\
                                                                        END {print total, total/count, min, max} ')


                tiempoEvacResidentsG2=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotalR2=0}{if($3==0 && $4==2)sumaTotalR2+=$8} END{print sumaTotalR2}')
                printf "$tiempoEvacResidentsG2 \n" >> $tmpEvFile6

                ResidentsG2=$(cat $tmpEvFile6 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile6<min){min=$tmpEvFile6};\
                                                               if($tmpEvFile6>max){max=$tmpEvFile6};\
                                                                        total+=$tmpEvFile6; count+=1;\
                                                                        }\
                                                                        END {print total, total/count, min, max} ')


                tiempoEvacResidentsG3=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotalR3=0}{if($3==0 && $4==3)sumaTotalR3+=$8} END{print sumaTotalR3}')
                printf "$tiempoEvacResidentsG3 \n" >> $tmpEvFile7

                ResidentsG3=$(cat $tmpEvFile7 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile7<min){min=$tmpEvFile7};\
                                                               if($tmpEvFile7>max){max=$tmpEvFile7};\
                                                                        total+=$tmpEvFile7; count+=1;\
                                                                        }\
                                                                        END {print total, total/count, min, max} ')

#Grupos de VisitorsI G0,G1,G2,G3

                tiempoEvacVisitorsIG0=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotalV0=0}{if($3==1 && $4==0)sumaTotalV0+=$8} END{print sumaTotalV0}')
                printf "$tiempoEvacVisitorsIG0 \n" >> $tmpEvFile8

                VisitorsIG0=$(cat $tmpEvFile8 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile8<min){min=$tmpEvFile8};\
                                                               if($tmpEvFile8>max){max=$tmpEvFile8};\
                                                                        total+=$tmpEvFile8; count+=1;\
                                                                        }\
                                                                        END {print total, total/count, min, max} ')

                tiempoEvacVisitorsIG1=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotalV1=0}{if($3==1 && $4==1)sumaTotalV1+=$8} END{print sumaTotalV1}')
                printf "$tiempoEvacVisitorsIG1 \n" >> $tmpEvFile9

                VisitorsIG1=$(cat $tmpEvFile9 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile9<min){min=$tmpEvFile9};\
                                                               if($tmpEvFile9>max){max=$tmpEvFile9};\
                                                                        total+=$tmpEvFile9; count+=1;\
                                                                        }\
                                                                        END {print total, total/count, min, max} ')
                tiempoEvacVisitorsIG2=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotalV2=0}{if($3==1 && $4==2)sumaTotalV2+=$8} END{print sumaTotalV2}')
                printf "$tiempoEvacVisitorsIG2 \n" >> $tmpEvFile10

                VisitorsIG2=$(cat $tmpEvFile10 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile10<min){min=$tmpEvFile10};\
                                                               if($tmpEvFile10>max){max=$tmpEvFile10};\
                                                                        total+=$tmpEvFile10; count+=1;\
                                                                        }\
                                                                        END {print total, total/count, min, max} ')
                tiempoEvacVisitorsIG3=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN {sumaTotalV3=0}{if($3==1 && $4==3)sumaTotalV3+=$8} END{print sumaTotalV3}')
                printf "$tiempoEvacVisitorsIG3 \n" >> $tmpEvFile11

                VisitorsIG3=$(cat $tmpEvFile11 | awk 'BEGIN{ min=2**63-1; max=0}{ if($tmpEvFile11<min){min=$tmpEvFile11};\
                                                               if($tmpEvFile11>max){max=$tmpEvFile11};\
                                                                        total+=$tmpEvFile11; count+=1;\
                                                                        }\
                                                                        END {print total, total/count, min, max} ')


	done


printf "alls:promedio:min:max\n" >> $A_FinalP2
printf "residents:promedio:min:max\n" >> $A_FinalP2
printf "visitorsI:promedio:min:max\n" >> $A_FinalP2

printf "residents-G0:promedio:min:max\n" >> $A_FinalP2
printf "residents-G1:promedio:min:max\n" >> $A_FinalP2
printf "residents-G2:promedio:min:max\n" >> $A_FinalP2
printf "residents-G3:promedio:min:max\n" >> $A_FinalP2

printf "visitorsI-G0:promedio:min:max\n" >> $A_FinalP2
printf "visitorsI-G1:promedio:min:max\n" >> $A_FinalP2
printf "VisitorsI-G2:promedio:min:max\n" >> $A_FinalP2
printf "visitorsI-G3:promedio:min:max\n" >> $A_FinalP2



printf "%i : %.2f : %i : %i\n" $All >> $A_FinalP2
printf "%i : %.2f : %i : %i\n" $Residents >> $A_FinalP2
printf "%i : %.2f : %i : %i\n" $Visitors >> $A_FinalP2

printf "%i : %.2f : %i : %i\n" $ResidentsG0 >> $A_FinalP2
printf "%i : %.2f : %i : %i\n" $ResidentsG1 >> $A_FinalP2
printf "%i : %.2f : %i : %i\n" $ResidentsG2 >> $A_FinalP2
printf "%i : %.2f : %i : %i\n" $ResidentsG3 >> $A_FinalP2

printf "%i : %.2f : %i : %i\n" $VisitorsIG0 >> $A_FinalP2
printf "%i : %.2f : %i : %i\n" $VisitorsIG1 >> $A_FinalP2
printf "%i : %.2f : %i : %i\n" $VisitorsIG2 >> $A_FinalP2
printf "%i : %.2f : %i : %i\n" $VisitorsIG3 >> $A_FinalP2





rm -f $tmpEvFile1
rm -f $tmpEvFile2
rm -f $tmpEvFile3
rm -f $tmpEvFile4
rm -f $tmpEvFile5
rm -f $tmpEvFile6
rm -f $tmpEvFile7
rm -f $tmpEvFile8
rm -f $tmpEvFile9
rm -f $tmpEvFile10
rm -f $tmpEvFile11




#
#PARTE 3
#Datos del uso de telefonos moviles
#
#	Salida: timestamp:promedio:min:max
#
#




	usePhoneFiles=(`find $searchDir -name 'usePhone-*.txt' -print | sort `)

	A_FinalP3="usePhone-stats.txt"
	tmpFilePhone="UsoTelefono.txt"


	for i in ${usePhoneFiles[*]};
	do
		tiempoUso=(`cat $i | tail -n+3 |cut -d ':' -f 3`)
		for i in ${tiempoUso[*]};
		do
			printf "%d:" $i >> $tmpFilePhone
		done
		printf "\n" >> $tmpFilePhone
	done
	totalFields=$(head -1 $tmpFilePhone | sed 's/.$//' | tr ':' '\n' | wc -l)

	printf "#timestamp:promedio:min:max\n" >> $A_FinalP3
	for i in $(seq 1 $totalFields);
	do
		out=$(cat $tmpFilePhone | cut -d ':' -f $i |\
			awk 'BEGIN{min=2**63-1; max=0}{if($1<min){min=$1};\
						if($1>max){max=$1};\
						total+=$1; count+=1;}\
						END{print total/count":"max":"min}' )
		printf "$i:$out\n" >> $A_FinalP3
	done

	rm -f $tmpFilePhone


