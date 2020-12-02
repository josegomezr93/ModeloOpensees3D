# OUTPUTS

#GENERAMOS CARPETAS POR ANALISIS
#Displacements
file mkdir $Outputs/Displacement;
recorder Node -file $Outputs/Displacement/nodesdispContr.out -time  -node 3 -dof 1  disp;
recorder Node -file $Outputs/Displacement/nodesdisp13.out -time -node 13 -dof 1 disp;
# recorder Node -file $Outputs/Displacement/disp10.out    -node 10 -dof 1 2 3 4 5 6  disp; 

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
recorder Element -file $Outputs/SectionForce/ele1sec1fiber.out -time -ele 1 section $::np fiber 0.0 0.0 stressStrain;
recorder Element -file $Outputs/SectionForce/ele1sec2fiber.out -time -ele 1 section $::np fiber $::y1 $::z4 stressStrain;
	
# Section Forces
file mkdir $Outputs/Beams;
recorder Element -file $Outputs/Beams/ele1gp1force.out -time -ele 1 section 1 force; 
recorder Element -file $Outputs/Beams/ele1gp1deform.out -time -ele 1 section 1 deformation;

#Rotulas Plasticas
file mkdir $Outputs/Rotulas;
recorder Element -file $Outputs/Rotulas/rotula1f.out -time -region 1 section 1 fiber 0.10 0.10 stressStrain;
recorder Element -file $Outputs/Rotulas/rotula1force.out -time -region 1 force;
recorder Element -file $Outputs/Rotulas/rotula1def.out -time -region 1 deformation;


# Salida de matriz de modos de vibración:	
# file mkdir $Outputs/Modos

# # Salida de matrices de masas y rigideces:	
# 	file mkdir $Outputs/Matrices

