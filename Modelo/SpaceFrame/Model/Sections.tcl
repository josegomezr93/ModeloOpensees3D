# SECCIONES:
	# Constantes que definen las secciones
	set Sv1 40001; #IPE220 - viga
	set ASv1 3340; #Area de la seccion IPE220
	set ItSv1 90300; #It inercia torsional
	set IySv1 2050000; #Iyy inercia menor
	set IzSv1 27720000; #Izz inercia mayor
	set massSv1 [expr $ASv1*$ds]; #[expr $ASv1*$dc]
	set WySv1 [expr -$massSv1*$g]; #Peso distribuido direccion Y local
	set WzSv1 0.0;
	set WxSv1 0.0; #Peso distribuido a lo largo del elemento (eje del elemento)
	
	section Elastic $Sv1 $Es $ASv1 $IzSv1 $IySv1 $Gs $ItSv1;
	
	
	#SECCION COLUMNA [ELEMENTO FIBRA]


# DEFINIR LAS FIBRAS DE LA SECCIÓN DE HORMIGÓN
#================================================#
# 			   SECCIONES NO LINEALES			 #
#				     [COLUMNAS]					 #
#================================================#
#                        [Y+]					 #
#      Coordenadas        ^						 #
#      Locales            |     				 #
#             	 y4 +-----------+   -- 	 		 #
#                y3 +----+ +----+    |	 		 #
#               		 | |	     |			 #
#              [Z+]<---- |+|(0,0)    h 			 #
#               		 | |		 | 	 		 #
#          	 y2 [L] +----+ +----+[K] |	 		 #
#             y1 [I]+-----------+[J] --  		 #
#                   z4	z3 z2	z1				 #
#                 	|-----b-----|	        	 #
#================================================#

set Sv2 40002; #HEB 200 columna
set ASv2 7810; #Area de la seccion
set ItSv2 56.9e6; #Momento de inercia torsional
set IzSv2 56960000;
set massSv2 [expr $ASv2*$ds];
set WySv2 0.0;
set WzSv2 0.0;
set WxSv2 [expr -$massSv2*$g]; #Carga en el eje local X
# DEFINIR GEOMETRÍA DE LA SECCIÓN FIBRA
set b 200.0;
set h 200.0;
set alma 9.0;	
set ala	15.0;			
set halma [expr $h-2*$ala];

#Calculo ejes referencias
set y1 [expr -$h/2];
set y2 [expr -$halma/2];
set y3 [expr  $halma/2];
set y4 [expr  $h/2];

set z1 [expr -$b/2];
set z2 [expr -$alma/2];
set z3 [expr  $alma/2];
set z4 [expr  $b/2];

# DEFINIR EL NÚMERO DE FIBRAS EN CADA DIRECCIÓN
set nvert_alma	4;
set nhorz_alma	2;
set nvert_ala 	2;
set nhorz_ala 	4;

#section Fiber 	$secTag	$numSubdivY $numSubdivZ [y,x Inf-izda I] [y,x Inf-dcha J] [y,x Sup-dcha K] [y,x Sup-izda L]
#El recorrido de la malla debe ser antihorario
 set Sv2fibra [expr $Sv2-100]
 section Fiber $Sv2fibra -GJ [expr $Gs*$ItSv2] {
 patch quad $::Acero $nhorz_ala $nvert_ala 	$y1  $z4 	$y1  $z1 	$y2  $z1 	$y2  $z4; 	
 patch quad $::Acero $nhorz_alma $nvert_alma 	$y2  $z3 	$y2  $z2 	$y3  $z2 	$y3  $z3;
 patch quad $::Acero $nhorz_ala $nvert_ala 	$y3  $z4 	$y3  $z1 	$y4  $z1 	$y4  $z4;	 						
}


# Transformadas geometricas del plano xZ || a que coordenada global
	set Tbz 1;
	set Tbx 2;
	set Tcol 3;
	geomTransf Linear $Tbz 0 -1 0;
	geomTransf Linear $Tbx 1 0 0;
	geomTransf Linear $Tcol 0 -1 0;
	