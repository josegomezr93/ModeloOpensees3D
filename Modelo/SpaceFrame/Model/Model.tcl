# MODEL
	# NODE COORDENATES
	#Caracteristicas basicas del modelo
	set ::nodo_cont 3; #Nodo control
		source "Nodes.tcl"; 
		# Display: Number of nodes
		set Nudos [getNodeTags];

		# global NodeEnd
		set ::NodeEnd [lindex $Nudos end]; # :: se utiliza para hacer una variable global
		puts "N de Nudos: $::NodeEnd";

	# BOUNDARY CONDITIONS:
		# Nodes:
			fix 1 1 1 1 1 1 1;
			fix 4 1 1 1 1 1 1;
			fix 7 1 1 1 1 1 1;
			fix 10 1 1 1 1 1 1;

		#equalDof nodes: GDL Globales
			#equalDof tag nodeR nodeC
			equalDOF 2 15 1 2 3 4 5; #No se condiciona la direc 6, ya que es la direccion en la que trabajara la rotula
			equalDOF 5 16 1 2 3 4 5;
			equalDOF 6 17 1 2 3 5 6; #No se condiciona la direc 4, ya que es la direccion en la que trabajara la rotula
			equalDOF 8 18 1 2 3 5 6;
			equalDOF 8 19 1 2 3 4 5;
			equalDOF 11 20 1 2 3 4 5;
			equalDOF 11 21 1 2 3 5 6;
			equalDOF 2 22 1 2 3 5 6;

			equalDOF 3 23 1 2 3 4 5;
			equalDOF 6 24 1 2 3 4 5;
			equalDOF 6 25 1 2 3 5 6;
			equalDOF 9 26 1 2 3 5 6;
			equalDOF 9 27 1 2 3 4 5;
			equalDOF 12 28 1 2 3 4 5;
			equalDOF 12 29 1 2 3 5 6;
			equalDOF 3 30 1 2 3 5 6;
			
		#rigidDiaphragm $perpDirn $rNodeTag $cNodeTag1 $cNodeTag2 ...
			rigidDiaphragm 2 13 2 5 8 11;
			rigidDiaphragm 2 14 3 6 9 12;

			fix 13 0 1 0 1 0 1; #Restriccion en los nodos master deL Diafragma
			fix 14 0 1 0 1 0 1; #Restriccion en los nodos master del Diafragma

	# ELEMENTS:
		# Beam elements
		set ::np 5; #Numero de integracion del elemento
		puts "Cargando los elementos";
		source "FrameElem.tcl";
		
		# Display: Number of elements
		set Elem [getEleTags];
		set ElemEnd [lindex $Elem end];
		puts "N de Elementos: $ElemEnd";
		# Mostramos en pantalla el número de elementos
		set Elem [getEleTags];
		set ::ElemEnd [expr [lindex $Elem end]];
		puts "Elementos introducidos: $Elem";
		puts "Elementos totales del modelo: $::ElemEnd";
		puts "-------Elementos cargados OK--------";
	
	# Opcional para imprimir

		# puts "------------------------------------------------------";
		# # Mostramos los nudos que contiene un elemento
		# set ElemX 1;
		# set EleNudos [eleNodes $ElemX];
		# puts "Nudos del elemento $ElemX: $EleNudos";
		
		# set ElemX 2;
		# set EleNudos [eleNodes $ElemX];
		# puts "Nudos del elemento $ElemX: $EleNudos";
		
		# set ElemX 3;
		# set EleNudos [eleNodes $ElemX];
		# puts "Nudos del elemento $ElemX: $EleNudos";

		
	# NODE MASSES
	
		puts "Cargando las masas nodales";
		source "NodesMass.tcl";
		puts "Masas nodales cargadas";


	# REGIONES
	#region $regTag <-ele ($ele1 $ele2 ...)> <-eleOnly ($ele1 $ele2 ...)> <-eleRange $startEle $endEle> <-eleOnlyRange $startEle $endEle> <-node ($node1 $node2 ...)> <-nodeOnly ($node1 $node2 ...)> <-nodeRange $startNode $endNode> <-nodeOnlyRange $startNode $endNode> <-node all> <-rayleigh $alphaM $betaK $betaKinit $betaKcomm>
	
	region 1 -ele 17 18 21 22; #RotulasYZ de la primera planta
	region 2 -ele 19 20 23 24; #RotulasXZ de la primera planta
	region 3 -ele 25 26 29 30; #RotulasYZ de la segunda planta
	region 4 -ele 27 28 31 32; #RotulasXZ de la segunda planta