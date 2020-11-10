# LIBRERIAS OPENSEES
model basic -ndm 3 -ndf 6; # Carga las funciones de OpenSees al interpreter Tcl
wipe; # Limpia los objetos y archivos de salida del interprete
set SimulationName SpaceFrame

	
	
# BACKUP MODEL
file mkdir $SimulationName/Model
logFile "$SimulationName/Log_model.log";
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
puts WSv1:$WySv1;
set Qy [expr $WySv1 * $ASv1];
puts q:$Qy;
	
# MODEL
source Model.tcl;

# OUTPUTS
set Outputs $SimulationName;
source Outputs.tcl;

# ANALYSIS
source Analysis.tcl;

#Analisis Modal
wipeAnalysis;
set GDL 2;
set niveles 2;
set numModes [expr $niveles * $GDL];

doModal $numModes $Outputs

#ANALISIS GRAVITATORIO
wipeAnalysis;
set dF 0.20;
set iter 10;
set ConvInf 1;
set tol 1e-4;

timeSeries Constant 1;
pattern Plain 1 1 {
	eleLoad	-ele 9 -type -beamUniform -25.0 $WzSv1 $WxSv1;
	eleLoad	-ele 10 -type -beamUniform -25.0 $WzSv1 $WxSv1;
	eleLoad	-ele 11 -type -beamUniform -25.0 $WzSv1 $WxSv1;
	eleLoad	-ele 12 -type -beamUniform -25.0 $WzSv1 $WxSv1;
	eleLoad	-ele 13 -type -beamUniform -25.0 $WzSv1 $WxSv1;
	eleLoad	-ele 14 -type -beamUniform -25.0 $WzSv1 $WxSv1;
	eleLoad	-ele 15 -type -beamUniform -25.0 $WzSv1 $WxSv1;
	eleLoad	-ele 16 -type -beamUniform -25.0 $WzSv1 $WxSv1;
}


doForceControl $dF $ConvInf $tol $iter $Outputs Inf;

#Analisis Pushover
wipeAnalysis;
set maxU 100.0;
set numPasos 100;
set dU [expr $maxU / $numPasos];
set dof 1;
set ControlNode $::nodo_cont;
set iter 100;
set ConvInf 1;
set tol 1e-6;

timeSeries Linear 2;
pattern Plain 2 2 {
	sp $ControlNode 1 $dU;
}

doPushover $maxU $dU $ControlNode $dof $ConvInf $tol $iter $Outputs Inf;


	
	