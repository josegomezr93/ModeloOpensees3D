#================================================#
# 			   PLASTICIDAD DISTRIBUIDA			 #
#				     [COLUMNAS]					 #
#================================================#

# Número de puntos de integración
set np 5; # Con un máximo de 10 puntos

#element nonlinearBeamColumn $eleTag $iNode $jNode  $numIntgrPts $secTag $transfTag 
 element nonlinearBeamColumn 	1 		1 	   2 		$np 		$Sv2 		  $Trx;	
 element nonlinearBeamColumn 	2 		4 	   5 		$np 		$Sv2 		  $Trx;
 element nonlinearBeamColumn 	3 		7 	   8 		$np 		$Sv2 		  $Trx;	
 element nonlinearBeamColumn 	4 		10 	   11 		$np 		$Sv2 		  $Trx;
 element nonlinearBeamColumn 	5 		2 	   3 		$np 		$Sv2 		  $Trx;	
 element nonlinearBeamColumn 	6 		5 	   6 		$np 		$Sv2 		  $Trx;
 element nonlinearBeamColumn 	7 		8 	   9 		$np 		$Sv2 		  $Trx;	
 element nonlinearBeamColumn 	8 		11 	   12 		$np 		$Sv2 		  $Trx;

#================================================#
# 			   PLASTICIDAD CONCENTRADA			 #
#				     [VIGAS]					 #
#================================================#

#element elasticBeamColumn $eleTag $iNode $jNode  $A 	$E   $G  $J  $Iy  $Iz $transfTag  
 element elasticBeamColumn 	  9 	 2	 	5 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  10 	 5	 	8 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  11 	 11	 	8 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  12 	 2	 	11 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  13 	 3	 	6 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  14 	 6	 	9 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  15 	 12	 	9 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  16 	 3	 	12 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
# ZERO LENGTH:
# Requiere que los dos nudos que conectemos estén en la misma coordenada.
# Solo se puede definir un muelle para una dirección.
# Se le asigna el material con la ley constitutiva de la rótula para que simule ese comportamiento.

#element zeroLength $eleTag $iNode $jNode  -mat  $matTag1 -dir DespX  DespY DespZ GiroZ GiroY GiroZ	
 element zeroLength     4  	   5     3     -mat      2 	  -dir  		 						6;  
 element zeroLength     5  	   6     4     -mat      2 	  -dir  		 						6;

# Mostramos en pantalla el número de elementos
set Elem [getEleTags]
set ::ElemEnd [expr [lindex $Elem end]]
puts "Elementos introducidos: $Elem"
puts "Elementos totales del modelo: $::ElemEnd"

puts "------------------------------------------------------"
# Mostramos los nudos que contiene un elemento
set ElemX 1
set EleNudos [eleNodes $ElemX]
puts "Nudos del elemento $ElemX: $EleNudos"

set ElemX 2
set EleNudos [eleNodes $ElemX]
puts "Nudos del elemento $ElemX: $EleNudos"

set ElemX 3
set EleNudos [eleNodes $ElemX]
puts "Nudos del elemento $ElemX: $EleNudos"





element nonlinearBeamColumn 1 1 2 $numIntgrPts $Sv1 3 
element nonlinearBeamColumn 2 2 3 $numIntgrPts $Sv1 3
element nonlinearBeamColumn 3 3 4 $numIntgrPts $Sv1 3
element nonlinearBeamColumn 4 4 5 $numIntgrPts $Sv1 3
element nonlinearBeamColumn 5 6 7 $numIntgrPts $Sv2 3 
element nonlinearBeamColumn 6 7 8 $numIntgrPts $Sv2 3
element nonlinearBeamColumn 7 8 9 $numIntgrPts $Sv2 3
element nonlinearBeamColumn 8 9 10 $numIntgrPts $Sv2 3
element nonlinearBeamColumn 9 5 11 $numIntgrPts $Sv3 1
element nonlinearBeamColumn 10 11 12 $numIntgrPts $Sv3 1
element nonlinearBeamColumn 11 12 13 $numIntgrPts $Sv3 1
element nonlinearBeamColumn 12 13 10 $numIntgrPts $Sv3 1


