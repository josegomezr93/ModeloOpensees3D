# OUTPUTS

#GENERAMOS CARPETAS POR ANALISIS
#Displacements
file mkdir $Outputs/Displacement;
recorder Node -file $Outputs/Displacement/nodesdispContr.out -time  -node 3 -dof 1  disp;
recorder Node -file $Outputs/Displacement/nodesdisp14.out -time -node 14 -dof 1 disp;
recorder Node -file $Outputs/Displacement/nodesdisp13.out -time -node 13 -dof 1 disp;
# recorder Node -file $Outputs/Displacement/disp10.out    -node 10 -dof 1 2 3 4 5 6  disp; 

# Velocidades
file mkdir $Outputs/Velocidades;
recorder Node -file $Outputs/Velocidades/nodesvelContr.out -time -node 3 -dof 1 vel;

# Accelerations
file mkdir $Outputs/Acceleration;
recorder Node -file $Outputs/Acceleration/nodesaccContr.out -time -node 3 -dof 1 accel;
# recorder Node -file $Outputs/Acceleration/acc3.out  -time   -node 3 -dof  1 2 3 4 5 6  accel;
# recorder Node -file $Outputs/Acceleration/acc6.out  -time   -node 6 -dof  1 2 3 4 5 6  accel;
# recorder Node -file $Outputs/Acceleration/acc8.out -time -node 8 -dof 1 accel;
# recorder Node -file $Outputs/Acceleration/acc14.out -time -node 14 -dof 1 accel;
	
# Reactions
file mkdir $Outputs/Reactions;
recorder Node -file $Outputs/Reactions/node1reac.out -time -node 1 -dof 1 2 3 4 5 6 reaction;
recorder Node -file $Outputs/Reactions/node4reac.out -time  -node 4 -dof 1 2 3 4 5 6 reaction;
recorder Node -file $Outputs/Reactions/node7reac.out -time -node 7 -dof 1 2 3 4 5 6 reaction;
recorder Node -file $Outputs/Reactions/node10reac.out -time  -node 10 -dof 1 2 3 4 5 6 reaction;
	
# Section Forces (FIBRA)
file mkdir $Outputs/SectionForce;
recorder Element -file $Outputs/SectionForce/ele1force.out -time -ele 1 section $::np force;
recorder Element -file $Outputs/SectionForce/ele1def.out -time -ele 1 section $::np deformation;
# recorder Element -file $Outputs/SectionForce/ele1sec1fiber.out -time -ele 1 section $::np fiber 0.0 0.0 stressStrain;
# recorder Element -file $Outputs/SectionForce/ele1sec2fiber.out -time -ele 1 section $::np fiber $::y1 $::z4 stressStrain;
	
# Section Forces (Vigas)
file mkdir $Outputs/Beams;
set vigasSecciones "$Outputs/Beams";
for {set i 9} {$i <= 16} {incr i} {
	set ploteoforce "$vigasSecciones/ele$i";
	set ploteodef "$vigasSecciones/ele$i";
	recorder Element -file "$ploteoforce.out" -time -ele $i force;
	recorder Element -file "$ploteodef.out" -time -ele $i deformation;
}


#Rotulas Plasticas
file mkdir $Outputs/Rotulas;
set regionFinal 4;
set ficheroNombre $Outputs/Rotulas;
for {set i 1} {$i <= $regionFinal} {incr i} {
	set ploteoforce "$ficheroNombre/rotulasforce$i";
	set ploteodef "$ficheroNombre/rotulasdef$i";
	recorder Element -file "$ploteoforce.out" -time -region $i force;
	recorder Element -file "$ploteodef.out" -time -region $i deformation;
}



# # Salida de matrices de masas y rigideces:	
# 	file mkdir $Outputs/Matrices

