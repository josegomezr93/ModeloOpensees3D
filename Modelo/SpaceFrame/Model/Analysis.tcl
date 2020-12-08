 # ANÁLISIS

#===========================================#
#			   MATRIZ DE MASAS				#
#===========================================#

proc doMassMatrix {ConvInf Outputs Inf} {
	
	if {$Inf != "NoInf"} {						
	puts "------------------------------------------------------"
	puts "MATRIZ DE MASAS"
	}
		
	constraints Transformation;
	numberer Plain;
	system FullGeneral;

	test NormDispIncr 1.0e-10  10 $ConvInf;
	integrator NewmarkExplicit 0.5 ; 			
	algorithm Newton;
	analysis Transient;
	analyze 1 1; 

	if {$Inf != "NoInf"} {
	puts "Escribiendo matriz de masas M..."
	}

	printA -file $Outputs/Matrices/M.txt;
	printA;
	
}
	
#===========================================#
#			 MATRIZ DE RIGIDECES			#
#===========================================#
	
proc doStiffnessMatrix {ConvInf Outputs Inf} {
	
	if {$Inf != "NoInf"} {
	puts "------------------------------------------------------"
	puts "MATRIZ DE RIGIDEZ"
	}
	
	constraints Transformation;
	numberer Plain;
	system FullGeneral;

	test NormDispIncr 1.0e-10 10 $ConvInf;                     
	integrator LoadControl 1;	
	algorithm Newton;
	analysis Static;
	analyze 1;

	if {$Inf != "NoInf"} {
	puts "Escribiendo matriz de rigideces K..."
	}
	printA -file $Outputs/Matrices/K.txt;
	printA;
	
}
	
#===========================================#
#		   ANÁLISIS GRAVITATORIO			#
#===========================================#

