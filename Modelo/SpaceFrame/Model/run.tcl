# LIBRERIAS OPENSEES
	model basic -ndm 3 -ndf 6; # Carga las funciones de OpenSees al interpreter Tcl
	wipe; # Limpia los objetos y archivos de salida del interprete
	set SimulationName SpaceFrame
	logFile mkdir $SimulationName/log
	
	
# BACKUP MODEL
	file mkdir $SimulationName/Model
	file copy -force "run.tcl" $SimulationName/Model 
	file copy -force "Materials.tcl" $SimulationName/Model 
	file copy -force "Sections.tcl" $SimulationName/Model
	file copy -force "Model.tcl" $SimulationName/Model 	
	file copy -force "Nodes.tcl" $SimulationName/Model 	
	file copy -force "FrameElem.tcl" $SimulationName/Model 	
	file copy -force "NodesMass.tcl" $SimulationName/Model 	
	file copy -force "Outputs.tcl" $SimulationName/Model 	
	file copy -force "Analysis.tcl" $SimulationName/Model 	
	file copy -force "ReadVector.tcl" $SimulationName/Model 
	
# PROCEDURES USED
	source Analysis.tcl;
	source ReadVector.tcl;

# MATERIAL LIBRERIES:
	source Materials.tcl;
	
# SECTION LIBRERIES:
	source Sections.tcl;
		
# MODEL
	source Model.tcl;
	
# OUTPUTS
	set Outputs $SimulationName;
	source Outputs.tcl;

# ANALYSIS

# MATRIZ DE RIGIDECES:
	wipeAnalysis;		# Para limpiar todas las restricciones y parámetros definidos en análisis anteriores.
	set ConvInf 0;		# Opciones de impresión de las iteraciones del test: 
						# 0 = No imprime; 1 = Imprime información en cada paso; 2 = Imprime información al final del test
		
	set Inf Inf;		# Inf = Si queremos que muestre información en pantalla	
						# NoInf = Si no queremos que muestre información en pantalla

	
						
doStiffnessMatrix $ConvInf $Outputs $Inf

# MATRIZ DE MASAS:
	wipeAnalysis;		# Para limpiar todas las restricciones y parámetros definidos en análisis anteriores.
	set ConvInf 0;		# Opciones de impresión de las iteraciones del test: 
						# 0 = No imprime; 1 = Imprime información en cada paso; 2 = Imprime información al final del test
		
	set Inf Inf;		# Inf = Si queremos que muestre información en pantalla	
						# NoInf = Si no queremos que muestre información en pantalla
						
doMassMatrix $ConvInf $Outputs $Inf

# # ANÁLISIS MODAL ESPECTRAL:
# 	wipeAnalysis;		# Para limpiar todas las restricciones y parámetros definidos en análisis anteriores.
# 	set ConvInf 0;		# Opciones de impresión de las iteraciones del test: 
# 						# 0 = No imprime; 1 = Imprime información en cada paso; 2 = Imprime información al final del test
		
# 	set Inf Inf;		# Inf = Si queremos que muestre información en pantalla	
# 						# NoInf = Si no queremos que muestre información en pantalla
						
# 	set numModos 6; 	# Establecemos el número de modos a calcular (teniendo en cuenta los GDL)
	
# doModal $numModos $Outputs $Inf

# FORCE CONTROL ANALYSIS	
	set dF 0.25
	set tol 1e-6
	set iter 10
	set ConvInf 1

	timeSeries Linear 1;
 	pattern Plain 	1 	1	 {		 
	 load 3 0.0 0.0 -10.0 0.0 0.0 0.0;
	}

doForceControl $dF $ConvInf $tol $iter $Outputs Inf
	
# #PUSHOVER ANALYSIS		
# 		set maxU 100.0;
# 		set dU [expr 0.05*$maxU];
# 		set ControlNode 3;
# 		set dof 1
# 		set tol 1e-6
# 		set iter 300
# 		set Inf NoInf;
		
# 		timeSeries Linear 2
# 		pattern Plain 2 2 {
# 		sp $ControlNode $dof $dU
# 		}	
# 	doPushover $maxU $dU $ControlNode $dof $ConvInf $tol $iter $Outputs $Inf
		
# # STATIC REVERSED CYCLIC ANALYSIS
# 		source Disp.tcl; # En este archivo se define iDstep
# 		set ControlNode 10
# 		set dof 1
# 		set dU 1
# 		set tol 1e-4
# 		set iter 300
		
# 		timeSeries Linear 3; #Aplicación del pseudotiempo
# 		pattern Plain 500 3 {
# 			sp $ControlNode $dof $dU
# 		}

# 		# doReversedCyclic $iDstep $dU $ControlNode $dof $ConvInf $tol $iter $Outputs Inf	
		
# # MODAL ANALYSIS	
# 	set numModes 6
# 	doModal $numModes $Outputs Inf	
	
# # MATRIX OUTPUTS
# 	doMassMatrix $ConvInf $Outputs Inf
# 	doStiffnessMatrix $ConvInf $Outputs Inf	

# # DAMPING PROPERTIES
# 		set DampingRatio 0.05
# 		set ::nEigenI 1
# 		set ::nEigenJ 3
# 		set ::Model "RayleighKcomm"
# 		DampingModel $DampingRatio $nEigenI $nEigenJ $Model Inf

#Analisis Modal
	# system BandGeneral
	# constraints Penalty 1.0e16 1.0e16;
	# numberer Plain
	# test NormDispIncr 1e-6  10 2
	# algorithm KrylovNewton
	
	# # set numSteps [expr int($maxU/$dU)]
	# # integrator DisplacementControl $ControlNode $dof $dU
	# # analysis Static
	# # analyze $numSteps;
		
	# set numModes 6
		
	# doModal $numModes $Outputs Inf
	
	# doMassMatrix $ConvInf $Outputs Inf
	# doStiffnessMatrix $ConvInf $Outputs Inf
		
# # DYNAMIC ANALYSIS
# 		# set iGMfile "Calitri_f200HzDirX Calitri_f200HzDirX" ;		# ground-motion filenames, should be different files
# 		# ReadVector "Earthquakes/Calitri_f200HzDirX.txt" THData StepN; # Lee numero de steps
			
# 	# Bidirectional Uniform Earthquake ground motion (uniform acceleration input at all support nodes)
# 		# set Earthquakes Earthquakes
# 		# set iGMdirection "1 2";			# ground-motion direction
# 		# set iGMfact "1.0 1.0";			# ground-motion scaling factor
# 		# set ::dt 0.005
# 		# set tol 1e-2
# 		# set iter 400
# 		# set gamma 0.5
# 		# set beta 0.25
		

# 		# set IDloadTag 400;	# for uniformSupport excitation
# 		# foreach GMdirection $iGMdirection GMfile $iGMfile GMfact $iGMfact {
# 			# incr IDloadTag;
# 			# set DataFile $Earthquakes/$GMfile.txt;
# 			# set GMfatt [expr $g*$GMfact];			
# 			# set AccelSeries "Series -dt $dt -filePath $DataFile -factor  $GMfatt";		
# 			# pattern UniformExcitation  $IDloadTag  $GMdirection -accel  $AccelSeries  ;
# 		# }	
	
# 		# set TmaxAnalysis [expr $StepN*$dt];	
# 		# set dtcal [expr $dt*1.0]
		
# 		# doDynamic $dtcal $TmaxAnalysis $gamma $beta $ConvInf $tol $iter $Outputs Inf	

exit

	
	