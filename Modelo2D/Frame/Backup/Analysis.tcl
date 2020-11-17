 # ANÁLISIS

#===========================================#
#			   MATRIZ DE MASAS				#
#===========================================#

proc doMassMatrix {ConvInf Outputs Inf} {
	
	if {$Inf != "NoInf"} {						
	puts "------------------------------------------------------"
	puts "MATRIZ DE MASAS"
	}
		
	constraints Transformation;					# Para definir cómo se manejan las restricciones en GDL de los nudos.
	numberer Plain;								# Reenumera los GDL para minimizar el ancho de banda de las matrices
	system FullGeneral; 						# Para definir cómo se resuelve el sistema de ecuaciones.
			
	test NormDispIncr 1.0e-10  10 $ConvInf;		# Para construir un test de convergencia definiendo tolerancias e iteraciones.
	integrator NewmarkExplicit 0.5 ; 			# Determina el paso predictivo del tiempo t+dt y depende de si el análisis será estático o dinámico.
												# Debe ser un integrador explícito porque computacionalmente es más eficiente.
	algorithm Newton;							# Para definir cómo se resuelve las ecuaciones no lineales.
	analysis Transient;							# Para definir el tipo de análisis estático, dinámico con paso constante del tiempo o variable.
	analyze 1 1; 								# Para llevar a cabo el análisis definimos el número de pasos y el incremento del paso del tiempo.
												# El paso del tiempo solo es válido para análisis dinámicos.
	
	if {$Inf != "NoInf"} {
	puts "Escribiendo matriz de masas M..."
	}

	printA -file $Outputs/Matrices/M.txt;
	printA;
	
}
	#=============#
	#    NOTAS    #
	#=============#
	
	# El integrador monta el sistema Mü + Cú + ku = F y lo organiza para que se llegue a un sistema Ax = B y nos devuelve la matriz A. Siendo B una función conocida.
	# En estático tendríamos ku = F y se corresponde la matriz de rigidez K con la matriz A (del printA).
	# En el artículo Numerical Integration explica cómo interpretar el sistema resuelto para sacar la matriz de masas M.
	# En caso de que el amortiguamiento sea 0, la matriz de masas A sería M.
	# En diferencias centrales es sencillo de intuir. Se necesita un integrador EXPLÍCITO.
	
#===========================================#
#			 MATRIZ DE RIGIDECES			#
#===========================================#
	
proc doStiffnessMatrix {ConvInf Outputs Inf} {
	
	if {$Inf != "NoInf"} {
	puts "------------------------------------------------------"
	puts "MATRIZ DE RIGIDEZ"
	}
	
	constraints Transformation;             	# Para definir cómo se manejan las restricciones en GDL de los nudos.
	numberer Plain;								# Reenumera los GDL para minimizar el ancho de banda de las matrices.
	system FullGeneral;							# Para definir cómo se resuelve el sistema de ecuaciones.
	
	test NormDispIncr 1.0e-10 10 $ConvInf;  	# Para construir un test de convergencia definiendo tolerancias e iteraciones.                                     
	integrator LoadControl 1;               	# Determina el paso predictivo del tiempo t+dt y depende de si el análisis será estático o dinámico.
												# Se indica el factor de incremento lambda.	
												# Se trata de un control de cargas clásico si las cargas están en load pattern con un TimeSeries de factor 1.0 (por defecto).	
	
	algorithm Newton;                       	# Para definir cómo se resuelve las ecuaciones no lineales.
	analysis Static;                        	# Para definir el tipo de análisis estático, dinámico con paso constante del tiempo o variable.
	analyze 1;	                            	# Para llevar a cabo el análisis definimos el número de pasos y el incremento del paso del tiempo.
												# El paso del tiempo solo es válido para análisis dinámicos.
	
	if {$Inf != "NoInf"} {
	puts "Escribiendo matriz de rigideces K..."
	}
	printA -file $Outputs/Matrices/K.txt;
	printA;
	
}
	#=============#
	#    NOTAS    #
	#=============#
	
	# Para determinar la rigidez necesitamos conocer las siguientes propiedades ya definidas en otros scripts:
	
	# PROPIEDADES MECÁNICAS DE LOS MATERIALES:
	#			- Módulo elástico (Young) del material.
	#			- Momento de inercia en función de la geometría de la sección.
	# PROPIEDADES GEOMÉTRICAS DE LA ESTRUCTURA:
	#			- Longitudes de los elementos estructurales que conectan los nudos.
	#			- Condiciones de contorno de la estructura que definirán la proporción de rigidez.
	
	# En el cálculo dinámico los giros no producen fuerzas, solo las masas desplazadas.
	# Por lo que se eliminan los términos de los giros como incógnitas.
	# Las únicas incógnitas que quedan son los desplazamientos de los nudos susceptibles de movimiento.
	# Esta nueva matriz más pequeña se llama 'matriz reducida' o 'matriz condensada'.
	# Opensees genera dicha matriz.
	
