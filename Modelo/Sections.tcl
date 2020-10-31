# SECCIONES:
	# Constantes que definen las secciones
	set Sv1 40001; #IPE220 - viga
	set ASv1 33.4e2; #Area de la seccion IPE220
	set I0Sv1 [expr 1/12.0*$bSv1*$hSv1*($bSv1**2.0+$hSv1**2.0)]
	set ItSv1 9.07e4; #It inercia torsional
	set IySv1 205e4; #Iyy inercia menor
	set IzSv1 2772e4; #Izz inercia mayor
	set massSv1 [expr $ASv1*$ds]; #[expr $ASv1*$dc]
	set WySv1 0.0
	set WzSv1 0.0
	set WxSv1 [expr -$massSv1*$g]
	
	section Elastic $Sv1 $Es $ASv1 $IzSv1 $IySv1 $Gs $ItSv1
	
	
	#Seccion Columna
	set Sv2 40002; #HEB 200 columna
	set ASv2 78.1; #Area de la seccion
	# DEFINIR GEOMETRÍA DE LA SECCIÓN FIBRA
	set b	200.;
	set h	200.;
	set alma	9.;	
	set ala		15.;			
	set halma	[expr $h-2*$ala]
	
	#Calculo ejes referencias
	set z1 [expr -$h/2]
	set z2 [expr -$halma/2]
	set z3 [expr  $halma/2]
	set z4 [expr  $h/2]

	set y1 [expr -$b/2]
	set y2 [expr -$alma/2]
	set y3 [expr  $alma/2]
	set y4 [expr  $b/2]

# DEFINIR EL NÚMERO DE FIBRAS EN CADA DIRECCIÓN
	set n_h_alma	4;			# Número de fibras a lo largo del alto del alma
	set n_b_alma	2;			# Número de fibras a lo largo del ancho del alma
	set n_h_ala		2;			# Número de fibras a lo largo del alto del ala
	set n_b_ala		4;          # Número de fibras a lo largo del ancho del ala

