# MODEL
	# NODE COORDENATES
	#Caracteristicas basicas del modelo
	set ::vano 5000.0;
	set ::altura 3000.0;
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
			equalDOF 14 13 1 2 3 4 5 6;
			equalDOF 15 16 1 2 3 4 5 6;
			equalDOF 18 17 1 2 3 4 5 6;
			equalDOF 19 20 1 2 3 4 5 6;
			equalDOF 22 21 1 2 3 4 5 6;
			equalDOF 23 24 1 2 3 4 5 6;
			equalDOF 26 25 1 2 3 4 5 6;
			equalDOF 27 28 1 2 3 4 5 6;

			equalDOF 30 29 1 2 3 4 5 6;
			equalDOF 31 32 1 2 3 4 5 6;
			equalDOF 34 33 1 2 3 4 5 6;
			equalDOF 35 36 1 2 3 4 5 6;
			equalDOF 38 37 1 2 3 4 5 6;
			equalDOF 39 40 1 2 3 4 5 6;
			equalDOF 42 41 1 2 3 4 5 6;
			equalDOF 43 44 1 2 3 4 5 6;
			
		#rigidDiaphragm $perpDirn $rNodeTag $cNodeTag1 $cNodeTag2 ...
			rigidDiaphragm 3 45 2 5 8 11;
			rigidDiaphragm 3 46 3 6 9 12;

			#element zeroLength 17 14 13 -mat $::Muelle -dir 6; 
		 	#element zeroLength 18 15 16 -mat $::Muelle -dir 6;
		 	#element zeroLength 19 18 17 -mat $::Muelle -dir 6;
		 	#element zeroLength 20 19 20 -mat $::Muelle -dir 6;
		 	#element zeroLength 21 22 21 -mat $::Muelle -dir 6;
		 	#element zeroLength 22 23 24 -mat $::Muelle -dir 6;
		 	#element zeroLength 23 26 25 -mat $::Muelle -dir 6;
		 	#element zeroLength 24 27 28 -mat $::Muelle -dir 6;
		 	#element zeroLength 25 30 29 -mat $::Muelle -dir 6;
		 	#element zeroLength 26 31 32 -mat $::Muelle -dir 6;
		 	#element zeroLength 27 34 33 -mat $::Muelle -dir 6;
		 	#element zeroLength 28 35 36 -mat $::Muelle -dir 6;
		 	#element zeroLength 29 38 37 -mat $::Muelle -dir 6;
		 	#element zeroLength 30 39 40 -mat $::Muelle -dir 6;
		 	#element zeroLength 31 42 41 -mat $::Muelle -dir 6;
		 	#element zeroLength 32 43 44 -mat $::Muelle -dir 6;

	# ELEMENTS:
		# Beam elements
		set np 5; #Numero de integracion del elemento
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

		
		
