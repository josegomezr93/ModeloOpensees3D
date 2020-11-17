#Geometria nodal
set h 3000.0; #Altura
set vano 5000.0; #Vanos en x e y

node 1 0.0 0.0;
node 2 0.0 $h;
node 3 0.0 [expr 2.0 * $h];
node 4 $vano 0.0;
node 5 $vano $h;
node 6 $vano [expr 2.0 * $h];

#Nodos de rotulas plasticas
node 7 0.0 $h;
node 8 0.0 [expr 2.0 * $h];
node 9 $vano $h;
node 10 $vano [expr 2.0 * $h];