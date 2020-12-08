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
	
# LIBRERIAS BASICAS DEL MODELO
source Analysis.tcl;
source ReadVector.tcl;
source Materials.tcl;
source Sections.tcl;	
source Model.tcl;


# OUTPUTS
set Outputs $SimulationName;
source Outputs.tcl;

# ANALYSIS
source Analysis.tcl;
set SwitchModal 0;
set SwitchGravitatorio 1;
set SwitchPushover 0;
set SwitchDinamico 1;
set SwitchK 0;
set SwitchM 0;

#ANALISIS MODAL
set SwitchAnalisis $SwitchModal;
	if {$SwitchAnalisis == 1} {
		wipeAnalysis;
		set GDL 2;
		set niveles 2;
		set numModes [expr $niveles * $GDL];
		
		doModal $numModes $Outputs;
	}


#ANALISIS GRAVITATORIO
set SwitchAnalisis $SwitchGravitatorio;
	if {$SwitchAnalisis == 1} {
		wipeAnalysis;
		set dF 0.20;
		set iter 5;
		set ConvInf 1;
		set tol 1e-4;
		
		timeSeries Linear 1;
		set cargaP1 [expr -9.0*$g / 4.0];
		set cargaP2 [expr -12.0*$g / 4.0];
		pattern Plain 1 1 {
		eleLoad	-ele 9 -type -beamUniform $WySv1 $WzSv1 $WxSv1;
		eleLoad	-ele 10 -type -beamUniform $WySv1 $WzSv1 $WxSv1;
		eleLoad	-ele 11 -type -beamUniform $WySv1 $WzSv1 $WxSv1;
		eleLoad	-ele 12 -type -beamUniform $WySv1 $WzSv1 $WxSv1;
		eleLoad	-ele 13 -type -beamUniform $WySv1 $WzSv1 $WxSv1;
		eleLoad	-ele 14 -type -beamUniform $WySv1 $WzSv1 $WxSv1;
		eleLoad	-ele 15 -type -beamUniform $WySv1 $WzSv1 $WxSv1;
		eleLoad	-ele 16 -type -beamUniform $WySv1 $WzSv1 $WxSv1;
		eleLoad -ele 1 -type -beamUniform $WySv2 $WzSv2 $WxSv2;
		eleLoad -ele 2 -type -beamUniform $WySv2 $WzSv2 $WxSv2;
		eleLoad -ele 3 -type -beamUniform $WySv2 $WzSv2 $WxSv2;
		eleLoad -ele 4 -type -beamUniform $WySv2 $WzSv2 $WxSv2;
		eleLoad -ele 5 -type -beamUniform $WySv2 $WzSv2 $WxSv2;
		eleLoad -ele 6 -type -beamUniform $WySv2 $WzSv2 $WxSv2;
		eleLoad -ele 7 -type -beamUniform $WySv2 $WzSv2 $WxSv2;
		eleLoad -ele 8 -type -beamUniform $WySv2 $WzSv2 $WxSv2;
		load 2 0.0 $cargaP1 0.0 0.0 0.0 0.0;
		load 5 0.0 $cargaP1 0.0 0.0 0.0 0.0;
		load 8 0.0 $cargaP1 0.0 0.0 0.0 0.0;
		load 11 0.0 $cargaP1 0.0 0.0 0.0 0.0;
		load 3 0.0 $cargaP2 0.0 0.0 0.0 0.0;
		load 6 0.0 $cargaP2 0.0 0.0 0.0 0.0;
		load 9 0.0 $cargaP2 0.0 0.0 0.0 0.0;
		load 12 0.0 $cargaP2 0.0 0.0 0.0 0.0;
		
		}
		
		doForceControl $dF $ConvInf $tol $iter $Outputs Inf;
	}

#Analisis Pushover
set SwitchAnalisis $SwitchPushover;
	if {$SwitchAnalisis == 1} {
		remove recorders;
		wipeAnalysis;
		set maxU 260.0;
		set numPasos 100;
		set dU [expr $maxU / $numPasos];
		set dof 1;
		set ControlNode $::nodo_cont;
		set iter $numPasos;
		set ConvInf 1;
		set tol 1e-6;
		
		timeSeries Linear 2;
		pattern Plain 2 2 {
			sp 14 1 $dU;
			sp 13 1 [expr $dU / 2];
		}
		
		doPushover $maxU $dU $ControlNode $dof $ConvInf $tol $iter $Outputs Inf;
	}