proc doForceControl {dF ConvInf tol iter Outputs Inf} {
					
		if {$Inf != "NoInf"} {
		puts "------------------------------------------------------"
		puts "STATIC FORCE CONTROL ANALYSIS"
		}
		
		if {$Outputs != "NoOutputs"} {
		source "Outputs.tcl";
		}
		
		numberer RCM;
		system UmfPack;
		constraints Transformation;

		set typeText EnergyIncr
		
		test $typeText $tol $iter $ConvInf
		algorithm KrylovNewton
		set numSteps [expr int(1.0/$dF)]
		integrator LoadControl $dF
		analysis Static
		
		set itern 0
		set ok 0
		set currentDisp 0
		while {$ok == 0 && $itern  < $numSteps} {
			set ok [analyze 1]; 
			
			set ok [StaticAlgoritm $ok $Inf $itern $tol $iter $ConvInf $typeText]
					
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
		loadConst -time 0;
	    return $ok
}

#===========================================#
#		  		 ANÁLISIS MODAL				#
#===========================================#

proc doModal {numModes Outputs} {
	puts "------------------------------------------------------";
	puts "ANALISIS MODAL";

	file mkdir $Outputs/Modos;

	# constraints Transformation;
	# system UmfPack;
	# numberer Plain;

	set lambda [eigen -fullGenLapack $numModes];
	# set lambda [eigen -genBandArpack $numModes];
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

	# Obtener los vectores propios
	#nodeEigenvector $nodeTag $eigenvector <$dof>
	for {set i 1} {$i <= $numModes} {incr i} {
		if {$i == 1 | $i == 3} {

			set f1 [nodeEigenvector 1 $i 1];
			set f2 [nodeEigenvector 2 $i 1];
			set f3 [nodeEigenvector 3 $i 1];
			set autovector [list [expr {$f1/$f3}] [expr {$f2/$f3}] [expr {$f3/$f3}]];
			puts "eigenvectorX $i: $autovector";
		}
		if {$i == 2 | $i == 4} {
		
			set f1 [nodeEigenvector 1 $i 2];
			set f2 [nodeEigenvector 2 $i 2];
			set f3 [nodeEigenvector 3 $i 2];
			set autovector [list [expr {$f1/$f3}] [expr {$f2/$f3}] [expr {$f3/$f3}]];
			puts "eigenvectorY $i: $autovector";	

		}
	}
	
	#Bloque de codigo para plotear el vector modal i
	for {set k 1} {$k <= $numModes} {incr k} {
		if {$k == 1 | $k == 3} {
			set modo [format "$Outputs/Modos/eigen%i.txt" $k];
			set nodo1 [nodeEigenvector 1 $k 1];
			set nodo2 [nodeEigenvector 2 $k 1];
			set nodo3 [nodeEigenvector 3 $k 1];
			set Vectors [open $modo "w"]
			close $Vectors
		}

		if {$k == 2 | $k == 4} {
			set modo [format "$Outputs/Modos/eigen%i.txt" $k];
			set nodo1 [nodeEigenvector 1 $k 2];
			set nodo2 [nodeEigenvector 2 $k 2];
			set nodo3 [nodeEigenvector 3 $k 2];
			set Vectors [open $modo "w"]
			close $Vectors
		}
		
	}

	# set dxLoc 0;
	# set dyLoc 0;
	# for {set i 1} {$i <= $numModes} {incr i} {
	# 	set period [format "%.3f" [lindex $T [expr $i - 1]]];
	# 	set tituloVentana "Modo $i - Periodo: $period sec";
	# 	recorder display $tituloVentana [expr 10 + $dxLoc] [expr 10 + $dyLoc] 500 500 -wipe;
	# 	set dxLoc [expr $dxLoc + 150];
	# 	set dyLoc [expr $dyLoc + 30];
	# 	vup 0 1 0;
	# 	vpn 0.25 0.25 1;
	# 	prp $::h $::h 1;
	# 	viewWindow -5000 5000 -5000 5000;
	# 	display -$i 3 50;
	# }
	
}

#===========================================#
#		      ANÁLISIS PUSHOVER				#
#===========================================#
	
proc doPushover { maxU dU ControlNode dof ConvInf tol iter Outputs Inf} {
		
	if {$Inf != "NoInf"} {
	puts "------------------------------------------------------"
	puts "STATIC PUSHOVER ANALYSIS"
	}
	
	if {$Outputs != "NoOutputs"} {
	source "Outputs.tcl";
	}

	constraints Penalty 1.0e16 1.0e16;
	#constraints Lagrange
	#constraints Transformation
	#constraints Plain;
	system UmfPack;
	numberer RCM;

	set typeText NormDispIncr
	
	integrator DisplacementControl $ControlNode $dof $dU;
	test $typeText $tol  $iter $ConvInf
	algorithm KrylovNewton
	analysis Static
			
	set itern 0
	set ok 0
	set currentDisp 0
	while {$ok == 0 && abs($currentDisp) < abs($maxU)} {
		set ok [analyze 1]; 
		
		set ok [StaticAlgoritm $ok $Inf $itern $tol $iter $ConvInf $typeText]
		
		set itern [expr $itern+1]
		set currentDisp [nodeDisp $ControlNode $dof];
		
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
	    record;

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

	#constraints Transformation;
	constraints Penalty 1.0e16 1.0e16;	
	numberer RCM;
	system UmfPack

	set typeText EnergyIncr;

	test $typeText $tol $iter $ConvInf;					
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
				
		set ok [DynamicAlgoritm $ok $Inf $itern $dtAnalisis $tol $iter $TiempoControl $ConvInf $typeText]
		
			
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
		
		variable sistemaAnalisis "-fullGenLapack"
		set lambdaN [eigen $sistemaAnalisis $nEigenJ];
			
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
			set alphaM [expr 2*$DampingRatio*$omegaI];
			set betaKcurr 0.0;
			set betaKinit 0.0;
			set betaKcomm 0.0;
		rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm;
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
			set lambda [eigen $sistemaAnalisis $nEigenJ];
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

 proc StaticAlgoritm {ok Inf itern tol iter ConvInf typeText} {
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
			test $typeText $tol  $iter $ConvInf;
			algorithm Broyden 20
			set ok [analyze 1]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
				puts "Probando ModifiedNewton con tangente inicial..."
			}
			test $typeText $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			algorithm ModifiedNewton –initial;
			set ok [analyze 1]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			test $typeText $tol  $iter $ConvInf;
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
				puts "Probando Newton con la tangente inicial..."
			}
			test $typeText $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			algorithm Newton –initial;
			set ok [analyze 1]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			test $typeText $tol  $iter $ConvInf;
			algorithm KrylovNewton;
		
		}
return $ok			
}	

#===========================================#
#  	   ALGORITMO PARA CÁLCULO DINÁMICO	    #
#===========================================#

proc DynamicAlgoritm {ok Inf itern dtAnalisis tol iter TiempoControl ConvInf typeText} {
		
	if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Probando NewtonWithLineSearch..."
			puts Step:$itern
			puts CurrentTime:$TiempoControl
			}
			# test NormDispIncr $tol  $iter $ConvInf;
			test $typeText $tol $iter $ConvInf
			algorithm NewtonLineSearch .8
			set ok [analyze 1 $dtAnalisis]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test $typeText $tol $iter $ConvInf
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Probando Broyden..."
			}
			# test NormDispIncr $tol  $iter $ConvInf;
			test $typeText $tol $iter $ConvInf
			algorithm Broyden 20
			set ok [analyze 1 $dtAnalisis]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test $typeText $tol $iter $ConvInf
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Probando ModifiedNewton con la tangente inicial..."
			}
			# test NormDispIncr $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			test $typeText $tol $iter $ConvInf
			algorithm ModifiedNewton –initial;
			set ok [analyze 1 $dtAnalisis]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test $typeText $tol $iter $ConvInf
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Probando Newton con la tangente inicial..."
			}
			# test NormDispIncr $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			test $typeText $tol $iter $ConvInf
			algorithm Newton –initial;
			set ok [analyze 1 $dtAnalisis]; 
			if {$ok == 0} {puts "Ha funcionado... vuelta al KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test $typeText $tol $iter $ConvInf
			algorithm KrylovNewton;
		}	
		
		return $ok		
}