#===========================================#
#		   ANÁLISIS GRAVITATORIO			#
#===========================================#

proc doForceControl {dF ConvInf tol iter Outputs Inf} {
# Outputs: nombre de la carpeta Outputs o "NoOutputs" si no se quieren resultados
	
	if {$Inf != "NoInf"} {
	puts "------------------------------------------------------"
	puts "STATIC FORCE CONTROL ANALYSIS"
	}
	
	if {$Outputs != "NoOutputs"} {
	source "Outputs.tcl";
	}
	
	numberer RCM;
	system UmfPack; #Para grandes modelos funciona a la perfeccion este sistema
	constraints Transformation
	
	test NormDispIncr $tol  $iter $ConvInf
	algorithm KrylovNewton
	set numSteps [expr int(1.0/$dF)]
	integrator LoadControl $dF
	analysis Static
	
	set itern 0
	set ok 0
	set currentDisp 0
	while {$ok == 0 && $itern  < $numSteps} {
		set ok [analyze 1]; 
		
		set ok [StaticAlgoritm $ok $Inf $itern $tol $iter $ConvInf]
				
		set itern [expr $itern+1]
		# puts Step:$itern 		
	}
	if {$Inf != "NoInf"} {
		if {$ok == 0} {
			puts "Force Control analysis completed SUCCESSFULLY"
		} else {
			puts "Force Control analysis FAILED End Step:$itern";
		}
	}
	loadConst -time 0; # hace que las fuerzs de gravedad se mantengan constantes
    return $ok
    record
}

#===========================================#
#		   ANÁLISIS MODAL ESPECTRAL			#
#===========================================#

proc doModal {numModes Outputs} {
	
	puts "------------------------------------------------------";
	puts "ANALISIS MODAL ESPECTRAL";

	file mkdir $Outputs/Modos;

	#Condiciones de contorno para el ensamblaje de la matrices
	constraints Transformation
	numberer Plain
	system BandGeneral
	
	set lambda [eigen -fullGenLapack $numModes];

	set omega {}
	set f {}
	set T {}


	foreach lam $lambda {
		lappend omega [expr sqrt($lam)];
		lappend f [expr sqrt($lam)/(2*$::pi)];
		lappend T [expr (2*$::pi)/sqrt($lam)];
	}
	
	puts "periodos son $T";
	
	set period "$Outputs/Modos/Periods.txt";
	set Periods [open $period "w"]
	foreach t $T {
		puts $Periods " $t"
	}
	close $Periods

}

#===========================================#
#		      ANÁLISIS PUSHOVER				#
#===========================================#
	
proc doPushover { maxU dU ControlNode dof ConvInf tol iter Outputs Inf} {
# Outputs: nombre de la carpeta Outputs o "NoOutputs" si no se quieren resultados
	
	if {$Inf != "NoInf"} {
	puts "------------------------------------------------------"
	puts "STATIC PUSHOVER ANALYSIS"
	}
	
	if {$Outputs != "NoOutputs"} {
	source "Outputs.tcl";
	}
	
	system UmfPack
	constraints Penalty 1.0e16 1.0e16;
	
	integrator DisplacementControl   $ControlNode $dof $dU 1 $dU $dU; # Control por desplazamientos en Story 1
	test NormDispIncr $tol  $iter $ConvInf
	algorithm KrylovNewton
	analysis Static
			
	set itern 0
	set ok 0
	set currentDisp 0
	while {$ok == 0 && abs($currentDisp) < abs($maxU)} {
		set ok [analyze 1]; 
		
		set ok [StaticAlgoritm $ok $Inf $itern $tol $iter $ConvInf]
		
		set itern [expr $itern+1]
		set currentDisp [nodeDisp $ControlNode $dof]
		
		if {$Inf != "NoInf"} {
			puts Step:$itern 
			puts desp:$currentDisp
		}
	}
	if {$Inf != "NoInf"} {
		if {$ok == 0} {
		  puts "Pushover analysis completed SUCCESSFULLY";
		} else {
		  puts "Pushover analysis FAILED";
		}
	}
	    return $ok
}	

#===========================================#
#		       ANÁLISIS DINÁMICO			#
#===========================================#