#ANÁLISIS DINÁMICO EN EL DOMINIO DEL TIEMPO:
set SwitchAnalisis $SwitchDinamico;
	if {$SwitchAnalisis == 1} {
		remove recorders;
		wipeAnalysis
					
		# PROPIEDADES DE AMORTIGUAMIENTO
		set DampingRatio 0.05;
		set ::nEigenI 1;
		set ::nEigenJ 3;
		set Inf Inf;
		set ::Modelo "RayleighKactual";		
		#set ::Modelo "RayleighKinicial";
		#set ::Modelo "RayleighKultima";
		#set ::Modelo "AmortiguamientoModal";
		# El modelo de amortiguamiento puede ser "Masa", 	"RayleighKinicial", la 			"RayleighKultima", la 	"RayleighKactual" o "AmortiguamientoModal" 
		
		DampingModel $DampingRatio $nEigenI $nEigenJ $Modelo $Inf;
		
		# LECTURA DE TERREMOTO
		set ArchivoTerremoto "Calitri_f200HzDirX.txt";
		ReadVector $ArchivoTerremoto

		set nPts $StepN; #Numero de puntos del registro
		set Direccion_Terr 1;
		set FactorEscala 5.0;	# Determinamos el factor de escala (si 	tenemos dos 			terremotos podemos combinar el 100% de uno con el 	30% del otro).
		set Frecuencia	200;
		set ::dt [expr 1.0/$Frecuencia];
		
		set FactorEscala_g [expr $g*$FactorEscala]; # Al factor de escala 	se le 		introduce el 	valor de la fuerza gravitatoria para 	optener los resustados 	en 	acceleraciones y no 	en función de "g".
		set accelSeries 3;
		set Cod_Terremoto 3; # Etiquetamos el terremoto introducido
		timeSeries Path $accelSeries -dt $dt -filePath $ArchivoTerremoto -factor $FactorEscala_g;
		pattern UniformExcitation $Cod_Terremoto $Direccion_Terr -accel $accelSeries; 								
		# ANÁLISIS DINÁMICO
		wipeAnalysis;		# Para limpiar todas las restricciones y 	parámetros 		definidos en 	análisis anteriores.
		set ConvInf 1;		# Opciones de impresión de las iteraciones 	del test: 
							# 0 = No imprime; 1 = Imprime información en 	cada paso; 	2 = 		Imprime información al 	final del test
			
		set Inf Inf;		# Inf = Si queremos que muestre información 	en pantalla		
							# NoInf = Si no queremos que muestre 	información en 	pantalla
							
		set TmaxAnalisis [expr 1.2*$nPts*$dt];		# Definimos la 	duracción máxima 	del 		análisis un 20% mayor que la duracción 	del terremoto para captar 	la cola de 		vibración libre
		set dtAnalisis [expr $dt*0.5];				# Definimos el paso 	del tiempo 		para el 	análisis dinámico y la generación de 	resultados.
		set PasoAnalisis [expr int($TmaxAnalisis/$dtAnalisis)];  # Número 	de pasos 	del 		análisis que no tiene porqué coincidir con la 	frecuencia del 	acelerograma.
		
		set tol 1e-5;								# Tolerancia para el 	test de 			convergencia.
		set iter 100;								# Número de 	iteraciones 	permitidas 	por 	paso.
		set gamma 0.5;								# Factor Gamma para 	el 	integrador 		Newmark (Método aceleración media = 0.5 ; Método 		aceleración lineal = 0.5).
		set beta 0.25;								# Factor Beta para el 	integrador 		Newmark 	(Método aceleración media = 0.25 ; Método 	aceleración lineal = 	0.5).
		
		doDynamic $PasoAnalisis $dtAnalisis $TmaxAnalisis $gamma $beta $ConvInf $tol $iter $Outputs Inf	
	}

####Matriz de Rigidez y de Masas#####
##Matriz de Masas##
set SwitchAnalisis $SwitchM;
	if {$SwitchAnalisis == 1} {
		wipeAnalysis;
		set ConvInf 1;
		doMassMatrix $ConvInf $Outputs Inf
		printA;
	}

##Matriz de Rigidez##
set SwitchAnalisis $SwitchK;
	if {$SwitchAnalisis == 1} {
		wipeAnalysis
		set ConvInf 1;
		doStiffnessMatrix $ConvInf $Outputs Inf
		printA;
	}
