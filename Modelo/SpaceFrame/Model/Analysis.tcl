 ###########################################################################
 #
 #                       PROCEDURES FOR OPENSEES ANALYSIS
 # 
 #       Author: David Galé-Lamuela
 #       Department: Ingeniería Mecánica ETSII (UPM)
 #
 ###########################################################################

proc doMassMatrix {ConvInf Outputs Inf} {
	
	if {$Inf != "NoInf"} {
	puts "--------------------------"
	puts "MASS MATRIX"
	}
	
	system FullGeneral
	constraints Transformation

	integrator NewmarkExplicit 0.5; 	# it should be an explicit integrator		
	# test NormDispIncr 1.0e-10  10 $ConvInf;
	algorithm Newton;					
	analysis Transient;					
	analyze 1 1; # it should be 1 step of size 1
	
	if {$Inf != "NoInf"} {
	puts "Writing M..."
	}
	file mkdir $Outputs/Matrices
	printA -file $Outputs/Matrices/M.out;
	printA;
	
	reset
}

	
proc doStiffnessMatrix {ConvInf Outputs Inf} {
	
	if {$Inf != "NoInf"} {
	puts "--------------------------"
	puts "STIFFNESS MATRIX"
	}
	
	system FullGeneral
	constraints Transformation
	
	test NormDispIncr 1.0e-10 10 $ConvInf; 
	integrator LoadControl 1
	algorithm Newton
	analysis Static
	analyze 1
	if {$Inf != "NoInf"} {
	puts "Writing K..."
	}
	file mkdir $Outputs/Matrices
	printA -file $Outputs/Matrices/K.out;
	printA;
	
	reset

}

proc doModal {numModes Outputs Inf} {
# Outputs: nombre de la carpeta Outputs o "NoOutputs" si no se quieren resultados

	if {$Inf != "NoInf"} {
	puts "------------------------------------------------------"
	puts "MODAL ANALYSIS"
	}

	system UmfPack
	constraints Transformation
	
	# set lambda [eigen  $numModes];	# 
	set lambda [eigen $numModes]; # -fullGenLapack in case of [nº modes=ngdl and masses]

	
	set omega {}
	set f {}
	set T {}
	set pi [expr acos(-1.0)];
	
	foreach lam $lambda {
		lappend omega [expr sqrt($lam)]
		lappend f [expr sqrt($lam)/(2*$pi)]
		lappend T [expr (2*$pi)/sqrt($lam)]
	}
	
	if {$Inf != "NoInf"} {
	puts "Periods are: $T -s-"
	puts "Frequencies are: $f -Hz-"
	}
	
	if {$Outputs != "NoOutputs"} {
		file mkdir $Outputs/Modes
		for { set k 1 } { $k <= $numModes } { incr k } {
			 recorder Node -file [format "$Outputs/Modes/mode%i.out" $k] -time -nodeRange 1 "$::NodeEnd" -dof 1 2 3 4 5 6  "eigen $k"
		}
		set period "$Outputs/Modes/Periods.txt"
		set Periods [open $period "w"]
		foreach t $T {
			puts $Periods " $t"
		}
		close $Periods
		record
	}

}


proc doForceControl {dF ConvInf tol iter Outputs Inf} {
# Outputs: nombre de la carpeta Outputs o "NoOutputs" si no se quieren resultados
	remove recorders 
	wipeAnalysis 
	
	if {$Inf != "NoInf"} {
	puts "------------------------------------------------------"
	puts "STATIC FORCE CONTROL ANALYSIS"
	}
	
	if {$Outputs != "NoOutputs"} {
	source "Outputs.tcl";
	}
	
	system ProfileSPD
	constraints Transformation
	numberer RCM
	
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
}