proc doDynamic {PasoAnalisis dtAnalisis TmaxAnalisis gamma beta ConvInf tol iter Outputs Inf} {

	if {$Inf != "NoInf"} {
		puts "------------------------------------------------------"
		puts "ANALISIS DINAMICO"
	}

	if {$Outputs != "NoOutputs"} {
	source "Outputs.tcl";
	}
	
	constraints Transformation	
	numberer Plain
	system UmfPack

	test EnergyIncr $tol $iter $ConvInf;					
	algorithm KrylovNewton;									
	integrator Newmark $gamma $beta;						
	analysis Transient;					
	set ok [analyze $PasoAnalisis $dtAnalisis];

	set itern 0
	set ok 0
	
	set TiempoControl 0;
	while {$TiempoControl < $TmaxAnalisis && $ok == 0} {
		
		set ok [analyze 1 $dtAnalisis];
		set TiempoControl [getTime];
				
		set ok [DynamicAlgoritm $ok $Inf $itern $dtAnalisis $tol $iter $TiempoControl $ConvInf]
		
			
		set itern [expr $itern+1]
		
		# ----------------------------------------------------------------------------------------------
		if {$Inf != "NoInf"} {
			# source InfDuringEartquake.tcl; #Activate in case of obtaining something step by step
		}
		# ----------------------------------------------------------------------------------------------
			
		puts Paso:$itern 
		puts TiempoActual:$TiempoControl
	}

	if {$Inf != "NoInf"} {
		if {$ok == 0} {
		  puts "Analisis dinamico completado SATISFACTORIAMENTE en el instante: [getTime]";
		} else {
		  puts "Analisis dinamico FALLO en el instante: [getTime]";
		}
	}
		
		return $ok
}

#===========================================#
#  	   	   MODELO DE AMORTIGUAMIENTO	    #
#===========================================#

