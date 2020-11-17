#Ensamblaje del modelo

#Cargamos los nodos del modelo
puts "Cargando Nodos ===";
source Nodes.tcl;
set Nudos [getNodeTags];
set ::NodeEnd [lindex $Nudos end];
puts "N de nudos: $::NodeEnd";
puts "Nodos OK";

#Condiciones de Contorno
fix 1 1 1 1;
fix 4 1 1 1;
#Condiciones de contorno para los nodos creados para las rotulas
equalDOF 2 7 1 2;
equalDOF 3 8 1 2;
equalDOF 5 9 1 2;
equalDOF 6 10 1 2;

#Cargamos los elementos
puts "Cargando los elementos ===";
set np 5;
source Elements.tcl;
set Elem [getEleTags];
set ElemEnd [lindex $Elem end];
puts "N de elementos: $ElemEnd";
puts "Elementos OK";

#Cargamos las masas nodales
puts "Cargando Masas";
source MassNodes.tcl;
puts "Masas OK";