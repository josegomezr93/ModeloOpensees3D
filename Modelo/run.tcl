# LIBRERIAS OPENSEES
	model basic -ndm 3 -ndf 6; # Carga las funciones de OpenSees al interpreter Tcl
	wipe; # Limpia los objetos y archivos de salida del interprete
	set SimulationName SpaceFrame
	
	
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
	source Analysis.tcl
	source ReadVector.tcl

# MATERIAL LIBRERIES:
	source Materials.tcl 
	
# SECTION LIBRERIES:
	source Sections.tcl	
		
# MODEL
	source Model.tcl
	
# OUTPUTS
	 set Outputs $SimulationName
	 source Outputs.tcl
		
# ANALYSIS
	numberer Plain
	set ConvInf 0

# FORCE CONTROL ANALYSIS	
		set dF 0.25
		set tol 1e-10
		set iter 300
		
		timeSeries Linear 1
		pattern Plain 1 1 {
				eleLoad -ele 1 -type -beamUniform $WySv1 $WzSv1 $WxSv1
				eleLoad -ele 2 -type -beamUniform $WySv2 $WzSv2 $WxSv2
				eleLoad -ele 3 -type -beamUniform $WySv3 $WzSv3 $WxSv3
				load 3 0.0 0.0 [expr -8.0*$g] 0.0 0.0 0.0
				load 4 0.0 0.0 [expr -8.0*$g] 0.0 0.0 0.0
			}	

	set dF 0.25
	set tol 1e-6
	set iter 10
	doForceControl $dF $ConvInf $tol $iter $Outputs Inf	
	
# PUSHOVER ANALYSIS		
		set maxU 100.0;
		set dU [expr 0.05*$maxU];
		set ControlNode 10
		set dof 1
		set tol 1e-6
		set iter 300
		
		timeSeries Linear 2
		pattern Plain 2 2 {
		sp $ControlNode $dof $dU
		}	
	doPushover $maxU $dU $ControlNode $dof $ConvInf $tol $iter $Outputs Inf
		
# STATIC REVERSED CYCLIC ANALYSIS
		source Disp.tcl; # En este archivo se define iDstep
		set ControlNode 10
		set dof 1
		set dU 1
		set tol 1e-4
		set iter 300
		
		timeSeries Linear 3; #Aplicación del pseudotiempo
		pattern Plain 500 3 {
			sp $ControlNode $dof $dU
		}

		# doReversedCyclic $iDstep $dU $ControlNode $dof $ConvInf $tol $iter $Outputs Inf	
		
# MODAL ANALYSIS	
	# set numModes 1
	# doModal $numModes $Outputs Inf	
	
# MATRIX OUTPUTS
	# doMassMatrix $ConvInf $Outputs Inf
	# doStiffnessMatrix $ConvInf $Outputs Inf	

# DAMPING PROPERTIES
		# set DampingRatio 0.03
		# set ::nEigenI 1
		# set ::nEigenJ 1
		# set ::Model "Mass"
		# DampingModel $DampingRatio $nEigenI $nEigenJ $Model Inf
		
# DYNAMIC ANALYSIS
		# set iGMfile "Calitri_f200HzDirX Calitri_f200HzDirX" ;		# ground-motion filenames, should be different files
		# ReadVector "Earthquakes/Calitri_f200HzDirX.txt" THData StepN; # Lee numero de steps
			
	# Bidirectional Uniform Earthquake ground motion (uniform acceleration input at all support nodes)
		# set Earthquakes Earthquakes
		# set iGMdirection "1 2";			# ground-motion direction
		# set iGMfact "1.0 1.0";			# ground-motion scaling factor
		# set ::dt 0.005
		# set tol 1e-2
		# set iter 400
		# set gamma 0.5
		# set beta 0.25
		

		# set IDloadTag 400;	# for uniformSupport excitation
		# foreach GMdirection $iGMdirection GMfile $iGMfile GMfact $iGMfact {
			# incr IDloadTag;
			# set DataFile $Earthquakes/$GMfile.txt;
			# set GMfatt [expr $g*$GMfact];			
			# set AccelSeries "Series -dt $dt -filePath $DataFile -factor  $GMfatt";		
			# pattern UniformExcitation  $IDloadTag  $GMdirection -accel  $AccelSeries  ;
		# }	
	
		# set TmaxAnalysis [expr $StepN*$dt];	
		# set dtcal [expr $dt*1.0]
		
		# doDynamic $dtcal $TmaxAnalysis $gamma $beta $ConvInf $tol $iter $Outputs Inf	

	exit

	
	