proc DampingModel {DampingRatio nEigenI nEigenJ Modelo Inf} {
		
if {$Inf != "NoInf"} {
		puts "------------------------------------------------------"
		puts "MODELO DE AMORTIGUAMIENTO"
		puts "Ratio de amortiguamiento: $DampingRatio";	
	}

	if {$nEigenJ > 1} {
	set lambdaN [eigen -genBandArpack $nEigenJ];			# Análisis de autovalores para nEigenJ modos
	} else {
	set lambdaN [eigen -fullGenLapack $nEigenJ];			# Análisis de autovalores para nEigenJ modos
	}
	
set lambdaI [lindex $lambdaN [expr $nEigenI-1]]; 			# Autovalores del modo i
set lambdaJ [lindex $lambdaN [expr $nEigenJ-1]]; 			# Autovalores del modo j

set omegaI [expr pow($lambdaI,0.5)];
set omegaJ [expr pow($lambdaJ,0.5)];


if {$Modelo == "Masa"} {
	if {$Inf != "NoInf"} {
		puts "Modelo de amortiguamiento: Masa"
		puts omegaI:$omegaI
		puts omegaJ:$omegaJ
	}
	set alphaM [expr 2*$DampingRatio*$omegaI];			# Factor aplicado a la matriz de masas, [C1] = [alphaM]*[M]. La matriz de masas se considera invariable en el análisis.
	set betaKcurr 0.0;                                  # Factor aplicado a la matriz de rigidez actual, [C2] = [betaKactual]*[Kactual]. Sistemas inelásticos: Actualiza la matriz [C] cada vez que varía la rigidez. [Beta] Constante y [K] variable.
	set betaKinit 0.0;                                  # Factor aplicado a la matriz de rigidez inicial, [C3] = [betaKinicial]*[Kinicial]. Sistemas inelásticos: Actualiza la matriz [C] cada vez que varía la rigidez. [Beta] variable y [K] variable.
	set betaKcomm 0.0;                                  # Factor aplicado a la matriz de rigidez ultima, [C4] = [betaKultima]*[Kultima]. Sistemas Elásticos. [Beta] constante y [K] constante
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; 		# Amortiguamiento de Rayleigh, [D] = [C1] + [C2] + [C3] + [C4]  								
if {$Inf != "NoInf"} {
		puts alphaM:$alphaM
	}
} 

if {$nEigenJ > 1} {

if {$Modelo == "RayleighKinicial"} {
	
	if {$Inf != "NoInf"} {
		puts "Modelo de amortiguamiento: Rayleigh K inicial "
		puts omegaI:$omegaI
		puts omegaJ:$omegaJ
	}

set MpropSwitch 1.0;
set KcurrSwitch 0.0;
set KcommSwitch 0.0;
set KinitSwitch 1.0;

set alphaM [expr $MpropSwitch*$DampingRatio*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)];	
set betaKcurr [expr $KcurrSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         		
set betaKcomm [expr $KcommSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];   			
set betaKinit [expr $KinitSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         		
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; 									
if {$Inf != "NoInf"} {
		puts alphaM:$alphaM
		puts betaKinit:$betaKinit
	}
} elseif {$Modelo == "RayleighKultima"} {

	if {$Inf != "NoInf"} {
		puts "Modelo de amortiguamiento: Rayleigh K ultima"
		puts omegaI:$omegaI
		puts omegaJ:$omegaJ
	}

set MpropSwitch 0.0;
set KcurrSwitch 0.0;
set KcommSwitch 1.0;
set KinitSwitch 0.0;

set alphaM [expr $MpropSwitch*$DampingRatio*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)];	
set betaKcurr [expr $KcurrSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         		
set betaKcomm [expr $KcommSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];   			
set betaKinit [expr $KinitSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         		
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; 									
if {$Inf != "NoInf"} {
		puts alphaM:$alphaM
		puts betaKcomm:$betaKcomm
	}
} elseif {$Modelo == "RayleighKactual"} {
	
	if {$Inf != "NoInf"} {
		puts "Modelo de amortiguamiento: Rayleigh K actual"
		puts omegaI:$omegaI
		puts omegaJ:$omegaJ
	}
	
set MpropSwitch 1.0;
set KcurrSwitch 1.0;
set KcommSwitch 0.0;
set KinitSwitch 0.0;

set alphaM [expr $MpropSwitch*$DampingRatio*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)];	
set betaKcurr [expr $KcurrSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         		
set betaKcomm [expr $KcommSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];   			
set betaKinit [expr $KinitSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         		
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; 									
if {$Inf != "NoInf"} {
		puts alphaM:$alphaM
		puts betaKcurr:$betaKcurr
	}
	
} elseif {$Modelo == "AmortiguamientoModal"} {
	
	if {$Inf != "NoInf"} {
		puts "Modelo de amortiguamiento: Amortiguamiento modal"
		puts Modos:$nEigenJ
	}
	set lambda [eigen  $nEigenJ];
	modalDamping $DampingRatio

}

	}

}

#===========================================#
#  ALGORITMOS PARA MEJORA DE CONVEREGENCIA	#
#===========================================#
 
#===========================================#
#  	   ALGORITMO PARA CÁLCULO ESTÁTICO	    #
#===========================================#

 proc StaticAlgoritm {ok Inf itern tol iter ConvInf} {
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
				puts "Probando NewtonWithLineSearch..."
				puts Step:$itern 
			}
			algorithm NewtonLineSearch 0.8
			set ok [analyze 1]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
				puts "Probando Broyden .." 
			}
			test NormDispIncr $tol  $iter $ConvInf;
			algorithm Broyden 20
			set ok [analyze 1]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
				puts "Probando ModifiedNewton con tangente inicial..."
			}
			test NormDispIncr $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			algorithm ModifiedNewton –initial;
			set ok [analyze 1]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			test NormDispIncr $tol  $iter $ConvInf;
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
				puts "Probando Newton con la tangente inicial..."
			}
			test NormDispIncr $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			algorithm Newton –initial;
			set ok [analyze 1]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			test NormDispIncr $tol  $iter $ConvInf;
			algorithm KrylovNewton;
		
		}
return $ok			
}	

#===========================================#
#  	   ALGORITMO PARA CÁLCULO DINÁMICO	    #
#===========================================#

proc DynamicAlgoritm {ok Inf itern dtAnalisis tol iter TiempoControl ConvInf} {
		
	if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Probando NewtonWithLineSearch..."
			puts Step:$itern
			puts CurrentTime:$TiempoControl
			}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm NewtonLineSearch .8
			set ok [analyze 1 $dtAnalisis]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Probando Broyden..."
			}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm Broyden 20
			set ok [analyze 1 $dtAnalisis]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Probando ModifiedNewton con la tangente inicial..."
			}
			# test NormDispIncr $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			test EnergyIncr $tol $iter $ConvInf
			algorithm ModifiedNewton –initial;
			set ok [analyze 1 $dtAnalisis]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Probando Newton con la tangente inicial..."
			}
			# test NormDispIncr $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			test EnergyIncr $tol $iter $ConvInf
			algorithm Newton –initial;
			set ok [analyze 1 $dtAnalisis]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm KrylovNewton;
		}	
		
		return $ok		
}
