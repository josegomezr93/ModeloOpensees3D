# MATERIALES:  (Unidades mm, N, s, T)
	# Constantes generales
	set g 9810; # Aceleración de la gravedad en mm/s^2
	set pi [expr acos(-1.0)];
	# Constantes que definen el comportamiento de los materiales
	set ::Acero 1;
	set fy 355;
	set ds 7.85e-9; # [7850 kg/m3] Densidad del acero
	set nus 0.3; # Poisson Acero
	set Es 2.1e5; # Modulo de Young steel[N/mm^2]
	set Gs [expr $Es/(2*($nus+1.0))]; # Shear modulus acero [N/mm^2]
	
	
	uniaxialMaterial Steel02 $::Acero $fy $Es 0.0003 18.5 0.925 0.15 ;
	
	# Material elástico del muelle
	# uniaxialMaterial Elastic 1 80000
	
	# Material no lineal del muelle
	set ::Muelle 2;
	set Lp 220.0;
	set My  [expr 101.175e6];
	set Xy  [expr 1.58e-3/$Lp];
	set Xu  [expr 8.53e-2/$Lp];
	set Ko [expr $My/$Xy];

	set s1p $My;
	set e1p $Xy;
	set s2p $My;
	set e2p $Xu;
			
	uniaxialMaterial Hysteretic $::Muelle $s1p $e1p $s2p $e2p  -$s1p -$e1p -$s2p -$e2p  1 1 0 0 0.4 
	
	