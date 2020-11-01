# MODEL
	# NODE COORDENATES
	#Caracteristicas basicas del modelo
	puts "Cargando nodos"
	set ::vano 5000.0;
	set ::altura 3000.0;
	set ::nodo_cont 3; #Defino el nodo control
		source "Nodes.tcl"; 
		# Display: Number of nodes
		set Nudos [getNodeTags]
		# global NodeEnd
		set ::NodeEnd [lindex $Nudos end]; # :: se utiliza para hacer una variable global
		puts "N de Nudos: $::NodeEnd"
	puts "Nodos OK"

	# BOUNDARY CONDITIONS:
		# Nodes:
			fix 1 1 1 1 1 1 1 
			fix 6 1 1 1 1 1 1 
						
			# equalDOF 10 14 1 2 3 4 6
			
	# ELEMENTS:
		# Beam elements
	puts "Cargando elementos"
		set np 5;
		source "FrameElem.tcl";

		# Mostramos en pantalla el número de elementos
		set Elem [getEleTags]
		set ::ElemEnd [expr [lindex $Elem end]]
		puts "Elementos introducidos: $Elem"
		puts "Elementos totales del modelo: $::ElemEnd"
		
		puts "------------------------------------------------------"
		# Mostramos los nudos que contiene un elemento
		set ElemX 1
		set EleNudos [eleNodes $ElemX]
		puts "Nudos del elemento $ElemX: $EleNudos"
	puts "Todos los elementos cargados"
		
		# set ElemX 2
		# set EleNudos [eleNodes $ElemX]
		# puts "Nudos del elemento $ElemX: $EleNudos"
		
		# set ElemX 3
		# set EleNudos [eleNodes $ElemX]
		# puts "Nudos del elemento $ElemX: $EleNudos"
		
		#zerolength Elementoselement 	(activate either material spring or material spring)	
			element zeroLength  13 10 14 -mat 2 -dir 5; mat=1 linear mat=2 nolinear spring (material spring)

			element zeroLengthSection 13 10 14 3002; #(Section spring) 			
		
		# Display: Number of elements
		# set Elem [getEleTags]
		# set ElemEnd [lindex $Elem end]
		# puts "N de Elementos: $ElemEnd"

		
	# NODE MASSES
		source "NodesMass.tcl";
