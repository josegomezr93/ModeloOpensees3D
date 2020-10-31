# MODEL
	# NODE COORDENATES
		source "Nodes.tcl"; 
		# Display: Number of nodes
		set Nudos [getNodeTags]
		# global NodeEnd
		set ::NodeEnd [lindex $Nudos end]; # :: se utiliza para hacer una variable global
		puts "N de Nudos: $::NodeEnd"

	# BOUNDARY CONDITIONS:
		# Nodes:
			fix 1 1 1 1 1 1 1 
			fix 6 1 1 1 1 1 1 
						
			# equalDOF 10 14 1 2 3 4 6
			
	# ELEMENTS:
		# Beam elements
		set numIntgrPts 5
		source "FrameElem.tcl";
		
		# zerolength Elementoselement 	(activate either material spring or material spring)	
			# element zeroLength  13 10 14 -mat 2 -dir 5; mat=1 linear mat=2 nolinear spring (material spring)

			# element zeroLengthSection 13 10 14 3002; #(Section spring) 			
		
		# Display: Number of elements
		set Elem [getEleTags]
		set ElemEnd [lindex $Elem end]
		puts "N de Elementos: $ElemEnd"

		
	# NODE MASSES
		source "NodesMass.tcl";
		
