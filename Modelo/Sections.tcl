# SECCIONES:
	# Constantes que definen las secciones
	set Sv1 40001; #IPE220 - viga
	set ASv1 33.4e2; #Area de la seccion IPE220
	set ItSv1 9.07e4; #It inercia torsional
	set IySv1 205e4; #Iyy inercia menor
	set IzSv1 2772e4; #Izz inercia mayor
	set massSv1 [expr $ASv1*$ds]; #[expr $ASv1*$dc]
	set WySv1 [expr -$massSv1*$g];
	set WzSv1 0.0;
	set WxSv1 0.0;
	
	#section Elastic $Sv1 $Es $ASv1 $IzSv1 $IySv1 $Gs $ItSv1;
	
	
	#Seccion Columna
	set Sv2 40002; #HEB 200 columna
	set ASv2 78.1e2; #Area de la seccion
	set ItSv2 56.9e6; #Momento de inercia torsional
	set massSv2 [expr $ASv2*$ds];
	set WySv2 0.0;
	set WzSv2 [expr -$massSv2*$g];
	set WxSv2 0.0;
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
	set nvert_alma	4;			# Número de fibras a lo largo del alto del alma
	set nhorz_alma	2;			# Número de fibras a lo largo del ancho del alma
	set nhorz_ala 	2;			# Número de fibras a lo largo del alto del ala
	set nvert_ala 	4;          # Número de fibras a lo largo del ancho del ala

# DEFINIR LAS FIBRAS DE LA SECCIÓN DE HORMIGÓN
	#section Fiber 		$secTag
	 section Fiber $Sv2 -GJ [expr $Gs*$ItSv2] {
	 patch quadr $::Acero $nvert_ala $nhorz_ala 	$y1  $z4 	$y2  $z4 	$y2  $z1 	$y1  $z1; 	
	 patch quadr $::Acero $nvert_alma $nhorz_alma 	$y2  $z3 	$y3  $z3 	$y3  $z2 	$y2  $z2;
	 patch quadr $::Acero $nvert_ala $nhorz_ala 	$y3  $z4 	$y4  $z4 	$y4  $z1 	$y3  $z1;	 						
	}

# Transformadas geometricas del plano xZ || a que coordenada global
	set Tbz 1;
	set Tbx 2;
	set Tcol 3;
	geomTransf Linear $Tbz 0 0 1;
	geomTransf Linear $Tbx 0 0 1;
	geomTransf Linear $Tcol -1 0 0;
	