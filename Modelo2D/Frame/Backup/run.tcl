#Script para modelo uno de los porticos

#Unidades del proyecto N; mm; Tons
wipe;

model BasicBuilder -ndm 2 -ndf 3;
set SimulationName Frame

	
# BACKUP MODEL
	file mkdir $SimulationName/Backup;
	logFile "$SimulationName/Log_model.log";
	file copy -force "run.tcl" $SimulationName/Backup; 
	file copy -force "Outputs.tcl" $SimulationName/Backup; 	
	file copy -force "Analysis.tcl" $SimulationName/Backup;
	file copy -force "Sections.tcl" $SimulationName/Backup;
	file copy -force "Materials.tcl" $SimulationName/Backup;
	file copy -force "Elements.tcl" $SimulationName/Backup;
	file copy -force "Nodes.tcl" $SimulationName/Backup;
	file copy -force "MassNodes.tcl" $SimulationName/Backup;
	file copy -force "Model.tcl" $SimulationName/Backup;

set ::pi [expr acos(-1.0)];
set g 9810;
set Outputs $SimulationName;


#Cargamos liberia de materiales definida
puts "Cargando Materiales ===";
source Materials.tcl;
puts "Materiales OK";

#Definicion de secciones
puts "Cargando secciones";
source Sections.tcl;
puts "Secciones Ok";

#Cargamos el Modelo
puts "Cargando el Modelo";
source Model.tcl;
puts "Modelo OK";

#Cargamos el fichero de los analisis
source Analysis.tcl;

#Cargamos fichero de Salida
source Outputs.tcl;

######################
####ANALISIS MODAL####
######################

wipeAnalysis;
set numModes 2;

doModal $numModes $Outputs

# Para plotar los modos
# recorder display "Mode Shape n" 10 10 500 500 -wipe
# prp $h $h 1;
# vup 0 1 0;
# vpn 0 0 1;
# viewWindow -200 200 -200 200;
# display -n 5 20;

# Obtener los vectores propios
#nodeEigenvector $nodeTag $eigenvector <$dof>
# set f11 [nodeEigenvector 2 1 1];
# set f21 [nodeEigenvector 3 1 1];
# set f12 [nodeEigenvector 2 2 1];
# set f22 [nodeEigenvector 3 2 1];
# set eigenuno [list [expr {$f11/$f21}] [expr {$f21/$f21}]];
# set eigendos [list [expr {$f12/$f22}] [expr {$f22/$f22}]];
# puts "eigenvector 1: $eigenuno";
# puts "eigenvector 2: $eigendos";

# #Bloque de codigo para plotear el vector modal i
# for {set k 1} {$k <= $numModes} {incr k} {
# 	set modo [format "$Outputs/Modos/eigen%i.txt" $k];
# 	set nodo1 [nodeEigenvector 1 $k 1];
# 	set nodo2 [nodeEigenvector 2 $k 1];
# 	set nodo3 [nodeEigenvector 3 $k 1];
# 	set Vectors [open $modo "w"]
# 	puts $Vectors "$nodo1"
# 	puts $Vectors "$nodo2"
# 	puts $Vectors "$nodo3"
# 	close $Vectors
# }

#############################
####ANALISIS GRAVITATORIO####
#############################

# wipeAnalysis;
# set dF 0.25;
# set tol 1e-6;
# set iter 10;
# set ConvInf 1;

# timeSeries Constant 1;
# pattern Plain 1 1 {
# 	eleLoad -range 5 6 -type -beamUniform $WySv1;
# }

# doForceControl $dF $ConvInf $tol $iter $Outputs Inf;

#Analisis PushOver
# wipeAnalysis;
# numberer RCM;
# set maxU 100.0;
# set dU [expr 0.05*$maxU];
# set ConvInf 0;
# set ControlNode 3;
# set dof 1
# set tol 1e-6
# set iter 300
# set Inf NoInf;

# timeSeries Linear 2
# pattern Plain 2 2 {
# 	sp $ControlNode $dof $dU;
#	sp 2 $dof [expr $dU / 2.0];
# }

# doPushover $maxU $dU $ControlNode $dof $ConvInf $tol $iter $Outputs $Inf

#Matriz de Rigidez y de Masas
# ##Matriz de Masas##
# wipeAnalysis;
# set ConvInf 1;
# doMassMatrix $ConvInf $Outputs Inf
# printA;