proc doPushover { maxU dU ControlNode dof ConvInf tol iter Outputs Inf} {
# Outputs: nombre de la carpeta Outputs o "NoOutputs" si no se quieren resultados
	remove recorders 
	wipeAnalysis 
	
	if {$Inf != "NoInf"} {
	puts "------------------------------------------------------"
	puts "STATIC PUSHOVER ANALYSIS"
	}
	
	if {$Outputs != "NoOutputs"} {
	source "Outputs.tcl";
	}
	
	system UmfPack
	constraints Penalty 1.0e25 1.0e25;
	numberer Plain
	
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
		
		# if {$Inf != "NoInf"} {
			# puts Step:$itern 
			# puts desp:$currentDisp
		# }
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



proc doDynamic {dtcal TmaxAnalysis gamma beta ConvInf tol iter Outputs Inf} {
# Outputs: nombre de la carpeta Outputs o "NoOutputs" si no se quieren resultados
	if {$Inf != "NoInf"} {
		puts "------------------------------------------------------"
		puts "DYNAMIC ANALYSIS"
		puts "TmaxAnalysis:$TmaxAnalysis"
	}

	if {$Outputs != "NoOutputs"} {
	source "Outputs.tcl";
	}
	
	
	system UmfPack; 	# system FullGeneral # in case of obtaining K in each step
	constraints Transformation

	integrator Newmark $gamma $beta	

	test EnergyIncr $tol $iter $ConvInf
	algorithm KrylovNewton;					
	analysis Transient;					# define type of analysis: time-dependent

	set itern 0
	set ok 0
	
	set controlTime 0;
	while {$controlTime < $TmaxAnalysis && $ok == 0} {
		
		set ok [analyze 1 $dtcal];
		set controlTime [getTime];
		
		
		set ok [DynamicAlgoritm $ok $Inf $itern $dtcal $tol $iter $controlTime $ConvInf]
		
			
		set itern [expr $itern+1]
		
		# ----------------------------------------------------------------------------------------------
		if {$Inf != "NoInf"} {
			# source InfDuringEartquake.tcl; #Activate in case of obtaining something step by step
		}
		# ----------------------------------------------------------------------------------------------
			
		# puts Step:$itern 
		# puts CurrentTime:$controlTime
	}

	if {$Inf != "NoInf"} {
		if {$ok == 0} {
		  puts "Transient analysis completed SUCCESSFULLY End Time: [getTime]";
		} else {
		  puts "Transient analysis FAILED End Time: [getTime]";
		}
	}
		
		return $ok
}


proc doReversedCyclic {iDstep dU ControlNode dof ConvInf tol iter Outputs Inf} {
# Outputs: nombre de la carpeta Outputs o "NoOutputs" si no se quieren resultados
	if {$Inf != "NoInf"} {
		puts "------------------------------------------------------"
		puts "STATIC REVERSED CYCLIC ANALYSIS"
	}
	
	if {$Outputs != "NoOutputs"} {
	source "Outputs.tcl";
	}
	
	# system UmfPack
	system BandGeneral
	constraints Penalty 1.0e25 1.0e25;

		set D0 0.0
		foreach Dstep $iDstep {
			set D1 $Dstep
			set Dincr [expr $D1 - $D0]
			set itern 0
			
			integrator DisplacementControl $ControlNode $dof $Dincr; 
			test NormDispIncr $tol $iter $ConvInf
			algorithm KrylovNewton
			analysis Static
			
			set ok [analyze 1]
			
		# set ok [StaticAlgoritm $ok $Inf $itern $tol $iter $ConvInf]	
		
			set itern [expr $itern+1]
			
			set D0 $D1;			
		}
		
		if {$Inf != "NoInf"} {
		if {$ok == 0} {
		  puts "Reversed Cyclic analysis completed SUCCESSFULLY End Step: $D0";
		} else {
		  puts "Reversed Cyclic analysis FAILED End Step: $D0";
		}
	}
		
	return $ok
  
} 
 
 # Algoritmos para mejorar la convergencia en Cálculo Estático
 proc StaticAlgoritm {ok Inf itern tol iter ConvInf} {
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
				puts "Trying NewtonWithLineSearch .."
				puts Step:$itern 
			}
			algorithm NewtonLineSearch 0.8
			set ok [analyze 1]; 
			if {$ok == 0} {puts "that worked .. back to KrylovNewton"}
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
				puts "Trying Broyden .." 
			}
			test NormDispIncr $tol  $iter $ConvInf;
			algorithm Broyden 20
			set ok [analyze 1]; 
			if {$ok == 0} {puts "that worked .. back to KrylovNewton"}
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
				puts "Trying ModifiedNewton with Initial Tangent .."
			}
			test NormDispIncr $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			algorithm ModifiedNewton –initial;
			set ok [analyze 1]; 
			if {$ok == 0} {puts "that worked .. back to KrylovNewton"}
			test NormDispIncr $tol  $iter $ConvInf;
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
				puts "Trying Newton with Initial Tangent .."
			}
			test NormDispIncr $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			algorithm Newton –initial;
			set ok [analyze 1]; 
			if {$ok == 0} {puts "that worked .. back to KrylovNewton"}
			test NormDispIncr $tol  $iter $ConvInf;
			algorithm KrylovNewton;
		
		}
