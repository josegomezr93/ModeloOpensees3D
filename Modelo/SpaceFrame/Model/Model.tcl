# MODEL
	# NODE COORDENATES
	#Caracteristicas basicas del modelo
	set ::vano 5000.0;
	set ::altura 3000.0;
	set ::nodo_cont 3; #Nodo control
		source "NodesModel.tcl"; 
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
		
		# Condiciones geometricas de los nodos (equalDOF)
			#rigidLink $type $rNodeTag $cNodeTag
			rigidLink beam 2 14;
			rigidLink beam 2 27; 
			rigidLink beam 5 15; 
			rigidLink beam 5 18;
			rigidLink beam 8 19; 
			rigidLink beam 8 22;
			rigidLink beam 11 23; 
			rigidLink beam 11 26;
			rigidLink beam 3 30;
			rigidLink beam 3 43; 
			rigidLink beam 6 31; 
			rigidLink beam 6 34;
			rigidLink beam 9 35; 
			rigidLink beam 9 38;
			rigidLink beam 12 39; 
			rigidLink beam 12 42;
			
	# ELEMENTS:
		# Beam elements
		set np 5; #Numero de integracion del elemento
		puts "Cargando los elementos";
		source "FrameElemModel.tcl";
		
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
		