# ##Matriz de Rigidez##
# wipeAnalysis
# set ConvInf 0;
# doStiffnessMatrix $ConvInf $Outputs Inf
# printA;

# ANÁLISIS DINÁMICO EN EL DOMINIO DEL TIEMPO:
	
# PROPIEDADES DE AMORTIGUAMIENTO
set DampingRatio 0.05;	# Ratio de amortiguamiento del sistema en función del amortiguamiento crítico.
set ::nEigenI 1;		# Modo de vibración 1
set ::nEigenJ 2;
set Inf Inf;
#set ::Modelo "RayleighKactual";		
set ::Modelo "RayleighKinicial";
#set ::Modelo "RayleighKultima";
#set ::Modelo "AmortiguamientoModal";
# El modelo de amortiguamiento puede ser "Masa", "RayleighKinicial", la "RayleighKultima", la "RayleighKactual" o "AmortiguamientoModal" 

DampingModel $DampingRatio $nEigenI $nEigenJ $Modelo $Inf

# LECTURA DE TERREMOTO
set NombreTerremoto	"Calitri_f200HzDirX"; # Nombre del terremoto sin extensión.
set ArchivoTerremoto "$NombreTerremoto.txt" ; # Indicamos la ruta y añadimos extensión.
set fp [open "$ArchivoTerremoto" r]; # Abre el archivo del terremoto.
set Datos [split [read $fp] "\n"]; # Genera un índice con la posición de cada dato. Indice de longitud n datos.
set nPts [llength $Datos] ;	# Lee la posición del último dato del archivo que contiene los índices.
close $fp
	
set Direccion_Terr 1;	# Determinamos dirección del terremeto en coordenadas globales (1 = X ; 2 = Y ; 3 = Z).
set FactorEscala 1.0;	# Determinamos el factor de escala (si tenemos dos terremotos podemos combinar el 100% de uno con el 30% del otro).
set Frecuencia	200;	# Frecuencia del registro de datos del terremoto introducido.
set ::dt [expr 1.0/$Frecuencia];	# Paso del tiempo de los datos del archivo del terremoto.

set FactorEscala_g [expr $g*$FactorEscala]; # Al factor de escala se le introduce el valor de la fuerza gravitatoria para optener los resustados en acceleraciones y no en función de "g".
set accelSeries "Series -dt $dt -filePath $ArchivoTerremoto -factor  $FactorEscala_g";  # Definimos el acelerograma que viene con datos en función de g.	
set Cod_Terremoto 3; # Etiquetamos el terremoto introducido
pattern UniformExcitation $Cod_Terremoto $Direccion_Terr -accel $accelSeries; 					# Definimos la aplicación de la acción sísmica.

# ANÁLISIS DINÁMICO
wipeAnalysis;		# Para limpiar todas las restricciones y parámetros definidos en análisis anteriores.
set ConvInf 1;		# Opciones de impresión de las iteraciones del test: 
					# 0 = No imprime; 1 = Imprime información en cada paso; 2 = Imprime información al final del test
	
set Inf Inf;		# Inf = Si queremos que muestre información en pantalla	
					# NoInf = Si no queremos que muestre información en pantalla
					
set TmaxAnalisis [expr 1.2*$nPts*$dt];		# Definimos la duracción máxima del análisis un 20% mayor que la duracción del terremoto para captar la cola de vibración libre
set dtAnalisis [expr $dt*0.5];				# Definimos el paso del tiempo para el análisis dinámico y la generación de resultados.
set PasoAnalisis [expr int($TmaxAnalisis/$dtAnalisis)];  # Número de pasos del análisis que no tiene porqué coincidir con la frecuencia del acelerograma.

set tol 1e-5;								# Tolerancia para el test de convergencia.
set iter 5000;								# Número de iteraciones permitidas por paso.
set gamma 0.5;								# Factor Gamma para el integrador Newmark (Método aceleración media = 0.5 ; Método aceleración lineal = 0.5).
set beta 0.25;								# Factor Beta para el integrador Newmark (Método aceleración media = 0.25 ; Método aceleración lineal = 0.5).
	
doDynamic $PasoAnalisis $dtAnalisis $TmaxAnalisis $gamma $beta $ConvInf $tol $iter $Outputs Inf




	