# DEFINIR LAS FIBRAS DE LA SECCIÓN DE HORMIGÓN
	#section Fiber 		$secTag
	 section Fiber	 	  1 	{    
	#				   	    [y,x Inf-izda] [y,x Inf-dcha] [y,x Sup-dcha] [y,x Sup-izda]
	#patch rect $matTag 	$numSubdivY $numSubdivZ   $yI  $zI    	   $yJ  $zJ       $yK  $zK       $yL  $zL 
	 patch quadr  	1 	$n_h_ala	$n_b_ala	  $z1  $y4		   $z1  $y1       $z2  $y1       $z2  $y4; 	
	 patch quadr  	1 		$n_h_alma	$n_b_alma	  $z2  $y3		   $z2  $y2       $z3  $y2       $z3  $y3;
	 patch quadr  	1 		$n_h_ala	$n_b_ala	  $z3  $y4		   $z3  $y1       $z4  $y1       $z4  $y4;	 						
	}

	# uniaxialMaterial Elastic [expr $Sv1-790] [expr $Gc*$ASv1*5.0/6.0]; #Rigideces de cortantes z e y
	# uniaxialMaterial Elastic [expr $Sv1-780] [expr $Gc*$ItSv1]; #Rigidez de torsion
	# section Aggregator $Sv1 [expr $Sv1-790] Vz [expr $Sv1-790] Vy [expr $Sv1-780] T -section [expr $Sv1-770] 
		
	
	# set Sv2 30002; # Viga
	# set bSv2 350; # Base de la sección de la columna 
	# set hSv2 500; # Altura de la sección de la columna
	# set ASv2 [expr $bSv2*$hSv2]
	# set I0Sv2 [expr 1/12.0*$bSv2*$hSv2*($bSv2**2.0+$hSv2**2.0)]
	# set ItSv2 [expr $ASv2**4.0/(40*$I0Sv2)]
	# set IySv2 [expr 1.0/12.0*($bSv2*$hSv2**3.0)];
	# set IzSv2 [expr 1.0/12.0*($hSv2*$bSv2**3.0)];
	# set massSv2 0.0;#[expr $ASv2*$dc]
	# set WySv2 0.0
	# set WzSv2 [expr -$massSv2*$g-32.0]
	# set WxSv2 0.0
	
	# set As12 [expr $pi*(12.0/2.0)**2]
	# section Fiber [expr $Sv2-770] {
		# patch rect $::Hormigon 30 30        [expr -350.0/2.0]        [expr -500.0/2.0]      [expr 350.0/2.0]         [expr 500.0/2.0];
		# layer straight $::Acero 2 $As12 [expr -350.0/2.0+30.0]   [expr -500.0/2.0+30.0] [expr 500.0/2.0-30.0]   [expr -500.0/2.0+30.0]; 
		# layer straight $::Acero 2 $As12 [expr -350.0/2.0+30.0]   [expr  500.0/2.0-30.0] [expr 500.0/2.0-30.0]   [expr  500.0/2.0-30.0]; 
 	# }	
	
	# uniaxialMaterial Elastic [expr $Sv2-790] [expr $Gc*$ASv2*5.0/6.0]; #Rigideces de cortantes z e y
	# uniaxialMaterial Elastic [expr $Sv2-780] [expr $Gc*$ItSv2]; #Rigidez de torsion
	# section Aggregator $Sv2 [expr $Sv2-790] Vz [expr $Sv2-790] Vy [expr $Sv2-780] T -section [expr $Sv2-770] 
		
	
	# set Sv3 30003; #Columna
	# set bSv3 350; # Base de la sección de la columna 
	# set hSv3 350; # Altura de la sección de la columna
	# set ASv3 [expr $bSv3*$hSv3]
	# set I0Sv3 [expr 1/12.0*$bSv3*$hSv3*($bSv3**2.0+$hSv3**2.0)]
	# set ItSv3 [expr $ASv3**4.0/(40*$I0Sv3)]
	# set IySv3 [expr 1.0/12.0*($bSv3*$hSv3**3.0)];
	# set IzSv3 [expr 1.0/12.0*($hSv3*$bSv3**3.0)];
	# set massSv3 0.0;#[expr $ASv3*$dc]
	# set WySv3 0.0
	# set WzSv3 0.0
	# set WxSv3 [expr -$massSv3*$g]
	
	# set As16 [expr $pi*(16.0/2.0)**2]
	# section Fiber [expr $Sv3-770] {
	# patch rect $::Hormigon 30 30            [expr -350.0/2.0]        [expr -350.0/2.0]      [expr 350.0/2.0]         [expr 350.0/2.0];
		# layer straight $::Acero 2 $As16 [expr -350.0/2.0+30.0]   [expr -350.0/2.0+30.0] [expr 350.0/2.0-30.0]   [expr -350.0/2.0+30.0]; 
		# layer straight $::Acero 2 $As16 [expr -350.0/2.0+30.0]   [expr  350.0/2.0-30.0] [expr 350.0/2.0-30.0]   [expr  350.0/2.0-30.0]; 
 	# }	
	
	# uniaxialMaterial Elastic [expr $Sv3-790] [expr $Gc*$ASv3*5.0/6.0]; #Rigideces de cortantes z e y
	# uniaxialMaterial Elastic [expr $Sv3-780] [expr $Gc*$ItSv3]; #Rigidez de torsion
	# section Aggregator $Sv3 [expr $Sv3-790] Vz [expr $Sv3-790] Vy [expr $Sv3-780] T -section [expr $Sv3-770] 


	# Orientación de las vigas y columnas (Matriz de transformación)-----> Fuera del FOR -> Evita conflictos cuando nproc < nº de cálculos
	set Trx 1; # Nombre de la dirección de las vigas en X
	set Try 2; # Nombre de la dirección de las vigas en Y
	set Trz 3; # Nombre de la dirección de las vigas en Z
	# geomTransf Linear $transfTag $vecxzX $vecxzY $vecxzZ <-jntOffset $dXi $dYi $dZi $dXj $dYj $dZj>
	geomTransf Linear $Trx 0 0 1; # z local en Zglobal
	geomTransf Linear $Try 0 0 1; # z local en Zglobal
	geomTransf Linear $Trz -1 0 0; # z local en -Xglobal
		
	# geomTransf PDelta o Linear
