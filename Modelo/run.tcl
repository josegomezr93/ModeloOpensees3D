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

	
	