return $ok			
}	

 # Algoritmos para mejorar la convergencia en Cálculo Dinámico
proc DynamicAlgoritm {ok Inf itern dtcal tol iter controlTime ConvInf} {
		
	if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Trying NewtonWithLineSearch .."
			puts Step:$itern
			puts CurrentTime:$controlTime
			}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm NewtonLineSearch .8
			set ok [analyze 1 $dtcal]; 
			if {$ok == 0} {puts "that worked .. back to KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Trying Broyden .."
			}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm Broyden 20
			set ok [analyze 1 $dtcal]; 
			if {$ok == 0} {puts "that worked .. back to KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Trying ModifiedNewton with Initial Tangent .."
			}
			# test NormDispIncr $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			test EnergyIncr $tol $iter $ConvInf
			algorithm ModifiedNewton –initial;
			set ok [analyze 1 $dtcal]; 
			if {$ok == 0} {puts "that worked .. back to KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm KrylovNewton;
		}
		
		if {$ok != 0} {
			if {$Inf != "NoInf"} {
			puts "Trying Newton with Initial Tangent .."
			}
			# test NormDispIncr $tol $iter $ConvInf; # if the analysis fails try initial tangent iteration
			test EnergyIncr $tol $iter $ConvInf
			algorithm Newton –initial;
			set ok [analyze 1 $dtcal]; 
			if {$ok == 0} {puts "that worked .. back to KrylovNewton"}
			# test NormDispIncr $tol  $iter $ConvInf;
			test EnergyIncr $tol $iter $ConvInf
			algorithm KrylovNewton;
		}	
		
		return $ok		
}

# Modelo de amortiguamiento
proc DampingModel {DampingRatio nEigenI nEigenJ Model Inf} {

if {$Inf != "NoInf"} {
		puts "------------------------------------------------------"
		puts "DAMPING MODEL"
		puts "Damping Ratio: $DampingRatio";	# damping ratio
	}

	if {$nEigenJ > 1} {
	set lambdaN [eigen -genBandArpack $nEigenJ];			# eigenvalue analysis for nEigenJ modes
	} else {
	set lambdaN [eigen -fullGenLapack $nEigenJ];			# eigenvalue analysis for nEigenJ modes
	}
	
set lambdaI [lindex $lambdaN [expr $nEigenI-1]]; 		# eigenvalue mode i
set lambdaJ [lindex $lambdaN [expr $nEigenJ-1]]; 	# eigenvalue mode j

set omegaI [expr pow($lambdaI,0.5)];
set omegaJ [expr pow($lambdaJ,0.5)];


if {$Model == "Mass"} {
	if {$Inf != "NoInf"} {
		puts "Damping Model: Mass"
		puts omegaI:$omegaI
		puts omegaJ:$omegaJ
	}
	set alphaM [expr 2*$DampingRatio*$omegaI];	# M-prop. damping; D = alphaM*M
	set betaKcurr 0.0
	set betaKinit 0.0
	set betaKcomm 0.0
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; 	
if {$Inf != "NoInf"} {
		puts alphaM:$alphaM
	}
} 

if {$nEigenJ > 1} {

if {$Model == "RayleighKini"} {
	
	if {$Inf != "NoInf"} {
		puts "Damping Model: Rayleigh Kini "
		puts omegaI:$omegaI
		puts omegaJ:$omegaJ
	}

set MpropSwitch 1.0;
set KcurrSwitch 0.0;
set KcommSwitch 0.0;
set KinitSwitch 1.0;

set alphaM [expr $MpropSwitch*$DampingRatio*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)];	# M-prop. damping; D = alphaM*M
set betaKcurr [expr $KcurrSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         		# current-K;      +beatKcurr*KCurrent
set betaKcomm [expr $KcommSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];   		# last-committed K;   +betaKcomm*KlastCommitt
set betaKinit [expr $KinitSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         			# initial-K;     +beatKinit*Kini
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; 				# RAYLEIGH damping D=$alphaM*M + $betaKcurr*Kcurrent + $betaKcomm*KlastCommit + $beatKinit*$Kinitial
if {$Inf != "NoInf"} {
		puts alphaM:$alphaM
		puts betaKinit:$betaKinit
	}
} elseif {$Model == "RayleighKcomm"} {

	if {$Inf != "NoInf"} {
		puts "Damping Model: Rayleigh Kcomm"
		puts omegaI:$omegaI
		puts omegaJ:$omegaJ
	}

set MpropSwitch 1.0;
set KcurrSwitch 0.0;
set KcommSwitch 1.0;
set KinitSwitch 0.0;

set alphaM [expr $MpropSwitch*$DampingRatio*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)];	# M-prop. damping; D = alphaM*M
set betaKcurr [expr $KcurrSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         		# current-K;      +beatKcurr*KCurrent
set betaKcomm [expr $KcommSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];   		# last-committed K;   +betaKcomm*KlastCommitt
set betaKinit [expr $KinitSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         			# initial-K;     +beatKinit*Kini
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; 				# RAYLEIGH damping D=$alphaM*M + $betaKcurr*Kcurrent + $betaKcomm*KlastCommit + $beatKinit*$Kinitial
if {$Inf != "NoInf"} {
		puts alphaM:$alphaM
		puts betaKcomm:$betaKcomm
	}
} elseif {$Model == "RayleighKcurr"} {
	
	if {$Inf != "NoInf"} {
		puts "Damping Model: Rayleigh Kcurr"
		puts omegaI:$omegaI
		puts omegaJ:$omegaJ
	}
	
set MpropSwitch 1.0;
set KcurrSwitch 1.0;
set KcommSwitch 0.0;
set KinitSwitch 0.0;

set alphaM [expr $MpropSwitch*$DampingRatio*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)];	# M-prop. damping; D = alphaM*M
set betaKcurr [expr $KcurrSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         		# current-K;      +beatKcurr*KCurrent
set betaKcomm [expr $KcommSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];   		# last-committed K;   +betaKcomm*KlastCommitt
set betaKinit [expr $KinitSwitch*2.*$DampingRatio/($omegaI+$omegaJ)];         			# initial-K;     +beatKinit*Kini
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; 				# RAYLEIGH damping D=$alphaM*M + $betaKcurr*Kcurrent + $betaKcomm*KlastCommit + $beatKinit*$Kinitial
if {$Inf != "NoInf"} {
		puts alphaM:$alphaM
		puts betaKcurr:$betaKcurr
	}
	
} elseif {$Model == "modalDamping"} {
	
	if {$Inf != "NoInf"} {
		puts "Damping Model: Modal Damping"
		puts Modes:$nEigenJ
	}
	set lambda [eigen  $nEigenJ];
	modalDamping $DampingRatio

}

	}

}


